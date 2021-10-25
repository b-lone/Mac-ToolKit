//
//  UTModifierTextAttachment.swift
//  UIToolkit
//
//  Created by James Nestor on 08/09/2021.
//

import Cocoa

//MARK: - UTModifierTextAttachment
public class UTModifierTextAttachment: NSTextAttachment{
    var displayString: String = ""
    
    public init(displayString:String) {
        self.displayString = displayString
        super.init(data: nil, ofType: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UTModifierWithResultAttachment
public class UTModifierWithResultAttachment : UTModifierTextAttachment{
    public var modifier: UTModifier

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(displayString:String , modifier:UTModifier) {
        self.modifier = modifier
        super.init(displayString: displayString)
    }
    
    static func create(displayString:String, modifier: UTModifier) -> UTModifierWithResultAttachment{
        let modifierAttachment = UTModifierWithResultAttachment(displayString: displayString, modifier: modifier)
        let modifierAttachmentCell = ModifierAttachmentCell()
        modifierAttachmentCell.font = UTFontType.subheaderSecondary.font()
        modifierAttachment.attachmentCell = modifierAttachmentCell

        return modifierAttachment
    }
}

//MARK: - UTModifierTypeTextAttachment
public class UTModifierTypeTextAttachment: UTModifierTextAttachment{
    public var type:UTModifierType
    
    init(displayString:String, type:UTModifierType) {
        self.type = type
        super.init(displayString: displayString)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func create(displayString:String, modifierType: UTModifierType) -> UTModifierTypeTextAttachment{
        let modifierAttachment = UTModifierTypeTextAttachment(displayString: displayString, type:modifierType)
        let modifierAttachmentCell = ModifierAttachmentCell()
        modifierAttachmentCell.font = UTFontType.subheaderSecondary.font()
        modifierAttachment.attachmentCell = modifierAttachmentCell
        
        return modifierAttachment
    }
}

//MARK: - ModifierAttachmentCell
class ModifierAttachmentCell: NSTextAttachmentCell{
    
    enum Style {
        case globalHeader
        
        var backgroundToken: String{
            switch self{
            case .globalHeader:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-searchModifierInputPath-background" : UTColorTokens.globalHeaderModifierChipBackground.rawValue
            }
        }
        
        var textToken:String{
            switch  self{
            case.globalHeader:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-searchModifierInput-Text" : UTColorTokens.globalHeaderModifierChipText.rawValue
            }
        }
    }
    
    var selfWidth:CGFloat = 0
    var style:Style = .globalHeader
    
    override func cellFrame(for textContainer: NSTextContainer, proposedLineFragment lineFrag: NSRect, glyphPosition position: NSPoint, characterIndex charIndex: Int) -> NSRect {
        let cellHeight:CGFloat = 18
        let cellWidthPadding:CGFloat = 20
        
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: cellHeight)
        if let attachment = self.attachment as? UTModifierTextAttachment {
            if let font = self.font, selfWidth == 0 {
                let size  = attachment.displayString.size(with: font, constrainedTo:  constraintRect)
                selfWidth = size.width + cellWidthPadding
            }
            
            return NSMakeRect(0, 0, selfWidth, cellHeight)
        }
        assert(false)
        
        return NSMakeRect(0, 0,  0, 0);
    }
        
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView?) {
        if let font = self.font {
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            paragraphStyle.allowsDefaultTighteningForTruncation = false
            paragraphStyle.lineSpacing = 0
                        
            if let attachment = self.attachment as? UTModifierTextAttachment {
                
                let fontColor = UIToolkit.shared.getThemeManager().getColors(tokenName: style.textToken).normal
                
                let textFontAttributes = [
                    NSAttributedString.Key.font: font,
                    NSAttributedString.Key.foregroundColor: fontColor,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                    ] as [NSAttributedString.Key : Any]
               
                var pillOrigin = cellFrame.origin.y
                var textOrigin = cellFrame.origin.y + 4
                
                let textAttrString = NSAttributedString(string: attachment.displayString, attributes: textFontAttributes)
                
                if let controlView = controlView {
                    
                    let heightDiff = controlView.frame.height - cellFrame.height
                    pillOrigin = heightDiff / 2
                    
                    let textHeight = textAttrString.size().height
                    let textHeightDiff = controlView.frame.height - textHeight
                    textOrigin = (textHeightDiff / 2) - 1
                }
                
                let pillRect = NSMakeRect(cellFrame.origin.x + 2, pillOrigin, cellFrame.width - 4, cellFrame.height)
                let halfHeight:CGFloat = cellFrame.height / 2
                
                NSGraphicsContext.saveGraphicsState()
                let clipPath = NSBezierPath(roundedRect: pillRect, xRadius: halfHeight, yRadius: halfHeight)
                
                let backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: style.backgroundToken).normal
                backgroundColor.setFill()
                clipPath.fill()
                self.isSelectable = true
                
                textAttrString.draw(in: NSMakeRect(pillRect.origin.x + 8, textOrigin, pillRect.width - 12, cellFrame.height))
                
                NSGraphicsContext.restoreGraphicsState()
            }
        }
    }
}
