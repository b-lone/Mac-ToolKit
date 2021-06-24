//
//  TestListWindowController.swift
//  Test-Mac
//
//  Created by Archie You on 2021/6/23.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class TestActionButton: NSButton {
    enum ActionType {
        case start
        case stop
    }
    
    var caseName = ""
    var actionType = ActionType.start {
        didSet {
            if actionType == .start {
                layer?.borderColor = NSColor.green.cgColor
            } else {
                layer?.borderColor = NSColor.red.cgColor
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        wantsLayer = true
        layer?.borderWidth = 1
        layer?.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TestLabel: NSTextField {
    var title: String
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let attributedString = NSAttributedString(string: title, attributes: [.font : font ?? .systemFont(ofSize: 18, weight: .bold),
                                                                              .foregroundColor: textColor ?? .black])
        
        let size = attributedString.size()
        let rect = NSMakeRect(dirtyRect.minX + (dirtyRect.width - size.width)/2, dirtyRect.minY + (dirtyRect.height - size.height)/2, size.width, size.height)
        attributedString.draw(in: rect)
        
    }
}

class TestCases: NSObject {
    func onStartButton(caseName: String) {
    }
    
    func onStopButton(caseName: String) {
    }
    
    func getTestCases() -> [String] {
        return [String]()
    }
}

class TestListWindowController: NSWindowController {
    var testList = [String]()
    @IBOutlet weak var tableView: NSTableView!
    
    override var windowNibName: NSNib.Name? { "TestListWindowController" }
    
    private var testCases = [TestCases]()
    
    init() {
        super.init(window: nil)
        let _ = window
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.backgroundColor = .white
        tableView.backgroundColor = .white
    }
    
    func registerTestCases(cases: TestCases) {
        testCases.append(cases)
        testList += cases.getTestCases()
        tableView.reloadData()
    }
    
    @objc func onStartButton(_ sender: TestActionButton) {
        testCases.forEach{ $0.onStartButton(caseName: sender.caseName) }
    }
    
    @objc func onStopButton(_ sender: TestActionButton) {
        testCases.forEach{ $0.onStopButton(caseName: sender.caseName) }
    }
}

extension TestListWindowController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier("1") {
            let label = TestLabel(title: testList[row])
            label.isBordered = false
            return label
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("2") {
            let startButton = TestActionButton()
            startButton.caseName = testList[row]
            startButton.actionType = .start
            startButton.title = "Start"
            startButton.target = self
            startButton.action = #selector(onStartButton(_:))
            return startButton
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("3") {
            let stopButton = TestActionButton()
            stopButton.caseName = testList[row]
            stopButton.actionType = .stop
            stopButton.title = "Stop"
            stopButton.target = self
            stopButton.action = #selector(onStopButton(_:))
            return stopButton
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: NSTableView, sizeToFitWidthOfColumn column: Int) -> CGFloat {
        if column == 0 {
            return 120
        } else {
            return 40
        }
    }
}

extension TestListWindowController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return testList.count
    }
}
