//
//  UTHoverableView.swift
//  UIToolkit
//
//  Created by James Nestor on 14/07/2021.
//

import Cocoa

public protocol UTHoverableViewDelegate: AnyObject {
    ///If hovering is enabled this will be called when hover state changes
    func isHoveredChanged(sender: UTView, isHovered:Bool)
}

public class UTHoverableView: UTView {
    
    //MARK: - Public variables
    
    var popoverBehavior:NSPopover.Behavior = .transient
    
    ///If hover is enabled a tracking area is added to the bounds of the view which will send a hover changed event
    ///after the mouse hovers for a delay time (1.5 seconds). If hovered hover changed will fire on mouse exit
    @IBInspectable public var enableHover:Bool = false {
        didSet {
            if enableHover != oldValue {
                if enableHover {
                    updateTrackingAreas()
                } else {
                    stopHover()
                    removeTracker()
                }
            }
        }
    }
    
    public func addUTToolTip(toolTip:UTTooltipType) {
        
        switch toolTip {
        case .plain(let toolTipString):
            super.toolTip = toolTipString
            enableHover = false
        case .rich(_):
            super.toolTip = ""
            enableHover = true
        }
        
        tooltipType = toolTip
    }
    
    internal var checkIsInVisibleRectOnTrackingAreaUpdate = true
    
    ///Delegate for hover events
    public weak var hoverDelegate:UTHoverableViewDelegate?
    
    //MARK: - Internal variables
    internal var hoverDelay: TimeInterval = 1.2
    
    //MARK: - Private variables
    private var hoverTimer: Timer!
    private var isHovering:Bool = false
    private var trackingArea: NSTrackingArea?
    private var tooltipType: UTTooltipType = .plain("")
    private var popover: UTPopover!
    
    
    //MARK: - Lifecycle
    deinit{
        removeTracker()
    }
    
    func removeTracker() {
        if let trackingArea = trackingArea{
            self.removeTrackingArea(trackingArea)
        }
    }
    
    //MARK: - Public functions
    public override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        if let trackingArea = trackingArea {
            self.removeTrackingArea(trackingArea)
        }
        
        if !enableHover {
            stopHover()
            return
        }
        
        trackingArea = NSTrackingArea(rect: NSZeroRect,
                                      options: [NSTrackingArea.Options.inVisibleRect,
                                                NSTrackingArea.Options.activeAlways,
                                                NSTrackingArea.Options.mouseEnteredAndExited],
                                      owner: self,
                                      userInfo: nil)
        
        if let trackingArea = trackingArea {
            if !self.trackingAreas.contains(trackingArea){
                self.addTrackingArea(trackingArea)
            }
        }
        
        if checkIsInVisibleRectOnTrackingAreaUpdate {
            if isMouseInVisibleRect{
                startHoverTimer()
            }
            else{
                stopHover()
            }
        }
    }
    
    override public func mouseEntered(with event: NSEvent) {
        guard event.trackingArea == trackingArea else { return }
        showToolTip()
        startHoverTimer()
    }
    
    override public func mouseExited(with event: NSEvent) {
        guard event.trackingArea == trackingArea else { return }
        removeToolTip()
        stopHover()
    }
    
    private func showToolTip() {
        if case .rich(let details) = tooltipType, details.attTooltipString.length > 0 {
            popover?.close()
            
            let toolTipVC = RichToolTipViewController(tooltip:details.attTooltipString, size:details.size)
            popover = UTPopover(contentViewController: toolTipVC, sender: self, bounds: self.bounds, preferredEdge: details.preferredEdge, behavior: popoverBehavior,  style: .toolTip)
        }
    }
    
     func removeToolTip() {
        popover?.close()
        popover = nil
    }
    
    //MARK: - Private functions
    
    private func startHoverTimer() {
        //If hover delay time is 0 just call the delegate directly as Timer.scheduledTimer
        // will queue the call onto the main thread instead of directly doing it
        
        if hoverDelay == 0 &&
            isMouseInVisibleRect {
            
            isHovering = true
            hoverDelegate?.isHoveredChanged(sender: self, isHovered: true)
        }
        else {
            if hoverTimer == nil {
                hoverTimer = Timer.scheduledTimer(timeInterval: hoverDelay,
                                                        target: self,
                                                      selector: #selector(UTHoverableView.onHoverTimer),
                                                      userInfo: nil,
                                                       repeats: false)
            }
        }
    }
    
    private func stopHover(){
        if hoverTimer != nil {
            hoverTimer.invalidate()
            hoverTimer = nil
        }
        
        if isHovering {
            isHovering = false
            hoverDelegate?.isHoveredChanged(sender: self, isHovered: false)
        }
    }
    
    @objc private func onHoverTimer(timer: Timer){
        if isMouseInView {
            isHovering = true
            hoverDelegate?.isHoveredChanged(sender: self, isHovered: true)
        }
    }
    
}
