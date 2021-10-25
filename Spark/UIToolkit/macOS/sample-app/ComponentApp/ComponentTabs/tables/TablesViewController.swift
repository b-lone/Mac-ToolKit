//
//  TablesViewController.swift
//  ComponentApp
//
//  Created by James Nestor on 19/05/2021.
//

import Cocoa
import UIToolkit

class TablesViewController: UTBaseViewController {
    
    @IBOutlet var tabView: UTTabView!
    @IBOutlet var splitView: NSSplitView!
    
    
    @IBOutlet var legacyCheckBox: NSButton!
    @IBOutlet var compactCheckBox: NSButton!
    
    @IBOutlet var tableIdTextField: UTTextField!
    @IBOutlet var applyButton: UTPillButton!
    @IBOutlet var reloadTableDataButton: UTPillButton!
    
    
    private var standardTableVC:StandardTableVC!
    private var tableFromComponentVC:TableFromComponentsVC!
    private var multiLineTableVC:MultiLineTableViewController!
    
    private var standardTableTabItem:UTTabItem!
    private var tableFromComponentTabItem:UTTabItem!
    private var multiLineTabItem:UTTabItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        tabView.setTabButtonEdgeInsets(edgeInsets: NSEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        standardTableVC = StandardTableVC()
        tableFromComponentVC = TableFromComponentsVC()
        multiLineTableVC = MultiLineTableViewController()
        
        standardTableTabItem = UTTabItem(label: "DataOnlyTest", accessibilityLabel: "DataOnlyTest")
        standardTableTabItem.viewController = standardTableVC
        tableFromComponentTabItem = UTTabItem(label: "TableFromComponent", accessibilityLabel: "TableFromComponent")
        tableFromComponentTabItem.viewController = tableFromComponentVC
        multiLineTabItem = UTTabItem(label: "Multi line", accessibilityLabel: "multi line")
        multiLineTabItem.viewController = multiLineTableVC
        
        tabView.addTab(tab: tableFromComponentTabItem)
        tabView.addTab(tab: multiLineTabItem)
        tabView.addTab(tab: standardTableTabItem)
        
        applyButton.buttonHeight = .small
        applyButton.title = "Apply"
        
        tableIdTextField.size = .medium
        reloadTableDataButton.title = "Reload table data"
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        splitView.setPosition(self.view.frame.width / 2, ofDividerAt: 0)
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        
        self.view.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: "background-secondary").normal.cgColor
        tabView.setThemeColors()
        
        reloadTableDataButton.setThemeColors()
        tableIdTextField.setThemeColors()
        applyButton.setThemeColors()
    }
    
    @IBAction func legacyCheckBoxAction(_ sender: Any) {
        tableFromComponentVC.showLegacyStyle(isLegacy: legacyCheckBox.state == .on)
    }
    
    @IBAction func compactCheckBoxAction(_ sender: Any) {        
        tableFromComponentVC.setCompactMode(isCompact: compactCheckBox.state == .on)
        multiLineTableVC.setCompactMode(isCompact: compactCheckBox.state == .on)
    }
    
    @IBAction func selectRowWithIdAction(_ sender: Any) {
        
        let id = tableIdTextField.stringValue
        tableFromComponentVC.selectRowWithId(rowId: id)
        multiLineTableVC.selectRowWithId(rowId: id)
    }
    
    @IBAction func reloadTableData(_ sender: Any) {
        tableFromComponentVC.reloadTableData()
        multiLineTableVC.reloadTableData()
    }
}


extension TablesViewController: UTTabViewDelegate {
    func tabView(_ tabView: UTTabView, didSelect tabButton: UTTabButton){
        
        if tabView == self.tabView{
            if tabButton.tabItem == standardTableTabItem{
                
            }
            else if tabButton.tabItem == tableFromComponentTabItem {
                
            }
            else if tabButton.tabItem == multiLineTabItem {
            }
        }
        
    }
    
    func tabView(_ tabView: UTTabView, didRightClick tabViewItem: UTTabButton){
    }
}
