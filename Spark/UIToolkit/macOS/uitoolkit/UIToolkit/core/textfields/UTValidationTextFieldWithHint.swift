//
//  UTValidationTextFieldWithHint.swift
//  UIToolkit
//
//  Created by James Nestor on 21/05/2021.
//

import Cocoa

public class UTValidationTextFieldWithHint: NSView, ThemeableProtocol {
    
    private var containerStackView: NSStackView!
    private var validationTextField: UTTextField!
    private var hintLabel: UTHintLabel!
    
    
    @IBInspectable public var validationState: UTTextFieldValidationState = .noError{
        didSet{
            updateForValidationState()
        }
    }
    
    @IBInspectable public var textFieldPlaceholderString: String = "" {
        didSet{
            validationTextField.placeholderString = textFieldPlaceholderString
        }
    }
    
    @IBInspectable public var hintString: String = "" {
        didSet{
            hintLabel.hintString = hintString
            updateErrorLabelVisibility()
        }
    }
    
    public var textField: UTTextField {
        return validationTextField
    }
    
    public var stringValue: String {
        get {
            return validationTextField.stringValue
        }
        set  {
            validationTextField.stringValue = newValue
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }

    private func initialise(){
        self.wantsLayer = true
        self.layer?.masksToBounds = false
                
        validationTextField = UTTextField()
        hintLabel = UTHintLabel()
        
        containerStackView = NSStackView()
        containerStackView.wantsLayer = true
        
        containerStackView.orientation = .vertical
        containerStackView.distribution = .fill
        containerStackView.alignment = .leading
        containerStackView.spacing = 4
        
        self.setAsOnlySubviewAndFill(subview: containerStackView)
        containerStackView.addArrangedSubview(validationTextField)
        containerStackView.addArrangedSubview(hintLabel)
        hintLabel.isHidden = true
    }
    
    private func updateForValidationState() {
        validationTextField.validationState = validationState
        hintLabel.validationState = validationState
        updateErrorLabelVisibility()
    }
    
    private func updateErrorLabelVisibility() {
        hintLabel.isHidden = (validationState == .noError) || hintLabel.hintString.isEmpty
    }
    
    public func setFocus() {
        self.window?.makeFirstResponder(validationTextField)
    }
    
    public func setThemeColors() {
        validationTextField.setThemeColors()
        hintLabel.setThemeColors()
    }
    
}
