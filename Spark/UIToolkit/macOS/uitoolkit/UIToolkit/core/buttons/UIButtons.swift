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
        
        return [NSAttributedString.Key.font : theFont,
                NSAttributedString.Key.foregroundColor : textColor,
                NSAttributedString.Key.underlineStyle: underlineStyle]
    }
    
    public override var intrinsicContentSize: NSSize{
    
        switch buttonType {
        case .square:
            return NSMakeSize(calulateWidthFromElements(), self.heightFloat)
        default:
            return super.intrinsicContentSize
        }
    }
        
    public override func resetCursorRects() {
        super.resetCursorRects()
        addCursorRect(self.bounds, cursor: .pointingHand)
    }
    
    override open var title: String {
        didSet {
            addUIElement(element: .Label(title))
            setupTextAndFonts()
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
