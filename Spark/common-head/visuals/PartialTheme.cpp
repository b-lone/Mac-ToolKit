#include "PartialTheme.h"

#include "Parsers.h"
#include "Tokens.h"
#include "SparkAlgorithms.h"

#include <functional>
#include <utility>


namespace SemanticVisuals
{
    PartialTheme::PartialTheme(std::string name, std::shared_ptr<ITheme> parentTheme)
        : mName(std::move(name))
        , mParentTheme(std::move(parentTheme))
    {
    }

    std::string PartialTheme::getName() const
    {
        return mName;
    }

    inline ThemeColors PartialTheme::getThemeColors() const
    {
        auto baseColors = mParentTheme->getThemeColors();

        auto resultColors = mAlteredColors;
        for (const auto& baseColor : baseColors)
        {
            auto baseIt = spark::find_if(resultColors, [baseColor](auto c)
            {
                return std::get<Token>(baseColor) == std::get<Token>(c);
            });

            if (baseIt == resultColors.end())
            {
                resultColors.push_back(baseColor);
            }
        }

        return resultColors;
    }

    inline ColorSet PartialTheme::getColorSet(Token token) const
    {
        const auto colorSetIt = spark::find_if(mAlteredColors, [=](auto t)
        {
            return std::get<Token>(t) == token;
        });

        return colorSetIt != std::end(mAlteredColors) ? std::get<ColorSet>(*colorSetIt) : mParentTheme->getColorSet(token);
    }

    inline ColorSet PartialTheme::getColorSet(const std::string& tokenString) const
    {
        const auto colorSetIt = spark::find_if(mAlteredColors, [=](auto t)
        {
            return std::get<std::string>(t) == tokenString;
        });

        return colorSetIt != std::end(mAlteredColors) ? std::get<ColorSet>(*colorSetIt) : mParentTheme->getColorSet(tokenString);
    }

    inline Color PartialTheme::getColorByPath(const std::string& path) const
    {
        return mParentTheme->getColorByPath(path);
    }

    inline std::string PartialTheme::tokenToString(Token token) const
    {
        return mParentTheme->tokenToString(token);
    }

    inline Token PartialTheme::tokenFromString(const std::string& tokenString) const
    {
        return mParentTheme->tokenFromString(tokenString);
    }

    bool PartialTheme::isValidToken(Token token) const
    {
        return mParentTheme->isValidToken(token);
    }

    void PartialTheme::setAlteredColors(ThemeColors alteredColors)
    {
        mAlteredColors = std::move(alteredColors);
    }
}

