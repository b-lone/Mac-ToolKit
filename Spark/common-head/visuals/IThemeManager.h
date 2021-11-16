#pragma once

#include <string>
#include <memory>
#include <map>
#include <functional>


namespace SemanticVisuals
{
    enum class ThemeType;

    class ITheme;
    using IThemePtr = std::shared_ptr<ITheme>;

    using GetJsonFunction = std::function<std::string()>;

    class IThemeManager
    {
    public:
        virtual ~IThemeManager() = default;

        virtual void addThemeFromJson(const std::string& name, GetJsonFunction getInputJson) = 0;

#ifdef _WIN32
        virtual void addHighContrastThemeFromJson(const std::string& name, GetJsonFunction getInputJson) = 0;
        virtual void addMomentumHighContrastThemeFromJson(const std::string& name, GetJsonFunction getInputJson) = 0;
#endif
        virtual void setActiveTheme(const std::string& themeName) = 0;
        [[nodiscard]] virtual IThemePtr getActiveTheme() const = 0;
        [[nodiscard]] virtual std::vector<IThemePtr> loadAndGetAllThemes() = 0;
        [[nodiscard]] virtual std::string getActiveThemeName() const = 0;
        virtual void processBrandingColors(const std::map<std::string, std::string>&) = 0;
        virtual bool isThemeSelectable() const = 0;
        virtual bool isMomentumThemeEnabled() = 0;
        virtual void setIsMomentumThemesEnabled(bool isEnabled) = 0;
        virtual std::string getActiveMomentumThemeName(const std::string& themeName) = 0;

        virtual bool isDark() = 0;
        virtual bool isHighContrast() = 0;
    };
}
