//
//  MyWindow.swift
//  Test-Mac
//
//  Created by Archie You on 2021/3/9.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class MyWindow: NSWindowController {
    @IBOutlet weak var collectionView: NSCollectionView!
    
    override var windowNibName: NSNib.Name? {
        return "MyWindow"
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        window?.delegate = self
//        SPARK_LOG_DEBUG("\(window?.windowNumber)")
    }
    
    @IBAction func onButtonClicked(_ sender: Any) {
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
        print("onButtonClicked")
    }
}

extension MyWindow: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        print("windowWillClose")
//        NSApp.stopModal()
    }
}
