//
//  UTInputTextFieldWithHint.swift
//  UIToolkit
//
//  Created by James Nestor on 21/05/2021.
//

import Cocoa

public class UTInputTextFieldWithHint: NSView, ThemeableProtocol {

    var textField:UTTextField!
    var hintLabel:UTHintLabel!
    
    @IBInspectable public var textFieldPlaceholderString: String = "" {
        didSet{
            textField.placeholderString = textFieldPlaceholderString
        }
    }
    
    @IBInspectable public var hintString: String = "" {
        didSet{
            hintLabel.hintString = hintString
        }
    }
    
    public var stringValue: String{
        return textField.stringValue
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    func initialise(){
        self.wantsLayer = true
                
        textField = UTTextField(frame: NSZeroRect)
        hintLabel = UTHintLabel(frame: NSZeroRect)
        
        textField.alignment = .natural
        
        self.addSubview(textField)
        self.addSubview(hintLabel)
        
        let textFieldIntrinsicContentSize = textField.intrinsicContentSize
        textField.frame = NSMakeRect(self.bounds.minX, self.bounds.maxY - textFieldIntrinsicContentSize.height, self.bounds.width, textFieldIntrinsicContentSize.height)
        
        
        hintLabel.frame = NSMakeRect(8, textField.frame.minY - 28, self.bounds.width, 20)
        hintLabel.hintString = "This is help text for the input."
        
    }
    
    public func setThemeColors() {
        textField.setThemeColors()
        hintLabel.setThemeColors()
    }
    
}
