#include "SystemHighContrastTheme.h"
#include "Tokens.h"
#include "Parsers.h"

#include "spark-client-framework/SparkLogger.h"
#include "spark-client-framework/Utilities/WinUtils.h"
#include "spark-client-framework/Utilities/StringUtils.h"
#include "SparkAssert.h"

#include <sstream>
#include <cstdint>
#include <algorithm>

#include <Windows.h>


namespace SemanticVisuals
{
    static constexpr std::string_view REGISTRY_ACTIVE_BASE_PATH = "Control Panel\\Colors\\";

    SystemHighContrastTheme::SystemHighContrastTheme(const std::string& name, std::shared_ptr<ITheme> proxiedTheme, const std::optional<Parsers::HighContrastTokens>& uiStates)
        :PartialTheme(name, proxiedTheme),
        mTokens(uiStates)
    {
        initMappings();
        readRegistries();
    }

    Color SystemHighContrastTheme::parseActiveColor(const std::string& registryName)
    {
        Color color(0, 0, 0, 255);
        const auto regKey = std::wstring(registryName.begin(), registryName.end());
        const auto regValue = WinUtils::readRegistryValue(HKEY_CURRENT_USER, std::wstring(REGISTRY_ACTIVE_BASE_PATH.begin(), REGISTRY_ACTIVE_BASE_PATH.end()), regKey);

        if (regValue.has_value())
        {
            const auto regValueString = StringUtils::toString(regValue.value());

            std::stringstream regValueStream(regValueString);
            unsigned r;
            unsigned g;
            unsigned b;

            regValueStream >> r;
            regValueStream >> g;
            regValueStream >> b;

            color = Color(r, g, b);
        }
        else
        {
            SPARK_LOG_ERROR("HC: failed to read active colors from \'" << REGISTRY_ACTIVE_BASE_PATH << "\\" << registryName << "\'");
        }

        return color;
    }

    void SystemHighContrastTheme::readRegistries()
    {
        for (const auto& [resourceId, registryName] : mRegistryNames)
        {
            mResourceColor[resourceId] = parseActiveColor(registryName);
        }

        setAlteredColors(generateAlteredColors());
    }

    void SystemHighContrastTheme::initMappings()
    {
        mRegistryNames = {
            {AccessibilityResource::WindowTextColor, "WindowText"},
            {AccessibilityResource::HotlightColor, "HotTrackingColor"},
            {AccessibilityResource::GrayTextColor, "GrayText"},
            {AccessibilityResource::HighlightTextColor, "HilightText"},
            {AccessibilityResource::HighlightColor, "Hilight"},
            {AccessibilityResource::ButtonTextColor, "ButtonText"},
            {AccessibilityResource::ButtonFaceColor, "ButtonFace"},
            {AccessibilityResource::WindowColor, "Background"},
            {AccessibilityResource::PlaceholderColor, "Background"} //we just map this to background color for now
        };

        std::for_each(mRegistryNames.begin(), mRegistryNames.end(), [this](const auto& resourcePair) {
                      mRegistryNameIds[resourcePair.second] = resourcePair.first;
                      });

        mResourceNames = {
            {"WindowTextColor", AccessibilityResource::WindowTextColor},
            {"HotlightColor", AccessibilityResource::HotlightColor},
            {"GrayTextColor", AccessibilityResource::GrayTextColor},
            {"HighlightTextColor", AccessibilityResource::HighlightTextColor},
            {"HighlightColor", AccessibilityResource::HighlightColor},
            {"ButtonTextColor", AccessibilityResource::ButtonTextColor},
            {"ButtonFaceColor", AccessibilityResource::ButtonFaceColor},
            {"WindowColor", AccessibilityResource::WindowColor},
            {"PlaceholderColor", AccessibilityResource::PlaceholderColor}
        };
    }

