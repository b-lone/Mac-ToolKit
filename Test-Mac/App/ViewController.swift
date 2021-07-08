//
//  ViewController.swift
//  Test-Mac
//
//  Created by Archie You on 2021/1/14.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa
import Carbon.HIToolbox

class ViewController: NSViewController {
    @IBOutlet weak var leftButton: NSButton!
    @IBOutlet weak var v1: MouseView!
    @IBOutlet weak var v2: MouseView!
    @IBOutlet weak var roundView: RoundSameSideCornerView!
    @IBOutlet weak var iconView: FontelloIcon!
    @IBOutlet weak var label: FontelloLabelWithText!
    
    var shortcut = GlobalShortcutHander()
    var testDrawingBoard = TestDrawingBoard()
    
    let testWindowController = TestListWindowController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        v1.wantsLayer = true
        v2.wantsLayer = true
        v1.layer?.backgroundColor = NSColor.red.cgColor
        v2.layer?.backgroundColor = NSColor.blue.cgColor
        
        roundView.cornerDirection = .antidiagonal
        view.wantsLayer = true
        
        iconView.iconName = "I"
        iconView.iconSize = 20
        iconView.yOffset = 35
        iconView.layer?.cornerRadius = 30
        iconView.layer?.backgroundColor = NSColor.blue.cgColor
        
        setupLabel()
        
        testWindowController.registerTestCases(cases: testDrawingBoard)
        
        testWindowController.window?.makeKeyAndOrderFront(self)
    }
    
    private func setupLabel() {
        label.labelText = "Hold  \u{fa0a}  to select multiple applications."
        label.boldText = "\u{fa0a}"
        label.boldTextFont = NSFont(name: "momentum-ui-icons", size: 20)
        
        label.fontSize = 16
        label.spacing = 8
        
        label.iconColour = .black
        label.textColour = .black
        label.boldTextBackgroundColor = .gray
    }
    
    override func flagsChanged(with event: NSEvent) {
//        NSEventModifierFlags(rawValue: 65536) NSEventModifierFlags(rawValue: 131072)
//        capsLock down
//        57 NSEventModifierFlags(rawValue: 65536)
//        capsLock Up
//        57 NSEventModifierFlags(rawValue: 0)
//        shift down
//        56 NSEventModifierFlags(rawValue: 131072)
//        shift up
//        56 NSEventModifierFlags(rawValue: 0)
//        shift down with capsLock
//        56 NSEventModifierFlags(rawValue: 196608)
//        shift up with capsLock
//        56 NSEventModifierFlags(rawValue: 65536)
        if event.keyCode == kVK_Shift || event.keyCode == kVK_RightShift {
            print("\(event.modifierFlags.intersection(.deviceIndependentFlagsMask).rawValue & NSEvent.ModifierFlags.shift.rawValue == NSEvent.ModifierFlags.shift.rawValue)")
        }
    }
    
    @IBAction func onLeftButton(_ sender: Any) {
        print("onLeftButton")
    }
    
    @IBAction func onRightButton(_ sender: Any) {
        print("onRightButton")
    }
}
