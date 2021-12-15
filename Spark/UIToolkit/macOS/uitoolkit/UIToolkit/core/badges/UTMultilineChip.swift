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
                return UTColorTokens.multilineChipOneText.rawValue
            case .two:
                return UTColorTokens.multilineChipTwoText.rawValue
            case .three:
                return UTColorTokens.multilineChipThreeText.rawValue
            case .four:
                return UTColorTokens.multilineChipFourText.rawValue
            case .five:
                return UTColorTokens.multilineChipFiveText.rawValue
            case .six:
                return UTColorTokens.multilineChipSixText.rawValue
            case .seven:
                return UTColorTokens.multilineChipSevenText.rawValue
            case .eight:
                return UTColorTokens.multilineChipEightText.rawValue
                                
            }
        }
        
        var borderColorToken: String {
            switch self {
            case .one:
                return UTColorTokens.multilineChipOneOutline.rawValue
            case .two:
                return UTColorTokens.multilineChipTwoOutline.rawValue
            case .three:
                return UTColorTokens.multilineChipThreeOutline.rawValue
            case .four:
                return UTColorTokens.multilineChipFourOutline.rawValue
            case .five:
                return UTColorTokens.multilineChipFiveOutline.rawValue
            case .six:
                return UTColorTokens.multilineChipSixOutline.rawValue
            case .seven:
                return UTColorTokens.multilineChipSevenOutline.rawValue
            case .eight:
                return UTColorTokens.multilineChipEightOutline.rawValue
                                
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
