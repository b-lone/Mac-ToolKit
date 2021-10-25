//
//  TabsViewController.swift
//  ComponentApp
//
//  Created by Jimmy Coyne on 25/05/2021.
//

import Cocoa
import UIToolkit

class TabsViewController: UTBaseViewController {


    @IBOutlet weak var tabView: UTTabView!
    @IBOutlet weak var tabAreaView: NSTabView!
    
    @IBOutlet weak var tabNameTextField: NSTextField!
    @IBOutlet weak var tabNumber: NSTextField!
    
    
    @IBOutlet weak var renameButton: NSButton!
    @IBOutlet weak var removeButton: NSButton!
    @IBOutlet weak var disableButton: NSButton!
    @IBOutlet weak var enableButton: NSButton!
    @IBOutlet weak var setSelectedButton: NSButton!
    @IBOutlet weak var arrowOnButton: NSButton!
    @IBOutlet weak var arrowOffButton: NSButton!
    
    var tabItem1: UTTabItem!
    var tabItem2: UTTabItem!
    var tabItem3: UTTabItem!
    var tabItem4:  UTTabItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        tabView.wantsLayer = true
        tabView.clipping(allow: true)
        tabView.delegate = self
        
    let vc1 = ColorViewController()
        let vc2 = ColorViewController()
        vc2.setBGColor(color: .blue)
        let vc3 = ColorViewController()
        vc3.setBGColor(color: .brown)
        let vc4 = ColorViewController()
        vc4.setBGColor(color: .cyan)

        
        guard let image = NSImage(named: "swift") else {
            assert(false, "Image is missing")
            return 
        }
             
        tabItem1 =  UTTabItem(label: "hello", lhsIcon: .videoRegular,  accessibilityLabel: "hello", enableArrow: true)
        tabItem1.viewController = vc1
    
        tabItem2 =  UTTabItem(showUnreadPill: true,  label: "this is a test", showAlert: false, image: image, accessibilityLabel: "hello", enableArrow: false)
        tabItem2.viewController = vc2
        
        //label:String, accessibilityLabel:String, enableArrrow: Bool = false,
        tabItem3 = UTTabItem(badgeCount: 23, label: "this is a test", accessibilityLabel: "test", enableArrow: true)
        tabItem3.viewController = vc3
        
        tabItem4 = UTTabItem(label: "Check for calls here", accessibilityLabel: "Call Tab")
        tabItem4.viewController = vc3
        

        tabView.addTab(tab: tabItem1)
        tabView.addTab(tab: tabItem2)
        tabView.addTab(tab: tabItem3)
        tabView.addTab(tab: tabItem4)
        
        _ = tabView.removeTab(tab: tabItem3)
        tabItem3 = UTTabItem(badgeCount: 22, label: "this is a test", accessibilityLabel: "test", enableArrow: true)
        tabItem3.viewController = vc3
        tabView.addTab(tab: tabItem3)
    }
    
    
    override func setThemeColors() {
        super.setThemeColors()
        tabView.setThemeColors()
    }
    

    
    @IBAction func addTabAction(_ sender: Any) {
      
            if  tabNameTextField.stringValue.count > 0 {
                let tabName = tabNameTextField.stringValue
                let tabItem = UTTabItem(label: tabName, accessibilityLabel: tabName)
                let vc1 = ColorViewController()
                tabItem.viewController = vc1
                tabView.addTab(tab: tabItem)
            }
        
    }
    
    
    
    //needed to group radio buttons
    @IBAction func radioOnClicked(_ sender: Any) {}
    
    
    @IBAction func updateTab(_ sender: Any) {
        if  tabNumber.stringValue.count > 0 {
            if let number = Int(tabNumber.stringValue) {
                
                if renameButton.state == .on {
                    let tabName = tabNameTextField.stringValue
                    tabView.renameTab(at: number, name: tabName, accessibilityLabel: tabName)
                    
                } else if enableButton.state == .on {
                    tabView.enable(at: number, enable: true)
                    
                } else if disableButton.state == .on {
                    tabView.enable(at: number, enable: false)
                }
                else if removeButton.state == .on {
                    _ = tabView.removeTab(at: number)
                }
                else if setSelectedButton.state == .on {
                    if let tab = tabView.getTabs().getItemAtIndex(number) {
                        tabView.setSelected(tab: tab)
                    }
                }
                else if arrowOnButton.state == .on {
                    if let tab = tabView.getTabs().getItemAtIndex(number) {
                        tabView.setArrowOnForTab(for: tab, arrowOn: true)
                    }
                }
                else if arrowOffButton.state == .on {
                    if let tab = tabView.getTabs().getItemAtIndex(number) {
                        tabView.setArrowOnForTab(for: tab, arrowOn: false)
                    }
                }
            }
        }
    }
    
    
    @IBAction func enableTab(_ sender: Any) {
        if  tabNumber.stringValue.count > 0 {
            let tabName = tabNumber.stringValue
            if let number = Int(tabName) {
                tabView.enable(at: number, enable: true)
            }
        }
    }
    @IBAction func disableTab(_ sender: Any) {
        if  tabNumber.stringValue.count > 0 {
            let tabName = tabNumber.stringValue
            if let number = Int(tabName) {
                tabView.enable(at: number, enable: false)
            }
        }
    }
    
    @IBAction func removeTabs(_ sender: Any) {
        if  tabNumber.stringValue.count > 0 {
            let tab = tabNumber.stringValue
            if let number = Int(tab) {
                tabView.removeTab(at: number)
            }
        }
    }
}

extension TabsViewController : UTTabViewDelegate {
    
    func tabView(_ tabView: UTTabView, didSelect tabButton: UTTabButton) {
        print("didSelect tabButton: UTTabButton")
        
        if tabButton.tabItem == tabItem3 {            
            _ = UTPopover(contentViewController: BadgesViewController(),
                                         sender: tabButton,
                                         bounds: tabButton.bounds,
                                addCancelButton: true)
        }
    }
    
    func tabView(_ tabView: UTTabView, didRightClick tabViewItem: UTTabButton){
    }
    
}
