//
//  UTMultilineChip.swift
//  UIToolkit
//
//  Created by James Nestor on 15/09/2021.
//

import Cocoa

public class UTMultilineChip: UTTextWithBackground {

    public enum Style {
        
        ///mint
        case one
        
        ///cobalt
        case two
        
        ///orange
        case three
        
        ///pink
        case four
        
        ///olive
        case five
        
        ///cyan
        case six
        
        ///purple
        case seven
        
        ///violet
        case eight
        
        var textColorToken: String {
            switch self {
            case .one:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-multilineBadgeOne-background" : "multilineChip-one-text"
            case .two:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-multilineBadgeTwo-background" : "multilineChip-two-text"
            case .three:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-multilineBadgeThree-background" : "multilineChip-three-text"
            case .four:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-multilineBadgeFour-background" : "multilineChip-four-text"
            case .five:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-multilineBadgeFive-background" : "multilineChip-five-text"
            case .six:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-multilineBadgeSix-background" : "multilineChip-six-text"
            case .seven:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-multilineBadgeSeven-background" : "multilineChip-seven-text"
            case .eight:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-multilineBadgeEight-background" : "multilineChip-eight-text"
                                
            }
        }
        
        var borderColorToken: String {
            switch self {
            case .one:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-multilineBadgeOne-background" : "multilineChip-one-border"
            case .two:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-multilineBadgeTwo-background" : "multilineChip-two-border"
            case .three:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-multilineBadgeThree-background" : "multilineChip-three-border"
            case .four:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-multilineBadgeFour-background" : "multilineChip-four-border"
            case .five:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-multilineBadgeFive-background" : "multilineChip-five-border"
            case .six:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-multilineBadgeSix-background" : "multilineChip-six-border"
            case .seven:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-multilineBadgeSeven-background" : "multilineChip-seven-border"
            case .eight:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-multilineBadgeEight-background" : "multilineChip-eight-border"
                                
            }
        }
        
        var textColor: CCColor {
            return UIToolkit.shared.getThemeManager().getColors(tokenName: textColorToken).normal
        }
        
        var borderColor: CCColor {
            return UIToolkit.shared.getThemeManager().getColors(tokenName: borderColorToken).normal
        }
    }
    
    public var style:Style = .one
    
    public var title : String = ""
    
    override var stringValue: String {
        return title
    }
    
    override var horizontalPadding:CGFloat {
        return 8
    }
    
    override var verticalPadding:CGFloat {
        return 2
    }
    
    internal override var minimumWidth:CGFloat {
        return 30
    }
    
    override var font: NSFont {
        return UTFontType.subheaderSecondary.font()
    }
    
    override var cornerRadius:CGFloat {
        return 9
    }
    
    override var fontColor:CCColor {
        return style.textColor
    }
    
    override var backgroundColor:CCColor {
        return  .clear
    }
    
    var borderColor:CCColor {
        return style.borderColor
    }
 
    override public func draw(_ dirtyRect: NSRect) {
        let str = attributedStringValue
        let rect = self.bounds.centredRect(for: str)
        
        let path = NSBezierPath(roundedRect: self.bounds.getAdjustedRect(adjust: 1), xRadius: cornerRadius, yRadius: cornerRadius)
        
        path.lineWidth = 1
        borderColor.setStroke()
        path.stroke()
        
        str.draw(in: rect)
    }
}
