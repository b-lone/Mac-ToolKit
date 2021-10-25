//
//  UTWindow.swift
//  UTToolKit
//
//  Created by jnestor on 19/11/2020.
//  Copyright © 2020 Cisco Systems. All rights reserved.
//

import Cocoa

//MARK: UTWindow
open class UTWindow: NSWindow, ThemeableProtocol {
    
    //MARK: - Variables
    private var fieldEditor:UTTextFieldEditor?
    
    //MARK: - Lifecycle
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        UIToolkit.shared.themeableProtocolManager.subscribe(listener: self)
        NSLog("Initialise UTWindow")
    }
    
    deinit {
        UIToolkit.shared.themeableProtocolManager.unsubscribe(listener: self)
        NSLog("Deinit UTWindow")
    }

    //MARK: - Overriden Public API
    
    //Overriding the filed editor is necessary for NSTextField to properly show focus state
    //TextFields give focus to a field editor after gaining focus which means they are no longer first responder
    //The field editor is shared between all NSTextFields within a window
    public override func fieldEditor(_ createFlag: Bool, for object: Any?) -> NSText? {
           
        if delegate?.responds(to: #selector(NSWindowDelegate.windowWillReturnFieldEditor) ) == true{
           
            if let editor = delegate?.windowWillReturnFieldEditor?(self, to: object) as? NSText{
                return editor
            }
        }
        else if let textField = object as? NSTextField,
                textField.cell is NSSecureTextFieldCell {
            return super.fieldEditor(createFlag, for: object)
        }
       
        if fieldEditor == nil && createFlag{
            fieldEditor = UTTextFieldEditor()
            fieldEditor?.isFieldEditor = true
            fieldEditor?.addKeyWindowObserver()
        }
        
        if let textField = object as? NSTextField{
            fieldEditor?.lastTextField = textField
        }

        return fieldEditor
    }
    
    public func setDialogProperties() {
        self.standardWindowButton(.miniaturizeButton)?.isEnabled = false
        self.standardWindowButton(.zoomButton)?.isEnabled        = false
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
    }
 
    //MARK: - ThemeableProtocol
    public func setThemeColors() {
        self.appearance = NSAppearance.getThemedAppearance()
    }
}
