//
//  UTPasswordTextFieldWithHint.swift
//  UIToolkit
//
//  Created by Fabio Dantas on 01/12/2021.
//

import Cocoa

public class UTPasswordTextFieldWithHint: NSView, ThemeableProtocol {


    public var errorMessage: String = "" {
        didSet {
            errorLabel.hintString = errorMessage
        }
    }

    public var validationState:UTTextFieldValidationState = .noError {
        didSet {
            updateForValidationState()
        }
    }
    
    @IBInspectable public var textFieldPlaceholderString: String = "" {
        didSet{
            passwordTextField.placeholderString = textFieldPlaceholderString
        }
    }
    
    public var stringValue: String {
        get {
            return passwordTextField.stringValue
        }
        set  {
            passwordTextField.stringValue = newValue
        }
    }
    
    public var textField: UTPasswordTextField {
        return passwordTextField
    }
    

    //MARK: - Private
    private var containerStackView: NSStackView!
    private var errorLabel: UTHintLabel!
    private var passwordTextField: UTPasswordTextField!

    override public init(frame frameRect: NSRect) {
        super.init(frame: .zero)
        initialise()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }

    private func initialise() {
        self.wantsLayer = true
        self.layer?.masksToBounds = false
        passwordTextField = UTPasswordTextField()
        errorLabel = UTHintLabel()
        errorLabel.hintString = errorMessage

        containerStackView = NSStackView()
        containerStackView.wantsLayer = true

        containerStackView.setHuggingPriority(.defaultHigh, for: .horizontal)
        containerStackView.orientation = .vertical
        containerStackView.distribution = .fillProportionally
        containerStackView.spacing = 4
        
        self.setAsOnlySubviewAndFill(subview: containerStackView)
        containerStackView.addArrangedSubview(passwordTextField)
        containerStackView.addArrangedSubview(errorLabel)
        errorLabel.isHidden = true
    }
    
    private func updateForValidationState() {
        errorLabel.validationState = validationState
        errorLabel.isHidden = (validationState == .noError) || errorLabel.hintString.isEmpty
    }
    
    public func setFocus() {
        self.window?.makeFirstResponder(passwordTextField)
    }
    
    public func setThemeColors() {
        passwordTextField.setThemeColors()
        errorLabel.setThemeColors()
    }

}
