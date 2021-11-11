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

internal class UTIconRoundButton: UTRoundButton {
    override func initialise() {
        super.initialise()
        self.buttonHeight = .extrasmall
        self.style = .ghost
    }

    override func toCGFloat(height: ButtonHeight) -> CGFloat {
        return 24
    }
}

public class UTIconDualButton: UTHoverableView {
    
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
    
    public var rightButton: UTButton? {
        return rhsButton
    }
    
    public var leftButton: UTButton? {
        return lhsButton
    }
    
    public func addLHSDetails(accessibilityLabel:String, icon:MomentumRebrandIconType ) {
        lhsButton.fontIcon = icon
        lhsButton.setAccessibilityLabel(accessibilityLabel)
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

public protocol UTIconDualButtonWithTitleDelegate : AnyObject{
    func lhsButtonClicked(sender:UTIconDualWithTitleButton, button:UTButton)
    func rhsButtonCLicked(sender:UTIconDualWithTitleButton, button:UTButton)
    func middleButtonCLicked(sender:UTIconDualWithTitleButton, button:UTButton)
}

public class UTIconDualWithTitleButton: UTHoverableView {

    class UTSquareButton : UTButton {
        override func initialise(){
            super.initialise()
            super.style = .ghost
            super.buttonType = .square
        }
        
        override func toCGFloat(height: ButtonHeight) -> CGFloat {
            switch height {
            case .small:
                return 28
            case .medium:
                return 32
            default:
                assert(false, "height not supported for UTSquareButton")
                return 32
            }
        }
    }
    
    public weak var delegate:UTIconDualButtonWithTitleDelegate?
    private let borderToken =  UTColorTokens.buttonSecondaryBorder
    private let lhsButton = UTIconRoundButton()
    lazy private var line1 = UTSeparatorLine(length: 16,direction: .vertical, token: borderToken, lineWidth: 1.0)
    private let midButton = UTSquareButton()
    lazy private var line2 = UTSeparatorLine(length: 16,direction: .vertical, token: borderToken, lineWidth: 1.0)
    private let rhsButton = UTIconRoundButton()

    public enum Size : CGFloat {
        case medium
        case small
    }

    public enum UTIconDualWithTitleButtonPosition {
        case lhs
        case middle
        case rhs
    }
    
    public var size: Size = .small {
        didSet {
            switch size {
            case .medium:
                midButton.buttonHeight = .medium
            case .small:
                midButton.buttonHeight = .small
            }
            invalidateIntrinsicContentSize()
        }
    }
    public var style: UTButton.Style = .primary {
        didSet {
            lhsButton.style = style
            rhsButton.style = style
            midButton.style = style
        }
    }

    public func addLHSDetails(accessibilityLabel:String, icon:MomentumRebrandIconType ) {
        lhsButton.fontIcon = icon
        lhsButton.setAccessibilityLabel(accessibilityLabel)
    }

    public func addRHSDetails(accessibilityLabel:String, icon:MomentumRebrandIconType ) {
        rhsButton.fontIcon = icon
        rhsButton.setAccessibilityLabel(accessibilityLabel)
    }
    
    public func addMiddleDetails(accessibilityLabel:String, title:String) {
        midButton.setAccessibilityLabel(accessibilityLabel)
        midButton.title = title
        invalidateIntrinsicContentSize()
    }
    
    public func enable(at position: UTIconDualWithTitleButtonPosition, enable: Bool) {
        switch position {
        case .lhs:
            lhsButton.isEnabled = enable
        case .rhs:
            rhsButton.isEnabled = enable
        case .middle:
            midButton.isEnabled = enable
        }
    }
    
    public var rightButton: UTButton? {
        return rhsButton
    }
    
    public var leftButton: UTButton? {
        return lhsButton
    }
    
    public var middleButton: UTButton? {
        return midButton
    }

    override func initialise() {
        super.initialise()
        super.popoverBehavior = .semitransient
        
        self.wantsLayer = true
        self.layer?.borderWidth = 1
        self.layer?.cornerRadius = bounds.height/2
        self.translatesAutoresizingMaskIntoConstraints = false
        
        lhsButton.translatesAutoresizingMaskIntoConstraints = false
        line1.translatesAutoresizingMaskIntoConstraints = false
        midButton.translatesAutoresizingMaskIntoConstraints = false
        line2.translatesAutoresizingMaskIntoConstraints = false
        rhsButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(lhsButton)
        self.addSubview(line1)
        self.addSubview(midButton)
        self.addSubview(line2)
        self.addSubview(rhsButton)
        
        layoutButtons()
        lhsButton.target = self
        lhsButton.action = #selector(UTIconDualWithTitleButton.lhsClicked)
        
        rhsButton.target = self
        rhsButton.action = #selector(UTIconDualWithTitleButton.rhsClicked)
        
        midButton.target = self
        midButton.action = #selector(UTIconDualWithTitleButton.middleClicked)
        
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
    
    @objc
    private func middleClicked() {
        removeToolTip()
        delegate?.middleButtonCLicked(sender: self, button: midButton)
    }
        
    private func layoutButtons() {
        let buttonLineSpacing:CGFloat = 4

        self.centerYAnchor.constraint(equalTo: line1.centerYAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: line2.centerYAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: lhsButton.centerYAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: rhsButton.centerYAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: midButton.centerYAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: midButton.centerXAnchor).isActive = true
        
        self.line1.leadingAnchor.constraint(equalTo: lhsButton.trailingAnchor, constant: buttonLineSpacing).isActive = true
        self.midButton.leadingAnchor.constraint(equalTo: line1.trailingAnchor, constant: buttonLineSpacing).isActive = true
        self.line2.leadingAnchor.constraint(equalTo: midButton.trailingAnchor, constant: buttonLineSpacing).isActive = true
        self.rhsButton.leadingAnchor.constraint(equalTo: line2.trailingAnchor, constant: buttonLineSpacing).isActive = true
    }

    public override func setThemeColors() {
        lhsButton.setThemeColors()
        rhsButton.setThemeColors()
        line1.setThemeColors()
        line2.setThemeColors()
        midButton.setThemeColors()
        self.layer?.borderColor = borderColors.normal.cgColor
    }

    var borderColors:UTColorStates {
        return UIToolkit.shared.getThemeManager().getColors(tokenName: borderToken.rawValue)
    }

    public override var intrinsicContentSize: NSSize {
        let middleBtnWidth = midButton.intrinsicContentSize.width
        let middleButtonPadding: CGFloat = 8
        switch size {
        case .medium:
            let leftRightButtonsWidth: CGFloat = 64
            let totalWidth = middleBtnWidth + leftRightButtonsWidth + middleButtonPadding
            return NSSize(width: totalWidth, height: 32)
        case .small:
            let leftRightButtonsWidth: CGFloat = 60
            let totalWidth = middleBtnWidth + leftRightButtonsWidth + middleButtonPadding
            return NSSize(width: totalWidth, height: 28)
        }
    }
}

#if DEBUG
extension UTIconDualWithTitleButton {
    public func getLhsButton() -> UTButton? {
        return lhsButton
    }
    public func getRhsButton() -> UTButton? {
        return rhsButton
    }
    public func getMiddleButton() -> UTButton? {
        return middleButton
    }
}
#endif
