#pragma once

#include "Tokens.h"
#include "CoBrandedTheme.h"

#include <string>
#include <vector>
#include <sstream>
#include <tuple>


namespace SemanticVisuals
{
    using CSSToken = std::tuple<Token, ColorStatePtr>;
    using CSSTokens = std::vector<CSSToken>;

    class CSSGenerator
    {
        CSSTokens mCSSTokens {
            { Token::TextHyperlink, &ColorSet::normal },
            { Token::TextHyperlink, &ColorSet::hovered },
            { Token::ThemeGradientSecondary1Background, &ColorSet::normal },
            { Token::ThemeGradientSecondary0Background, &ColorSet::normal },
            /* the above are used in all themes, below ones are only used in System High Contrast */
            { Token::BackgroundPrimary, &ColorSet::normal },
            { Token::TextPrimary, &ColorSet::normal },
            { Token::TextPrimary, &ColorSet::disabled },
            { Token::ButtonPrimary, &ColorSet::normal },
            { Token::ButtonPrimary, &ColorSet::hovered },
            { Token::ButtonTextPrimary, &ColorSet::normal },
            { Token::ButtonTextPrimary, &ColorSet::hovered },
            { Token::LegacySeparatorPrimary, &ColorSet::normal },
            { Token::LegacySeparatorSecondary, &ColorSet::normal },
            { Token::ButtonTertiary, &ColorSet::hovered },
            { Token::ButtonTertiary, &ColorSet::pressed },
            { Token::AvatarPresenceIconActive, &ColorSet::normal },
            { Token::AvatarPresenceIconMeeting, &ColorSet::normal },
            { Token::AvatarPresenceIconSchedule, &ColorSet::normal },
            { Token::AvatarPresenceIconDnd, &ColorSet::normal },
            { Token::AvatarPresenceIconPresenting, &ColorSet::normal },
            { Token::AvatarPresenceIconQuietHours, &ColorSet::normal },
            { Token::AvatarPresenceIconAway, &ColorSet::normal },
            { Token::AvatarPresenceIconOoo, &ColorSet::normal },
            { Token::AvatarPresenceIconBackground, &ColorSet::normal },
            { Token::AvatarChatBubbleIconNormal, &ColorSet::normal },
            { Token::AvatarChatBubbleBorderNormal, &ColorSet::normal }
        };
    public:
        std::string generate(const IThemePtr& theme)
        {
            std::stringstream ss;
            ss << ".semantic { ";
            for (const auto& [token, state] : mCSSTokens)
            {
                const auto name = theme->tokenToString(token) + "-" + stateToStr(state);
                const auto color = theme->getColorSet(token).*state;
                ss << "--" << name << ": " << color.rgb() << "; ";
            }
            ss << "}";
            return ss.str();
        }

    private:
        static std::string stateToStr(const ColorStatePtr& state)
        {
            if (state == &ColorSet::hovered)
            {
                return "hovered";
            }
            if (state == &ColorSet::pressed)
            {
                return "pressed";
            }
            if (state == &ColorSet::disabled)
            {
                return "disabled";
            }
            if (state == &ColorSet::focused)
            {
                return "focused";
            }
            return "normal";
        }
    };
}
