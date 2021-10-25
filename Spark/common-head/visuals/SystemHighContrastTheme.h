#pragma once

#include <unordered_map>
#include <tuple>
#include <string>

#include "PartialTheme.h"
#include "IThemeManager.h"
#include "Parsers.h"

namespace SemanticVisuals
{
    class SystemHighContrastTheme : public PartialTheme
    {
    public:
        enum class AccessibilityResource
        {
            WindowTextColor,
            HotlightColor,
            GrayTextColor,
            HighlightTextColor,
            HighlightColor,
            ButtonTextColor,
            ButtonFaceColor,
            WindowColor,
            PlaceholderColor    // this is needed for the momentum transition, until we get full specs
        };

        using ResourceColor = std::unordered_map<AccessibilityResource, Color>;

        SystemHighContrastTheme(const std::string& name, std::shared_ptr<ITheme> proxiedTheme, const std::optional<Parsers::HighContrastTokens>& uiStates);
        ~SystemHighContrastTheme() override = default;


    private:
        void initMappings();
        ThemeColors generateAlteredColors();
        void readRegistries();

        static Color parseActiveColor(const std::string& registryName);

        void logThemeColor(const ThemeColor& themeColor) const;

        const std::optional<Parsers::HighContrastTokens>& mTokens;
        std::unordered_map<AccessibilityResource, std::string> mRegistryNames{};
        std::unordered_map<std::string, AccessibilityResource> mRegistryNameIds{};
        std::unordered_map<std::string, AccessibilityResource> mResourceNames{};
        ResourceColor mResourceColor{};
    };
}
