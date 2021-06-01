//
//  FloatingPanel.swift
//  Test-Mac
//
//  Created by Archie You on 2021/4/26.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class FloatingPanel: NSPanel {
    override var canBecomeKey: Bool {
        return false
    }
    
    init() {
        let frame = NSRect(x: 500, y: 500, width: 500, height: 500)
        super.init(contentRect: frame, styleMask: NSWindow.StyleMask(rawValue: NSWindow.StyleMask.borderless.rawValue | NSWindow.StyleMask.nonactivatingPanel.rawValue), backing:.buffered, defer: false)
        self.isReleasedWhenClosed = false
        self.backgroundColor = .green
        self.alphaValue = 0.1
        self.collectionBehavior = NSWindow.CollectionBehavior(rawValue: NSWindow.CollectionBehavior.canJoinAllSpaces.rawValue | NSWindow.CollectionBehavior.fullScreenAuxiliary.rawValue)
        self.isFloatingPanel = true
        self.worksWhenModal = true
        self.hasShadow = false
        self.acceptsMouseMovedEvents = false
        self.isOpaque = false
        self.ignoresMouseEvents = true
        
        self.animator().toggleFullScreen(self)

        level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.popUpMenuWindow)) + 1)
        zoom(self)
    }
}
