#pragma once

#include "Colors.h"

#include <vector>
#include <tuple>


namespace SemanticVisuals
{
    enum class ThemeType;
    enum class Token;

    using ThemeColor = std::tuple<Token, std::string, ColorSet>;
    using ThemeColors = std::vector<ThemeColor>;

    class ITheme
    {
    public:
        virtual ~ITheme() = default;

        [[nodiscard]] virtual std::string getName() const = 0;
        [[nodiscard]] virtual ThemeColors getThemeColors() const = 0;
        [[nodiscard]] virtual ColorSet getColorSet(Token token) const = 0;
        [[nodiscard]] virtual ColorSet getColorSet(const std::string& tokenString) const = 0;
        [[nodiscard]] virtual Color getColorByPath(const std::string& path) const = 0;

        [[nodiscard]] virtual std::string tokenToString(Token token) const = 0;
        [[nodiscard]] virtual Token tokenFromString(const std::string& tokenString) const = 0;

        [[nodiscard]] virtual bool isValidToken(Token token) const = 0;
    };
}