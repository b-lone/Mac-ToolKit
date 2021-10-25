//
//  ColorStates.swift
//  uitoolkit
//
//  Created by Jimmy Coyne on 19/03/2021.
//

import Foundation
import Cocoa

@objcMembers
@objc open class UTColorStates : NSObject {
    
    public var normal: CCColor
    public var hover: CCColor
    public var pressed: CCColor
    public var on : CCColor
    public var disabled: CCColor
    public var focused:CCColor
    
    
    public init(normal: CCColor, hover: CCColor? = nil , pressed: CCColor?, on: CCColor? = nil, focused: CCColor? = nil, disabled: CCColor? = nil) {
        self.normal = normal
        self.hover = hover ?? normal
        self.pressed = pressed ?? normal
        self.on = on ?? normal
        self.focused = focused ?? normal
        self.disabled = disabled ?? normal
    }
    
    func getColorForState(isEnabled:Bool, isMouseDown:Bool, isHovered:Bool, isOn:Bool) -> CCColor {
                
        if !isEnabled {
            return disabled
        }
        else if isMouseDown && isHovered {
            return pressed
        }
        
        else if isHovered {
            return hover
        }
        
        else if isOn {
            return on
        }
    
        return normal
    }
    
}
