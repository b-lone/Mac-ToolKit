//
//  MainWindow.swift
//  TestApp
//
//  Created by Jimmy Coyne on 25/04/2021.
//

import Cocoa

class MainWindow: NSWindowController {
    
    convenience init() {
        self.init(windowNibName: "MainWindow" )
    }
    
    
    lazy var libraryTabViewController: NSTabViewController = {
        let tabVC = NSTabViewController()
        
        let buttonTab = NSTabViewItem(viewController: ButtonsTabViewController())
        buttonTab.label = "Buttons"
        buttonTab.color = .blue
      //  buttonTab.image  = NSImage(imageLiteralResourceName:)
        
        tabVC.addTabViewItem(buttonTab)
                                      
        let textFieldTab = NSTabViewItem(viewController: TextFieldsViewController())
        textFieldTab.label = "Input fields"
        tabVC.addTabViewItem(textFieldTab)
        
        let badgesTab = NSTabViewItem(viewController: BadgesViewController())
        badgesTab.label = "Badges"
        tabVC.addTabViewItem(badgesTab)
        
        let tablesTab = NSTabViewItem(viewController: TablesViewController())
        tablesTab.label = "Tables"
        tabVC.addTabViewItem(tablesTab)
        

        let popoversTab = NSTabViewItem(viewController: PopoversAndDialogsViewController())
        popoversTab.label = "Popovers/Dialogs"
        tabVC.addTabViewItem(popoversTab)
        

        let tabTab = NSTabViewItem(viewController: TabsViewController())
        tabTab.label = "Tabs"
        tabVC.addTabViewItem(tabTab)
        

        let alertsTab = NSTabViewItem(viewController: AlertsVC())
        alertsTab.label = "Alerts"
        tabVC.addTabViewItem(alertsTab)
        

        let avatarTab = NSTabViewItem(viewController: AvatarViewController())
        avatarTab.label = "Avatar"
        tabVC.addTabViewItem(avatarTab)
        
        let controlsTab = NSTabViewItem(viewController: ControlsViewController())
        controlsTab.label = "Controls"
        tabVC.addTabViewItem(controlsTab)

        let teamsTab = NSTabViewItem(viewController: TeamsViewController())
        teamsTab.label = "Teams"
        tabVC.addTabViewItem(teamsTab)

        let demoTab = NSTabViewItem(viewController: AppDemoVC())
        demoTab.label = "Demo"
        tabVC.addTabViewItem(demoTab)
        
        let callWindowTab = NSTabViewItem(viewController: CallWindowVC())
        callWindowTab.label = "Call Window Prep"
        tabVC.addTabViewItem(callWindowTab)
        
        let overlayTab = NSTabViewItem(viewController: BackgroundTabViewController())
        overlayTab.label = "Backgrounds"
        tabVC.addTabViewItem(overlayTab)

        let cardsTab = NSTabViewItem(viewController: CalendarCardViewController())
        cardsTab.label = "Cards"
        tabVC.addTabViewItem(cardsTab)

        
        tabVC.selectedTabViewItemIndex = 0
        tabVC.tabStyle = .toolbar
        return tabVC
        
        
    }()

    override func windowDidLoad() {
        super.windowDidLoad()
        super.window?.title  = "Library Collection"

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.\
        UserDefaults.standard.set(true, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")
        self.contentViewController = libraryTabViewController
        
    }

}
