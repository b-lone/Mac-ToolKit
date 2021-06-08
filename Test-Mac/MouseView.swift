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
    
    var id = MagicDrawingBoardManager.inValidDrawingId
    override func mouseEntered(with event: NSEvent) {
        print("\(toolTip ?? "") mouseEntered")
        
        let screen = toolTip == "1" ? 0 : 1
        
        MagicDrawingBoardManager.shared.removeDrawing(drawingId: id)
        id = MagicDrawingBoardManager.shared.drawScreenBorder(screen: NSScreen.screens[screen], style: .hoverScreen)
    }
    
    override func mouseExited(with event: NSEvent) {
        print("\(toolTip ?? "") mouseExited")
        MagicDrawingBoardManager.shared.removeDrawing(drawingId: id)
    }
    
    var clickTimer: Timer?
    override func mouseDown(with event: NSEvent) {
        print("mouseDown \(event.clickCount)")
        if clickTimer != nil {
            clickTimer?.invalidate()
            clickTimer = nil
        }
        
        if event.clickCount == 1 {
            clickTimer = Timer.scheduledTimer(withTimeInterval: NSEvent.doubleClickInterval, repeats: false) { [weak self] _ in
                if let strongSelf = self {
                    print("singleClick")
                    strongSelf.clickTimer = nil
                }
            }
        } else if event.clickCount == 2 {
            print("doubleClick")
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        print("mouseUp \(event.clickCount)")
    }
    
    @IBAction func testMenuItem(_ sender: Any) {
        print("testMenuItem")
    }
    
    @objc func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        print("validateMenuItem")
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        interpretKeyEvents([event])
    }
    
    override func insertTab(_ sender: Any?) {
        print("insertTab")
    }
    
    override func insertBacktab(_ sender: Any?) {
        print("insertBackTab")
    }
}
