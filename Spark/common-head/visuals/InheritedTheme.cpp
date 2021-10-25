#include "InheritedTheme.h"

#include "Parsers.h"
#include "SparkAlgorithms.h"
#include "spark-client-framework/Utilities/StringUtils.h"

#include <functional>
#include <utility>
#include "SparkAssert.h"
#include <json.hpp>
#include "Tokens.h"

namespace SemanticVisuals
{
    InheritedTheme::InheritedTheme(std::string name, std::shared_ptr<ITheme> parentTheme, const Parsers::Theme& themeData, std::shared_ptr<Colors> colors, TokenFromStringFunction tokenFromStringFunc, TokenToStringFunction tokenToStringFunc)
        : PartialTheme(std::move(name), std::move(parentTheme))
        , mColors(std::move(colors))
    {
        ThemeColors alteredColors;

        const auto& allTokens = themeData.tokens;

        auto color = [this](const std::string& name) { return *mColors->getColor(name); };
        using ApplyPropertyFunc = ColorSet& (ColorSet::*) (Color);

        std::map<Parsers::UIState, ApplyPropertyFunc> propertyMappings = {
            { Parsers::UIState::hovered , &ColorSet::setHovered },
            { Parsers::UIState::pressed, &ColorSet::setPressed },
            { Parsers::UIState::checked, &ColorSet::setChecked },
            { Parsers::UIState::focused, &ColorSet::setFocused },
            { Parsers::UIState::disabled, &ColorSet::setDisabled }
        };

        auto getState = [](const Parsers::UIState state, const Parsers::UIStates& states)
        {
            const auto it = spark::find_if(states, [state](auto statePair)
            {
                return statePair.first == state;
            });

            return it != states.end() ? (*it).second : "";
        };

        for (const auto& tokenData: allTokens)
        {
            auto token = tokenFromStringFunc(tokenData.first);
            if (!StringUtils::startsWith(mName, "Momentum") && !mParentTheme->isValidToken(token))
            {
                sparkAssert(false, "Trying to define token " << tokenData.first << " in theme " << mName << " that doesn't exist in a parent theme " << mParentTheme->getName());
                continue;
            }

            if (auto normalState = getState(Parsers::UIState::normal, tokenData.second); !normalState.empty())
            {
                auto colorSet = ColorSet(normalState.is_object() ? Parsers::parseJsonColor(normalState) : color(normalState));
                auto otherStates = spark::filter(tokenData.second, [](auto statePair)
                {
                    return statePair.first != Parsers::UIState::normal;
                });

                for(auto statePair: otherStates)
                {
                    auto propertySetter = propertyMappings[std::get<Parsers::UIState>(statePair)];
                    auto state = std::get<Parsers::Color>(statePair);
                    (colorSet.*propertySetter)(statePair.second.is_object() ? Parsers::parseJsonColor(state) : color(state));
                }

                alteredColors.emplace_back(token, tokenToStringFunc(token), colorSet);
            }
        }

        setAlteredColors(alteredColors);
    }
}
