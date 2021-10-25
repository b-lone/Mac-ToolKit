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
        
    var textToken:String{
        switch self{
        case .primary:
            return UIToolkit.shared.isUsingLegacyTokens ? "text-primary" : UTColorTokens.labelPrimaryText.rawValue
        case .secondary:
            return UIToolkit.shared.isUsingLegacyTokens ? "text-secondary" : UTColorTokens.labelSecondaryText.rawValue
        case .success:
            return UIToolkit.shared.isUsingLegacyTokens ? "alertText-success" : UTColorTokens.labelSuccessText.rawValue
        case .warning:
            return UIToolkit.shared.isUsingLegacyTokens ? "alertText-warning" : UTColorTokens.labelWarningText.rawValue
        case .error:
            return UIToolkit.shared.isUsingLegacyTokens ? "alertText-error" : UTColorTokens.labelErrorText.rawValue
        case .hyperlink:
            return UIToolkit.shared.isUsingLegacyTokens ? "text-hyperlink" : UTColorTokens.buttonHyperlinkText.rawValue
            
        case .presenceDND:
            return UIToolkit.shared.isUsingLegacyTokens ? "alertText-error" : "avatar-presence-icon-dnd"
        case .presenceMeeting:
            return UIToolkit.shared.isUsingLegacyTokens ? "alertText-warning" : "avatar-presence-icon-meeting"
        case .presenceAway:
            return UIToolkit.shared.isUsingLegacyTokens ? "text-primary" : "avatar-presence-icon-away"
            
        case .callMediaIndicator:
            return UIToolkit.shared.isUsingLegacyTokens ? "buttonText-secondary" : UTColorTokens.labelPrimaryText.rawValue
        case .callMediaIndicatorWithBackground:
            return UIToolkit.shared.isUsingLegacyTokens ? "buttonText-primary" : UTColorTokens.buttonJoinFillText.rawValue
            
        case .mediaQualityIndicatorGood:
            return UIToolkit.shared.isUsingLegacyTokens ? "wx-activated-device-status" : UTColorTokens.avatarPresenceIconActive.rawValue
        case .mediaQualityIndicatorPoor:
            return UIToolkit.shared.isUsingLegacyTokens ? "wx-callStripAudioVideoButton-icon" : UTColorTokens.avatarPresenceIconDnd.rawValue
        case .mediaQualityIndicatorUnstable:
            return UIToolkit.shared.isUsingLegacyTokens ? "alertText-warning" : UTColorTokens.labelWarningText.rawValue
            
        case .callButtonCancelFill:
            return UIToolkit.shared.isUsingLegacyTokens ? "buttonText-secondary" : UTColorTokens.buttonCancelFillText.rawValue
        case .callButtonJoinFill:
            return UIToolkit.shared.isUsingLegacyTokens ? "buttonText-secondary" : UTColorTokens.buttonJoinFillText.rawValue
        case .callButtonSecondary:
            return UIToolkit.shared.isUsingLegacyTokens ? "buttonText-secondary" : UTColorTokens.buttonSecondaryText.rawValue
        case .callButtonGhost:
            return UIToolkit.shared.isUsingLegacyTokens ? "buttonText-secondary" : UTColorTokens.buttonGhostText.rawValue
            
        case .buttonPrimaryText:
            return UTColorTokens.buttonPrimaryText.rawValue
        
        case .globalPlusMenuOptionDisabled:
            return "inputText-secondary"
        
        }
    }
    
    public var colorStates:UTColorStates {
        return UIToolkit.shared.getThemeManager().getColors(tokenName: textToken)
    }
}
