//
//  MyWindowController.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/7/8.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class MyWindowController: NSWindowController {
    override var windowNibName: NSNib.Name? { "MyWindowController" }
    
    init() {
        super.init(window: nil)
        _ = window
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
}

extension MyWindowController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        print(#function)
        NSApp.stopModal()
    }
}
