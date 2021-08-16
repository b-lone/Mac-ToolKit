//
//  TestListViewController.swift
//  Test-Mac
//
//  Created by Archie You on 2021/7/8.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

protocol TestCasesManager: AnyObject {
    var testName: String { get }
    func getTestCases() -> TestCaseList
    func onButton(caseName: String, actionName: String)
}

class TestAction: NSObject {
    static let startAction = "Start"
    static let stopAction = "Stop"
    
    enum ActionType {
        case button
    }
    var type: ActionType = .button
    var title: String = ""
    
    init(title: String, type: ActionType = .button) {
        self.type = type
        self.title = title
    }
}

class TestCase: NSObject {
    var name = ""
    var actionList = [TestAction(title: "Start", type: .button), TestAction(title: "Stop", type: .button)]
    init(name: String) {
        self.name = name
    }
}
typealias TestCaseList = [TestCase]

class TestListViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    private var testCasesManager: TestCasesManager
    
    private var testCaseList: TestCaseList { testCasesManager.getTestCases() }
    var testName: String { testCasesManager.testName }
    
    init(testCasesManager: TestCasesManager) {
        self.testCasesManager = testCasesManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .purple.withAlphaComponent(0.8)
        
        setup()
    }
    
    private func setup() {
        updateTableColumns()
        tableView.reloadData()
    }
    
    private func getColumnsCount() -> Int {
        var result = 0
        testCaseList.forEach {
            result = max($0.actionList.count, result)
        }
        return result + 1
    }
    
    private func updateTableColumns() {
        let tableColumns = tableView.tableColumns
        for tableColumn in tableColumns {
            tableView.removeTableColumn(tableColumn)
        }
        
        for index in 0..<getColumnsCount() {
            let tableColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("\(index - 1)"))
            if index == 0 {
                tableColumn.width = 140
                tableColumn.minWidth = 140
                tableColumn.maxWidth = 140
            } else {
                tableColumn.width = 80
                tableColumn.minWidth = 80
                tableColumn.maxWidth = 80
            }
            tableView.addTableColumn(tableColumn)
        }
    }
    
    @objc private func onTableViewButton(_ sender: TableViewButton) {
        testCasesManager.onButton(caseName: sender.testCase.name, actionName: sender.title)
    }
}

extension TestListViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard row < testCaseList.count else { return nil }
        
        let testCase = testCaseList[row]
        
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier("-1") {
            let label = TableViewLabel(title: testCase.name)
            label.isBordered = false
            return label
        } else if let identifier = tableColumn?.identifier.rawValue, let index = Int(identifier), index < testCase.actionList.count {
            switch testCase.actionList[index].type {
            case .button:
                let button = TableViewButton(testCase: testCase, index: index)
                button?.target = self
                button?.action = #selector(onTableViewButton(_:))
                return button
            }
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
}

extension TestListViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return testCaseList.count
    }
}

private class TableViewButton: NSButton {
    var borderColor = NSColor.clear {
        didSet{
            layer?.borderColor = borderColor.cgColor
        }
    }
    
    var testCase: TestCase {
        didSet {
            setup()
        }
    }
    
    private var index = 0
    
    init?(testCase: TestCase, index: Int) {
        guard index < testCase.actionList.count, testCase.actionList[index].type == .button else { return nil }
        self.testCase = testCase
        self.index = index
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        wantsLayer = true
        layer?.borderWidth = 1
        layer?.cornerRadius = 4
        
        let action = testCase.actionList[index]
        attributedTitle = NSAttributedString(string: action.title, attributes: [
            .foregroundColor : NSColor.white,
            .font: NSFont.systemFont(ofSize: NSFont.systemFontSize)
        ])
        isBordered = false
        
        if index == 0 {
            borderColor = .red
        } else if index == 1 {
            borderColor = .orange
        } else if index == 2 {
            borderColor = .yellow
        } else if index == 3 {
            borderColor = .green
        } else if index == 4 {
            borderColor = .cyan
        } else if index == 5 {
            borderColor = .blue
//        } else if index == 6 {
//            borderColor = .purple
        } else {
            borderColor = .black
        }
    }
}

private class TableViewLabel: NSTextField {
    var title: String
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        textColor = .white
        drawsBackground = false
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
