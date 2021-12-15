//
//  UTPasswordTextField.swift
//  UIToolkit
//
//  Created by James Nestor on 26/07/2021.
//

import Cocoa

public class UTPasswordTextField: UTTextField {
    
    var passwordButton = UTIconButton()

    public var showPassword: Bool = false {
        didSet{
            if oldValue != showPassword {
                initCell()
                
                self.wantsLayer = true
                self.drawsBackground = false
                self.isBordered = false
                self.layer?.borderWidth = 1
                self.layer?.cornerRadius = 8
                self.maximumNumberOfLines = 1
                                
                self.setThemeColors()
                self.setFont()
            }
        }
    }
    
    override public var nextKeyView: NSView? {
        didSet{
            passwordButton.nextKeyView = nextKeyView
            super.nextKeyView = passwordButton            
        }
    }
    
    override func initialise() {
        
        self.wantsClearIcon = false
        self.size           = .large
        
        super.initialise()
        
        setupShowPasswordIcon()
    }
    
    override internal func initCell(){        
        if showPassword {
            self.cell = UTTextFieldCell(with: self)
        }
        else {
            self.cell = UTSecureTextFieldCell(with: self)
        }
    }
    
    private func setupShowPasswordIcon(){
        
        passwordButton.icon = .password
        passwordButton.fontIconSize = 16
        passwordButton.buttonType = .round
        passwordButton.buttonHeight = .extrasmall
        passwordButton.initialise()
        
        passwordButton.target   = self
        passwordButton.action   = #selector(UTPasswordTextField.toggleShowPassword)
        passwordButton.isHidden = false
        passwordButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(passwordButton)
    
        let wConstraint             = NSLayoutConstraint.createWidthConstraint(firstItem: passwordButton, constant: passwordButton.heightFloat)
        let hConstraint             = NSLayoutConstraint.createHeightConstraint(firstItem: passwordButton, constant: passwordButton.heightFloat)
        let verticalConstraint      = NSLayoutConstraint(item: passwordButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let clearTrailingConstraint = NSLayoutConstraint(item: passwordButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -8)

        NSLayoutConstraint.activate([wConstraint, hConstraint, verticalConstraint, clearTrailingConstraint])
    }
    
    @IBAction public func toggleShowPassword(_ sender: AnyObject) {
        showPassword = !showPassword
                
        self.setFocusWithCursorAtEnd()
        isFocused = true
    }
    
    public override func textDidBeginEditing(_ notification: Notification) {
        super.textDidBeginEditing(notification)
        isFocused = true
    }

    public override func textDidEndEditing(_ notification: Notification) {
        super.textDidEndEditing(notification)
        isFocused = false
    }
    
    override internal func updateTrailingCellPadding(){}
    
    public override func resetCursorRects() {
        discardCursorRects()
        
        addCursorRect(NSMakeRect(self.bounds.maxX - UTTextFieldCellTrailingIconPadding, self.bounds.minY, UTTextFieldCellTrailingIconPadding, self.bounds.height), cursor: .arrow)
        addCursorRect(NSMakeRect(self.bounds.minX, self.bounds.minY, self.bounds.width - UTTextFieldCellTrailingIconPadding, self.bounds.height), cursor: .iBeam)
    }
    
    public override func setThemeColors() {
        super.setThemeColors()
        passwordButton.setThemeColors()
    }
}
