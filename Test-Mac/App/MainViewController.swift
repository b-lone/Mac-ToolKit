//
//  MainViewController.swift
//  Test-Mac
//
//  Created by Archie You on 2021/7/8.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    @IBOutlet weak var tabView: NSTabView!
    private var testListViewControllerList = [TestListViewController]()
    
    private var testDrawingBoard = TestDrawingBoard()
    private var testWindow = TestWindow()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateTestListViewControllerList()
        
        for viewController in testListViewControllerList {
            let tabItem = NSTabViewItem()
            tabItem.label = viewController.testName
            tabItem.view = viewController.view
            tabView.addTabViewItem(tabItem)
        }
    }
    
    private func generateTestListViewControllerList() {
        var viewController = TestListViewController(testCasesManager: testDrawingBoard)
        testListViewControllerList.append(viewController)
        viewController = TestListViewController(testCasesManager: testWindow)
        testListViewControllerList.append(viewController)
    }
}
