include(DetectTargetPlatform)
include(BuildModule)
include(VisualsCodeGeneration)
include(CMakeRC)

DetectTargetPlatform()

#
# Place theme JSON file to this list
#
set(CLIENT_THEMES_JSON
    config/themes/bronzeDark.json
    config/themes/bronzeLight.json
    config/themes/dark.json
    config/themes/default.json
    config/themes/jadeDark.json
    config/themes/jadeLight.json
    config/themes/lavenderDark.json
    config/themes/lavenderLight.json
    config/themes/gradient.json
    config/themes/emeraldLight.json
    config/themes/emeraldDark.json
)
set(SYSTEM_THEMES_JSON
    config/themes/systemHighContrast.json
    config/themes/momentum/momentumSystemHighContrast.json
)
set(MOMENTUM_THEMES_JSON
    config/themes/momentum/momentumBronzeDark.json
    config/themes/momentum/momentumBronzeLight.json
    config/themes/momentum/momentumDark.json
    config/themes/momentum/momentumDefault.json
    config/themes/momentum/momentumJadeDark.json
    config/themes/momentum/momentumJadeLight.json
    config/themes/momentum/momentumLavenderDark.json
    config/themes/momentum/momentumLavenderLight.json
    config/themes/momentum/momentumIndigoDark.json
    config/themes/momentum/momentumIndigoLight.json
    config/themes/momentum/momentumRoseDark.json
    config/themes/momentum/momentumRoseLight.json
)

set (ALL_THEMES_JSON
    ${CLIENT_THEMES_JSON}
)

if (TARGET_WINDOWS)
    list(APPEND ALL_THEMES_JSON ${SYSTEM_THEMES_JSON})
endif()

set(DEFAULT_THEME_JSON
    config/themes/default.json
)

set(COLORS_JSON
    config/colors.json
)

#
# Generate c++ code base on the themes
#
VisualsCodeGeneration(
    GENERATED_OUTPUT GENERATED_CH_FILES
    OUTPUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/autogen"
    THEME_GENERATION_INPUTS
        ${DEFAULT_THEME_JSON}
    MOMENTUM_THEME_GENERATION_INPUTS
        ${MOMENTUM_THEMES_JSON}
    THEME_VALIDATION_INPUTS
        ${CLIENT_THEMES_JSON}
    CODEGEN_DIR ${CMAKE_CURRENT_SOURCE_DIR}/codegen
    COLORS_INPUT ${CMAKE_CURRENT_SOURCE_DIR}/config/colors.json
)

#
# Add themes as resource
#
cmrc_add_resource_library(visuals_resources
    ALIAS visuals::rc
    NAMESPACE visualsrc
    PREFIX visual
    ${ALL_THEMES_JSON}
    ${MOMENTUM_THEMES_JSON}
    ${COLORS_JSON}
)

#
# Build visuals
#
BuildModule(
    NAME visuals
    IDE_FOLDER common-head
    FILES
        Colors.cpp
        Colors.h
        ITheme.h
        IThemeManager.h
        ThemeManager.h
        ThemeManager.cpp
        PartialTheme.h
        PartialTheme.cpp
        InheritedTheme.h
        InheritedTheme.cpp
        CoBrandedTheme.h
        CoBrandedTheme.cpp
        CoBrandedThemeCreator.h
        CoBrandedThemeCreator.cpp
        ThemesFactory.h
        ThemesFactory.cpp
        Parsers.cpp
        Parsers.h
        CSSGenerator.h
        ${GENERATED_CH_FILES}
        ${COLORS_JSON}
        ${ALL_THEMES_JSON}
        ${MOMENTUM_THEMES_JSON}
    FILES_WINDOWS
        SystemHighContrastTheme.cpp
        SystemHighContrastTheme.h
    DEPENDS_ON
        nlohmann
        scf
        visuals::rc
        magic_enum
    PUBLIC_HEADERS_DIR
        "${CMAKE_CURRENT_BINARY_DIR}"
        "${CMAKE_CURRENT_BINARY_DIR}/autogen"
        .
)
