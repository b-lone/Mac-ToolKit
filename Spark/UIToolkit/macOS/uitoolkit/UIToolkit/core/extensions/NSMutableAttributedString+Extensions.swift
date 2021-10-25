//
//  NSMutableAttributedString+Extensions.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 21/05/2021.
//

import Foundation
import Cocoa

extension NSMutableAttributedString {
    
    private static func getRangeForIcon(_ iconName: String?) -> NSRange {
        let iconNameLength:Int
        
        if let iconName = iconName {
            iconNameLength = iconName.count
        } else {
            iconNameLength = 1
        }
        return NSMakeRange(0, iconNameLength)
    }
    
    internal static func getIcon(fontName: String, size: CGFloat, color:CCColor) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        let utfont = NSFont.getIconFont(size: size)
        let attrsDictionary: [NSAttributedString.Key : Any] = [ NSAttributedString.Key.paragraphStyle : style,
                                                                NSAttributedString.Key.font : utfont as Any,
                                                                NSAttributedString.Key.foregroundColor: color]
        
        let attrString = NSMutableAttributedString.init(string: fontName , attributes: attrsDictionary)
        return attrString
    }
    
}
