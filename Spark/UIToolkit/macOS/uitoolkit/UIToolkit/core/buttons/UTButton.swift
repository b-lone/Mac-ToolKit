
import Cocoa
import QuartzCore

public protocol UTButtonDelegate : AnyObject{
    func onFocusStateChanged(_ button: UTButton, hasFocus: Bool)
}

open class UTButton: UTBaseButton {
 
    //MARK: Public API
    public enum Style {
        case unknown
        case primary
        case secondary
        case ghost
        case ghostCancel
        case ghostMessage
        case join
        case outlineJoin
        case cancel
        case outlineCancel
        case message
        case hyperlink
        case tabs
        case layout
        case teachingPrimary
        case teachingSecondary
        case teachingHyperlink
        
        case shareWindowPrimary
        case shareWindowSecondary
        
        func getBackgroundTokenName(on: Bool) -> String {
            switch self {
            case .unknown:
                return ""
            case .primary:
                return UIToolkit.shared.isUsingLegacyTokens ? "button-primary" : UTColorTokens.buttonPrimaryBackground.rawValue
            case .secondary:
                return UIToolkit.shared.isUsingLegacyTokens ? "button-secondary" : UTColorTokens.buttonSecondaryBackground.rawValue
            case .ghost:
                return UIToolkit.shared.isUsingLegacyTokens ? "button-ghost" : UTColorTokens.buttonGhostBackground.rawValue
            case .ghostCancel:
                return UIToolkit.shared.isUsingLegacyTokens ? "button-ghost" : UTColorTokens.buttonCancelGhostBackground.rawValue
            case .ghostMessage:
                return UIToolkit.shared.isUsingLegacyTokens ? "button-ghost" : UTColorTokens.buttonMessageGhostBackground.rawValue
            case .join:
                return UIToolkit.shared.isUsingLegacyTokens ? "buttonJoin-primary" : UTColorTokens.buttonJoinFillBackground.rawValue
            case .outlineJoin:
                return UIToolkit.shared.isUsingLegacyTokens ? "buttonJoin-primary-outline" : UTColorTokens.buttonJoinOutlineBackground.rawValue
            case .cancel:
                return UIToolkit.shared.isUsingLegacyTokens ? "button-cancel" : UTColorTokens.buttonCancelFillBackground.rawValue
            case .outlineCancel:
                return UIToolkit.shared.isUsingLegacyTokens ? "buttonOutline-cancel" : UTColorTokens.buttonCancelOutlineBackground.rawValue
            case .message:
                return UIToolkit.shared.isUsingLegacyTokens ? "button-primary" : UTColorTokens.buttonMessageFillBackground.rawValue
            case .hyperlink:
                return ""
            case .tabs:
                if on == true {
                    return UIToolkit.shared.isUsingLegacyTokens ? "tab-active-background" : UTColorTokens.tabActiveBackground.rawValue
                } else {
                    return UIToolkit.shared.isUsingLegacyTokens ? "tab-inactive-background" : UTColorTokens.tabInactiveBackground.rawValue
                }
            case .layout:
                return UIToolkit.shared.isUsingLegacyTokens ? "button-secondary" : UTColorTokens.buttonLayoutBackground.rawValue
            case .teachingPrimary:
                return UIToolkit.shared.isUsingLegacyTokens ? "teaching-button-primary" : UTColorTokens.coachmarkteachingButtonPrimaryBackground.rawValue
            case .teachingSecondary:
                return UIToolkit.shared.isUsingLegacyTokens ? "teaching-button-secondary" : UTColorTokens.coachmarkteachingButtonSecondaryBackground.rawValue
            case .teachingHyperlink:
                return ""
            case .shareWindowPrimary:
                return UIToolkit.shared.isUsingLegacyTokens ? "button-primary" : UTColorTokens.sharewindowControlButtonPrimaryBackground.rawValue
            case .shareWindowSecondary:
                return UIToolkit.shared.isUsingLegacyTokens ? "button-secondary" : UTColorTokens.sharewindowControlButtonSecondaryBackground.rawValue
            }
        }
        
