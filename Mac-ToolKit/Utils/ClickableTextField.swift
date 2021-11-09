//
//  ClickableTextField.swift
//  SparkMacDesktop
//
//  Created by joe leonard on 8/06/2016.
//  Copyright © 2016 Cisco Systems. All rights reserved.
//

import Cocoa
import Carbon.HIToolbox

protocol ClickableTextFieldDelegate: AnyObject {
    func mouseDown()
}

@objc class ClickableTextField: NSTextField {

    weak var clickableTextFieldDelegate: ClickableTextFieldDelegate?
    var isClickableTextFieldAccessibility = false
    var canAcceptFirstResponder = true
    var cursorType = NSCursor.iBeam

    func setElementAccessible(isAccessibile: Bool){
        isClickableTextFieldAccessibility = isAccessibile
    }

    func setCursorType(cursor: NSCursor){
        cursorType = cursor
        resetCursorRects()
    }

    func setCanAcceptFirstResponder(acceptFirstResponder: Bool){
        canAcceptFirstResponder = acceptFirstResponder
    }

    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        clickableTextFieldDelegate?.mouseDown()
    }
    
    override func resetCursorRects() {
        self.addCursorRect(self.bounds, cursor: cursorType)
    }
    
    override var acceptsFirstResponder: Bool{
        return canAcceptFirstResponder
    }
    
    override var canBecomeKeyView: Bool{
        return self.isHidden == false
    }
    
    override func drawFocusRingMask() {
        self.bounds.fill()
    }
    
    override var focusRingMaskBounds: NSRect {
        return self.bounds
    }
    
    override func keyDown(with event: NSEvent) {
        let keyCode:Int = Int(event.keyCode)
        if keyCode == kVK_Space {
            clickableTextFieldDelegate?.mouseDown()
        }
        else {
            super.keyDown(with: event)
        }
    }

    override func isAccessibilityElement() -> Bool {
        return isClickableTextFieldAccessibility
    }
}

protocol CustomToolTipsClickableTextFieldDelegate: AnyObject {
    func getTooltip() -> String
}

class CustomToolTipsClickableTextFieldTooltip: NSViewController {
    var tooltip = "" {
        didSet {
            updateTooltip()
        }
    }
    
    private var label: NSTextField = {
        let label = NSTextField(string: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: 260).isActive = true
        label.widthAnchor.constraint(lessThanOrEqualToConstant: 400).isActive = true
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.isEditable = false
        label.backgroundColor = .clear
        label.isBordered = false
        label.lineBreakMode = .byWordWrapping
        label.setAccessibilityRole(.button)
        return label
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view = PopoverView()
        viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.addSubview(label)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if let popoverView = view as? PopoverView {
            popoverView.color =  .black
        }
        
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
    }
   
    private func updateTooltip() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 16
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .left
        
        let attributedString = NSMutableAttributedString(string: tooltip, attributes: [
            .paragraphStyle: paragraphStyle,
            .foregroundColor: NSColor.white,
            .font: NSFont.systemFont(ofSize: 16)
        ])
        
        label.attributedStringValue = attributedString
    }
}

class CustomToolTipsClickableTextField: ClickableTextField {
    var customTooltip = ""
    private var toastPopover: NSPopover?
    private var customTooltipsController: CustomToolTipsClickableTextFieldTooltip?
    var shouldHigherCustomTooltipsWindowLevel = false
    var shouldExcludeTooltipsInShare = false
    
    private var trackingArea: NSTrackingArea? = nil
    
    weak var tooltipDelegate: CustomToolTipsClickableTextFieldDelegate?
    
    private func hideTooltip() {
        if let toastPopover = toastPopover, toastPopover.isShown {
            toastPopover.close()
        }
    }
    
    func showTooltip() {
        hideTooltip()
        guard !customTooltip.isEmpty else { return }
        var tooltip = customTooltip
        if let delegate = tooltipDelegate {
            tooltip = delegate.getTooltip()
        }
        customTooltipsController = CustomToolTipsClickableTextFieldTooltip()
        customTooltipsController?.tooltip = tooltip

        if let customTooltipsController = customTooltipsController {
            toastPopover = SparkPopoverBuilder().createInCallTooltipPopover(contentViewController: customTooltipsController, sender: self, bounds: self.bounds, preferredEdge: .minY)
            if let window = toastPopover?.contentViewController?.view.window {
                if shouldExcludeTooltipsInShare {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: OnShareShouldExcludeWindow), object: self, userInfo: ["windowNumber" : window.windowNumber])
                }
                if shouldHigherCustomTooltipsWindowLevel {
                    window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.popUpMenuWindow)) + 2)
                }
            }
        }
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        if let _ = trackingArea {
            removeTrackingArea(trackingArea!)
        }
        
        trackingArea = NSTrackingArea(rect: bounds,
                                      options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways],
                                      owner:self,
                                      userInfo:nil);
        addTrackingArea(trackingArea!)
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        showTooltip()
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        hideTooltip()
    }
}


