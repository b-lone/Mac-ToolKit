//
//  PreviewWindow.swift
//  Test-Mac
//
//  Created by Archie You on 2021/8/23.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class PreviewWindow: NSWindow {
    init() {
        super.init(contentRect: .zero, styleMask: NSWindow.StyleMask(rawValue: NSWindow.StyleMask.borderless.rawValue | NSWindow.StyleMask.closable.rawValue | NSWindow.StyleMask.resizable.rawValue), backing: .buffered, defer: true)
    }

}
