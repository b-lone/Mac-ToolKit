//
//  IconAlignment.swift
//  UIToolkit
//
//  Created by James Nestor on 19/06/2021.
//

import Cocoa

public enum IconAlignment {
    case left
    case right
}

public enum IconSize : CGFloat{
    case large       = 26
    case medium      = 20
    case mediumSmall = 16
    case small       = 14
    case extraSmall  = 12
    
    public var floatValue : CGFloat {
        return self.rawValue
    }
    
    public var contentSize : NSSize {
        return NSMakeSize(floatValue, floatValue)
    }
    
}
