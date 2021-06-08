//
//  MyWindow.swift
//  Test-Mac
//
//  Created by Archie You on 2021/3/9.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class MyWindow: NSWindowController {
    override var windowNibName: NSNib.Name? {
        return "MyWindow"
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        window?.delegate = self
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    @IBAction func onRightButton(_ sender: Any) {
//        let alert = NSAlert()
//        alert.messageText = "test"
//        let wc = MyWindow()
//        self.window?.addChildWindow(wc.window!, ordered: .above)
//        window?.center()
//        alert.runModal()
//        let timer = Timer(timeInterval: 1, repeats: false) { _ in
//            print("scheduledTimer")
//        }
//        RunLoop.current.add(timer, forMode: .modalPanel)
//        NSApp.stopModal()
//        print("onRightButton")
    }
}

extension MyWindow: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        print("windowWillClose")
//        NSApp.stopModal()
    }
}

