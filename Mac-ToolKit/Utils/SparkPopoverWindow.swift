//
//  SparkPopover.swift
//  SparkMacDesktop
//
//  Created by James Nestor on 21/09/2015.
//  Copyright © 2015 Cisco Systems. All rights reserved.
//

import Cocoa

/*
 For testing purposes, create SparkPopoverWindow via factory method
 */
class SparkPopoverWindowFactory {
    func createSparkPopoverWindow(contentViewController: NSViewController) -> SparkPopoverWindow {
        return SparkPopoverWindow(contentViewController: contentViewController)
    }
}

protocol SparkPopoverWindowDelegate: AnyObject {
    func popoverWindowWillClose(window: SparkPopoverWindow)
    func popoverWindowDidClose(window: SparkPopoverWindow)
    func popoverWindowWillShow(window: SparkPopoverWindow)
    func popoverWindowDidShow(window: SparkPopoverWindow)
    func popoverWindowDidBecomeKey(window: SparkPopoverWindow)
    func popoverWindowDidResignKey(window: SparkPopoverWindow)
    func shouldCloseWindowForMouseEvent(window: SparkPopoverWindow, event:NSEvent) -> Bool
    func shouldCloseWindowWhenClickOutsideInsensitiveArea(window: SparkPopoverWindow, event:NSEvent) -> Bool
}

extension SparkPopoverWindowDelegate {
    func popoverWindowWillClose(window: SparkPopoverWindow){}
    func popoverWindowDidClose(window: SparkPopoverWindow){}
    func popoverWindowWillShow(window: SparkPopoverWindow){}
    func popoverWindowDidShow(window: SparkPopoverWindow){}
    func popoverWindowDidBecomeKey(window: SparkPopoverWindow){}
    func popoverWindowDidResignKey(window: SparkPopoverWindow){}
    func shouldCloseWindowForMouseEvent(window: SparkPopoverWindow, event:NSEvent) -> Bool{ return true }
    func shouldCloseWindowWhenClickOutsideInsensitiveArea(window: SparkPopoverWindow, event:NSEvent) -> Bool { return true }
}

protocol SparkPopoverMouseEventInsensitiveWindowProtocol: NSWindow {
    func setInsensitiveView(_ view: NSView)
    func insensitiveArea() -> NSRect
}

extension SparkPopoverMouseEventInsensitiveWindowProtocol {
    func setInsensitiveView(_ view: NSView) { }
    func insensitiveArea() -> NSRect { return NSZeroRect }
}

enum PopoverXPosition{
    case middle
    case right
    case left
}

enum PopoverYPosition {
    case middle
    case top
    case bottom
}

class WeakWindowWrapper {
    weak var window: SparkPopoverMouseEventInsensitiveWindowProtocol?
    
    init(window: SparkPopoverMouseEventInsensitiveWindowProtocol) {
        self.window = window
    }
}

class SparkPopoverWindow: NSWindow {

    @IBInspectable var yOffset:CGFloat = 10
    @IBInspectable var xOffset:CGFloat = 0
    /**
     * TransientStyle true makes the window to behave like a popover .transient,
     * Fading out on clicking outside the window frame
     */
    @IBInspectable var transientStyle:Bool = false {
        didSet {
            if transientStyle {
                self.canBeKeyWindow = true
            }
            else {
                self.canBeKeyWindow = false
            }
        }
    }

    @IBInspectable var closeOnClickOutsideFrame = false {
        didSet {
            if closeOnClickOutsideFrame {
                listenToMouseDownEvent = true
            }
        }
    }
    @IBInspectable var listenToMouseDownEvent = false
    @IBInspectable var listenToFocusChange = false
    @IBInspectable var windowToFront:Bool = false

    private var frameObjectProtocol:NSObjectProtocol!
    private var windowObjectProtocol:NSObjectProtocol!
    private var localMouseDownEventMonitor: Any?
    private var lostFocusObserver: Any?
    
    private weak var relativeView:NSView?
    private var edgeToShow: NSRectEdge = .minY
    private var xPosition: PopoverXPosition = .middle
    private var yPosition: PopoverYPosition = .top
    private var preventOffscreen:Bool = true
    private var insensitiveWindows: [WeakWindowWrapper] = []
    
