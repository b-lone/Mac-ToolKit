//
//  UTTextFieldEditor.swift
//  UIToolkit
//
//  Created by jnestor on 12/05/2021.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa

class UTTextFieldEditor: NSTextView {
    
    weak var lastTextField:NSTextField? = nil
    
    func addKeyWindowObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(UTTextFieldEditor.windowBecameKey(_:)),   name: NSWindow.didBecomeKeyNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UTTextFieldEditor.windowResignedKey(_:)), name: NSWindow.didResignKeyNotification, object: nil)
    }
     
    override func resignFirstResponder() -> Bool {
        if let textField = lastTextField as? UTTextField{
            textField.isFocused = false
        }
        else if let textField = lastTextField as? UTHyperlinkTextField {
            textField.isFocused = false
        }
        
        return super.resignFirstResponder()
    }
    
    override func becomeFirstResponder() -> Bool {
        
        if let textField = lastTextField as? UTTextField{
            textField.isFocused = true
        }
        else if let textField = lastTextField as? UTHyperlinkTextField {
            textField.isFocused = true
        }
        
        return super.becomeFirstResponder()
    }
    
    override func paste(_ sender: Any?) {
        
        if let textField = lastTextField as? UTTextField{
            if textField.onPasteAction(sender) {
                //Text field has handled paste action
                return
            }
        }
        
        super.paste(sender)
    }
    
    
    override public func keyDown(with event: NSEvent) {
        guard let characters = event.charactersIgnoringModifiers,
                  characters.unicodeScalars.count == 1,
                let key = characters.unicodeScalars.first?.value else{
            
            return super.keyDown(with: event)
        }
        
        let keyCode = Int(key)
     
        if isActionKeyCode(keyCode: keyCode) ||
            characters == " " {
            if let tf = lastTextField as? UTHyperlinkTextField {
                tf.actionLink()
                return
            }
        }
        
        return super.keyDown(with: event)
    }
    
    @objc func windowBecameKey(_ notification:Notification){
        guard let senderWindow = notification.object as? NSWindow else { return }
        guard self.window == senderWindow else { return }
        guard self.window?.firstResponder == self else { return}
        
        if let tf = self.lastTextField as? UTTextField {
            tf.isFocused = true
        }
    }
    
    @objc func windowResignedKey(_ notification:Notification){
        guard let senderWindow = notification.object as? NSWindow else { return }
        guard self.window == senderWindow else { return }
        if let tf = self.lastTextField as? UTTextField {
            tf.isFocused = false
        }
    }
    
    private func isActionKeyCode(keyCode:Int) -> Bool{
        return keyCode == NSEvent.SpecialKey.enter.rawValue ||
                keyCode == NSEvent.SpecialKey.newline.rawValue ||
                keyCode == NSEvent.SpecialKey.carriageReturn.rawValue
    }
    
}
