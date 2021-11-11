//
//  PillButton.swift
//  ui toolkit
//
//  Created by Jimmy Coyne on 22/04/2021.
//

import Cocoa

public class UTPillButton : UTButton {
    override func initialise(){
        super.style = .primary
        super.buttonType = .pill
        super.initialise()
    }
    
    override func toCGFloat(height: ButtonHeight) -> CGFloat {
        switch height {
        case .extralarge:
        assert(false, "extralarge not supported for UTPillButton")
        return 40
        
        case .large: return 40
        case .medium: return 32
        case .small: return 28
        case .extrasmall: return 24
        default:
            assert(false)
            return 40
        }
    }
    
    override var trailingPadding:CGFloat {
        get {
            return trailingLeadingPadding
        }
    }
    
    override var leadingPadding:CGFloat {
        get {
            return trailingLeadingPadding
        }
    }
    
    private var trailingLeadingPadding:CGFloat {
        get {
            switch super.buttonHeight {
            case .extralarge:
            assert(false, "extralarge not supported for UTPillButton")
            return 16
            
            case .large: return 16
            case .medium: return 12
            case .small: return 10
            case .extrasmall: return 10
            default:
                assert(false)
                return 40
            }
        }
    }
    
    override internal func updateIconSize() {
        super.fontIconSize = getIconSize()
    }
    
    private func getIconSize() -> CGFloat {
        switch super.buttonHeight {
        case .extralarge: return 18
        case .large: return 18
        case .medium: return 18
        case .small: return 17
        case .extrasmall: return 16
        case .unknown: return 16
        }
    }
    
}

public class UTOverlayButton : UTButton {
    override func initialise() {        
        super.buttonType = .round
        super.buttonHeight = .extrasmall
        super.startAtLeadingPadding = true
        super.initialise()
        super.style = .overlay
    }
    
    override func toCGFloat(height: ButtonHeight) -> CGFloat {
        return 20
    }
    
    override internal func updateIconSize() {
        super.fontIconSize = getIconSize()
    }
    
    public override func setThemeColors() {
        super.setThemeColors()
    }
    
    override func positionTitleAndImage() {
        super.positionTitleAndImage()
    }
    
    private func getIconSize() -> CGFloat {
        return 12
    }
    
    override var trailingPadding:CGFloat {
        get {
            switch self.fontIcon {
            case .arrowRightFilled:
                return 3
            case .arrowLeftFilled:
                return 5
            default:
                return super.trailingPadding
            }
        }
    }

    override var leadingPadding:CGFloat {
        get {
            switch self.fontIcon {
            case .arrowRightFilled:
                return 5
            case .arrowLeftFilled:
                return 3
            default:
                return super.leadingPadding
            }
        }
    }
}

public class UTRoundButton : UTButton {
    override func initialise() {
        super.style = .primary
        super.buttonType = .round
        super.initialise()
    }
    
    override func toCGFloat(height: ButtonHeight) -> CGFloat {
        switch height {
        case .extralarge: return 64
        case .large: return 52
        case .medium: return 40
        case .small: return 32
        case .extrasmall: return 28
        default:
            assert(false)
            return 40
        }
    }
    
    override internal func updateIconSize() {
        super.fontIconSize = getIconSize()
    }
    
    public override func setThemeColors() {
        super.setThemeColors()
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

public class UTHyperlinkButton : UTButton {
    
    override var leadingPadding: CGFloat {
        return 2
    }
    
    override var trailingPadding: CGFloat {
        return 2
    }
    
    override func initialise(){
        super.style = .hyperlink
        super.buttonType = .square                
        super.initialise()
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    override func toCGFloat(height: ButtonHeight) -> CGFloat {
        let attrStr = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: self.labelFont.font()])
        return attrStr.size().height
    }
        
    override internal var attributes:[NSAttributedString.Key:Any]{
        let theFont = labelFont.font()
        let underlineStyle = isEnabled ? NSUnderlineStyle.single.rawValue : 0
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = .byTruncatingMiddle
        
        return [NSAttributedString.Key.font : theFont,
                NSAttributedString.Key.foregroundColor : textColor,
                NSAttributedString.Key.underlineStyle: underlineStyle,
                NSAttributedString.Key.paragraphStyle: para]
    }
        
    public override func resetCursorRects() {
        super.resetCursorRects()
        addCursorRect(self.bounds, cursor: .pointingHand)
    }
    
    override open var title: String {
        didSet {
            addUIElement(element: .Label(title))
            setupTextAndFonts()
            invalidateIntrinsicContentSize()
            self.toolTip = title
        }
    }
    
    override func updateLabelFontSize() {
        
        switch self.buttonHeight {
        case .extralarge, .large:
            self.labelFont = .hyperlinkPrimary
        case .medium, .small:
            self.labelFont = .hyperlinkSecondary
        case .extrasmall:
            self.labelFont = .labelCompact
        case .unknown:
            assert(false, "no size known font size")
        }
    }   
}

public class UTRoundBadgeButton : UTRoundButton {
    
    private var badge: UTBadge!
    public var unreadCount: Int = 0 {
        didSet {
            updateBadge()
        }
    }

    override func initialise() {
        badge = UTBadge()
        badge.showTooltip = false
        addSubview(badge)
        addConstraints([NSLayoutConstraint.createTopSpaceToViewConstraint(firstItem: badge, secondItem: self, constant: -8),
                        NSLayoutConstraint.createTrailingSpaceToViewConstraint(firstItem: badge, secondItem: self, constant: 5)])
        badge.translatesAutoresizingMaskIntoConstraints = false
        updateBadge()
        
        super.style = .primary
        super.buttonType = .round
        super.initialise()
        layer?.masksToBounds = false
    }
    
    public override func setThemeColors() {
        super.setThemeColors()
        badge.setThemeColors()
    }
    
    private func updateBadge() {
        badge.count = unreadCount
        badge.isHidden = unreadCount == 0
    }
}
