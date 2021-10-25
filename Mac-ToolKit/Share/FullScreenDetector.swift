//
//  FullScreenDetector FullScreenDetector FullScreenDetector FullScreenDetector FullScreenDetector.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/10/19.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

//A  1 * 1 pixel window to detect if the user has gone into full screen
 class FullScreenDetector: NSWindowController {

     override func windowDidLoad()  {
        super.windowDidLoad()

        guard let window = window else {
            return
        }
        window.backgroundColor = .red
        window.collectionBehavior = NSWindow.CollectionBehavior(rawValue: NSWindow.CollectionBehavior.canJoinAllSpaces.rawValue | NSWindow.CollectionBehavior.fullScreenNone.rawValue)
        window.level = .floating

    }


    public func isFullScreen() -> Bool {
        guard let window = window else {
            return false
        }
        return !window.isOnActiveSpace
    }

    override var windowNibName: NSNib.Name? {
        return "FullScreenDetector"
    }

}
