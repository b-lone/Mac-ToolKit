//
//  CallHistoryDemoVC.swift
//  ComponentApp
//
//  Created by James Nestor on 15/06/2021.
//

import Cocoa
import UIToolkit

class CallHistoryDemoVC: UTBaseViewController {

    @IBOutlet var tabViewContainer: NSView!
    @IBOutlet var rhsTabContainerView: NSView!
    
    @IBOutlet var tabView: UTTabView!
    @IBOutlet var splitView: NSSplitView!
    
    @IBOutlet var rhsTabView: NSTabView!
    
    private var callHistoryTableVC:CallHistoryTableVC!
    private var callHistoryItemSummaryVC:CallHistoryItemSummaryVC!
    private var callHistoryLandingVC:CallHistoryLandingVC!
    private var allTab:UTTabItem!
    private var missedTab:UTTabItem!
    
    private var callHistoryLandingTabItem:NSTabViewItem!
    private var callHistoryItemSummaryTabItem:NSTabViewItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        tabViewContainer.wantsLayer = true
        rhsTabContainerView.wantsLayer = true
        
        tabView.setTabButtonEdgeInsets(edgeInsets: NSEdgeInsets(top: 20, left: 0, bottom: 8, right: 0))
        
        callHistoryTableVC = CallHistoryTableVC()
        _ = callHistoryTableVC.view
        callHistoryTableVC.delegate = self
                
        allTab = UTTabItem(label: "All", accessibilityLabel: "All calls")
        allTab.viewController = callHistoryTableVC
        missedTab = UTTabItem(label: "Missed", accessibilityLabel: "Missed calls")
        missedTab.viewController = callHistoryTableVC
        
        tabView.addTab(tab: allTab)
        tabView.addTab(tab: missedTab)        
        tabView.delegate = self
        tabView.selectTab(tab: allTab)
        
        callHistoryLandingVC = CallHistoryLandingVC()
        callHistoryLandingTabItem = NSTabViewItem(viewController: callHistoryLandingVC)
        
        callHistoryItemSummaryVC = CallHistoryItemSummaryVC()
        callHistoryItemSummaryTabItem = NSTabViewItem(viewController: callHistoryItemSummaryVC)
        
        rhsTabView.addTabViewItem(callHistoryLandingTabItem)
        rhsTabView.addTabViewItem(callHistoryItemSummaryTabItem)
        rhsTabView.selectTabViewItem(callHistoryLandingTabItem)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        splitView.setPosition(self.view.frame.width / 2, ofDividerAt: 0)
        rhsTabView.selectTabViewItem(callHistoryLandingTabItem)
    }
    
    
    override func setThemeColors() {
        super.setThemeColors()
        tabView.setThemeColors()
        
        tabViewContainer.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: "background-secondary").normal.cgColor
        rhsTabContainerView.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: "background-primary").normal.cgColor
    }
    
}

extension CallHistoryDemoVC : CallHistoryTableVCDelegate {
    func callHistoryItemSelected(items:[TestCallHistoryTableData]){
        rhsTabView.selectTabViewItem(callHistoryItemSummaryTabItem)
        callHistoryItemSummaryVC.setData(items: items)
    }
}

extension CallHistoryDemoVC: UTTabViewDelegate {
    func tabView(_ tabView: UTTabView, didSelect utTabButton: UTTabButton){
        
        if tabView == self.tabView{
            if utTabButton.tabItem == allTab{
                callHistoryTableVC.showAllCalls()
            }
            else if utTabButton.tabItem == missedTab{
                callHistoryTableVC.showMissedCalls()
            }
        }
        
    }

}

extension CallHistoryDemoVC: NSTabViewDelegate{
    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
    }
    
    func tabView(_ tabView: UTTabView, didRightClick tabViewItem: UTTabButton){
    }
}
