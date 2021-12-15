
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
        case shareWindowActive
        case overlay
        case singleEqual
        case statedLayout
        
        func getBackgroundTokenName(on: Bool) -> String {
            switch self {
            case .unknown:
                return ""
            case .primary:
                return UTColorTokens.buttonPrimaryBackground.rawValue
            case .secondary:
                return UTColorTokens.buttonSecondaryBackground.rawValue
            case .ghost:
                return UTColorTokens.buttonGhostBackground.rawValue
            case .ghostCancel:
                return UTColorTokens.buttonCancelGhostBackground.rawValue
            case .ghostMessage:
                return UTColorTokens.buttonMessageGhostBackground.rawValue
            case .join:
                return UTColorTokens.buttonJoinFillBackground.rawValue
            case .outlineJoin:
                return UTColorTokens.buttonJoinOutlineBackground.rawValue
            case .cancel:
                return UTColorTokens.buttonCancelFillBackground.rawValue
            case .outlineCancel:
                return UTColorTokens.buttonCancelOutlineBackground.rawValue
            case .message:
                return UTColorTokens.buttonMessageFillBackground.rawValue
            case .hyperlink:
                return ""
            case .tabs:
                if on == true {
                    return UTColorTokens.tabActiveBackground.rawValue
                } else {
                    return UTColorTokens.tabInactiveBackground.rawValue
                }
            case .layout:
                return UTColorTokens.buttonLayoutBackground.rawValue
            case .teachingPrimary:
                return UTColorTokens.coachmarkteachingButtonPrimaryBackground.rawValue
            case .teachingSecondary:
                return UTColorTokens.coachmarkteachingButtonSecondaryBackground.rawValue
            case .teachingHyperlink:
                return ""
            case .shareWindowPrimary:
                return UTColorTokens.sharewindowControlButtonPrimaryBackground.rawValue
            case .shareWindowSecondary:
                return UTColorTokens.sharewindowControlButtonSecondaryBackground.rawValue
            case .shareWindowActive:
                return UTColorTokens.sharewindowControlButtonActiveBackground.rawValue
            case .overlay:
                return UTColorTokens.buttonOverlayBackground.rawValue
            case .singleEqual:
                if on == true {
                    return UTColorTokens.buttonSecondaryActiveBackground.rawValue
                } else {
                    return UTColorTokens.buttonLayoutBackground.rawValue
                }
            case .statedLayout:
                if on == true {
                    return UTColorTokens.buttonOverlayBackground.rawValue
                } else {
                    return UTColorTokens.buttonLayoutBackground.rawValue
                }
            }
        }
        
        func getFontTokenName(on: Bool) -> String  {
            switch self {
            case .unknown:
                return ""
            case .primary:
                return UTColorTokens.buttonPrimaryText.rawValue
            case .secondary:
                return UTColorTokens.buttonSecondaryText.rawValue
            case .ghost:
                return UTColorTokens.buttonGhostText.rawValue
            case .ghostCancel:
                return UTColorTokens.buttonCancelGhostText.rawValue
            case .ghostMessage:
                return UTColorTokens.buttonMessageGhostText.rawValue
            case .join:
                return UTColorTokens.buttonJoinFillText.rawValue
            case .outlineJoin:
                return UTColorTokens.buttonJoinOutlineText.rawValue
            case .cancel:
                return UTColorTokens.buttonCancelFillText.rawValue
            case .outlineCancel:
                return UTColorTokens.buttonCancelOutlineText.rawValue
            case .message:
                return UTColorTokens.buttonMessageFillText.rawValue
            case .hyperlink:
                return UTColorTokens.buttonHyperlinkText.rawValue
            case .tabs:
                if on == true {
                    return UTColorTokens.tabActiveText.rawValue
                } else {
                    return UTColorTokens.tabInactiveText.rawValue
                }
            case .layout:
                return UTColorTokens.buttonLayoutText.rawValue
            case .teachingPrimary:
                return UTColorTokens.coachmarkteachingButtonPrimaryText.rawValue
            case .teachingSecondary:
                return UTColorTokens.coachmarkteachingButtonSecondaryText.rawValue
            case .teachingHyperlink:
                return UTColorTokens.coachmarkteachingButtonHyperlinkText.rawValue
            case .shareWindowPrimary:
                return UTColorTokens.sharewindowControlButtonPrimaryText.rawValue
            case .shareWindowSecondary:
                return UTColorTokens.sharewindowControlButtonSecondaryText.rawValue
            case .shareWindowActive:
                return UTColorTokens.sharewindowControlButtonActiveText.rawValue
            case .overlay:               
                return UTColorTokens.buttonOverlayText.rawValue
            case .singleEqual:
                if on == true {
                    return UTColorTokens.buttonLayoutText.rawValue
                } else {
                    return UTColorTokens.labelSecondaryText.rawValue
                }
            case .statedLayout:
                return UTColorTokens.buttonLayoutText.rawValue
            }
        }
        
        var borderTokenName:String {
            switch self {
            case .unknown:
                return ""
            case .primary:
                return ""
            case .secondary:
                return UTColorTokens.buttonSecondaryBorder.rawValue
            case .ghost:
                return ""
            case .ghostCancel:
                return ""
            case .ghostMessage:
                return ""
            case .join:
                return ""
            case .outlineJoin:
                return UTColorTokens.buttonJoinOutlineBorder.rawValue
            case .cancel:
                return ""
            case .outlineCancel:
                return UTColorTokens.buttonCancelOutlineBorder.rawValue
            case .message:
                return ""
            case .hyperlink:
                return ""
            case .tabs:
                return  ""
            case .layout:
                return UTColorTokens.buttonLayoutBorder.rawValue
            case .teachingPrimary:
                return ""
            case .teachingSecondary:
                return UTColorTokens.coachmarkteachingButtonPrimaryBorder.rawValue
            case .teachingHyperlink:
                return ""
            case .shareWindowPrimary:
                return ""
            case .shareWindowSecondary:
                return UTColorTokens.sharewindowControlButtonSecondaryBorder.rawValue
            case .shareWindowActive:
                return UTColorTokens.sharewindowControlButtonActiveBorder.rawValue
            case .overlay:
                return UTColorTokens.buttonOverlayBorder.rawValue
            case .singleEqual:
                return UTColorTokens.buttonLayoutBorder.rawValue
            case .statedLayout:
                return UTColorTokens.buttonLayoutBorder.rawValue
            }
        }
    }
    
    public var style: Style = .unknown{
        didSet{
            //TODO, revist UTHyperlinkButton and the public hyperlink style .
            if style == .hyperlink {
                useAttributedStringForLabel = true

                if self is UTHyperlinkButton == false {
                    assert(false, "hyperlink types can only be used with UTHyperlinkButton ")
                }
            }
            else {
                useAttributedStringForLabel = false
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
