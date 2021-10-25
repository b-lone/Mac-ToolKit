//
//  NSColor+Extensions.swift
//  ComponentApp
//
//  Created by James Nestor on 18/06/2021.
//

import Cocoa

extension NSColor {

    public static func getColorFromHexString(hexString: String) -> NSColor {
        
        var hexString = (hexString as NSString).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        let scanner = Scanner(string: hexString as String)
        
        var color:UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let red   = CGFloat((color & 0xFF0000) >> 16)/255.0
        let green = CGFloat((color &   0xFF00) >>  8)/255.0
        let blue  = CGFloat((color &     0xFF)      )/255.0
        
        return NSColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
