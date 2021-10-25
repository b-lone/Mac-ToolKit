//
//  UTNavigationTabView.swift
//  UIToolkit
//
//  Created by James Nestor on 01/07/2021.
//

import Cocoa

public class UTNavigationTabView: UTTabView {
    
    override func initialise() {
        
        self.orientation = .vertical
        self.tabButtonContainerSize = 64
        
        super.initialise()
        
        self.setTabButtonEdgeInsets(edgeInsets: NSEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    override func buildButton(tab: UTTabItem) -> UTTabButton {
        
        let button = UTNavigationTabButton()
        button.fontIcon = tab.lhsElement
        
        button.action      = #selector(buttonSelected)
        button.target      = self
        button.tabItem     = tab
        button.unreadCount = tab.badgeCount
        
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .vertical)
        
        return button
    }
    
}