        func getFontTokenName(on: Bool) -> String  {
            switch self {
            case .unknown:
                return ""
            case .primary:
                return UIToolkit.shared.isUsingLegacyTokens ? "buttonText-primary" : UTColorTokens.buttonPrimaryText.rawValue
            case .secondary:
                return UIToolkit.shared.isUsingLegacyTokens ? "buttonText-secondary" : UTColorTokens.buttonSecondaryText.rawValue
            case .ghost:
                return UIToolkit.shared.isUsingLegacyTokens ? "buttonText-ghost" : UTColorTokens.buttonGhostText.rawValue
            case .ghostCancel:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-wbClearAllButton-text" : UTColorTokens.buttonCancelGhostText.rawValue
            case .ghostMessage:
                return UIToolkit.shared.isUsingLegacyTokens ? "text-hyperlink" : UTColorTokens.buttonMessageGhostText.rawValue
            case .join:
                return UIToolkit.shared.isUsingLegacyTokens ? "buttonText-primary" : UTColorTokens.buttonJoinFillText.rawValue
            case .outlineJoin:
                return UIToolkit.shared.isUsingLegacyTokens ? "buttonText-primary" : UTColorTokens.buttonJoinOutlineText.rawValue
            case .cancel:
                return UIToolkit.shared.isUsingLegacyTokens ? "buttonText-cancel" : UTColorTokens.buttonCancelFillText.rawValue
            case .outlineCancel:
                return UIToolkit.shared.isUsingLegacyTokens ? "buttonOutlineText-cancel" : UTColorTokens.buttonCancelOutlineText.rawValue
            case .message:
                return UIToolkit.shared.isUsingLegacyTokens ? "buttonText-primary" : UTColorTokens.buttonMessageFillText.rawValue
            case .hyperlink:
                return UIToolkit.shared.isUsingLegacyTokens ? "text-hyperlink" : UTColorTokens.buttonHyperlinkText.rawValue
            case .tabs:
                if on == true {
                    return UIToolkit.shared.isUsingLegacyTokens ? "tab-active-text" : UTColorTokens.tabActiveText.rawValue
                } else {
                    return UIToolkit.shared.isUsingLegacyTokens ? "tab-inactive-text" : UTColorTokens.tabInactiveText.rawValue
                }
            case .layout:
                return UIToolkit.shared.isUsingLegacyTokens ? "buttonText-secondary" : UTColorTokens.buttonLayoutText.rawValue
            case .teachingPrimary:
                return UIToolkit.shared.isUsingLegacyTokens ? "buttonText-secondary" : UTColorTokens.coachmarkteachingButtonPrimaryText.rawValue
            case .teachingSecondary:
                return UIToolkit.shared.isUsingLegacyTokens ? "teaching-text-inverted" : UTColorTokens.coachmarkteachingButtonSecondaryText.rawValue
            case .teachingHyperlink:
                return UIToolkit.shared.isUsingLegacyTokens ? "teaching-text-accent" : UTColorTokens.coachmarkteachingButtonHyperlinkText.rawValue
            case .shareWindowPrimary:
                return UIToolkit.shared.isUsingLegacyTokens ? "buttonText-primary" : UTColorTokens.sharewindowControlButtonPrimaryText.rawValue
            case .shareWindowSecondary:
                return UIToolkit.shared.isUsingLegacyTokens ? "buttonText-secondary" : UTColorTokens.sharewindowControlButtonSecondaryText.rawValue
            }
        }
        
        var borderTokenName:String {
            switch self {
            case .unknown:
                return ""
            case .primary:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : ""
            case .secondary:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : UTColorTokens.buttonSecondaryBorder.rawValue
            case .ghost:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : ""
            case .ghostCancel:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : ""
            case .ghostMessage:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : ""
            case .join:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : ""
            case .outlineJoin:
                return UIToolkit.shared.isUsingLegacyTokens ? "buttonJoinBorder-primary" : UTColorTokens.buttonJoinOutlineBorder.rawValue
            case .cancel:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : ""
            case .outlineCancel:
                return UIToolkit.shared.isUsingLegacyTokens ? "buttonOutlineBorder-cancel" : UTColorTokens.buttonCancelOutlineBorder.rawValue
            case .message:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : ""
            case .hyperlink:
                return ""
            case .tabs:
                return UIToolkit.shared.isUsingLegacyTokens ? "overlay-primary" : ""
            case .layout:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : UTColorTokens.buttonLayoutBorder.rawValue
            case .teachingPrimary:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : ""
            case .teachingSecondary:
                return UIToolkit.shared.isUsingLegacyTokens ? "teaching-outline-button" : UTColorTokens.coachmarkteachingButtonPrimaryBorder.rawValue
            case .teachingHyperlink:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : ""
            case .shareWindowPrimary:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : ""
            case .shareWindowSecondary:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : UTColorTokens.sharewindowControlButtonSecondaryBorder.rawValue
            }
        }
    }
    
    public var style: Style = .unknown{
        didSet{
            //TODO, revist UTHyperlinkButton and the public hyperlink style .
            if style == .hyperlink &&  self is UTHyperlinkButton == false {
                assert(false, "hyperlink types can only be used with UTHyperlinkButton ")
            }
            setThemeColors()
        }
    }
    
    internal override func setTokensFromStyle() {
        if style == .unknown {
            return
        }
        
        if style.getBackgroundTokenName(on: state == .on) != backgroundTokenName {
            backgroundTokenName = style.getBackgroundTokenName(on: state == .on)
        }
        
        if style.getFontTokenName(on: state == .on) != fontTokenName {
            fontTokenName = style.getFontTokenName(on: state == .on)
        }
        
        if style.borderTokenName != borderTokenName{
            borderTokenName = style.borderTokenName
        }
    }
    
    open override func becomeFirstResponder() -> Bool {
        buttonDelegate?.onFocusStateChanged(self, hasFocus: true)
        return super.becomeFirstResponder()
    }
    
    open override func resignFirstResponder() -> Bool {
        buttonDelegate?.onFocusStateChanged(self, hasFocus: false)
        return super.resignFirstResponder()
    }
}
