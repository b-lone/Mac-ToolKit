#pragma once
#include <memory>


namespace SemanticVisuals
{
    class ITheme;
    class CoBrandedTheme;

    class CoBrandedThemeCreator
    {
    public:
        static std::shared_ptr<CoBrandedTheme> create(std::shared_ptr<ITheme> originalTheme);
    };

}

