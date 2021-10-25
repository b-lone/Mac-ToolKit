//
//  UTTabViewTest.swift
//  UIToolkitTests
//
//  Created by Jimmy Coyne on 30/05/2021.
//

import XCTest
import UIToolkit

class UTTabViewTest: XCTestCase, UTTabViewDelegate {
   
    
    var selectedTab:UTTabItem?
    var rightClickedTab:UTTabItem?
    var expectation: XCTestExpectation?

    override func setUpWithError() throws {
        
        let sampleThemeManager = TestThemeManager()
        let toolkit = UIToolkit.shared
        toolkit.registerThemeManager(themeManager: sampleThemeManager)
        NSFont.loadUIToolKitFonts()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddItem() throws {
        
        let vc = TestViewController(nibName: "TestViewController", bundle: Bundle.getUIToolKitTestBundle())
        let tabView = UTTabView()
        XCTAssertEqual(tabView.count, 0)
        
        let tabItem1 = UTTabItem(label: "item1", accessibilityLabel: "item1")
        tabItem1.viewController = vc
        tabView.addTab(tab: tabItem1)
        XCTAssertEqual(tabView.count, 1)
        
        let tabItem2 = UTTabItem(label: "item2", accessibilityLabel: "item2")
        tabItem2.viewController = vc
        tabView.addTab(tab: tabItem2)
        XCTAssertEqual(tabView.count, 2)
    }
    
    func testUpdateItem() throws {
        
        let vc = TestViewController(nibName: "TestViewController", bundle: Bundle.getUIToolKitTestBundle())
        let tabView = UTTabView()
        XCTAssertEqual(tabView.count, 0)
        
        let tabItem1 = UTTabItem(label: "item1", accessibilityLabel: "item1")
        tabItem1.viewController = vc
        tabView.addTab(tab: tabItem1)
        XCTAssertEqual(tabView.count, 1)
        
        if let testTab = tabView.getButtonForTest(tab: tabItem1) {
            XCTAssert(testTab.title == "item1")
        } else {
            XCTAssert(false)
        }
        
        
        tabView.renameTab(at: 0, name: "new_name", accessibilityLabel: "new_name")
        if let testTab = tabView.getButtonForTest(tab: tabItem1) {
            XCTAssert(testTab.title == "new_name")
        } else {
            XCTAssert(false)
        }
       
    }
    
    func testAddAndRemoveAtPos() throws {
        let vc = TestViewController(nibName: "TestViewController", bundle: Bundle.getUIToolKitTestBundle())
        let tabView = UTTabView()
        XCTAssertEqual(tabView.count, 0)
        
        let tabItem1 = UTTabItem(label: "item1", accessibilityLabel: "item1")
        tabItem1.viewController = vc
        tabView.addTab(tab: tabItem1)
        XCTAssertEqual(tabView.count, 1)
        
        let tabItem2 = UTTabItem(label: "item2", accessibilityLabel: "item2")
        tabItem2.viewController = vc
        tabView.addTab(tab: tabItem2)
        XCTAssertEqual(tabView.count, 2)
        
        let result = tabView.removeTab(at: 0)
        XCTAssertEqual(tabView.count, 1)
        XCTAssert(result)
        
        let result2 = tabView.removeTab(at: 0)
        assert(tabView.count  == 0)
        XCTAssertTrue(result2)
        
        let result3 = tabView.removeTab(at: 0)
        assert(tabView.count  == 0)
        XCTAssertFalse(result3)
    }
    
    func testAddAndRemove() throws {
        let vc = TestViewController(nibName: "TestViewController", bundle: Bundle.getUIToolKitTestBundle())
        let tabView = UTTabView()
        XCTAssertEqual(tabView.count, 0)
        
        let tabItem1 = UTTabItem(label: "item1", accessibilityLabel: "item1")
        tabItem1.viewController = vc
        tabView.addTab(tab: tabItem1)
        XCTAssertEqual(tabView.count, 1)
        
        let tabItem2 = UTTabItem(label: "item2", accessibilityLabel: "item2")
        tabItem2.viewController = vc
        tabView.addTab(tab: tabItem2)
        XCTAssertEqual(tabView.count, 2)
        
        let result = tabView.removeTab(tab: tabItem2)
        XCTAssertEqual(tabView.count, 1)
        XCTAssert(result)
        
        let result2 = tabView.removeTab(tab: tabItem2)
        assert(tabView.count  == 1)
        XCTAssertTrue(result2 == false)
    }
    
    
    func testItemSelected() throws {
        
        let tabView = UTTabView()
        tabView.delegate = self
        expectation = expectation(description: "Selected tab")
        
        XCTAssertTrue(tabView.count == 0)
        let tabItem1 = UTTabItem(label: "item1", accessibilityLabel: "item1")
        tabView.addTab(tab: tabItem1)
        XCTAssertTrue(tabView.count == 1)
        let tabItem2 = UTTabItem(label: "item2", accessibilityLabel: "item2")
        tabView.addTab(tab: tabItem2)
        XCTAssertTrue(tabView.count == 2)
        
        XCTAssertEqual(tabView.selectedTabItem, tabItem1)
        
        tabView.selectTab(tab: tabItem2)
        waitForExpectations(timeout: 1)
        let result = try XCTUnwrap(selectedTab)
        XCTAssertEqual(result, tabItem2)
        XCTAssertEqual(tabView.selectedTabItem, tabItem2)
    }
    
    func testDefaultSelected() throws {
        
        let tabView = UTTabView()
        tabView.delegate = self
                
        XCTAssertEqual(tabView.count, 0)
        let tabItem1 = UTTabItem(label: "item1", accessibilityLabel: "item1")
        tabView.addTab(tab: tabItem1)
        XCTAssertEqual(tabView.count, 1)
        let tabItem2 = UTTabItem(label: "item2", accessibilityLabel: "item2")
        tabView.addTab(tab: tabItem2)
        XCTAssertEqual(tabView.count, 2)
        
        XCTAssertTrue(tabView.selectedTabItem == tabItem1)
    }
    
    func testSetSelected() throws {
        let tabView = UTTabView()
        tabView.delegate = self
        
        XCTAssertTrue(tabView.count == 0)
        let tabItem1 = UTTabItem(label: "item1", accessibilityLabel: "item1")
        tabView.addTab(tab: tabItem1)
        XCTAssertTrue(tabView.count == 1)
        let tabItem2 = UTTabItem(label: "item2", accessibilityLabel: "item2")
        tabView.addTab(tab: tabItem2)
        XCTAssertTrue(tabView.count == 2)
        
        XCTAssertEqual(tabView.selectedTabItem, tabItem1)
        
        tabView.setSelected(tab: tabItem2)
        XCTAssertEqual(tabView.selectedTabItem, tabItem2)
    }
    
    func testRepresentedObject() throws {
        
        let tabView = UTTabView()
        tabView.delegate = self
        expectation = expectation(description: "Check RepresentedObject ")
        
        XCTAssertEqual(tabView.count, 0)
        
        let myRepresentedObject1 = "hello"
        let tabItem1 = UTTabItem(label: "item1", accessibilityLabel: "item1")
        tabItem1.representedObject = myRepresentedObject1
        tabView.addTab(tab: tabItem1)
        
        let myRepresentedObject2 = "hello world"
        let tabItem2 = UTTabItem(label: "item1", accessibilityLabel: "item1")
        tabItem2.representedObject = myRepresentedObject2
        tabView.addTab(tab: tabItem2)
        
        tabView.selectTab(tab: tabItem2)
    
        waitForExpectations(timeout: 1)
        let result = try XCTUnwrap(selectedTab)
        XCTAssertEqual(result.representedObject as! String, myRepresentedObject2)
    }
    
    func testGetAllTabs() throws {
        
        let tabView = UTTabView()
        tabView.delegate = self
        XCTAssertEqual(tabView.count, 0)
        

        
        let myRepresentedObject1 = "hello"
        let tabItem1 = UTTabItem(label: "item1", accessibilityLabel: "item1")
        tabItem1.representedObject = myRepresentedObject1
        tabView.addTab(tab: tabItem1)
        
        let myRepresentedObject2 = "hello world"
        let tabItem2 = UTTabItem(label: "item1", accessibilityLabel: "item1")
        tabItem2.representedObject = myRepresentedObject2
        tabView.addTab(tab: tabItem2)
        
        let myRepresentedObject3 = "hello world"
        let tabItem3 = UTTabItem(label: "item1", accessibilityLabel: "item1")
        tabItem3.representedObject = myRepresentedObject3
        tabView.addTab(tab: tabItem3)
        
        let tabs = tabView.getTabs()
        
        XCTAssertEqual(tabs[0], tabItem1)
        XCTAssertEqual(tabs[1], tabItem2)
        XCTAssertEqual(tabs[2], tabItem3)
    }
    
    func testRightClickTab() throws {
        
        let tabView = UTTabView()
        tabView.delegate = self
        expectation = expectation(description: "right clicked tab")
        
        XCTAssertTrue(tabView.count == 0)
        let tabItem1 = UTTabItem(label: "item1", accessibilityLabel: "item1")
        let tabItem2 = UTTabItem(label: "item2", accessibilityLabel: "item2")
        tabView.addTab(tab: tabItem1)
        tabView.addTab(tab: tabItem2)
        XCTAssertTrue(tabView.count == 2)
        
        XCTAssertEqual(tabView.selectedTabItem, tabItem1)
        
        if let testTab = tabView.getButtonForTest(tab: tabItem2) {
            XCTAssert(testTab.title == "item2")
            testTab.rightMouseUp(with: NSEvent())
            waitForExpectations(timeout: 1)
            
            let result = try XCTUnwrap(rightClickedTab)
            XCTAssertEqual(result, tabItem2)
            // right click does not change selected tab
            XCTAssertEqual(tabView.selectedTabItem, tabItem1)
        }
        else {
            XCTAssert(false)
        }
    }
    
    func testTabTooltip() throws {
        
        let tabView = UTTabView()
        tabView.delegate = self
        
        XCTAssertTrue(tabView.count == 0)
        let tabItem1 = UTTabItem(label: "item1", accessibilityLabel: "item1", tooltip: "item1 tooltip")
        let tabItem2 = UTTabItem(label: "item2", accessibilityLabel: "item2")
        tabView.addTab(tab: tabItem1)
        tabView.addTab(tab: tabItem2)
        XCTAssertTrue(tabView.count == 2)
        
        if let testTab = tabView.getButtonForTest(tab: tabItem1) {
            XCTAssertEqual(testTab.toolTip, "item1 tooltip")
        }
        else {
            XCTAssert(false)
        }
    }
    
    func tabView(_ tabView: UTTabView, didSelect tabButton: UTTabButton) {
        self.selectedTab = tabButton.tabItem
        expectation?.fulfill()
        expectation = nil
    }
    
    func tabView(_ tabView: UTTabView, didRightClick tabButton: UTTabButton) {
        self.rightClickedTab = tabButton.tabItem
        expectation?.fulfill()
        expectation = nil
    }
}
