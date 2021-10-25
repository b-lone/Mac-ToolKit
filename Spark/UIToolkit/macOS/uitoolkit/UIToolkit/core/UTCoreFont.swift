//
//  UTCoreFont.swift
//  UIToolkit
//
//  Created by James Nestor on 24/06/2021.
//

import Cocoa

class UTCoreFont {
    
    enum Size : CGFloat{
        case extraLarge  = 40
        case large       = 26
        case medium      = 20
        case mediumSmall = 16
        case small       = 14
        case extraSmall  = 12
    }
    
    enum Weight {
        case bold
        case semibold
        case regular
        
        func nsFontWeight() -> NSFont.Weight {
            switch self {
            case .bold:
                return .bold
            case .semibold:
                return .semibold
            case .regular:
                return .regular
            }
        }
        
        var stringValue:String {
            switch self {
            case .bold:
                return "Bold"
            case .semibold:
                return "Semi Bold"
            case .regular:
                return "Regular"
            }
        }
    }
    
    static func getFont(size:Size, weight:Weight) -> NSFont {
        return NSFont.systemFont(ofSize: size.rawValue * UIToolkit.shared.fontManager.scaleFactor, weight: weight.nsFontWeight())
    }
}
