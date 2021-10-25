#include "ThemesFactory.h"
#include "ThemeManager.h"
#include "Parsers.h"
#include "DefaultTheme.h"
#include "spark-client-framework/Utilities/StringUtils.h"

#include <cmrc/cmrc.hpp>
#include <json.hpp>


CMRC_DECLARE(visualsrc);

namespace SemanticVisuals::ThemeManagerFactory
{
    std::shared_ptr<IThemeManager> CreateManager()
    {
        const auto fs = cmrc::visualsrc::get_filesystem();
        const auto colorsJson = fs.open("visual/config/colors.json");
        const auto colors = Parsers::parseColors({ colorsJson.cbegin(), colorsJson.cend() });

        const auto sharedColors = std::make_shared<Colors>(colors);
        auto themeManager = std::make_shared<ThemeManager>(std::make_shared<DefaultTheme>(sharedColors), sharedColors);

        //NOTE: Correct order important here, to keep right theme inheritance parent theme should be added first
        for (const std::string& name : {"dark", "bronzeDark", "bronzeLight", "jadeDark", "jadeLight", "lavenderDark", "lavenderLight", "gradient", "emeraldLight", "emeraldDark"})
        {
            auto capitalizedName = StringUtils::toUpper(name.substr(0, 1)) + name.substr(1);

            themeManager->addThemeFromJson(capitalizedName, [name]()
            {
                const auto fs = cmrc::visualsrc::get_filesystem();
                const auto themeFile = fs.open("visual/config/themes/" + name + ".json");
                return std::string(themeFile.cbegin(), themeFile.cend());
            });
        }
        
        for (const std::string& name : {"momentumDefault", "momentumDark", "momentumBronzeDark", "momentumBronzeLight", "momentumJadeDark", "momentumJadeLight", "momentumLavenderDark", "momentumLavenderLight", "momentumIndigoDark", "momentumIndigoLight", "momentumRoseDark", "momentumRoseLight" })
        {
            auto capitalizedName = StringUtils::toUpper(name.substr(0, 1)) + name.substr(1);

            themeManager->addThemeFromJson(capitalizedName, [name]()
            {
                const auto fs = cmrc::visualsrc::get_filesystem();
                const auto themeFile = fs.open("visual/config/themes/momentum/" + name + ".json");
                return std::string(themeFile.cbegin(), themeFile.cend());
            });
        }

#ifdef _WIN32
        themeManager->addHighContrastThemeFromJson("SystemHighContrast", []()
        {
            const auto& fs = cmrc::visualsrc::get_filesystem();
            const auto themeFile = fs.open("visual/config/themes/systemHighContrast.json");
            return std::string(themeFile.cbegin(), themeFile.cend());
        });

        themeManager->addMomentumHighContrastThemeFromJson("MomentumSystemHighContrast", []()
        {
          const auto& fs = cmrc::visualsrc::get_filesystem();
          const auto themeFile = fs.open("visual/config/themes/momentum/momentumSystemHighContrast.json");
          return std::string(themeFile.cbegin(), themeFile.cend());
        });
#endif

        return themeManager;
    }
}
