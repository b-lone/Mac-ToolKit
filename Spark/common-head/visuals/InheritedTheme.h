#pragma once

#include "PartialTheme.h"
#include <memory>
#include <functional>


namespace SemanticVisuals
{
    namespace Parsers
    {
        struct Theme;
    }

    using TokenFromStringFunction = std::function<Token(std::string)>;
    using TokenToStringFunction = std::function<std::string(Token)>;

    class InheritedTheme: public PartialTheme
    {
    public:
        InheritedTheme(std::string name, std::shared_ptr<ITheme> parentTheme, const Parsers::Theme& themeData, std::shared_ptr<Colors> colors, TokenFromStringFunction tokenFromStringFunc, TokenToStringFunction tokenToStringFunc);

    private:
        std::shared_ptr<Colors> mColors;
    };
    

}

