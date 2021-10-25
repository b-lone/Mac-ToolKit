//
//  UTTabView.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 25/05/2021.
//

import Cocoa
import Carbon.HIToolbox

//MARK: - TabStackView
public class UTTabStackView: NSStackView {
    
    @IBInspectable var useSystemFocusRing:Bool = false

    let tokenName = "button-secondary"
    
    weak var highlightedButton:NSButton? {
        didSet {
            if let newHighlightedButton = highlightedButton as? UTButton {
                updateButtonTabFocusState(button: newHighlightedButton, isHighlighted: true)
            }
            
            for view in views{
                view.needsDisplay = true
            }
        
            noteFocusRingMaskChanged()
        }
    }
    
    @IBInspectable var upDownChangeSelection:Bool = false
    @IBInspectable var leftRigthChangeSelection:Bool = true
    
    //Do not allow focus when clicked
    public override var acceptsFirstResponder: Bool{
        return false
    }
    
    //Allow tab focus
    public override var canBecomeKeyView: Bool{
        return self.isHiddenOrHasHiddenAncestor == false
    }
    
    func redrawAllItems(){
        for view in views{
            view.needsDisplay = true
        }
        
        needsDisplay = true
    }
    
    public override func becomeFirstResponder() -> Bool {
        let shouldBecomeFirstResponder = super.becomeFirstResponder()
        
        if shouldBecomeFirstResponder{
            for view in views{
                if let button = view as? UTButton, isButtonOn(button: button) {
                    highlightedButton = button
                    updateButtonTabFocusState(button: highlightedButton, isHighlighted: true)
                    break
                }
            }
            needsDisplay = true
        }
        
        return shouldBecomeFirstResponder
    }
    
    public override func resignFirstResponder() -> Bool {
        let shouldResignFirstResponder = super.resignFirstResponder()
        
        if shouldResignFirstResponder{
            updateButtonTabFocusState(button: highlightedButton, isHighlighted: false)
            highlightedButton = nil
            needsDisplay = true
        }
        
        return shouldResignFirstResponder
    }
    
    public override func moveUp(_ sender: Any?) {
        if upDownChangeSelection{
            movePrev()
        }
    }
    
    public override func moveDown(_ sender: Any?) {
        if upDownChangeSelection{
            moveNext()
        }
    }
    
    public override func moveLeft(_ sender: Any?) {
        if leftRigthChangeSelection{
            movePrev()
        }
    }
    
    public override func moveRight(_ sender: Any?) {
        if leftRigthChangeSelection{
            moveNext()
        }
    }
    
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if useSystemFocusRing{
            return
        }
        
        if let highlightedButton = highlightedButton{
            UIToolkit.shared.getThemeManager().getColors(tokenName: tokenName).normal.set()
            let bezierPath = NSBezierPath(roundedRect: highlightedButton.frame, xRadius: 4.0, yRadius: 4.0)
            
            bezierPath.addClip()
            bezierPath.fill()
        }
    }
    
    public override func keyDown(with event: NSEvent) {
        
        if highlightedButton != nil{
            let keyCode:Int = Int(event.keyCode)
            if keyCode == kVK_Space ||
                keyCode == kVK_Return{
                
                if hasFocus(){
                    highlightedButton?.performClick(self)
                    return
                }
            }
        }
        
        super.keyDown(with: event)
    }
    
    //MARK: - Private functions
    private func moveNext(){
        if hasFocus(){
            updateButtonTabFocusState(button: highlightedButton, isHighlighted: false)
            highlightedButton = getNextVisibleButton()
            
            needsDisplay = true
            NSAccessibility.post(element: self, notification: .titleChanged)
        }
    }
    
    private func movePrev(){
        if hasFocus(){
            updateButtonTabFocusState(button: highlightedButton, isHighlighted: false)
            highlightedButton = getPreviousVisibleButton()
            
            needsDisplay = true
            NSAccessibility.post(element: self, notification: .titleChanged)
        }
    }
    
    private func isButtonOn(button:NSButton) -> Bool{
        return button.state == NSControl.StateValue.on
    }
    
    private func updateButtonTabFocusState(button: NSButton?, isHighlighted: Bool) {
//        if let sparkButton = button as? UTButton {
//             sparkButton.isTabFocused = isHighlighted
//        }
        button?.needsDisplay = true
    }
    
    private func hasFocus() -> Bool{
        if self.window?.firstResponder == self{
            return true
        }
        
        return false
    }
    
    private func getNextVisibleButton() -> NSButton? {
        if let item = highlightedButton {
            if let currentIndex = views.firstIndex(of: item) {
                for i in currentIndex + 1 ..< views.count {
                    if let button = views[i] as? NSButton,
                           button.isHidden == false && button.isEnabled{
                        return button
                    }
                }
            }
            return item
        }
        
        return highlightedButton
    }
    
    private func getPreviousVisibleButton() -> NSButton? {
        if let item = highlightedButton {
            if let currentIndex = views.firstIndex(of: item) {
                for i in (0..<currentIndex).reversed() {
                    if let button = views[i] as? NSButton,
                           button.isHidden == false && button.isEnabled{
                        return button
                    }
                }
            }
            return item
        }
        return highlightedButton
    }
    
    //MARK: - Accessibility functions
    public override func isAccessibilityElement() -> Bool {
        return true
    }
    
    public override func accessibilityRole() -> NSAccessibility.Role? {
        return NSAccessibility.Role.list
    }
    
    public override func accessibilityTitle() -> String? {
        if let highlightedButton = highlightedButton {
            
            if let title = highlightedButton.accessibilityTitle(){
                return title
            }
            else if let title = highlightedButton.toolTip{
                return title
            }
        }
        
        return super.accessibilityTitle()
    }
    
    public override func accessibilityRowCount() -> Int {
        return self.visibleViewCount
    }
    
    public override func drawFocusRingMask() {
        
        if useSystemFocusRing{
            if let highlightButton = highlightedButton {
                let radius = highlightButton.layer?.cornerRadius ?? 0
                let path = NSBezierPath(roundedRect: highlightButton.frame, xRadius: radius, yRadius: radius)
                path.fill()
            }            
        }
        else{
            super.drawFocusRingMask()
        }
    }
    
    public override var focusRingMaskBounds: NSRect {
        if let highlightButton = highlightedButton {
            return highlightButton.frame
        }
        
        return self.bounds
    }
}
