//
//  MyWindowController.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/7/8.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class MyWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
}

extension MyWindowController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        print(#function)
    }
}
