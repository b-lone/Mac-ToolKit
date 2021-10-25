//
//  MainWindowController.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/7/11.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        window?.appearance = NSAppearance(named: .vibrantDark)
        
        if let appDelegate = NSApp.delegate as? AppDelegate {
            appDelegate.mainWindowController = self
        }
    }

}
