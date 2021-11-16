#include "ThemeManager.h"
#include <utility>

#include "ITheme.h"
#include "CoBrandedTheme.h"
#include "CoBrandedThemeCreator.h"
#include "SystemHighContrastTheme.h"
#include "Parsers.h"
#include "InheritedTheme.h"
#include "spark-client-framework/Utilities/SparkAlgorithms.h"
#include "spark-client-framework/Utilities/StringUtils.h"
#include "spark-client-framework/SparkLogger.h"
#include "common-head/Utils/SemanticUtils.h"
#include "common-head/Utils/ConfigUtils.h"
#include "Tokens.h"


namespace SemanticVisuals
{
    ThemeManager::ThemeManager(IThemePtr defaultTheme, std::shared_ptr<Colors> colors)
        : mColors(std::move(colors))
    {
        mLoadedThemes.emplace("Default", std::move(defaultTheme));
        setActiveTheme("Default");
    }

    void ThemeManager::loadTheme(const std::string& themeName)
    {
        if (mLoadedThemes.find(themeName) == mLoadedThemes.end())
        {
            if (const auto newTheme = createTheme(themeName); newTheme != nullptr)
            {
                mLoadedThemes.emplace(themeName, newTheme);
            }
        }
    }

    void ThemeManager::setActiveTheme(const std::string& themeName)
    {
        const auto theme = isMomentumThemeEnabled() ? getActiveMomentumThemeName(themeName) : themeName;
        loadTheme(theme);

        if (const auto result = mLoadedThemes.find(theme); mLoadedThemes.end() != result)
        {
            mActiveTheme = CoBrandedThemeCreator::create(result->second);
        }
    }

    IThemePtr ThemeManager::getActiveTheme() const
    {
        return mActiveTheme;
    }

    std::vector<IThemePtr> ThemeManager::loadAndGetAllThemes()
    {
        for (const auto& [name, _]: mJsonFactories)
        {
            loadTheme(name);
        }

        return spark::transform(mLoadedThemes, [](const auto& ntPair)
        {
            return ntPair.second;
        });
    }

    std::string ThemeManager::getActiveThemeName() const
    {
        return getActiveTheme()->getName();
    }

    std::string ThemeManager::getActiveMomentumThemeName(const std::string& themeName)
    {
        const auto momentumTheme = !StringUtils::startsWith(themeName, "Momentum") ? "Momentum" + themeName : themeName; 
        return spark::contains(mJsonFactories, momentumTheme) ? momentumTheme : "MomentumDark";
    }

    void ThemeManager::processBrandingColors(const std::map<std::string, std::string>& customColors)
    {
        if (customColors.empty())
        {
            return;
        }
        mThemeSelectable = false;
        mActiveTheme->processBrandingColors(customColors);
    }

    IThemePtr ThemeManager::getParent(const std::string& parentName)
    {
        const auto shouldLoadParent = [this](const auto& parentThemeName) {
            const auto it = mLoadedThemes.find(parentThemeName);
            return !parentThemeName.empty() && it == mLoadedThemes.end();
        };

        if (shouldLoadParent(parentName))
        {
            auto parentTheme = createTheme(parentName);
            mLoadedThemes.emplace(parentName, parentTheme);
        }

        const auto it = mLoadedThemes.find(parentName);
        return it != mLoadedThemes.end() ? (*it).second : nullptr;
    }

    void ThemeManager::addThemeFromJson(const std::string& name, GetJsonFunction getInputJson)
    {
        mJsonFactories.emplace(name, [this, getInputJson]() -> IThemePtr {
            if (const auto themeData = Parsers::parseTheme(getInputJson()); themeData.has_value())
            {
                if (const auto parentTheme = getParent(themeData->parent); parentTheme != nullptr)
                {
                    TokenFromStringFunction tokenFromStringFunc = [](auto s)
                    {
                        return SemanticVisuals::tokenFromString(s);
                    };
                    TokenToStringFunction tokenToStringFunc = [](auto t)
                    {
                        return SemanticVisuals::tokenToString(t);
                    };
                                        
                    return std::make_shared<InheritedTheme>(themeData->name, parentTheme, *themeData, mColors, tokenFromStringFunc, tokenToStringFunc);
                }
            }

            return nullptr;
        });
    }

#ifdef _WIN32
    void ThemeManager::addHighContrastThemeFromJson(const std::string& name, GetJsonFunction getInputJson)
    {
        mJsonFactories.emplace(name, [this, name, getInputJson]() -> IThemePtr {
            return std::make_shared<SystemHighContrastTheme>(name, getParent("Default"), Parsers::parseHighContrastTheme(getInputJson()));
        });
    }

    void ThemeManager::addMomentumHighContrastThemeFromJson(const std::string& name, GetJsonFunction getInputJson)
    {
        mJsonFactories.emplace(name, [this, name, getInputJson]() -> IThemePtr {
          return std::make_shared<SystemHighContrastTheme>(name, getParent("SystemHighContrast"), Parsers::parseHighContrastTheme(getInputJson()));
        });
    }
#endif

    IThemePtr ThemeManager::createTheme(const std::string& name)
    {
        if (!spark::contains(mJsonFactories, name))
        {
            return nullptr;
        }

        auto newTheme = mJsonFactories[name]();
        return newTheme;
    }

    bool ThemeManager::isThemeSelectable() const
    {
        return mThemeSelectable;
    }

    bool ThemeManager::isDark() 
    {
        const auto currentThemeType = SemanticVisuals::getThemeType(SemanticVisuals::getConfigKey(getActiveThemeName()));
        return SemanticVisuals::isDarkTheme(currentThemeType);
    }

    bool ThemeManager::isHighContrast()
    {
        return (getActiveThemeName() == "SystemHighContrast") || (getActiveThemeName() == "MomentumSystemHighContrast");
    }

    bool ThemeManager::isMomentumThemeEnabled()
    {
        return mIsMomentumThemesEnabled;
    }

    void ThemeManager::setIsMomentumThemesEnabled(bool isEnabled)
    {
        mIsMomentumThemesEnabled = isEnabled;
    }

}
