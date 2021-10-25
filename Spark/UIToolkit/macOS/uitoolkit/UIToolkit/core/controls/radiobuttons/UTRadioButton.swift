//
//  UTRadioButton.swift
//  UIToolkit
//
//  Created by James Nestor on 17/09/2021.
//

import Cocoa

public class UTRadioButton: NSButton, ThemeableProtocol {

    public var fontType:UTFontType = .bodyPrimary
    public var style:UTIconLabelStyle = .primary
        
    public func configure(fontType:UTFontType, style:UTIconLabelStyle, stringValue:String) {
        self.fontType = fontType
        self.font = fontType.font()
        self.style = style
        self.imageHugsTitle = true
        
        self.attributedTitle = NSAttributedString(string: stringValue,
                                                    attributes: [NSAttributedString.Key.font: fontType.font(),
                                                       NSAttributedString.Key.foregroundColor: style.colorStates.normal])
    }
    
    public func setThemeColors() {
        self.attributedTitle = NSAttributedString(string: attributedTitle.string,
                                                    attributes: [NSAttributedString.Key.font: fontType.font(),
                                                       NSAttributedString.Key.foregroundColor: style.colorStates.normal])

    }
}
