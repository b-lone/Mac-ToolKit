//
//  SparkTextField.swift
//  SparkMacDesktop
//
//  Created by James Nestor on 20/09/2015.
//  Copyright © 2015 Cisco Systems. All rights reserved.
//

import Cocoa
import UIToolkit

protocol SparkTextFieldDelegate: AnyObject  {
    func onFocusStateChanged(_ sparkTextField: SparkTextField, hasFocus: Bool)
}

class SparkTextField: FocusTextField {
  
    weak var sparkTextFieldDelegate: SparkTextFieldDelegate?
    var trackingArea:NSTrackingArea!
    
    fileprivate var drawsBackgroundOnHover: Bool = false
    private (set) var isMouseEntered = false
    override var isFocused:Bool{
        didSet{
            if isFocused != oldValue{
                updateBackgroundColor()
                updateBorderColor()
                sparkTextFieldDelegate?.onFocusStateChanged(self, hasFocus: isFocused)
            }
        }
    }
    
    @IBInspectable var shouldIgnoreTransparentTheme:Bool = false{
        didSet{
            updateStyle()
        }
    }
    
    @IBInspectable var passThroughMouseEvent:Bool = false
    
    @IBInspectable var hoverColor:NSColor!{
        didSet {
            self.drawsBackgroundOnHover = true
        }
    }
    
