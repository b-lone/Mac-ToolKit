//
//  IconDualButton.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 26/07/2021.
//

import Foundation
import Cocoa


public protocol UTIconDualButtonDelegate : AnyObject{
    func leadingButtonClicked(sender:UTIconDualButton, button:UTButton)
    func trailingButtonClicked(sender:UTIconDualButton, button:UTButton)
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
    private let leadingIconRoundButton = UTIconRoundButton()
    lazy private var line = UTSeparatorLine(length: 16,direction: .vertical, token: borderToken, lineWidth: 1.0)
    private let trailingIconRoundButton = UTIconRoundButton()
    
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
            leadingIconRoundButton.style = style
            trailingIconRoundButton.style = style
        }
    }
    
    public var leadingButton: UTButton? {
        return leadingIconRoundButton
    }
    
    public var trailingButton: UTButton? {
        return trailingIconRoundButton
    }
    
    public func addLeadingDetails(accessibilityLabel:String, icon:MomentumIconsRebrandType ) {
        leadingIconRoundButton.fontIcon = icon
        leadingIconRoundButton.setAccessibilityLabel(accessibilityLabel)
    }
    
    public func addTrailingDetails(accessibilityLabel:String, icon:MomentumIconsRebrandType ) {
        trailingIconRoundButton.fontIcon = icon
        trailingIconRoundButton.setAccessibilityLabel(accessibilityLabel)
    }
    
    override func initialise() {
        super.initialise()
        self.wantsLayer = true
        self.layer?.borderWidth = 1
        self.layer?.cornerRadius = bounds.height/2
        self.translatesAutoresizingMaskIntoConstraints = false
        
        leadingIconRoundButton.translatesAutoresizingMaskIntoConstraints = false
        leadingIconRoundButton.buttonHeight = .extrasmall
        self.addSubview(leadingIconRoundButton)
        super.popoverBehavior = .semitransient
        line.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(line)
        trailingIconRoundButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(trailingIconRoundButton)
        
        layoutButtons()
        leadingIconRoundButton.target = self
        leadingIconRoundButton.action = #selector(UTIconDualButton.leadingButtonClicked)
        
        trailingIconRoundButton.target = self
        trailingIconRoundButton.action = #selector(UTIconDualButton.trailingButtonClicked)
        setThemeColors()
    }
    
    @objc
    private func leadingButtonClicked() {
        removeToolTip()
        delegate?.leadingButtonClicked(sender: self, button: leadingIconRoundButton)
    }
    
    @objc
    private func trailingButtonClicked() {
        removeToolTip()
        delegate?.trailingButtonClicked(sender: self, button: trailingIconRoundButton)
    }
        
    private func layoutButtons() {
        
        let buttonLineSpacing:CGFloat = 4
        //add line to middle of component, this is anchor point buttons
        self.centerXAnchor.constraint(equalTo: line.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: line.centerYAnchor).isActive = true
        
        self.line.leadingAnchor.constraint(equalTo: leadingIconRoundButton.trailingAnchor, constant: buttonLineSpacing).isActive = true
        self.centerYAnchor.constraint(equalTo: leadingIconRoundButton.centerYAnchor).isActive = true
    
        self.trailingIconRoundButton.leadingAnchor.constraint(equalTo: line.trailingAnchor, constant: buttonLineSpacing).isActive = true
        self.centerYAnchor.constraint(equalTo: trailingIconRoundButton.centerYAnchor).isActive = true
    }
    
    public override func setThemeColors() {
        leadingIconRoundButton.setThemeColors()
        trailingIconRoundButton.setThemeColors()
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
    func leadingButtonClicked(sender:UTIconDualWithTitleButton, button:UTButton)
    func trailingButtonClicked(sender:UTIconDualWithTitleButton, button:UTButton)
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
    private let leadingIconRoundButton = UTIconRoundButton()
    lazy private var line1 = UTSeparatorLine(length: 16,direction: .vertical, token: borderToken, lineWidth: 1.0)
    private let midButton = UTSquareButton()
    lazy private var line2 = UTSeparatorLine(length: 16,direction: .vertical, token: borderToken, lineWidth: 1.0)
    private let trailingIconRoundButton = UTIconRoundButton()

    public enum Size : CGFloat {
        case medium
        case small
    }

    public enum UTIconDualWithTitleButtonPosition {
        case leading
        case middle
        case trailing
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
            leadingIconRoundButton.style = style
            trailingIconRoundButton.style = style
            midButton.style = style
        }
    }

    public func addLeadingDetails(accessibilityLabel:String, icon:MomentumIconsRebrandType ) {
        leadingIconRoundButton.fontIcon = icon
        leadingIconRoundButton.setAccessibilityLabel(accessibilityLabel)
    }

    public func addTrailingDetails(accessibilityLabel:String, icon:MomentumIconsRebrandType ) {
        trailingIconRoundButton.fontIcon = icon
        trailingIconRoundButton.setAccessibilityLabel(accessibilityLabel)
    }
    
    public func addMiddleDetails(accessibilityLabel:String, title:String) {
        midButton.setAccessibilityLabel(accessibilityLabel)
        midButton.title = title
        invalidateIntrinsicContentSize()
    }
    
    public func enable(at position: UTIconDualWithTitleButtonPosition, enable: Bool) {
        switch position {
        case .leading:
            leadingIconRoundButton.isEnabled = enable
        case .trailing:
            trailingIconRoundButton.isEnabled = enable
        case .middle:
            midButton.isEnabled = enable
        }
    }
    
    public var leadingButton: UTButton? {
        return leadingIconRoundButton
    }
    
    public var middleButton: UTButton? {
        return midButton
    }
    
    public var trailingButton: UTButton? {
        return trailingIconRoundButton
    }

    override func initialise() {
        super.initialise()
        super.popoverBehavior = .semitransient
        
        self.wantsLayer = true
        self.layer?.borderWidth = 1
        self.layer?.cornerRadius = bounds.height/2
        self.translatesAutoresizingMaskIntoConstraints = false
        
        leadingIconRoundButton.translatesAutoresizingMaskIntoConstraints = false
        line1.translatesAutoresizingMaskIntoConstraints = false
        midButton.translatesAutoresizingMaskIntoConstraints = false
        line2.translatesAutoresizingMaskIntoConstraints = false
        trailingIconRoundButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(leadingIconRoundButton)
        self.addSubview(line1)
        self.addSubview(midButton)
        self.addSubview(line2)
        self.addSubview(trailingIconRoundButton)
        
        layoutButtons()
        leadingIconRoundButton.target = self
        leadingIconRoundButton.action = #selector(UTIconDualWithTitleButton.leadingButtonClicked)
        
        trailingIconRoundButton.target = self
        trailingIconRoundButton.action = #selector(UTIconDualWithTitleButton.trailingButtonClicked)
        
        midButton.target = self
        midButton.action = #selector(UTIconDualWithTitleButton.middleClicked)
        
        setThemeColors()
    }

    @objc
    private func leadingButtonClicked() {
        removeToolTip()
        delegate?.leadingButtonClicked(sender: self, button: leadingIconRoundButton)
    }

    @objc
    private func trailingButtonClicked() {
        removeToolTip()
        delegate?.trailingButtonClicked(sender: self, button: trailingIconRoundButton)
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
        self.centerYAnchor.constraint(equalTo: leadingIconRoundButton.centerYAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: trailingIconRoundButton.centerYAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: midButton.centerYAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: midButton.centerXAnchor).isActive = true
        
        self.line1.leadingAnchor.constraint(equalTo: leadingIconRoundButton.trailingAnchor, constant: buttonLineSpacing).isActive = true
        self.midButton.leadingAnchor.constraint(equalTo: line1.trailingAnchor, constant: buttonLineSpacing).isActive = true
        self.line2.leadingAnchor.constraint(equalTo: midButton.trailingAnchor, constant: buttonLineSpacing).isActive = true
        self.trailingIconRoundButton.leadingAnchor.constraint(equalTo: line2.trailingAnchor, constant: buttonLineSpacing).isActive = true
    }

    public override func setThemeColors() {
        leadingIconRoundButton.setThemeColors()
        trailingIconRoundButton.setThemeColors()
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
            let leadingTrailingButtonsWidth: CGFloat = 64
            let totalWidth = middleBtnWidth + leadingTrailingButtonsWidth + middleButtonPadding
            return NSSize(width: totalWidth, height: 32)
        case .small:
            let leadingTrailingButtonsWidth: CGFloat = 60
            let totalWidth = middleBtnWidth + leadingTrailingButtonsWidth + middleButtonPadding
            return NSSize(width: totalWidth, height: 28)
        }
    }
}

#if DEBUG
extension UTIconDualWithTitleButton {
    public func getLeadingButton() -> UTButton? {
        return leadingIconRoundButton
    }
    public func getTrailingButton() -> UTButton? {
        return trailingIconRoundButton
    }
    public func getMiddleButton() -> UTButton? {
        return middleButton
    }
}
#endif
