//
//  AppDelegate.swift
//  Test-Mac
//
//  Created by Archie You on 2021/1/14.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var mainWindowController: NSWindowController? = nil
   
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
//        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/macOSInjection.bundle")?.load()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        mainWindowController?.window?.makeKeyAndOrderFront(self)
        return false
    }
}

