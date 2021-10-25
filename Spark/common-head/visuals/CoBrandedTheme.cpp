#include "CoBrandedTheme.h"

#include "Parsers.h"
#include "Tokens.h"
#include "SparkAlgorithms.h"

#include <functional>
#include <utility>


namespace SemanticVisuals
{
    CoBrandedTheme::CoBrandedTheme(std::shared_ptr<ITheme> proxiedTheme, ElemsMapping elemsMapping)
        : PartialTheme(proxiedTheme->getName(), proxiedTheme)
        , mElemsMapping(std::move(elemsMapping))
    {
    }

    void CoBrandedTheme::processBrandingColors(std::map<std::string, std::string> customColors)
    {
        auto isNormal = [](auto elem) { return std::get<ColorStatePtr>(elem) == &ColorSet::normal; };

        auto activeElems = spark::filter(mElemsMapping, [customColors](auto x) {
            auto elemName = std::get<std::string>(x);
            return customColors.find(elemName) != customColors.end();
        });

        auto normalStates = spark::filter(activeElems, [isNormal](auto x) { return isNormal(x); });
        auto otherStates = spark::filter(activeElems, [isNormal](auto x) { return !isNormal(x); });

        ThemeColors alteredColors;
        for (auto state: normalStates)
        {
            auto token = std::get<Token>(state);
            alteredColors.emplace_back(
                token, 
                tokenToString(token),
                Color(customColors[std::get<std::string>(state)]));
        }

        for (auto state: otherStates)
        {
            auto colorIt = std::find_if(alteredColors.begin(), alteredColors.end(), [state](auto colorInfo)
            {
                return std::get<Token>(state) == std::get<Token>(colorInfo);
            });

            auto statePtr = std::get<ColorStatePtr>(state);
            if (colorIt != alteredColors.end())
            {
                auto& colorSet = std::get<ColorSet>(*colorIt);
                colorSet.*statePtr = Color(customColors[std::get<std::string>(state)]);
                colorSet = colorSet;
            }
            else
            {
                // here we clone a token from the base theme and alter it
                auto token = std::get<Token>(state);
                auto baseColorSet = mParentTheme->getColorSet(token);
                baseColorSet.*statePtr = Color(customColors[std::get<std::string>(state)]);
                alteredColors.emplace_back(
                    token,
                    tokenToString(token),
                    baseColorSet
                );
            }
        }

        setAlteredColors(alteredColors);
    }
}

