//
//  UTAvatarOverflowBadge.swift
//  UIToolkit
//
//  Created by James Nestor on 21/09/2021.
//

import Cocoa

public class UTAvatarOverflowBadge: UTHoverableView {
    
    //MARK: - Public variables
    
    ///The current number displayed on the badge.
    ///If value larger than 1000 the number and K will be displayed i.e. "+1K"
    @IBInspectable public var count:UInt = 0{
        didSet{
            invalidateIntrinsicContentSize()
            needsDisplay = true
        }
    }
    
    public override var intrinsicContentSize: NSSize{
        let stringSize = attributedStringValue.size()
        let width      = max(minimumWidth,  ceil(stringSize.width + horizontalPadding))
        let height     = max(minimumHeight, stringSize.height + verticalPadding)
        
        return NSMakeSize(width, height)
    }
    
    //MARK: - Private variables
    
    private var attributedStringValue:NSAttributedString {

        let attributes = [NSAttributedString.Key.foregroundColor : fontColor,
                          NSAttributedString.Key.font : font]
                
        return NSAttributedString(string: stringValue, attributes: attributes)
    }
    
    private var stringValue:String {
        if count >= 1000 {
            return "+" + String(count / 1000) + "K"
        }
        
        return "+" + String(count)
    }
    
    private var minimumWidth:CGFloat {
        return 24
    }
    
    private var minimumHeight:CGFloat {
        return 24
    }
    
    private var horizontalPadding:CGFloat {
        return 8
    }
    
    private var verticalPadding:CGFloat {
        return 2
    }
    
    private var cornerRadius:CGFloat{
        return self.bounds.height / 2
    }
    
    private var font:NSFont {
        return UTFontType.labelCompact.font()
    }
    
    private var fontColor:CCColor {
        return UIToolkit.shared.getThemeManager().getColors(token: UTColorTokens.avatarColorAvatarText).normal
    }
    
    private var backgroundColor:CCColor {
        return  UIToolkit.shared.getThemeManager().getColors(token: UTColorTokens.avatarColorAvatarBackgroundDefault).normal
    }
    
    //MARK: - Public API
    
    override func initialise() {
        super.initialise()
        enableHover = true
    }
    
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let str = attributedStringValue
        let rect = self.bounds.centredRect(for: str)
        
        let path = NSBezierPath(roundedRect: self.bounds, xRadius: cornerRadius, yRadius: cornerRadius)
        backgroundColor.set()
        path.fill()
        str.draw(in: rect)
    }
    
}
