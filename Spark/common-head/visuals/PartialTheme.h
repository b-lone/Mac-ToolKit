#pragma once

#include "ITheme.h"

#include <memory>
#include <utility>


namespace SemanticVisuals
{
    class PartialTheme: public ITheme
    {
    public:
        PartialTheme(std::string name, std::shared_ptr<ITheme> parentTheme);
        ~PartialTheme() override = default;

        [[nodiscard]] std::string getName() const override;
        [[nodiscard]] ThemeColors getThemeColors() const override;
        [[nodiscard]] ColorSet getColorSet(Token token) const override;
        [[nodiscard]] ColorSet getColorSet(const std::string& tokenString) const override;
        [[nodiscard]] Color getColorByPath(const std::string& path) const override;
        [[nodiscard]] std::string tokenToString(Token token) const override;
        [[nodiscard]] Token tokenFromString(const std::string& tokenString) const override;
        [[nodiscard]] bool isValidToken(Token token) const override;
        
    protected:
        void setAlteredColors(ThemeColors alteredColors);

        std::string mName;
        std::shared_ptr<ITheme> mParentTheme;
        ThemeColors mAlteredColors;
    };
}