    func registerInsensitiveWindow(_ window: SparkPopoverMouseEventInsensitiveWindowProtocol) {
        insensitiveWindows = insensitiveWindows.filter({$0.window != nil})
        if insensitiveWindows.contains(where: {$0.window === window}){ return }
        insensitiveWindows.append(WeakWindowWrapper(window: window))
    }
    func unRegisterInsensitiveWindow(_ window: SparkPopoverMouseEventInsensitiveWindowProtocol) {
        if let firstIndex = insensitiveWindows.firstIndex(where: { $0.window === window } ){
            insensitiveWindows.remove(at: firstIndex)
        }
    }
    
    private func isInsensitive(window: NSWindow) -> Bool {
        return insensitiveWindows.contains { $0.window === window }
    }
   
    var canBeKeyWindow:Bool = false
    
    // need to be able to mock this for swift unit testing
    var _currentScreenFrame: NSRect? = NSScreen.main?.frame
    var currentScreenFrame: NSRect? {
        get {
            return _currentScreenFrame
        }
        set {
            _currentScreenFrame = newValue
        }
    }
    
    weak var sparkPopoverWindowDelegate:SparkPopoverWindowDelegate?

    func showRelativeToRect(posView: NSView, edge: NSRectEdge, makeKey: Bool = true, xPosition: PopoverXPosition = .middle, yPosition: PopoverYPosition = .top, preventOffscreen: Bool = true, currentScreenFrame: CGRect? = NSScreen.main?.frame){
        self.currentScreenFrame = currentScreenFrame
        sparkPopoverWindowDelegate?.popoverWindowWillShow(window: self)
        relativeView = posView
        edgeToShow = edge
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.preventOffscreen = preventOffscreen
        
        self.setWindowFrameFromView(posView.bounds, posView: posView, edge:edge, display: true, xPosition: xPosition, yPosition: yPosition, preventOffScreen: preventOffscreen)
        
        if self.parent == nil {
            
            frameObjectProtocol = NotificationCenter.default.addObserver(forName: NSView.didUpdateTrackingAreasNotification, object: posView, queue: nil, using: {[weak self] (NSNotification) -> Void in
                
                self?.setWindowFrameFromView(posView.bounds, posView: posView, edge: edge, display: true, xPosition: xPosition, yPosition: yPosition, preventOffScreen: preventOffscreen)
            })
            
            var topmostParentWindow = posView.window            
            while (topmostParentWindow?.parent != nil) {
                topmostParentWindow = topmostParentWindow!.parent;
            }
            
            if let topmostParentWindow = topmostParentWindow{
                topmostParentWindow.addChildWindow(self, ordered: NSWindow.OrderingMode.above)                
                
                windowObjectProtocol = NotificationCenter.default.addObserver(forName: NSWindow.didResizeNotification, object: topmostParentWindow, queue: nil, using: {[weak self] (NSNotification) -> Void in
                    self?.setWindowFrameFromView(posView.bounds, posView: posView, edge: edge, display: true, xPosition: xPosition, yPosition: yPosition, preventOffScreen: preventOffscreen )
                })
            }

            /*
             Swiftifying the CustomMenus documention with localMouseDownEventMonitor and lostFocusObserver: https://developer.apple.com/library/archive/samplecode/CustomMenus/Listings/SuggestionsWindowController_m.html#//apple_ref/doc/uid/DTS40010056-SuggestionsWindowController_m-DontLinkElementID_17

             setup auto cancellation if the user clicks outside the suggestion window and parent text field.
             Note: this is a local event monitor and will only catch clicks in windows that belong to this application.
             We use another technique below to catch clicks in other application windows.
             */
            if listenToMouseDownEvent {
                localMouseDownEventMonitor = NSEvent.addLocalMonitorForEvents(matching: [NSEvent.EventTypeMask.leftMouseDown,
                                                                                         NSEvent.EventTypeMask.rightMouseDown,
                                                                                         NSEvent.EventTypeMask.otherMouseDown], handler:
                    {[weak self](_ event: NSEvent) -> NSEvent? in
                        guard let strongSelf = self else { return event }
                        
                        // If click outside this window frame close it
                        if strongSelf.closeOnClickOutsideFrame {
                            if (event.window as? SparkPopoverWindow) != strongSelf {
                                if let hitWindow = event.window as? SparkPopoverMouseEventInsensitiveWindowProtocol {
                                    let winBounds = NSMakeRect(0, 0, NSWidth(hitWindow.frame), NSHeight(hitWindow.frame))
                                    let insensitiveArea = hitWindow.insensitiveArea() == NSZeroRect ? winBounds : hitWindow.insensitiveArea()
                                    
                                    if !(strongSelf.isInsensitive(window: hitWindow) && NSPointInRect(event.locationInWindow, insensitiveArea)) {
                                        if strongSelf.shouldCloseWhenClickOutsideInsensitiveArea(event: event) {
                                            strongSelf.close()
                                        }
                                    }
                                } else {
                                    strongSelf.close()
                                }
                            }
                        }
                        // If the mouse event is in the suggestion window, then tshere is nothing to do.
                        let event: NSEvent! = event
                        if event.window != strongSelf {
                            if event.window == posView.window {
                                /* Clicks in the parent window should either be in the parent text field or dismiss the suggestions window.
                                 We want clicks to occur in the parent text field so that the user can move the caret or select the search text.

                                 Use hit testing to determine if the click is in the parent text field. Note: when editing an NSTextField,
                                 there is a field editor that covers the text field that is performing the actual editing.
                                 Therefore, we need to check for the field editor when doing hit testing.
                                 */
                                let contentView = posView.window?.contentView
                                let locationTest = contentView?.convert(event.locationInWindow, from: nil)
                                let hitView = contentView?.hitTest(locationTest ?? NSPoint.zero)
                                if let posTextField = posView as? NSTextField {
                                    let fieldEditor = posTextField.currentEditor()
                                    if hitView != posTextField && ( (fieldEditor != nil && hitView != fieldEditor) || fieldEditor == nil) {
                                        //  Click is not in the parent text field, return nil event if we don't want parent window to process it, and cancel the suggestion window.
                                        
                                        if strongSelf.shouldCloseMouseOnClick(event: event){
                                        //Delay the close so any other control gets a chance to reeact before close is done
                                            strongSelf.perform(#selector(strongSelf.close), with: nil, afterDelay: 0.2)
                                        }
                                    }
                                }
                            } else {
                                // Not in the suggestion window, and not in the parent window. This must be another window or palette for this application.
                                if strongSelf.shouldCloseMouseOnClick(event: event){
                                    strongSelf.perform(#selector(strongSelf.close), with: nil, afterDelay: 0.2)
                                }
                            }
                        }
                        return event
                })
            }

            /*
             As per the documentation, do not retain event monitors.
             We also need to auto cancel when the window loses key status. This may be done via a mouse click in another window,
             or via the keyboard (cmd-~ or cmd-tab), or a notificaiton.
             Observing NSWindowDidResignKeyNotification catches all of these cases and the mouse down event monitor catches the other cases.
             */
            if listenToFocusChange {
                lostFocusObserver = NotificationCenter.default.addObserver(forName: NSApplication.didResignActiveNotification, object: nil, queue: nil, using:
                    {[weak self](_: Notification) -> Void in
                        // lost key status, cancel the suggestion window
                        self?.close()
                })
            }
            
        }
        if (makeKey) {
            self.makeKeyAndOrderFront(self)
        }
        
        if windowToFront {
            self.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.popUpMenuWindow)) + 1)
        }
        sparkPopoverWindowDelegate?.popoverWindowDidShow(window: self)
    }
        
    func showRelativeToRect(posView: NSView){
        showRelativeToRect(posView: posView, edge: edgeToShow, makeKey: true)
    }
    
    func shouldCloseMouseOnClick(event:NSEvent) -> Bool{
        guard let windowDelegate = sparkPopoverWindowDelegate else { return true }
        return windowDelegate.shouldCloseWindowForMouseEvent(window: self, event: event)
    }
    
    func shouldCloseWhenClickOutsideInsensitiveArea(event:NSEvent) -> Bool{
        guard let windowDelegate = sparkPopoverWindowDelegate else { return true }
        return windowDelegate.shouldCloseWindowWhenClickOutsideInsensitiveArea(window: self, event: event)
    }
    
    override var canBecomeKey: Bool {
        return canBeKeyWindow
    }
    
    override func becomeKey() {
        super.becomeKey()
        sparkPopoverWindowDelegate?.popoverWindowDidBecomeKey(window: self)
    }
    
    override func resignKey() {
        super.resignKey()
        sparkPopoverWindowDelegate?.popoverWindowDidResignKey(window: self)
        if transientStyle {
            fadeOutAndCloseWindow()
        }
    }
    
    override var isKeyWindow: Bool {
        return canBeKeyWindow
    }
    
    override func cancelOperation(_ sender: Any?) {
        fadeOutAndCloseWindow()
    }
    
    func getWindowRect(_ posRect: CGRect, posView: NSView, edge: NSRectEdge, xPosition: PopoverXPosition, yPosition: PopoverYPosition, preventOffScreen: Bool) -> NSRect {
        guard let posViewWindow = posView.window else { return NSZeroRect}
        let alignmentRect = posView.alignmentRect(forFrame: posRect)
        let frameRelativeToWindw = posView.convert(alignmentRect, to: nil)
        let frameRelativeToScreen = posViewWindow.convertToScreen(frameRelativeToWindw)
        let contentFrame = self.contentView!.frame
        return getWindowRect(frameRelativeToScreen: frameRelativeToScreen, contentFrame: contentFrame, edge: edge, xPosition: xPosition, yPosition: yPosition, preventOffScreen: preventOffscreen)
    }
    
    func getWindowRect(frameRelativeToScreen: CGRect, contentFrame: CGRect, edge: NSRectEdge, xPosition: PopoverXPosition, yPosition: PopoverYPosition, preventOffScreen: Bool) -> NSRect {
        
        var originX = frameRelativeToScreen.origin.x
        if contentFrame.width > frameRelativeToScreen.width {
            let diff = contentFrame.width - frameRelativeToScreen.width
            
            var calculatedOffset = -(diff / 2)
            if xPosition == .right {
                calculatedOffset = -diff
            } else if xPosition == .left {
                calculatedOffset = 0
            }
            
            originX = (frameRelativeToScreen.origin.x + calculatedOffset) + xOffset
            
            if let currentScreenFrame = currentScreenFrame {
                if currentScreenFrame.minX - originX > 0 {
                    originX += (currentScreenFrame.minX - originX)
                } else if originX + contentFrame.width > currentScreenFrame.maxX {
                    originX -= (originX + contentFrame.width - currentScreenFrame.maxX)
                }
            }
        } else if frameRelativeToScreen.width > contentFrame.width {
            let diff = frameRelativeToScreen.width - contentFrame.width
            
            var calculatedOffset = diff / 2
            if xPosition == .right {
                calculatedOffset = diff
            } else if xPosition == .left {
                calculatedOffset = 0
            }
            
            originX = frameRelativeToScreen.origin.x + calculatedOffset + xOffset
        } else {
            originX = frameRelativeToScreen.origin.x + xOffset
        }

        //TODO: Add a parameter that aligns Y-axis to top, middle or bottom of view
        //Currently align originY to top of posView
        var originY = frameRelativeToScreen.origin.y
        if contentFrame.height > frameRelativeToScreen.height {
            let diff = contentFrame.height - frameRelativeToScreen.height
            
            var calculatedOffset = -diff / 2
            if yPosition == .bottom {
                calculatedOffset = 0
            } else if yPosition == .top {
                calculatedOffset = -diff
            }
            
            originY = (frameRelativeToScreen.origin.y + calculatedOffset) + yOffset
        } else if frameRelativeToScreen.height > contentFrame.height {
            let diff = frameRelativeToScreen.height - contentFrame.height
            
            var calculatedOffset = diff / 2
            if yPosition == .bottom {
                calculatedOffset = 0
            } else if yPosition == .top {
                calculatedOffset = diff
            }
            
            originY = (frameRelativeToScreen.origin.y + calculatedOffset) + yOffset
        }
        
        guard let currentScreenFrame = currentScreenFrame else { return NSZeroRect }
        switch edge {
        case .minY:
            if !preventOffScreen
                || frameRelativeToScreen.origin.y - contentFrame.height - yOffset > currentScreenFrame.origin.y {
                originY = frameRelativeToScreen.origin.y - (contentFrame.height + yOffset)
            } else {
                originY = frameRelativeToScreen.origin.y + frameRelativeToScreen.height + yOffset
            }
        case .maxY:
            if !preventOffScreen ||
                frameRelativeToScreen.origin.y + frameRelativeToScreen.height + contentFrame.height + yOffset < currentScreenFrame.height + currentScreenFrame.origin.y {
                originY = (frameRelativeToScreen.origin.y + frameRelativeToScreen.height) + yOffset
            } else {
                originY = frameRelativeToScreen.origin.y - contentFrame.height - yOffset
            }
        case .minX:
            if !preventOffScreen ||
                frameRelativeToScreen.origin.x - contentFrame.width - xOffset > currentScreenFrame.origin.x {
                originX = frameRelativeToScreen.origin.x - ( contentFrame.width + xOffset )
            } else {
                originX = frameRelativeToScreen.origin.x + frameRelativeToScreen.width + xOffset
            }
        case .maxX:
            if !preventOffScreen ||
                frameRelativeToScreen.origin.x + frameRelativeToScreen.width + contentFrame.width + xOffset < currentScreenFrame.width + currentScreenFrame.origin.x {
                originX = frameRelativeToScreen.origin.x + frameRelativeToScreen.width + xOffset
            } else {
                originX = frameRelativeToScreen.origin.x - contentFrame.width - xOffset
            }
        default: break
        }
        return NSMakeRect(originX, originY, contentFrame.width, contentFrame.height)
    }
    
    func setWindowFrameFromView(_ posRect: CGRect, posView: NSView, edge: NSRectEdge, display: Bool, xPosition:PopoverXPosition, yPosition: PopoverYPosition, preventOffScreen:Bool) {
        if posView.window != nil {
            self.setFrame(getWindowRect(posRect, posView: posView, edge: edge, xPosition:xPosition, yPosition: yPosition, preventOffScreen: preventOffscreen), display: display)
        }
    }
    
    func setWindowFrameFromView(_ posRect: CGRect, posView: NSView, xPosition:PopoverXPosition, yPosition: PopoverYPosition, preventOffScreen:Bool){
        setWindowFrameFromView(posRect, posView: posView, edge: .minY, display: true, xPosition:xPosition, yPosition: yPosition, preventOffScreen: preventOffscreen)
    }
    
    public func isMouseInWindow() -> Bool {
        guard let contentView = self.contentView else { return false }
        let globalMouseLocation = NSEvent.mouseLocation
        let mouseLocationInWindow = self.convertPoint(fromScreen: globalMouseLocation)
        return contentView.bounds.contains(mouseLocationInWindow)
    }
    
    override func close() {
        NotificationCenter.default.removeObserver(self)
        
        if let objProtocol = self.frameObjectProtocol{
            NotificationCenter.default.removeObserver(objProtocol)
            self.frameObjectProtocol = nil
        }
        
        if let objProtocol = self.windowObjectProtocol{
            NotificationCenter.default.removeObserver(objProtocol)
            self.windowObjectProtocol = nil
        }

        if let lostFocusObserver = lostFocusObserver {
            NotificationCenter.default.removeObserver(lostFocusObserver)
            self.lostFocusObserver = nil
        }
        if let localMouseDownEventMonitor = localMouseDownEventMonitor {
            NSEvent.removeMonitor(localMouseDownEventMonitor)
            self.localMouseDownEventMonitor = nil
        }
                
        if(self.parent != nil){
            self.parent?.removeChildWindow(self)
        }
        sparkPopoverWindowDelegate?.popoverWindowWillClose(window: self)
        super.close()
        sparkPopoverWindowDelegate?.popoverWindowDidClose(window: self)
    }
    
    func updatePosition() {
        if let relativeView = relativeView {
            setWindowFrameFromView(relativeView.bounds, posView: relativeView, edge: edgeToShow, display: true, xPosition: xPosition, yPosition: yPosition, preventOffScreen: preventOffscreen)
        }
    }
    
    fileprivate func fadeOutAndCloseWindow() {
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.allowsImplicitAnimation = true
            context.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeIn)
            context.duration =  0.2
            
            self.contentView?.animator().alphaValue = 0
        }, completionHandler:{ () -> Void in
            self.contentView?.alphaValue = 1
            self.close()
        })
        
        sparkPopoverWindowDelegate?.popoverWindowDidClose(window: self)
    }
    
    deinit {
        self.close()
    }
    
    override func accessibilityRole() -> NSAccessibility.Role? {
        return NSAccessibility.Role.popover
    }
}
