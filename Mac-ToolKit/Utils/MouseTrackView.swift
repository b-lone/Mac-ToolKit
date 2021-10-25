//
//  MouseView.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/4/27.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

protocol MouseTrackViewDelegate : AnyObject {
    func mouseTrackViewMouseEntered(with event: NSEvent)
    func mouseTrackViewMouseExited(with event: NSEvent)
    func mouseTrackViewMouseDown(with event: NSEvent)
    func mouseTrackViewMouseUp(with event: NSEvent)
    func mouseTrackViewMouseDragged(with event: NSEvent)
}
 
extension MouseTrackViewDelegate {
    func mouseTrackViewMouseEntered(with event: NSEvent) {}
    func mouseTrackViewMouseExited(with event: NSEvent) {}
    func mouseTrackViewMouseDown(with event: NSEvent) {}
    func mouseTrackViewMouseUp(with event: NSEvent) {}
    func mouseTrackViewMouseDragged(with event: NSEvent) {}
}

class MouseTrackView: NSView {
    weak var mouseTrackDelegate: MouseTrackViewDelegate?
    var trackingAreaOptions: NSTrackingArea.Options? {
        didSet {
            updateTrackingAreas()
        }
    }
    
    private var trackingArea: NSTrackingArea?
    
    override func becomeFirstResponder() -> Bool {
        true
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        if let trackingArea = trackingArea {
            removeTrackingArea(trackingArea)
        }
        if let trackingAreaOptions = trackingAreaOptions {
            trackingArea = NSTrackingArea(rect: bounds, options: trackingAreaOptions, owner: self, userInfo: nil)
            addTrackingArea(trackingArea!)
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
        mouseTrackDelegate?.mouseTrackViewMouseEntered(with: event)
    }
    
    override func mouseExited(with event: NSEvent) {
        mouseTrackDelegate?.mouseTrackViewMouseExited(with: event)
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        mouseTrackDelegate?.mouseTrackViewMouseDown(with: event)
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        mouseTrackDelegate?.mouseTrackViewMouseUp(with: event)
    }
    
    override func mouseDragged(with event: NSEvent) {
        mouseTrackDelegate?.mouseTrackViewMouseDragged(with: event)
    }
}
