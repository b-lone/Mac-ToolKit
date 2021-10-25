//
//  IconDualButton.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 26/07/2021.
//

import Foundation
import Cocoa


public protocol UTIconDualButtonDelegate : AnyObject{
    func lhsButtonClicked(sender:UTIconDualButton, button:UTButton)
    func rhsButtonCLicked(sender:UTIconDualButton, button:UTButton)
}


public class UTIconDualButton: UTHoverableView {
    
    class UTIconRoundButton: UTRoundButton {
        
        override func initialise() {
            super.initialise()
            self.buttonHeight = .extrasmall
            self.style = .ghost
        }

        override func toCGFloat(height: ButtonHeight) -> CGFloat {
            return 24
        }
    }
    
    
    public weak var delegate:UTIconDualButtonDelegate?
    private let borderToken =  UTColorTokens.buttonSecondaryBorder
    private let lhsButton = UTIconRoundButton()
    lazy private var line = UTSeparatorLine(length: 16,direction: .vertical, token: borderToken, lineWidth: 1.0)
    private let rhsButton = UTIconRoundButton()
    
    public enum Size : CGFloat {
        case medium
        case small
        
        func toNSSize() -> NSSize {
            switch self {
            case .medium:
                return NSSize(width: 64, height: 32)
            case .small:
                return NSSize(width: 60, height: 28)
            }
        }
    }
    
    
    public var size: Size = . small {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    public var style: UTButton.Style = .primary {
        didSet {
            lhsButton.style = style
            rhsButton.style = style
        }
    }
    
    public func addLHSDetails(accessibilityLabel:String, icon:MomentumRebrandIconType ) {
        lhsButton.fontIcon = icon
        rhsButton.setAccessibilityLabel(accessibilityLabel)
    }
    
    public func addRHSDetails(accessibilityLabel:String, icon:MomentumRebrandIconType ) {
        rhsButton.fontIcon = icon
        rhsButton.setAccessibilityLabel(accessibilityLabel)
    }
    
    override func initialise() {
        super.initialise()
        self.wantsLayer = true
        self.layer?.borderWidth = 1
        self.layer?.cornerRadius = bounds.height/2
        self.translatesAutoresizingMaskIntoConstraints = false
        
        lhsButton.translatesAutoresizingMaskIntoConstraints = false
        lhsButton.buttonHeight = .extrasmall
        self.addSubview(lhsButton)
        super.popoverBehavior = .semitransient
        line.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(line)
        rhsButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rhsButton)
        
        layoutButtons()
        lhsButton.target = self
        lhsButton.action = #selector(UTIconDualButton.lhsClicked)
        
        rhsButton.target = self
        rhsButton.action = #selector(UTIconDualButton.rhsClicked)
        setThemeColors()
    }
    
    @objc
    private func lhsClicked() {
        removeToolTip()
        delegate?.lhsButtonClicked(sender: self, button: lhsButton)
    }
    
    @objc
    private func rhsClicked() {
        removeToolTip()
        delegate?.rhsButtonCLicked(sender: self, button: rhsButton)
    }
        
    private func layoutButtons() {
        
        let buttonLineSpacing:CGFloat = 4
        //add line to middle of component, this is anchor point buttons
        self.centerXAnchor.constraint(equalTo: line.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: line.centerYAnchor).isActive = true
        
        self.line.leadingAnchor.constraint(equalTo: lhsButton.trailingAnchor, constant: buttonLineSpacing).isActive = true
        self.centerYAnchor.constraint(equalTo: lhsButton.centerYAnchor).isActive = true
    
        self.rhsButton.leadingAnchor.constraint(equalTo: line.trailingAnchor, constant: buttonLineSpacing).isActive = true
        self.centerYAnchor.constraint(equalTo: rhsButton.centerYAnchor).isActive = true
 
    }
    
    public override func setThemeColors() {
        lhsButton.setThemeColors()
        rhsButton.setThemeColors()
        line.setThemeColors()
        self.layer?.borderColor = borderColors.normal.cgColor
    }
    
    var borderColors:UTColorStates{
        return UIToolkit.shared.getThemeManager().getColors(tokenName: borderToken.rawValue)
    }
    
    
    public override var intrinsicContentSize: NSSize{
        return size.toNSSize()
    }
    
}
