#pragma once

#include "Colors.h"

#include <vector>
#include <string>
#include <utility>
#include <tuple>
#include <json.hpp>

namespace SemanticVisuals::Parsers
{
    Colors parseColors(const std::string& inputJson);
    SemanticVisuals::Color parseJsonColor(const nlohmann::json& inputJson);

    enum class UIState
    {
        normal = 0,
        hovered,
        pressed,
        disabled,
        focused,
        checked
    };

    using Color = nlohmann::json;
    using UIStates = std::vector<std::pair<UIState, Color>>;
    using Token = std::string;
    using Tokens = std::vector<std::pair<Token, UIStates>>;


    struct Theme
    {
        friend bool operator==(const Theme& lhs, const Theme& rhs)
        {
            return std::tie(lhs.name, lhs.parent, lhs.tokens) == std::tie(rhs.name, rhs.parent, rhs.tokens);
        }

        Theme(std::string name, std::string parent, Tokens tokens)
            : name(std::move(name)), parent(std::move(parent)), tokens(std::move(tokens))
        {}
        Theme() = default;
        std::string name;
        std::string parent;
        Tokens tokens;
    };

    using HighContrastUIStates = std::vector<std::pair<UIState, std::string>>;
    using HighContrastTokens = std::vector<std::pair<Token, HighContrastUIStates>>;

    std::optional<Theme> parseTheme(const std::string& inputJson);

#ifdef _WIN32
    std::optional<HighContrastTokens> parseHighContrastTheme(const std::string& inputJson);
#endif
}
