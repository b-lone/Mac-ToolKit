//
//  CommonTestWindowController.swift
//  Test-Mac
//
//  Created by Archie You on 2021/7/11.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa
protocol CommonTestWindowControllerDelegate: AnyObject {
    func windowController(_ windowController: CommonTestWindowController, didResize size: NSSize)
}

class CommonTestWindowController: NSWindowController {
    override var windowNibName: NSNib.Name? { "CommonTestWindowController" }
    @IBOutlet weak var contentView: NSView!
    weak var delegate: CommonTestWindowControllerDelegate?
    
    init() {
        super.init(window: nil)
        let _ = window
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.delegate = self

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
}

extension CommonTestWindowController: NSWindowDelegate {
    func windowDidResize(_ notification: Notification) {
        if let size = window?.frame.size {
            delegate?.windowController(self, didResize: size)
        }
    }
}
