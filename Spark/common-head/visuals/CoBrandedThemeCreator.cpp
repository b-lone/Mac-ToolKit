#include "CoBrandedThemeCreator.h"
#include "CoBrandedTheme.h"
#include "Tokens.h"


std::shared_ptr<SemanticVisuals::CoBrandedTheme> SemanticVisuals::CoBrandedThemeCreator::create(std::shared_ptr<ITheme> originalTheme)
{
        auto coBrandingElemsMapping = ElemsMapping({
            { "appHeader", Token::AppHeader, &ColorSet::normal },
            { "appHeader", Token::GlobalHeaderContainerBackground, &ColorSet::normal },
                        
            { "appHeader-buttonDevice", Token::AppHeaderButtonDevice, &ColorSet::normal },
            { "appHeader-buttonDevice", Token::GlobalHeaderButtonDeviceBackground, &ColorSet::normal },
            { "appHeader-buttonDevice-hover", Token::AppHeaderButtonDevice, &ColorSet::hovered },
            { "appHeader-buttonDevice-hover", Token::GlobalHeaderButtonDeviceBackground, &ColorSet::hovered },
            { "appHeader-buttonDevice-pressed", Token::AppHeaderButtonDevice, &ColorSet::pressed },
            { "appHeader-buttonDevice-pressed", Token::GlobalHeaderButtonDeviceBackground, &ColorSet::pressed },
            { "appHeader-buttonDevice-text", Token::GlobalHeaderButtonDeviceTextInactive, &ColorSet::normal },
            { "appHeader-buttonDevice-text-active", Token::AppHeaderButtonDeviceTextActive, &ColorSet::normal },
            { "appHeader-buttonDevice-text-active", Token::GlobalHeaderButtonDeviceTextActive, &ColorSet::normal },

            { "appHeader-buttonPlus", Token::AppHeaderButtonPlus, &ColorSet::normal },
            { "appHeader-buttonPlus", Token::GlobalHeaderButtonIconBackground, &ColorSet::normal },
            { "appHeader-buttonPlus-hover", Token::AppHeaderButtonPlus, &ColorSet::hovered },
            { "appHeader-buttonPlus-hover", Token::GlobalHeaderButtonIconBackground, &ColorSet::hovered },
            { "appHeader-buttonPlus-pressed", Token::AppHeaderButtonPlus, &ColorSet::pressed },
            { "appHeader-buttonPlus-pressed", Token::GlobalHeaderButtonIconBackground, &ColorSet::pressed },
            { "appHeader-buttonPlus-icon", Token::AppHeaderButtonPlusIcon, &ColorSet::normal },
            { "appHeader-buttonPlus-icon", Token::GlobalHeaderButtonIconIcon, &ColorSet::normal },

            { "appHeader-buttonStatus", Token::AppHeaderButtonStatus, &ColorSet::normal },
            { "appHeader-buttonStatus", Token::GlobalHeaderButtonStatusBackground, &ColorSet::normal },
            { "appHeader-buttonStatus-hover", Token::AppHeaderButtonStatus, &ColorSet::hovered },
            { "appHeader-buttonStatus-hover", Token::GlobalHeaderButtonStatusBackground, &ColorSet::hovered },
            { "appHeader-buttonStatus-pressed", Token::AppHeaderButtonStatus, &ColorSet::pressed },
            { "appHeader-buttonStatus-pressed", Token::GlobalHeaderButtonStatusBackground, &ColorSet::pressed },
            { "appHeader-buttonStatus-text", Token::GlobalHeaderButtonStatusText, &ColorSet::normal },
            
            { "appHeader-searchBar", Token::AppHeaderSearchBar, &ColorSet::normal },
            { "appHeader-searchBar", Token::GlobalHeaderTextfieldBackground, &ColorSet::normal },
            { "appHeader-searchBar-hover", Token::AppHeaderSearchBar, &ColorSet::hovered },
            { "appHeader-searchBar-hover", Token::GlobalHeaderTextfieldBackground, &ColorSet::hovered },
            { "appHeader-searchBar-pressed", Token::AppHeaderSearchBar, &ColorSet::pressed },
            { "appHeader-searchBar-pressed", Token::GlobalHeaderTextfieldBackground, &ColorSet::pressed },
            { "appHeader-searchBar-text", Token::SearchText, &ColorSet::normal },
            { "appHeader-searchBar-text", Token::GlobalHeaderTextfieldPlaceholderTextText, &ColorSet::normal },
            { "appHeader-searchBar-text", Token::GlobalHeaderTextfieldText, &ColorSet::normal },
            { "appHeader-searchBar-text", Token::GlobalHeaderSearchCancelButtonBorder, &ColorSet::normal },
            { "appHeader-searchBar-text", Token::GlobalHeaderSearchCancelButtonText, &ColorSet::normal },
            
            { "appNav-badge", Token::AppNavBadge, &ColorSet::normal },
            { "appNav-badge", Token::BadgeBackground, &ColorSet::normal },
            { "appNav-badge-text",  Token::AppNavBadgeText, &ColorSet::normal },
            { "appNav-badge-text",  Token::BadgeText, &ColorSet::normal },
            { "appNav-icon-active", Token::AppNavIcon, &ColorSet::checked },
            { "appNav-icon-active", Token::TabActiveText, &ColorSet::normal },

            { "button-primary", Token::ButtonPrimary, &ColorSet::normal},
            { "button-primary", Token::ButtonPrimaryBackground, &ColorSet::normal},
            { "button-primary-hover", Token::ButtonPrimary, &ColorSet::hovered },
            { "button-primary-hover", Token::ButtonPrimaryBackground, &ColorSet::hovered },
            { "button-primary-pressed", Token::ButtonPrimary, &ColorSet::pressed },
            { "button-primary-pressed", Token::ButtonPrimaryBackground, &ColorSet::pressed },
            { "button-primary-text", Token::ButtonTextPrimary, &ColorSet::normal },
            { "button-primary-text", Token::ButtonPrimaryText, &ColorSet::normal },

            { "text-hyperlink", Token::TextHyperlink, &ColorSet::normal },
            { "text-hyperlink", Token::ButtonMessageGhostText, &ColorSet::normal },
            { "text-hyperlink", Token::ButtonHyperlinkText, &ColorSet::normal },
            { "text-hyperlink-hover", Token::TextHyperlink, &ColorSet::hovered },
            { "text-hyperlink-hover", Token::ButtonMessageGhostText, &ColorSet::hovered },
            { "text-hyperlink-hover", Token::ButtonHyperlinkText, &ColorSet::hovered },
            { "text-hyperlink-pressed", Token::ButtonMessageGhostText, &ColorSet::pressed },
            { "text-hyperlink-pressed", Token::ButtonHyperlinkText, &ColorSet::pressed },
            
            { "mainList-indicator", Token::MainListIndicator, &ColorSet::normal },
            { "mainList-indicator", Token::BadgeNotificationIndicator, &ColorSet::normal },
        });

    return std::make_shared<CoBrandedTheme>(originalTheme, coBrandingElemsMapping);
}

