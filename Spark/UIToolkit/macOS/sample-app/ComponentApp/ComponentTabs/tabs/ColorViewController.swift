//
//  ColorViewController.swift
//  ComponentApp
//
//  Created by Jimmy Coyne on 31/05/2021.
//

import Cocoa

class ColorViewController: NSViewController {
    
    func setBGColor(color: NSColor) {
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = color.cgColor
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.cyan.cgColor
        // Do view setup here.
    }
    
}
