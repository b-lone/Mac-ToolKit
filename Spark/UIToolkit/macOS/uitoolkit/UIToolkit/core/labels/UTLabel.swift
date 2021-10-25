//
//  UTLabel.swift
//  UIToolkit
//
//  Created by James Nestor on 26/05/2021.
//

import Cocoa

public class UTLabel: UTTokenLabel{
    
    public var style:UTIconLabelStyle = .primary {
        didSet{
            super.tokenName = style.textToken
        }
    }
    
    public override func setThemeColors() {
        if self.tokenName != style.textToken {
            self.tokenName = style.textToken
        }
        
        super.setThemeColors()
    }
    
    public convenience init(stringValue:String = "", fontType:UTFontType, style: UTIconLabelStyle = .primary, lineBreakMode: NSLineBreakMode = .byTruncatingMiddle) {
        self.init(wrappingLabelWithString: stringValue)
        self.fontType = fontType
        self.style = style
        super.tokenName = style.textToken
    
        self.lineBreakMode = lineBreakMode
        self.isSelectable = false
        initialise()
    }
}
