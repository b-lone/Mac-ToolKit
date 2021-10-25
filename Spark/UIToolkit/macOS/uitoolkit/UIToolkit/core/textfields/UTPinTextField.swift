//
//  UTPinTextField.swift
//  UIToolkit
//
//  Created by James Nestor on 09/07/2021.
//

import Cocoa

protocol PinTextFieldItemDelegate : AnyObject {
    func paste(sender: UTTextField, pastedString:String)
    func textChanged(sender: UTTextField)
}

public class UTPinTextFieldItem: UTTextField {
    
    weak var pinDelegate: PinTextFieldItemDelegate?
    
    override func initialise() {
        
        self.wantsClearIcon = false
        self.size           = .extraLarge
        self.alignment      = .center
        self.setContentHuggingPriority(.required, for: .horizontal)
        
        super.initialise()
    }
    
    override func onPasteAction(_ sender:Any?) -> Bool {
        guard let pastedString = NSPasteboard.general.string(forType: .string)?.trimWhiteSpace(),
              pastedString.count > 1 else {
            
            //Allow default handling
            return false
        }
        
        pinDelegate?.paste(sender: self, pastedString: pastedString)
        
        return true
    }
    
    public override func textDidChange(_ notification: Notification) {
        if !stringValue.isEmpty {
            
            if (stringValue.suffix(1)[0].isWholeNumber){
                self.stringValue = String(stringValue.suffix(1))
                pinDelegate?.textChanged(sender: self)
            }
            else {
                stringValue = String(stringValue.dropLast())
            }
        }
        
        super.textDidChange(notification)
    }
    
    public override var intrinsicContentSize: NSSize {
        return NSMakeSize(44, size.height)
    }
}


public protocol UTPinTextFieldDelegate : AnyObject {
    func onPinComplete(pin:String)
}

//MARK: - UTPinTextField
public class UTPinTextField : NSView, ThemeableProtocol {
    
    //MARK: - Public
    
    ///Delegate for notifying the pin has been completed
    public weak var pinDelegate:UTPinTextFieldDelegate?
    
    ///Current pin input
    public var pin:String {
        var str:String = ""
        for view in stackView.views {
            if let textField = view as? NSTextField {
                str += textField.stringValue
            }
        }
        return str
    }
    
    public var errorMessage:String = ""{
        didSet {
            errorLabel.hintString = errorMessage
        }
    }
    
    public var validationState:UTTextFieldValidationState = .noError {
        didSet {
            updateForValidationState()
        }
    }
    
    //MARK: - Private
    private var containerStackView:NSStackView!
        
    private var stackView:NSStackView!
    private var numberOfItems:Int = 6
    private var itemSpacing:Int = 8
        
    private var errorLabel:UTHintLabel!
    
    private var errorMessageTokenName:String {
        return UIToolkit.shared.isUsingLegacyTokens ? "inputText-error" : "textinput-error-text"
    }
    
    public init(numberOfItems:Int = 6, errorMessage:String) {
        if numberOfItems > 0 {
            self.numberOfItems = numberOfItems
        }
        
        self.errorMessage = errorMessage
        let width:CGFloat = CGFloat((self.numberOfItems * 44) + (self.numberOfItems * itemSpacing))
        super.init(frame: NSMakeRect(0, 0, width, UTTextFieldSize.getHeight(size:.extraLarge)))
        
        initialise()
    }
    
    override public init(frame frameRect: NSRect) {
        super.init(frame: .zero)
        initialise()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    private func initialise() {
        containerStackView = NSStackView()
        containerStackView.wantsLayer = true
        
        containerStackView.setHuggingPriority(.defaultHigh, for: .horizontal)
        containerStackView.orientation = .vertical
        containerStackView.distribution = .fillProportionally
        containerStackView.spacing = 4
        
        self.wantsLayer = true
        stackView = NSStackView()
        stackView.wantsLayer   = true
        stackView.orientation  = .horizontal
        stackView.distribution = .fillProportionally
        stackView.edgeInsets = NSEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        
        stackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        errorLabel = UTHintLabel()
        errorLabel.hintString = errorMessage
        
        self.setAsOnlySubviewAndFill(subview: containerStackView)
        containerStackView.addArrangedSubview(stackView)
        containerStackView.addArrangedSubview(errorLabel)
        
        errorLabel.isHidden = true
        
        configure()
    }
    
    //MARK: - Public API
    
    ///Update the configuration of pin items
    public func configure(numberOfItems:Int){
        if numberOfItems < 1 {
            assert(false)
            return
        }
        
        self.numberOfItems = numberOfItems
        configure()
    }
    
    ///Clear all fields
    public func clearFields() {
        for view in stackView.subviews {
            if let field = view as? UTPinTextFieldItem {
                field.stringValue = ""
            }
        }
    }
    
    public func setThemeColors() {
        stackView.setThemeableViewColors()
        errorLabel.setThemeColors()
    }
    
    //MARK: - Private API
    
    private func configure(){
        stackView.removeAllViews()
        
        for _ in 0..<numberOfItems {
            
            let pinTextField = UTPinTextFieldItem(size: .extraLarge, frame: NSMakeRect(0, 0, 44, UTTextFieldSize.getHeight(size:.extraLarge)))
            stackView.addArrangedSubview(pinTextField)
            pinTextField.pinDelegate = self
        }
    }
    
    private func isValidPasteStringCount(pastedString: String) -> Bool {
        return pastedString.count == stackView.visibleViewCount
    }
    
    private func allCharactersNumbers(pastedString: String) -> Bool {
        for character in pastedString {
            if !character.isWholeNumber {
                return false
            }
        }
        return true
    }
    
    private func updateForValidationState() {
        for view in stackView.views {
            if let textField = view as? UTTextField {
                textField.validationState = validationState
            }
        }
        
        errorLabel.isHidden = (validationState == .noError) || errorLabel.hintString.isEmpty
        errorLabel.validationState = validationState
    }
    
    private func isPinComplete() -> Bool {
        for view in stackView.views {
            if let textField = view as? UTTextField {
                if textField.stringValue.isEmpty {
                    return false
                }
            }
        }
        
        return true
    }
}

//MARK: - PinTextFieldItemDelegate
extension UTPinTextField : PinTextFieldItemDelegate{
    func paste(sender: UTTextField, pastedString: String){
        
        if isValidPasteStringCount(pastedString: pastedString),
           allCharactersNumbers(pastedString: pastedString){
            
            for i in 0..<pastedString.count {
                
                if let input = stackView.views[i] as? UTPinTextFieldItem {
                    if let index = pastedString.index(pastedString.startIndex, offsetBy: i, limitedBy: pastedString.endIndex){
                        let str = String(pastedString[index])
                        input.stringValue = str
                    }
                }
            }
            
            self.window?.makeFirstResponder(stackView.views.last)
            pinDelegate?.onPinComplete(pin: pin)
        }
    }
    
    func textChanged(sender: UTTextField){
        
        if let view = stackView.getView(after: sender) {
            self.window?.makeFirstResponder(view)
        }
        
        if isPinComplete() {
            pinDelegate?.onPinComplete(pin: pin)
        }
        
    }
    
}
