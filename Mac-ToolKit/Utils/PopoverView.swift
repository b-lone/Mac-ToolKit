//
//  PopoverView.swift
//  SparkMacDesktop
//
//  Created by jimmcoyn on 26/03/2017.
//  Copyright © 2017 Cisco Systems. All rights reserved.
//

import Cocoa
import Carbon.HIToolbox

class PopoverView: NSView {

    var color:NSColor? {
        didSet {            
            backgroundView?.layer?.backgroundColor = color?.cgColor
        }
    }
    var handleKeyboardNav: Bool = false
    var isAccessible: Bool = true
    
    weak var backgroundView:NSView?

    override func viewDidMoveToWindow() {
    
        guard let frameView = window?.contentView?.superview else {
            return
        }
        
        if let backgroundView = self.backgroundView{
            if let color = color{
                backgroundView.layer?.backgroundColor = color.cgColor
            }
            
            frameView.addSubview(backgroundView, positioned: .below, relativeTo: frameView)
        }
        else{
            let bgView = NSView(frame: frameView.bounds)
            bgView.wantsLayer = true
            
            if let color = color{
                bgView.layer?.backgroundColor = color.cgColor
            }
            
            bgView.autoresizingMask = [NSView.AutoresizingMask.width, NSView.AutoresizingMask.height]
            
            frameView.addSubview(bgView, positioned: .below, relativeTo: frameView)
            self.backgroundView = bgView
        }
    }
    
    override func isAccessibilityElement() -> Bool {
        return isAccessible
    }
    
    override func keyDown(with event: NSEvent) {
        if handleKeyboardNav {
            let keyCode:Int = Int(event.keyCode)
            if keyCode == kVK_Escape  {
                NotificationCenter.default.post(name: Notification.Name(rawValue: OnClosePopover), object: self, userInfo: nil)
            }
            else {
                super.keyDown(with: event)
            }
        }
        else {
            super.keyDown(with: event)
        }
    }
    
}
