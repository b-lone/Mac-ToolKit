//
//  CommonTestWindowController.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/7/11.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa
protocol CommonTestWindowControllerDelegate: AnyObject {
    func windowController(_ windowController: CommonTestWindowController, willResize newSize: NSSize) -> NSSize
    func windowController(_ windowController: CommonTestWindowController, didResize size: NSSize)
}

class CommonTestWindowController: NSWindowController {
    override var windowNibName: NSNib.Name? { "CommonTestWindowController" }
    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var label: NSTextField!
    weak var delegate: CommonTestWindowControllerDelegate?
    static private var int: Int = {
        SPARK_LOG_DEBUG("static")
        return 7
    }()
    
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
        
        let ps = NSMutableParagraphStyle()
        ps.headIndent = 20
        let string = NSMutableAttributedString(string: "protocol CommonTestWindowControllerDelegate: AnyObject {\n func windowController(_ windowController: CommonTestWindowController, willResize newSize: NSSize) -> NSSize \nfunc windowController(_ windowController: CommonTestWindowController, didResize size: NSSize) \n}", attributes: [.paragraphStyle: ps])
        label.attributedStringValue = string
        label.backgroundColor = .red

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
}

extension CommonTestWindowController: NSWindowDelegate {
    func windowDidResize(_ notification: Notification) {
        if let size = window?.frame.size {
            delegate?.windowController(self, didResize: size)
        }
    }
    
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        return delegate?.windowController(self, willResize: frameSize) ?? frameSize
    }
}
