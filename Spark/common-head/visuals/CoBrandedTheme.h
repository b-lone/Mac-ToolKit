#pragma once

#include "PartialTheme.h"

#include <map>
#include <memory>
#include <utility>


namespace SemanticVisuals
{
    using ColorStatePtr = Color ColorSet::*;
    using ElemToSemanticMapping = std::tuple<std::string, Token, ColorStatePtr>;
    using ElemsMapping = std::vector<ElemToSemanticMapping>;

    class CoBrandedTheme: public PartialTheme
    {
    public:
        CoBrandedTheme(std::shared_ptr<ITheme> proxiedTheme, ElemsMapping elemsMapping);
        ~CoBrandedTheme() override = default;

        void processBrandingColors(std::map<std::string, std::string> customColors);
    private:
        ElemsMapping mElemsMapping;
    };
}

