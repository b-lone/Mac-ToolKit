//
//  LogsWindowController.swift
//  Test-Mac
//
//  Created by Archie You on 2021/6/22.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

public func SPARK_LOG_DEBUG(_ msg: String?, lineNumber: Int32 = #line, fileName: String = #file, fnName: String = #function) {
    let flName = fileName.split(separator: "/").last
    var log = ""
    if #available(macOS 10.15, *) {
        log = "\(NSDate.now.description) \(flName ?? "")[\(lineNumber)] \(fnName): \(msg ?? "")"
    } else {
        log = "\(NSDate().description) \(flName ?? "")[\(lineNumber)] \(fnName): \(msg ?? "")"
    }
    
    Logs.show(log: log)
}
public func SPARK_LOG_TRACE(_ msg: String?, lineNumber: Int32 = #line, fileName: String = #file, fnName: String = #function) {
    let flName = fileName.split(separator: "/").last
    var log = ""
    if #available(macOS 10.15, *) {
        log = "\(NSDate.now.description) \(flName ?? "")[\(lineNumber)] \(fnName): \(msg ?? "")"
    } else {
        log = "\(NSDate().description) \(flName ?? "")[\(lineNumber)] \(fnName): \(msg ?? "")"
    }
    Logs.show(log: log)
}

public func SPARK_LOG_ERROR(_ msg: String?, lineNumber: Int32 = #line, fileName: String = #file, fnName: String = #function) {
    let flName = fileName.split(separator: "/").last
    var log = ""
    if #available(macOS 10.15, *) {
        log = "\(NSDate.now.description) \(flName ?? "")[\(lineNumber)] \(fnName): \(msg ?? "")"
    } else {
        log = "\(NSDate().description) \(flName ?? "")[\(lineNumber)] \(fnName): \(msg ?? "")"
    }
    Logs.show(log: log)
}

class Logs: NSObject {
    class func show(log: String) {
        print(log)
        DispatchQueue.main.async {
//            LogsWindowController.shared.insertLog(log: log + "\n")
        }
        
    }
}

class LogsWindowController: NSWindowController {
    override var windowNibName: NSNib.Name? { "LogsWindowController" }
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var contentView: NSView!
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
        window?.backgroundColor = .clear
        window?.appearance = NSAppearance(named: .vibrantDark)
    }
    
    @objc func insertLog(log: String) {
        textView.string += log
        showWindow(self)
    }
    
}
