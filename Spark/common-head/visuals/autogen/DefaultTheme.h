/*
    This file is AUTOGENERATED - DO NOT EDIT, or your changes will be lost
    Copyright 2020 Cisco Systems
*/

#pragma once

#include "Tokens.h"
#include "ITheme.h"
#include "Colors.h"

#include <memory>


namespace SemanticVisuals
{
    class DefaultTheme: public ITheme
    {
    public:
        explicit DefaultTheme(std::shared_ptr<Colors> colors);

        [[nodiscard]] ThemeColors getThemeColors() const override;
        [[nodiscard]] ThemeColors getRelevantColors() const override;
        [[nodiscard]] std::string getName() const override;
        [[nodiscard]] ColorSet getColorSet(Token token) const override;
        [[nodiscard]] ColorSet getColorSet(const std::string& tokenString) const override;
        [[nodiscard]] Color getColorByPath(const std::string& path) const override;

        [[nodiscard]] std::string tokenToString(Token token) const override;
        [[nodiscard]] Token tokenFromString(const std::string& tokenString) const override;

        [[nodiscard]] virtual bool isValidToken(Token token) const override;

    private:
        std::shared_ptr<Colors> mColors;
        ThemeColors mThemeColors;
    };
}