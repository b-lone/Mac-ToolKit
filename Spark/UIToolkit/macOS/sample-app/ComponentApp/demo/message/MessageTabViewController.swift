//
//  MessageTabViewController.swift
//  ComponentApp
//
//  Created by James Nestor on 30/06/2021.
//

import Cocoa
import UIToolkit

class MessageTabViewController: UTBaseViewController {
    
    @IBOutlet var spaceListTabView: UTTabView!
    
    @IBOutlet var messageControlsStackView: NSStackView!
    
    private var allTabItem:UTTabItem!
    private var directTabItem:UTTabItem!
    private var spacesTabItem:UTTabItem!
    
    private var spacesListDemoVC:SpaceListDemoVC!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        spacesListDemoVC = SpaceListDemoVC()
        allTabItem       = UTTabItem(label: "All", accessibilityLabel: "All spaces tab")
        directTabItem    = UTTabItem(label: "Direct", accessibilityLabel: "Direct messages tab")
        spacesTabItem    = UTTabItem(label: "Spaces", accessibilityLabel: "Spaces tab")
        
        allTabItem.viewController    = spacesListDemoVC
        directTabItem.viewController = spacesListDemoVC
        spacesTabItem.viewController = spacesListDemoVC
        
        spaceListTabView.addTab(tab: allTabItem)
        spaceListTabView.addTab(tab: directTabItem)
        spaceListTabView.addTab(tab: spacesTabItem)
        
        spaceListTabView.setTabButtonEdgeInsets(edgeInsets: NSEdgeInsets(top: 20, left: 0, bottom: 8, right: 0))
        
        let defaultBadge          = UTAlertBadge(style: .defaultBadge, iconType: .hideBold,         title: "Peek mode")
        let announcementBadge     = UTAlertBadge(style: .announcement, iconType: .announcementBold, title: "Announcement space")
        let alertWarningBadge     = UTAlertBadge(style: .alertWarning, iconType: .externalUserBold, title: "External participants")
        let importantBadge        = UTAlertBadge(style: .important,    iconType: .shieldBold,       title: "Highly confidential")
        let alertGeneralBadge     = UTAlertBadge(style: .alertGeneral, iconType: .blockedBold,      title: "",                         displayMode: .icon)
        let instantMessagingBadge = UTAlertBadge(style: .defaultBadge, iconType: ._invalid,         title: "Instant messagaing space", displayMode: .label)
        
        alertGeneralBadge.action = #selector(MessageTabViewController.alertGeneralBadgeAction(_:))
        alertGeneralBadge.target = self
        
        messageControlsStackView.addView(defaultBadge,          in: .trailing)
        messageControlsStackView.addView(announcementBadge,     in: .trailing)
        messageControlsStackView.addView(alertWarningBadge,     in: .trailing)
        messageControlsStackView.addView(importantBadge,        in: .trailing)
        messageControlsStackView.addView(alertGeneralBadge,     in: .trailing)
        messageControlsStackView.addView(instantMessagingBadge, in: .trailing)        
        
    }
    
    @objc func alertGeneralBadgeAction(_ sender: Any) {
        for view in messageControlsStackView.views {
            
            if let alertBadge = view as? UTAlertBadge,
               alertBadge.style == .alertGeneral {
                
                if alertBadge.title.isEmpty {
                    alertBadge.title = "Alert General"
                }
                else {
                    alertBadge.title = ""
                }
            }
        }
    }
    
    override func updateFont() {
        super.updateFont()
        
        messageControlsStackView.updateFontProtocolFonts()
    }
    
}

extension MessageTabViewController: NSTabViewDelegate{
    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        
    }
}
