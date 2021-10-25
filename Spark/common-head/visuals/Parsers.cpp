#include "Parsers.h"
#include "SparkAlgorithms.h"

#include "spark-client-framework/SparkLogger.h"

#include <json.hpp>
#include <magic_enum/magic_enum.hpp>

#include <optional>


namespace SemanticVisuals::Parsers
{
    using json = nlohmann::json;

    constexpr size_t RESERVED_COLORS_SIZE = 1000;

    std::optional<json> getNode(const json& node, const std::string& name, const bool optional = false)
    {
        if (const auto it = node.find(name); it != node.end())
        {
            return *it;
        }
        if (!optional)
        {
            SPARK_LOG_DEBUG("SemanticVisuals::Parsers, [" << name << "] node doesn't exist!");
        }
        return {};
    }

    std::optional<uint8_t> validateColorValue(const json& node, const std::string& colorStr, bool isAlpha = false)
    {
        if (const auto itColor = getNode(node, colorStr))
        {
            const auto& color = *itColor;

            if (!isAlpha && color.is_number_unsigned())
            {
                const auto val = color.get<unsigned int>();
                return val <= 255 ? val : std::optional<uint8_t>{};
            }

            if (isAlpha && color.is_number())
            {
                const auto val = std::round(color.get<float>() * 255.f);
                return val >= 0.f && val <= 255.f ? static_cast<uint8_t>(val) : std::optional<uint8_t>{};
            }
        }
        SPARK_LOG_DEBUG("SemanticVisuals::Parsers::parseColors(), [" << colorStr << "] not valid!");
        return {};
    }

    void from_json(const json& j, std::optional<SemanticVisuals::Color>& c)
    {
        const auto itRGBA = getNode(j, "rgba");
        if (!itRGBA)
        {
            return;
        }

        auto [r, g, b, a] = std::array{ validateColorValue(*itRGBA, "r"), validateColorValue(*itRGBA, "g"), validateColorValue(*itRGBA, "b"), validateColorValue(*itRGBA, "a", true) };
        if (r && g && b && a)
        {
            c = std::optional<SemanticVisuals::Color>(SemanticVisuals::Color(*r, *g, *b, *a));
        }
    }

    void from_json(const json& j, Colors& colors)
    {
        const auto itColorGroups = getNode(j, "colors");

        if (!itColorGroups)
        {
            return;
        }

        std::vector<std::pair<std::string, std::string>> replacedColors{};
        replacedColors.reserve(RESERVED_COLORS_SIZE);

        for (const auto& itColorGroup : *itColorGroups)
        {
            if (const auto itVariations = getNode(itColorGroup, "variations"))
            {
                for (const auto& itVariation : *itVariations)
                {
                    if (const auto itName = getNode(itVariation, "name"))
                    {
                        if (const auto itAlias = getNode(itVariation, "alias", true); itAlias)
                        {
                            const auto mm = itAlias->get<std::string>();
                            replacedColors.emplace_back(std::make_pair<std::string, std::string>(*itName, *itAlias));
                            continue;
                        }

                        std::optional<SemanticVisuals::Color> color;
                        from_json(itVariation, color);

                        if (color)
                        {
                            colors.setColor(*itName, *color);
                        }
                    }
                }
            }
        }

        for (const auto& replacedColor : replacedColors)
        {
            if (const auto aliasColor = colors.getColor(replacedColor.second))
            {
                colors.setColor(replacedColor.first, *aliasColor);
            }
            else
            {
                SPARK_LOG_DEBUG("SemanticVisuals::Parsers::parseColors(), error replacing [" << replacedColor.first << "], with [" << replacedColor.second << "], which doesn't exist!");
            }
        }
    }

    SemanticVisuals::Color parseJsonColor(const nlohmann::json& inputJson)
    {
        SemanticVisuals::Color color;
        auto [r, g, b, a] = std::array{ validateColorValue(inputJson, "r"), validateColorValue(inputJson, "g"), validateColorValue(inputJson, "b"), validateColorValue(inputJson, "a", true) };
        if (r && g && b && a)
        {
            color = SemanticVisuals::Color(*r, *g, *b, *a);
        }
        return color;
    }

    Colors parseColors(const std::string& inputJson)
    {
        if (!json::accept(inputJson))
            return {};

        Colors colors;
        from_json(json::parse(inputJson), colors);
        return colors;
    }

    constexpr size_t RESERVED_TOKENS_SIZE = 10000;

    void from_json(const json& j, UIStates& states)
    {
        for (auto& it : j.items()) {
            if (const auto uiState = magic_enum::enum_cast<UIState>(it.key()))
            {
                states.emplace_back(*uiState, it.value());
            }
            else
            {
                SPARK_LOG_DEBUG("SemanticVisuals::Parsers::parseTheme(), invalid token state [" << it.key() << "]!");
            }
        }
    }

    void from_json(const json& j, std::optional<Theme>& theme)
    {
        const auto itName = getNode(j, "name");

        if (!itName)
        {
            return;
        }

        const auto itParent = getNode(j, "parent");
        const auto itTokens = getNode(j, "tokens");

        if (itTokens == std::nullopt || (*itTokens).empty())
        {
            return;
        }

        Tokens tokens;
        tokens.reserve(RESERVED_TOKENS_SIZE);

        for (auto& itToken : (*itTokens).items())
        {
            const auto& tokenName = itToken.key();
            UIStates parsedStates;
            from_json(itToken.value(), parsedStates);

            if (parsedStates.cend() == spark::find_if(parsedStates, [](const auto& s) { return UIState::normal == s.first; }))
            {
                SPARK_LOG_DEBUG("SemanticVisuals::Parsers::parseTheme(), normal state not defined!");
                return;
            }
            tokens.emplace_back(tokenName, parsedStates);
        }

        theme = std::optional<Theme>{ Theme(*itName, itParent ? *itParent : "light", tokens) };
    }

    std::optional<Theme> parseTheme(const std::string& inputJson)
    {
        if (!json::accept(inputJson))
            return {};

        const auto tokens(json::parse(inputJson));
        std::optional<Theme> parsedTheme;
        from_json(tokens, parsedTheme);

        return parsedTheme;
    }

#ifdef _WIN32
    std::optional<HighContrastTokens> parseHighContrastTheme(const std::string& inputJson)
    {
        std::optional<HighContrastTokens> highContrastTokens;

        if (!json::accept(inputJson))
            return {};

        const auto themeData(json::parse(inputJson));

        const auto itTokens = getNode(themeData, "tokens");

        HighContrastTokens tokens;

        for (auto& itToken : (*itTokens).items())
        {
            const auto& tokenName = itToken.key();
            HighContrastUIStates parsedStates;
            

            for (auto& it : itToken.value().items())
            {
                if (const auto uiState = magic_enum::enum_cast<UIState>(it.key()))
                {
                    parsedStates.emplace_back(*uiState, it.value());
                }
            }

            if (parsedStates.cend() == spark::find_if(parsedStates, [](const auto& s) { return UIState::normal == s.first; }))
            {
                SPARK_LOG_DEBUG("SemanticVisuals::Parsers::parseTheme(), normal state not defined!");
                return {};
            }

            tokens.emplace_back(tokenName, parsedStates);
        }

        highContrastTokens.emplace(tokens);

        return highContrastTokens;
    }
#endif
}
