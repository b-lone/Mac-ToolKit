//
//  UTSplitButtonControl.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 19/07/2021.
//

import Cocoa

public protocol UTDualButtonDelegate : AnyObject{
    func leadingButtonClicked(sender:UTDualButton, button:UTButton)
    func trailingButtonClicked(sender:UTDualButton, button:UTButton)
}

public class UTDualButton: UTHoverableView {
    
    public weak var delegate:UTDualButtonDelegate?
    public var buttonHeight: ButtonHeight = .medium {
        didSet {
            leadingButton.buttonHeight = buttonHeight
            trailingButton.buttonHeight = buttonHeight
        }
    }
    
    public var style: UTButton.Style = .primary {
        didSet {
            leadingButton.style = style
            trailingButton.style = style
        }
    }
    
    public var shouldExcludeTooltipsInShare = false {
        didSet {
            leadingButton.shouldExcludeTooltipsInShare = shouldExcludeTooltipsInShare
            trailingButton.shouldExcludeTooltipsInShare = shouldExcludeTooltipsInShare
        }
    }

    private var containerStackView:NSStackView!
    private var leadingButton:UTSplitButton!
    private var trailingButton:UTSplitButton!
        
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

        
        leadingButton = UTLeadingSplitButton()
        trailingButton = UTTrailingSplitButton()
        trailingButton.fontIconSize = 14
        
        containerStackView.addView(leadingButton, in: .leading)
        containerStackView.addView(trailingButton, in: .leading)
        
        leadingButton.target = self
        leadingButton.action = #selector(UTDualButton.leadingButtonClicked)
        
        trailingButton.target = self
        trailingButton.action = #selector(UTDualButton.trailingButtonClicked)
        
        trailingButton.style = .secondary
        leadingButton.style = .secondary
    
    }
    
    @objc
    private func leadingButtonClicked() {
        removeToolTip()
        delegate?.leadingButtonClicked(sender: self, button: leadingButton)
    }
    
    @objc
    private func trailingButtonClicked() {
        removeToolTip()
        delegate?.trailingButtonClicked(sender: self, button: trailingButton)
    }

    
    public func addLeadingDetails(label:String,accessibilityLabel:String, iconType:MomentumIconsRebrandType? = nil, tooltip: UTTooltipType? = nil) {
        if !label.isEmpty {
            leadingButton.title = label
        }
        if let icon = iconType {
            leadingButton.fontIcon = icon
            leadingButton.setAccessibilityLabel(accessibilityLabel)
        }
        if let tooltip = tooltip {
            leadingButton.addUTToolTip(toolTip: tooltip)
        }
    }
    
    public func addTrailingDetails(accessibilityLabel:String, iconType:MomentumIconsRebrandType? = nil, tooltip: UTTooltipType? = nil) {
        if let icon = iconType {
            trailingButton.fontIcon = icon
            trailingButton.setAccessibilityLabel(accessibilityLabel)
        }
        if let tooltip = tooltip {
            trailingButton.addUTToolTip(toolTip: tooltip)
        }
    }
    
    public func toggleLeadingState(_ state: NSControl.StateValue) {
        leadingButton.state = state
        setThemeColors()
    }
    
    public func toggleTrailingState(_ state: NSControl.StateValue) {
        trailingButton.state = state
        setThemeColors()
    }
    
    public override func setThemeColors() {
        leadingButton.setThemeColors()
        trailingButton.setThemeColors()
        self.needsDisplay = true
    }
    

    public override var intrinsicContentSize: NSSize{
        let height = leadingButton.intrinsicContentSize.height + trailingButton.intrinsicContentSize.height
        let width = leadingButton.intrinsicContentSize.width + trailingButton.intrinsicContentSize.width
        return NSSize(width: width, height: height)
    }


}
