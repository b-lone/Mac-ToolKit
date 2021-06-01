//
//  StrokeLine.swift
//  Test-Mac
//
//  Created by Archie You on 2021/4/27.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class StrokeLine: NSPanel {
    init() {
        super.init(contentRect: .zero, styleMask: NSWindow.StyleMask(rawValue: NSWindow.StyleMask.borderless.rawValue | NSWindow.StyleMask.nonactivatingPanel.rawValue), backing: .buffered, defer: false)
        self.backgroundColor = .red
        level = .floating
        hasShadow = false
    }
}
