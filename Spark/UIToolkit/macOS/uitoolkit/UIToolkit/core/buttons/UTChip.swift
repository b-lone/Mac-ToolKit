//
//  UTChip.swift
//  UIToolkit
//
//  Created by James Nestor on 23/09/2021.
//

import Cocoa

public class UTChip: UTBaseButton {
    
    public enum Style {
        
        case secondary
        case message
        
        var backgroundToken:String {
            switch self {
            case .secondary:
                return UTColorTokens.buttonSecondaryBackground.rawValue
            case .message:
                return UTColorTokens.buttonMessageFillBackground.rawValue
            }
        }
        
        var fontToken:String {
            switch self {
            case .secondary:
                return UTColorTokens.buttonSecondaryText.rawValue
            case .message:
                return UTColorTokens.buttonMessageFillText.rawValue
            }
        }
        
        var borderToken:String {
            switch self {
            case .secondary:
                return UTColorTokens.buttonSecondaryBorder.rawValue
            case .message:
                return ""
            }
        }
    }
    
    public var style:Style = .secondary {
        didSet {
            setThemeColors()
        }
    }

    override func sortIndex(buttonElement: ButtonElement) -> Int {
        switch buttonElement {
        case .UnreadPill:
            return 0
        case .Badge:
            return 1
        case .Label:
            return 2
        case .FontIcon(_):
            return 3
        case .Image:
            return 4
        case .ArrowIcon:
            return 5
        }
    }
    
    override func initialise(){
        super.buttonType = .pill
        super.buttonHeight = .small
        super.fontIconSize = 16
        super.initialise()
    }
    
    override var trailingPadding:CGFloat {
        return 12
    }
    
    override var leadingPadding:CGFloat {
        return 12
    }
    
    override func onButtonHeightUpdated() {
        assert(self.buttonHeight == .small, "chip size must be small")
        super.onButtonHeightUpdated()
    }
    
    override func toCGFloat(height: ButtonHeight) -> CGFloat {
        switch height {
        case .medium,
             .small:
            return 28
        default:
            assert(false, "chip size must be small or medium")
            return 28
        }
    }
    
    override func updateLabelFontSize() {
        
        switch self.buttonHeight {
        case .medium:
            self.labelFont = .bodyPrimary
        case .small:
            self.labelFont = .bodySecondary
        default:
            assert(false, "chip size must be small")
        }
    }
    
    internal override func setTokensFromStyle() {
        
        if style.backgroundToken != backgroundTokenName {
            backgroundTokenName = style.backgroundToken
        }
        
        if style.fontToken != fontTokenName {
            fontTokenName = style.fontToken
        }
        
        if style.fontToken != iconTokenName {
            iconTokenName = style.fontToken
        }
                
        if style.borderToken != borderTokenName {
            borderTokenName = style.borderToken
        }
    }
    
}
