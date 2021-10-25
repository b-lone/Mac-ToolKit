//
//  UTIconButton.swift
//  UIToolkit
//
//  Created by James Nestor on 15/07/2021.
//

import Cocoa

public class UTIconButton: UTButton {

    public enum Icon {
        case clear        
        case cancel
        case globalHeaderCancel //Temporary Needed until rebrand client released
        case password
        case favorite
        case settings
        case attatchment
        case screenCapture
        case format
        case emoji
        case gif
        case mention
        case pmr
        case markdown
        case bitmoji
        case flag
        
        var iconType:MomentumRebrandIconType {
            switch self {
            case .clear:
                return .clearBold
            case .cancel:
                return .cancelBold
            case .globalHeaderCancel:
                return .cancelBold
            case .password:
                return .showBold
            case .favorite:
                return .favoriteBold
            case .settings:
                return .settingsBold
            case .attatchment:
                return .attachmentBold
            case .screenCapture:
                return .screenshotBold
            case .format:
                return .formatBold
            case .emoji:
                return .emojiHappyBold
            case .gif:
                return .gifBold
            case .mention:
                return .mentionBold
            case .pmr:
                return .pmrBold
            case .markdown:
                return .markdownBold
            case .bitmoji:
                return .bitmojiConnectedBold
            case .flag:
                return .flagFilled
            }
        }
        
        var checkedIcon:MomentumRebrandIconType {
            switch self {
            case .password:
                return .hideBold
            case .favorite:
                return .favoriteFilled
            case .settings:
                return .settingsFilled
            default:
                return iconType
            }
        }
        
        var fontToken : String {
            switch self {
            case .clear:
                return UIToolkit.shared.isUsingLegacyTokens ? "text-secondary" : UTColorTokens.canceliconDefaultIcon.rawValue
            case .cancel:
                return UIToolkit.shared.isUsingLegacyTokens ? "text-secondary" : UTColorTokens.labelSecondaryText.rawValue
            case .globalHeaderCancel:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-ghTopBarCloseButton-text" : UTColorTokens.globalHeaderSearchCancelButtonText.rawValue
            case .password:
                return UIToolkit.shared.isUsingLegacyTokens ? "text-secondary" : UTColorTokens.labelSecondaryText.rawValue
            case .favorite:
                return UIToolkit.shared.isUsingLegacyTokens ? "ut-legacy-favorite-icon" : UTColorTokens.interactiveiconTertiaryFilledIconInactive.rawValue
            case .settings:
                return UIToolkit.shared.isUsingLegacyTokens ? "ut-legacy-settings-icon" : UTColorTokens.interactiveiconPrimaryFilledIconInactive.rawValue
            case .attatchment,
                 .screenCapture,
                 .format,
                 .emoji,
                 .gif,
                 .mention,
                 .pmr,
                 .markdown,
                 .bitmoji:
                return UIToolkit.shared.isUsingLegacyTokens ? "ut-legacy-expressiveMessage-icon" : UTColorTokens.interactiveiconPrimaryOutlineIconInactive.rawValue
            case .flag:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-secondColumnFlagIcon" : UTColorTokens.interactiveiconQuaternaryFilledIconActive.rawValue
            }
        }
        
        var checkedFontToken: String {
            switch self {
            case .favorite:
                return UIToolkit.shared.isUsingLegacyTokens ? "ut-legacy-favorite-icon" : UTColorTokens.interactiveiconTertiaryFilledFavoriteIconActive.rawValue
            case .attatchment:
                return UIToolkit.shared.isUsingLegacyTokens ? "ut-legacy-expressiveMessage-icon" : UTColorTokens.interactiveiconPrimaryOutlineIconActive.rawValue
            case .flag:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-secondColumnFlagIcon" : UTColorTokens.interactiveiconQuaternaryFilledIconActive.rawValue
            default:
                return fontToken
            }
        }
        
        var backgroundToken: String {
            switch self {
            case .favorite:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : UTColorTokens.interactiveiconContainerBackground.rawValue
            case .settings:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : UTColorTokens.interactiveiconContainerBackground.rawValue
            case .attatchment,
                 .screenCapture,
                 .format,
                 .emoji,
                 .gif,
                 .mention,
                 .pmr,
                 .markdown,
                 .bitmoji:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : UTColorTokens.interactiveiconContainerBackground.rawValue
            case .flag:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : UTColorTokens.interactiveiconContainerBackground.rawValue
            default:
                return ""
            }
        }
        
        var checkedBackgroundToken: String {
            switch self {
            case .favorite:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : UTColorTokens.interactiveiconContainerBackground.rawValue
            case .attatchment,
                 .format,
                 .emoji,
                 .gif,
                 .markdown,                 
                 .bitmoji:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : UTColorTokens.interactiveiconContainerBackground.rawValue
            default:
                return backgroundToken
            }
        }
        
        var isCheckable:Bool {
            switch self {
            case .password,
                 .favorite,
                 .settings,
                 .attatchment,
                 .format,
                 .emoji,
                 .gif,
                 .markdown,
                 .bitmoji:
                return true
            
            default:
                return false
            }
        }
    }
    
    public var icon:Icon = .cancel {
        didSet {
            self.momentary = !icon.isCheckable
            updateIcon()
        }
    }
    
    public override var state: NSControl.StateValue {
        didSet{
            updateIcon()
        }
    }
    
    public override var style: UTButton.Style {
        didSet{
            assert(false, "style should not be used in icon button")
        }
    }
    
    override func initialise() {
        super.initialise()
        super.buttonType = .round
    }
    
    public override func performClick(_ sender: Any?) {
        super.performClick(sender)
        updateIcon()
    }
    
    override func toCGFloat(height: ButtonHeight) -> CGFloat {
        switch icon {
        case .attatchment,
             .screenCapture,
             .format,
             .emoji,
             .gif,
             .mention,
             .pmr,
             .markdown,
             .bitmoji,
             .favorite,
             .settings,
             .flag:
            return 24                
        default: return self.fontIconSize
        }
    }
    
    override internal func updateIconSize() {
        super.fontIconSize = getIconSize()
    }
    
    override public func setThemeColors() {
        updateIcon()
        super.setThemeColors()
    }
    
    private func updateIcon(){
        self.fontIcon = state == .on ? icon.checkedIcon : icon.iconType
        self.fontTokenName = state == .on ? icon.checkedFontToken : icon.fontToken
        self.backgroundTokenName = state == .on ? icon.checkedBackgroundToken : icon.backgroundToken
    }
    
    private func getIconSize() -> CGFloat {
        switch super.buttonHeight {
        case .extralarge: return 30
        case .large: return 28
        case .medium: return 18
        case .small: return 17
        case .extrasmall: return 16
        case .unknown: return 16
        }
    }
    
}
