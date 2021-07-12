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
    
    private var testCasesManagerList = [TestCasesManager]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testCasesManagerList.append(TestDrawingBoard())
        testCasesManagerList.append(TestWindow())
        testCasesManagerList.append(TestCoreAnimation())
        
        generateTestListViewControllerList()
        
        for viewController in testListViewControllerList {
            let tabItem = NSTabViewItem()
            tabItem.label = viewController.testName
            tabItem.view = viewController.view
            tabView.addTabViewItem(tabItem)
        }
    }
    
    private func generateTestListViewControllerList() {
        for testCasesManager in testCasesManagerList {
            let viewController = TestListViewController(testCasesManager: testCasesManager)
            testListViewControllerList.append(viewController)
        }
    }
}