    @IBInspectable var borderColor:NSColor!{
        didSet{
            self.wantsLayer = true
            self.layer?.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderColorActive:NSColor?
    
    @IBInspectable var cornerRadius:String!{
        didSet{
            self.wantsLayer = true
            if let c = cornerRadius{
                self.layer?.cornerRadius = CGFloat(Int(c) ?? 0)
            }
        }
    }
    
    @IBInspectable var borderWidth:String!{
        didSet{
            self.wantsLayer = true
            if let c = borderWidth{
                self.layer?.borderWidth = CGFloat(Int(c) ?? 0)
            }
        }
    }
    
    @IBInspectable var bgColor:NSColor!{
        didSet{
            self.wantsLayer = true
            if let bgColor = bgColor{
                self.layer?.backgroundColor = bgColor.cgColor
            }
        }
    }
    
    @IBInspectable var bgFocusedColor:NSColor?
    
    @IBInspectable var cursorColor: NSColor!{
        didSet{
            updateCursorColor()
        }
    }

    /*
     isPrimaryText - Allow the xib to set primary text to be the higher contrast black/white depending on the theme
     without needing to make an IBOutlet. ONLY use this for default text colors, not specialized UI components. Only generic black/greys for common usage.
     Ideally this would be an enum, but IBInspectable does not support enums
     value:
        1 (primary text): black/white text
        2 (secondary text): lighter grey contrast. What you'd see in a settings page as description text
     */
    @IBInspectable var themedTextColorIndex: Int = -1 {
        didSet {
            switch themedTextColorIndex {
            case 1:
                textColor = SemanticThemeManager.getColors(for: .textPrimary).normal
            case 2:
                textColor = .black
            default:
                // up to the consumer to setup other class variables to set the font/text color
                break
            }
        }
    }
    
    var customTooltip = "" {
        didSet {
            if !customTooltip.isEmpty {
                drawsBackgroundOnHover = true
                toolTip = nil
            }
        }
    }
    var customAttributedTooltip: NSAttributedString? {
        didSet {
            if customAttributedTooltip != nil {
                drawsBackgroundOnHover = true
                toolTip = nil
            }
        }
    }
    private var tooltipPopover: NSPopover?
//    private var customTooltipsController: CallViewCustomTooltipsViewController?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
    }
    
    func initialise(){
        self.wantsLayer = true        
    }
    
    deinit{
        if let _ = trackingArea{
            self.removeTrackingArea(trackingArea)
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)        
    }
    
    override func mouseEntered(with theEvent: NSEvent) {
        isMouseEntered = true
        updateBackgroundColor()
        
        if !customTooltip.isEmpty || customAttributedTooltip != nil {
            showTooltip()
        }
    }
    
    override func mouseExited(with theEvent: NSEvent) {
        isMouseEntered = false
        updateBackgroundColor()
        
        hideTooltip()
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        if !drawsBackgroundOnHover {
            return
        }
        
        if trackingArea == nil{
            trackingArea = NSTrackingArea(rect: NSZeroRect,
                                          options: [.inVisibleRect,
                                                    .activeAlways,
                                                    .mouseEnteredAndExited],
                                          owner: self,
                                          userInfo: nil)
        }
        
        if !self.trackingAreas.contains(trackingArea){
            self.addTrackingArea(trackingArea)
        }
        
        if let mouseLocation = self.window?.mouseLocationOutsideOfEventStream{
            let pt = self.convert(mouseLocation, from: nil)
            if NSPointInRect( pt, self.bounds ){
                isMouseEntered = true
            }
            else{
                isMouseEntered = false
            }
            
            updateBackgroundColor()
        }
    }

    override open func becomeFirstResponder() -> Bool {
        updateCursorColor()        
        isFocused = true
        
        return super.becomeFirstResponder()
    }
    
    
    override func hitTest(_ point: CGPoint) -> NSView? {
        let view = super.hitTest(point)
        return (passThroughMouseEvent && (view == self)) ? nil : view
    }
    
    func updatePlaceholderStringStyle(){
        let str = self.placeholderString ?? self.placeholderAttributedString?.string
        
        if let placeholderStr = str{
            let attsDictionary = [NSAttributedString.Key.foregroundColor: SemanticThemeManager.getColors(for:.inputTextSecondary).normal,
                                  NSAttributedString.Key.font: self.font!] as [NSAttributedString.Key : Any]
            self.placeholderAttributedString = NSAttributedString(string: placeholderStr, attributes: attsDictionary)
        }
    }
    
    func updateStyle(){
    }
    
    private func updateCursorColor(){
        if let fieldEditor = self.window?.fieldEditor(true, for: self) as? NSTextView {
            let insertionPointColor = cursorColor ?? NSColor.controlTextColor
            fieldEditor.insertionPointColor = insertionPointColor
        }
    }
    
    private func updateBackgroundColor(){
        if let color = getAppropriateBackgroundColor(){
            self.wantsLayer = true
            self.layer?.backgroundColor = color.cgColor
        }
    }
    
    private func updateBorderColor() {
        guard var theBorderColor = borderColor else { return }
        if isFocused || !stringValue.isEmpty,
            let color = borderColorActive {
            theBorderColor = color
        }
        self.wantsLayer = true
        self.layer?.borderColor = theBorderColor.cgColor
    }
        
    override func textDidEndEditing(_ notification: Notification) {
        isFocused = false
        super.textDidEndEditing(notification)
    }
    
    private func getAppropriateBackgroundColor() -> NSColor?{
        
        if let focusBgColor = self.bgFocusedColor,
            isFocused{
            
            return focusBgColor
        }
        else if let bgHoverColor = self.hoverColor,
                    isMouseEntered{
            
            return bgHoverColor
        }
        else{
            
            return bgColor
        }
    }
    
    private func showTooltip() {
        hideTooltip()
//        customTooltipsController = CallViewCustomTooltipsViewController(tooltip: customTooltip, attributedTooltip: customAttributedTooltip)
//        let _  = customTooltipsController?.view
//        if let customTooltipsController = customTooltipsController {
//            tooltipPopover = SparkPopoverBuilder().createInCallTooltipPopover(contentViewController: customTooltipsController, sender: self, bounds: bounds, preferredEdge: .minY)
//        }
    }
    
    private func hideTooltip() {
        if let tooltipPopover = tooltipPopover, tooltipPopover.isShown {
            tooltipPopover.close()
        }
    }
}
