//
//  UTTextWithBackground.swift
//  UIToolkit
//
//  Created by James Nestor on 25/05/2021.
//

import Cocoa

public class UTTextWithBackground : NSView, ThemeableProtocol{
    
    //MARK: - Internal variables
    
    internal var textAlignment: NSTextAlignment{
        return .center
    }
    
    internal var horizontalPadding:CGFloat {
        return 8
    }
    
    internal var verticalPadding:CGFloat {
        return 2
    }
    
    internal var minimumWidth:CGFloat {
        return 18
    }
    
    internal var minimumHeight:CGFloat {
        return 18
    }
    
    internal var cornerRadius:CGFloat {
        return 4
    }
    
    internal var fontColor:CCColor {
        return UIToolkit.shared.getThemeManager().getColors(tokenName: "appNav-badge-text").normal
    }
    
    internal var backgroundColor:CCColor {
        return  UIToolkit.shared.getThemeManager().getColors(tokenName: "appNav-badge").normal
    }
    
    internal var font:NSFont {
        return UTFontType.labelCompact.font()
    }
    
    internal var stringValue:String {
        return " "
    }
    
    internal var attributedStringValue:NSAttributedString {

        let attributes = [NSAttributedString.Key.foregroundColor : fontColor,
                          NSAttributedString.Key.font : font]
                
        return NSAttributedString(string: stringValue, attributes: attributes)
    }
    
    //MARK: - Public variables
    
    public override var intrinsicContentSize: NSSize{
        let stringSize = attributedStringValue.size()
        let width      = max(minimumWidth,  ceil(stringSize.width + horizontalPadding))
        let height     = max(minimumHeight, stringSize.height + verticalPadding)
        
        return NSMakeSize(width, height)
    }
    
    public func setThemeColors() {
        self.needsDisplay = true
    }
    
    //MARK: - Public
    
    public override func prepareForInterfaceBuilder() {
        invalidateIntrinsicContentSize()
        super.prepareForInterfaceBuilder()
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
