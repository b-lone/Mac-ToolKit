//
//  AppDelegate.swift
//  TestApp
//
//  Created by Jimmy Coyne on 19/03/2021.
//

import Cocoa
import UIToolkit

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!

        
    @IBOutlet weak var appearanceSubMenu: NSMenu!

    lazy var mainWindow = MainWindow()
    private lazy var fontWindow = FontWindow()
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        let sampleThemeManager = SampleThemeManager()
        let toolkit = UIToolkit.shared
        toolkit.registerThemeManager(themeManager: sampleThemeManager)
    
        NSFont.loadUIToolKitFonts()
        
        for (themeName, _) in sampleThemeManager.themeMapCollection{
            
            let themeItem = NSMenuItem(title: themeName, action: #selector(AppDelegate.updateAppearance(_:)), keyEquivalent: "")
            appearanceSubMenu.addItem(themeItem)
        }
        
        UserDefaults.standard.set(true, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")
    }

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        mainWindow.showWindow(nil)
        UIToolkit.shared.themeableProtocolManager.notifyListenersOnThemeUpdated()
    }


    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        mainWindow.showWindow(nil)
        return false
    }

    @objc private func updateAppearance(_ sender: AnyObject){
        guard let menuItem = (sender as? NSMenuItem) else { return }
        
        let theme = menuItem.title
        UIToolkit.shared.getThemeManager().setTheme(themeName: theme)
        UIToolkit.shared.themeableProtocolManager.notifyListenersOnThemeUpdated()
    }

    @IBAction func showFontWindow(_ sender: Any) {
        fontWindow.window?.makeKeyAndOrderFront(self)
    }
}

