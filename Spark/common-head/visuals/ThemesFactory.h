#pragma once

#include "IThemeManager.h"
#include <memory>


namespace SemanticVisuals::ThemeManagerFactory
{
    std::shared_ptr<SemanticVisuals::IThemeManager> CreateManager();
}
