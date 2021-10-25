//
//  UTSplitButtonControl.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 19/07/2021.
//

import Cocoa

public protocol UTDualButtonDelegate : AnyObject{
    func lhsButtonClicked(sender:UTDualButton, button:UTButton)
    func rhsButtonCLicked(sender:UTDualButton, button:UTButton)
}

public class UTDualButton: UTHoverableView {
    
    public weak var delegate:UTDualButtonDelegate?
    public var buttonHeight: ButtonHeight = .medium {
        didSet {
            lhsButton.buttonHeight = buttonHeight
            rhsButton.buttonHeight = buttonHeight
        }
    }
    
    public var style: UTButton.Style = .primary {
        didSet {
            lhsButton.style = style
            rhsButton.style = style
        }
    }

    private var containerStackView:NSStackView!
    private var lhsButton:UTSplitButton!
    private var rhsButton:UTSplitButton!
        
    override func initialise() {
        super.popoverBehavior = .semitransient
        self.wantsLayer = true
        let currentBounds = self.bounds
        self.translatesAutoresizingMaskIntoConstraints = false
        let newRect = NSRect(x: 0, y: 0, width: currentBounds.width, height: 32)
        containerStackView = NSStackView(frame: newRect)
        containerStackView.wantsLayer = true
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.orientation  = .horizontal
        containerStackView.distribution = .gravityAreas
        containerStackView.spacing      = -1
        self.setAsOnlySubviewAndFill(subview: containerStackView)

        
        lhsButton = UTLeftSplitButton()
        rhsButton = UTRightSplitButton()
        rhsButton.fontIconSize = 14
        
        containerStackView.addView(lhsButton, in: .leading)
        containerStackView.addView(rhsButton, in: .leading)
        
        lhsButton.target = self
        lhsButton.action = #selector(UTDualButton.lhsClicked)
        
        rhsButton.target = self
        rhsButton.action = #selector(UTDualButton.rhsClicked)
        
        rhsButton.style = .secondary
        lhsButton.style = .secondary
    
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

    
    public func addLHSDetails(label:String,accessibilityLabel:String, iconType:MomentumRebrandIconType? = nil, tooltip: UTTooltipType? = nil) {
        if !label.isEmpty {
            lhsButton.title = label
        }
        if let icon = iconType {
            lhsButton.fontIcon = icon
            lhsButton.setAccessibilityLabel(accessibilityLabel)
        }
        if let tooltip = tooltip {
            lhsButton.addUTToolTip(toolTip: tooltip)
        }
    }
    
    public func addRHSDetails(accessibilityLabel:String, iconType:MomentumRebrandIconType? = nil, tooltip: UTTooltipType? = nil) {
        if let icon = iconType {
            rhsButton.fontIcon = icon
            rhsButton.setAccessibilityLabel(accessibilityLabel)
        }
        if let tooltip = tooltip {
            rhsButton.addUTToolTip(toolTip: tooltip)
        }
    }
    
    public func toggleLHSState(_ state: NSControl.StateValue) {
        lhsButton.state = state
    }
    
    public func toggleRHSState(_ state: NSControl.StateValue) {
        rhsButton.state = state
    }
    
    public override func setThemeColors() {
        lhsButton.setThemeColors()
        rhsButton.setThemeColors()
        self.needsDisplay = true
    }
    

    public override var intrinsicContentSize: NSSize{
        let height = lhsButton.intrinsicContentSize.height + rhsButton.intrinsicContentSize.height
        let width = lhsButton.intrinsicContentSize.width + rhsButton.intrinsicContentSize.width
        return NSSize(width: width, height: height)
    }


}
