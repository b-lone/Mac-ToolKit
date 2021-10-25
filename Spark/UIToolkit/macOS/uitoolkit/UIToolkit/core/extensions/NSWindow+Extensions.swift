//
//  NSWindow+Extensions.swift
//  UIToolkit
//
//  Created by James Nestor on 08/07/2021.
//

import Cocoa

extension NSWindow {
    
    var isClosable: Bool {
        styleMask.contains(.closable)
    }
    
    func fadeInWithDuration(_ duration: TimeInterval){
        if(!self.isVisible || self.alphaValue < 1.0){
            
            if(!self.isVisible){
                self.alphaValue = 0.0
            }
            
            self.orderFront(self)
            
            NSAnimationContext.beginGrouping()
                NSAnimationContext.current.duration = duration
                self.animator().alphaValue = 1.0
            NSAnimationContext.endGrouping()
        }
    }
}
