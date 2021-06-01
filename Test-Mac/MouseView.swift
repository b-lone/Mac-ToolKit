//
//  MouseView.swift
//  Test-Mac
//
//  Created by Archie You on 2021/4/27.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class MouseView: NSView {

    var trackingArea: NSTrackingArea?
    
    override var canBecomeKeyView: Bool {
        true
    }
    
    override func becomeFirstResponder() -> Bool {
        true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        if let trackingArea = trackingArea {
            removeTrackingArea(trackingArea)
        }
        
        trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .mouseEnteredAndExited, .inVisibleRect], owner: self, userInfo: nil)
        addTrackingArea(trackingArea!)
    }
    
    override func mouseEntered(with event: NSEvent) {
        print("\(toolTip ?? "") mouseEntered")
    }
    
    override func mouseExited(with event: NSEvent) {
        print("\(toolTip ?? "") mouseExited")
    }
    
    @IBAction func testMenuItem(_ sender: Any) {
        print("testMenuItem")
    }
    
    @objc func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        print("validateMenuItem")
        return true
    }
}
