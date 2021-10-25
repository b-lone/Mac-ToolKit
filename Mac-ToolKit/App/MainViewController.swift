//
//  MainViewController.swift
//  Mac-Toolkit
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
        
        view.layer?.backgroundColor = NSColor.black.cgColor
        
        testCasesManagerList.append(TestDrawingBoard())
//        testCasesManagerList.append(TestWindow())
        testCasesManagerList.append(TestCoreAnimation())
        testCasesManagerList.append(TestBonjour())
        testCasesManagerList.append(TestShare())
        
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
