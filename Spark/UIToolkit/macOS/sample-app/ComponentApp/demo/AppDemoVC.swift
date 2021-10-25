//
//  AppDemoVC.swift
//  ComponentApp
//
//  Created by James Nestor on 30/06/2021.
//

import Cocoa
import UIToolkit

class AppDemoVC: UTBaseViewController {
        
    @IBOutlet var navigationTabView: UTNavigationTabView!
    
    //Message
    var messageTabVC:MessageTabViewController!
    var messageTabItem:UTTabItem!
    
    //Call History
    var callHistoryDemoVC:CallHistoryDemoVC!
    var callTabItem:UTTabItem!
    
    var upgradeTabItem:UTTabItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        
        messageTabVC = MessageTabViewController()
        callHistoryDemoVC = CallHistoryDemoVC()
        
        messageTabItem = UTTabItem(badgeCount: 56, label: "", lhsIcon: .chatFilled, accessibilityLabel: "", enableArrow: false, vc: messageTabVC)
        callTabItem = UTTabItem(badgeCount: 1, label: "", lhsIcon: .handsetFilled, accessibilityLabel: "", enableArrow: false, vc: callHistoryDemoVC)
        upgradeTabItem = UTTabItem(badgeCount: 501, label: "", lhsIcon: .restartBold, accessibilityLabel: "", enableArrow: false, vc: nil)
        
        navigationTabView.addTab(tab: messageTabItem)
        navigationTabView.addTab(tab: callTabItem)
        navigationTabView.addTab(tab: upgradeTabItem)
        navigationTabView.delegate = self

    }
    
    override func setThemeColors() {
        super.setThemeColors()
        
        self.view.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: "background-secondary").normal.cgColor
    }
  
}

extension AppDemoVC : UTTabViewDelegate {
    func tabView(_ tabView: UTTabView, didSelect tabViewItem: UTTabButton) {
    }
    
    func tabView(_ tabView: UTTabView, didRightClick tabViewItem: UTTabButton){
    }
}
