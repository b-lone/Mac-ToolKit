#pragma once

#include "IThemeManager.h"
#include "Colors.h"

#include <map>
#include <string>


namespace SemanticVisuals
{
    using ThemesMap = std::map<std::string, const IThemePtr>;
    using JsonThemesFactories = std::map<std::string, std::function<IThemePtr()>>;
    class CoBrandedTheme;

    class ThemeManager final : public IThemeManager
    {
    public:
        ~ThemeManager() override = default;
        explicit ThemeManager(IThemePtr defaultTheme, std::shared_ptr<Colors> colors);
        void setActiveTheme(const std::string& themeName) override;
        [[nodiscard]] IThemePtr getActiveTheme() const override;
        [[nodiscard]] std::vector<IThemePtr> loadAndGetAllThemes() override;
        [[nodiscard]] std::string getActiveThemeName() const override;
        void processBrandingColors(const std::map<std::string, std::string>&) override;
        void addThemeFromJson(const std::string& name, GetJsonFunction getInputJson) override;

#ifdef _WIN32
        void addHighContrastThemeFromJson(const std::string& name, GetJsonFunction getInputJson) override;
        void addMomentumHighContrastThemeFromJson(const std::string& name, GetJsonFunction getInputJson) override;
#endif

        bool isThemeSelectable() const override;
        bool isDark() override;
        bool isHighContrast() override;
        bool isMomentumThemeEnabled() override;
        void setIsMomentumThemesEnabled(bool isEnabled) override;

    protected:
        std::shared_ptr<Colors> mColors;
        ThemesMap mLoadedThemes;
        JsonThemesFactories mJsonFactories;
        bool mThemeSelectable {true};
        bool mIsMomentumThemesEnabled { false };

    private:
        void loadTheme(const std::string& themeName);
        IThemePtr createTheme(const std::string& name);
        IThemePtr getParent(const std::string& parentName);
        std::string getActiveMomentumThemeName(const std::string& themeName);
        std::shared_ptr<CoBrandedTheme> mActiveTheme;
    };
}
