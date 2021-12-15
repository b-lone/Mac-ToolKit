//
//  CursorIconView.swift
//  WebexTeams
//
//  Created by Archie You on 2021/12/15.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa

class CursorIconView: NSView {
    var cursor: NSCursor = .arrow {
        didSet {
            resetCursorRects()
        }
    }
    
    override func resetCursorRects() {
        super.resetCursorRects()
        addCursorRect(bounds, cursor: cursor)
    }
    
    override func cursorUpdate(with event: NSEvent) {
        super.cursorUpdate(with: event)
    }
}
