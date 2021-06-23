//
//  LogsWindowController.swift
//  Test-Mac
//
//  Created by Archie You on 2021/6/22.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class Logs: NSObject {
    class func show(log: String) {
        print(log)
        LogsWindowController.shared.insertLog(log: log + "\n")
    }
}

class LogsWindowController: NSWindowController {
    override var windowNibName: NSNib.Name? { "LogsWindowController" }
    @IBOutlet var textView: NSTextView!
    static let shared = LogsWindowController()
    
    private init() {
        super.init(window: nil)
        let _ = window
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    @objc func insertLog(log: String) {
        textView.string += log
    }
    
}
