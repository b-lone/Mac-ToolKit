//
//  AppDelegate.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/1/14.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa
import UIToolkit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var mainWindowController: NSWindowController? = nil
    let test = FullScreenDetector()
   
    func applicationWillFinishLaunching(_ notification: Notification) {
        UIToolkit.shared.registerThemeManager(themeManager: SemanticThemeManager.shared)
        NSFont.loadUIToolKitFonts()
        
        UIToolkit.shared.getThemeManager().setTheme(themeName: "MomentumDefault")
        UIToolkit.shared.themeableProtocolManager.notifyListenersOnThemeUpdated()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
//        test.showWindow(self)
//        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        mainWindowController?.window?.makeKeyAndOrderFront(self)
        return false
    }
    
    @objc func onTimer() {
//        print(test.isFullScreen())
    }
}

