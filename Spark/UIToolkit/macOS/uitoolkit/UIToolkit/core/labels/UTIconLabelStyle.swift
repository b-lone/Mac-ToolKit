//
//  UTIconLabelStyle.swift
//  UIToolkit
//
//  Created by James Nestor on 24/08/2021.
//

public enum UTIconLabelStyle {
    case primary
    case secondary
    
    case success
    case warning
    case error
    
    case hyperlink
    
    case presenceDND
    case presenceMeeting
    case presenceAway
    
    case callMediaIndicator
    case callMediaIndicatorWithBackground
    
    case mediaQualityIndicatorGood
    case mediaQualityIndicatorPoor
    case mediaQualityIndicatorUnstable
    
    case callButtonCancelFill
    case callButtonJoinFill
    case callButtonSecondary
    case callButtonGhost
    
    case buttonPrimaryText
    
    case globalPlusMenuOptionDisabled
    case externalUser
    case listItemTick
        
    var textToken:String{
        switch self{
        case .primary:
            return UTColorTokens.labelPrimaryText.rawValue
        case .secondary:
            return UTColorTokens.labelSecondaryText.rawValue
        case .success:
            return UTColorTokens.labelSuccessText.rawValue
        case .warning:
            return UTColorTokens.labelWarningText.rawValue
        case .error:
            return UTColorTokens.labelErrorText.rawValue
        case .hyperlink:
            return UTColorTokens.buttonHyperlinkText.rawValue
            
        case .presenceDND:
            return UTColorTokens.avatarPresenceIconDnd.rawValue
        case .presenceMeeting:
            return UTColorTokens.avatarPresenceIconMeeting.rawValue
        case .presenceAway:
            return UTColorTokens.avatarPresenceIconAway.rawValue
            
        case .callMediaIndicator:
            return UTColorTokens.labelPrimaryText.rawValue
        case .callMediaIndicatorWithBackground:
            return UTColorTokens.buttonJoinFillText.rawValue
            
        case .mediaQualityIndicatorGood:
            return UTColorTokens.avatarPresenceIconActive.rawValue
        case .mediaQualityIndicatorPoor:
            return UTColorTokens.avatarPresenceIconDnd.rawValue
        case .mediaQualityIndicatorUnstable:
            return UTColorTokens.labelWarningText.rawValue
            
        case .callButtonCancelFill:
            return UTColorTokens.buttonCancelFillText.rawValue
        case .callButtonJoinFill:
            return UTColorTokens.buttonJoinFillText.rawValue
        case .callButtonSecondary:
            return UTColorTokens.buttonSecondaryText.rawValue
        case .callButtonGhost:
            return UTColorTokens.buttonGhostText.rawValue
            
        case .buttonPrimaryText:
            return UTColorTokens.buttonPrimaryText.rawValue
        
        case .globalPlusMenuOptionDisabled:
            return "inputText-secondary"
        
        case .externalUser:
            return UTColorTokens.labelWarningText.rawValue
        case .listItemTick:
            return UTColorTokens.listitemTick.rawValue
        }
    }
    
    public var colorStates:UTColorStates {
        return UIToolkit.shared.getThemeManager().getColors(tokenName: textToken)
    }
}
