//
//  TextFieldsViewController.swift
//  TestApp
//
//  Created by Jimmy Coyne on 25/04/2021.
//

import Cocoa
import UIToolkit

class TextFieldsViewController: UTBaseViewController {

    //MARK: - Input text field
    @IBOutlet var textfieldStackView: NSStackView!
    @IBOutlet var largeInputTextField: UTTextField!
    @IBOutlet var mediumInputTextField: UTTextField!
    
    //MARK: - Search text field
    @IBOutlet var searchStackView: NSStackView!
    @IBOutlet var mediumSearchTextField: UTSearchInputTextField!
    
    //MARK: - Validation text field
    @IBOutlet var validationTextFieldLarge: UTTextField!
    @IBOutlet var noErrorRadioButton: NSButton!
    @IBOutlet var errorRadioButton: NSButton!
    @IBOutlet var testHintlabel: UTHintLabel!
    
    //MARK: - Hint text field
    @IBOutlet var hintTextField: UTInputTextFieldWithHint!
    
    //MARK: - validation hint textfield
    @IBOutlet var validationHintTextField: UTValidationTextFieldWithHint!
    @IBOutlet var validationHintNoErrorRadioButton: NSButton!
    @IBOutlet var validationHintErrorRadioButton: NSButton!
    
    //MARK: - Pin text field
    @IBOutlet var pinStackView: NSStackView!
    private var pinSixTextField:UTPinTextField!
    private var pinFourTextField:UTPinTextField!
    
    //MARK: - Password text field
    @IBOutlet var passwordTextField: UTPasswordTextField!
    
    //MARK: - Search modifier text field
    @IBOutlet var searchModifierTextField: UTSearchModifierTextField!
    
    //MARK: - Hyperlink text field
    @IBOutlet var linkLabel: UTHyperlinkTextField!
    
    //MARK: - Max character count
    @IBOutlet var characterCountTextField: UTMaxCharacterCountTextField!
    
    //MARK: - Https auto fill text field
    @IBOutlet var httpsAutoFillTextField: UTHttpsAutoFillTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        
        largeInputTextField.size       = .large
        mediumInputTextField.size      = .medium
        mediumSearchTextField.size     = .medium
        
        characterCountTextField.size = .large
        
        
        pinSixTextField = UTPinTextField(errorMessage: LocalizationStrings.errorPasswordMsg)
        pinFourTextField = UTPinTextField(numberOfItems: 4, errorMessage: LocalizationStrings.errorPasswordMsg)
        
        pinStackView.addArrangedSubview(pinSixTextField)
        pinStackView.addArrangedSubview(pinFourTextField)
        
        testHintlabel.hintString = "Test hint label"
        
        searchModifierTextField.setSupportedModifiers(modifiers: ["in:" : (.sharedIn, "In:"),
                                                                  "from:" : (.sharedBy, "From:"),
                                                                  "with:" : (.with, "With:")] )
        
        linkLabel.stringValue = "Test label with a link in it."
        linkLabel.style = .primary
        linkLabel.fontType = .bodyPrimary
        linkLabel.convertSubstrToLink(str: "link")
        linkLabel.hyperlinkDelegate = self
        
        httpsAutoFillTextField.placeholderString = "Enter website address"
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        
        self.view.layer?.backgroundColor = UIToolkit.shared.getThemeManager().isDarkTheme() ? NSColor.black.cgColor : NSColor.white.cgColor
        
        for view in textfieldStackView.views{
            if let themeableView = view as? ThemeableProtocol{
                themeableView.setThemeColors()
            }
        }
        
        for view in searchStackView.views{
            if let themeableView = view as? ThemeableProtocol{
                themeableView.setThemeColors()
            }
        }
        
        validationTextFieldLarge.setThemeColors()
        
        hintTextField.setThemeColors()
        validationHintTextField.setThemeColors()
        
        pinStackView.setThemeableViewColors()
        
        passwordTextField.setThemeColors()
        searchModifierTextField.setThemeColors()
        
        linkLabel.setThemeColors()
        characterCountTextField.setThemeColors()
        httpsAutoFillTextField.setThemeColors()
    }
    
    @IBAction func validationStateAction(_ sender: Any) {
        
        guard let button = sender as? NSButton else { return }
        
        if button == noErrorRadioButton{
            validationTextFieldLarge.validationState = .noError
            
            testHintlabel.validationState = .noError
            
            pinSixTextField.validationState = .noError
        }
        else if button == errorRadioButton{
            validationTextFieldLarge.validationState = .error            
            
            testHintlabel.validationState = .error
            
            pinSixTextField.validationState = .error
        }
    }
    
    
    @IBAction func validationHintStateAction(_ sender: Any) {
        guard let button = sender as? NSButton else { return }
        
        if button == validationHintNoErrorRadioButton{
            validationHintTextField.validationState = .noError
            validationHintTextField.hintString = "Textfield input hint"
        }
        else if button == validationHintErrorRadioButton{
            validationHintTextField.validationState = .error
            validationHintTextField.hintString = "Textfield error"
        }
    }
}

extension TextFieldsViewController : UTHyperlinkTextFieldDelegate {
    func onLinkAction(sender: UTHyperlinkTextField, link: String, plainText: String) {
        NSLog("link actioned")
    }
    
    
}