    ThemeColors SystemHighContrastTheme::generateAlteredColors()
    {
        ThemeColors themeColors;

        if (mTokens.has_value())
        {
            std::map<std::pair<Token, std::string>, ColorSet> colorSets;

            SPARK_LOG_DEBUG("HC: begin color generation");

            for (const auto& token : mTokens.value())
            {
                const auto& [tokenName, hcUiStates] = token;
                auto tokenId = mParentTheme->tokenFromString(tokenName);

                if (StringUtils::startsWith(mName, "Momentum") || mParentTheme->isValidToken(tokenId))
                {
                    const auto& tokenKey = std::make_pair(tokenId, tokenName);

                    if (!colorSets.count(tokenKey))
                    {
                        colorSets[tokenKey] = mParentTheme->getColorSet(tokenId);
                    }

                    ColorSet& colorSet = colorSets[tokenKey];

                    SemanticVisuals::Parsers::HighContrastUIStates hcSortedStates = hcUiStates;
                    std::sort(hcSortedStates.begin(), hcSortedStates.end(), [](const auto& tokenPair1, const auto& tokenPair2) -> bool
                        {
                            return static_cast<unsigned>(tokenPair1.first) < static_cast<unsigned>(tokenPair2.first);
                        });


                    for (const auto& [uiState, resourceName] : hcSortedStates)
                    {
                        const auto& resourceNameIt = mResourceNames.find(resourceName);

                        if (resourceNameIt != mResourceNames.end())
                        {
                            const auto& regColor = mResourceColor[mResourceNames[resourceName]];

                            switch (uiState)
                            {
                            case Parsers::UIState::normal:
                                colorSet = ColorSet(regColor); // dispatch to all states.
                                break;

                            case Parsers::UIState::hovered:
                                colorSet.hovered = regColor;
                                break;

                            case Parsers::UIState::pressed:
                                colorSet.pressed = regColor;
                                break;

                            case Parsers::UIState::disabled:
                                colorSet.disabled = regColor;
                                break;

                            case Parsers::UIState::focused:
                                colorSet.focused = regColor;
                                break;

                            case Parsers::UIState::checked:
                                colorSet.checked = regColor;
                                break;

                            default:
                                SPARK_LOG_ERROR("HC: Unhandled token state:" << static_cast<unsigned>(uiState));
                                continue;
                            }
                        }
                        else
                        {
                            SPARK_LOG_ERROR("HC: Invalid resource name:" << resourceName << "for token " << tokenName << " at UIState " << static_cast<unsigned>(uiState) << "; using parent theme colors!");
                            // use parent to hint that something was wrong.
                            colorSets = std::map<std::pair<Token, std::string>, ColorSet>();
                            themeColors = ThemeColors();
                            break;
                        }
                    }
                }
                else
                {
                    SPARK_LOG_ERROR("Trying to define token " << tokenName << " in theme " << mName << " that doesn't exist in a parent theme " << mParentTheme->getName());
                    continue;
                }
            }

            for (const auto& colorSet : colorSets)
            {
                themeColors.push_back(std::make_tuple(colorSet.first.first, colorSet.first.second, colorSet.second));
            }

            SPARK_LOG_DEBUG("HC: end color generation");

            for (const auto& tokenSetting : themeColors)
            {
                logThemeColor(tokenSetting);
            }
        }
        else
        {
            SPARK_LOG_ERROR("HC: no tokens, use parent theme");
            themeColors = ThemeColors();
        }

        return themeColors;
    }

    void SystemHighContrastTheme::logThemeColor(const ThemeColor& themeColor) const
    {
        const auto & [tokenId, tokenName, colorSet] = themeColor;
        SPARK_LOG_DEBUG("HC: token \'" << tokenName << "\'");

        const Color & colorNormal = colorSet.normal;
        SPARK_LOG_DEBUG("HC: \ttoken color NORMAL. r=\'" << int(colorNormal.r) << "\' g=\'" << int(colorNormal.g) << "\' b=\'" << int(colorNormal.b));

        const Color & colorHovered = colorSet.hovered;
        SPARK_LOG_DEBUG("HC: \ttoken color HOVERED. r=\'" << int(colorHovered.r) << "\' g=\'" << int(colorHovered.g) << "\' b=\'" << int(colorHovered.b));

        const Color& colorPressed = colorSet.pressed;
        SPARK_LOG_DEBUG("HC: \ttoken color PRESSED. r=\'" << int(colorPressed.r) << "\' g=\'" << int(colorPressed.g) << "\' b=\'" << int(colorPressed.b));

        const Color & colorDisabled = colorSet.disabled;
        SPARK_LOG_DEBUG("HC: \ttoken color DISABLED. r=\'" << int(colorDisabled.r) << "\' g=\'" << int(colorDisabled.g) << "\' b=\'" << int(colorDisabled.b));

        const Color& colorFocused = colorSet.focused;
        SPARK_LOG_DEBUG("HC: \ttoken color FOCUSED. r=\'" << int(colorFocused.r) << "\' g=\'" << int(colorFocused.g) << "\' b=\'" << int(colorFocused.b));

        const Color& colorChecked = colorSet.checked;
        SPARK_LOG_DEBUG("HC: \ttoken color CHECKED. r=\'" << int(colorChecked.r) << "\' g=\'" << int(colorChecked.g) << "\' b=\'" << int(colorChecked.b));
    }
}
