//
//  UTPopover.swift
//  UIToolkit
//
//  Created by James Nestor on 24/05/2021.
//

import Cocoa

public class UTPopover: NSPopover, ThemeableProtocol {
    
    private var popoverViewController:UTPopoverViewController!

    public init(contentViewController:NSViewController,
                            sender:NSView,
                            bounds:NSRect,
                            preferredEdge:NSRectEdge = NSRectEdge.maxY,
                            behavior:NSPopover.Behavior = .transient,
                            animates:Bool = true,
                            addCancelButton:Bool = false,
                            delegate: NSPopoverDelegate? = nil,
                            shouldShow: Bool = true,
                            forTeaching: Bool = false) {
    
        super.init()
        
        initialise(contentViewController: contentViewController,
                   sender: sender,
                   bounds: bounds,
                   preferredEdge: preferredEdge,
                   behavior: behavior,
                   animates: animates,
                   addCancelButton: addCancelButton,
                   delegate: delegate,
                   shouldShow: shouldShow,
                   style: forTeaching ? .teaching : .primary)
    }
    
    //internal init as we dont want UTPopoverView.Style public 
    internal init(contentViewController:NSViewController,
                            sender:NSView,
                            bounds:NSRect,
                            preferredEdge:NSRectEdge = NSRectEdge.maxY,
                            behavior:NSPopover.Behavior = .transient,
                            animates:Bool = true,
                            addCancelButton:Bool = false,
                            delegate: NSPopoverDelegate? = nil,
                            shouldShow: Bool = true,
                            style: UTPopoverView.Style){
    
        super.init()
    
        initialise(contentViewController: contentViewController,
                   sender: sender,
                   bounds: bounds,
                   preferredEdge: preferredEdge,
                   behavior: behavior,
                   animates: animates,
                   addCancelButton: addCancelButton,
                   delegate: delegate,
                   shouldShow: shouldShow,
                   style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialise(contentViewController:NSViewController,
                            sender:NSView,
                            bounds:NSRect,
                            preferredEdge:NSRectEdge,
                            behavior:NSPopover.Behavior,
                            animates:Bool,
                            addCancelButton:Bool,
                            delegate: NSPopoverDelegate?,
                            shouldShow: Bool,
                            style: UTPopoverView.Style) {
        
        popoverViewController = UTPopoverViewController(style: style)
        popoverViewController.setMainContentViewController(viewController: contentViewController)
        
        if addCancelButton{
            popoverViewController.addCancelButtion()
        }
        
        self.appearance = NSAppearance.getThemedAppearance()
        self.behavior = behavior
        super.contentViewController = popoverViewController
        self.animates = animates
        self.delegate = delegate
        if shouldShow{
            
            if sender.window != nil {
                self.show(relativeTo: bounds, of: sender, preferredEdge: preferredEdge)
            }
            else{
                assert(false, "UTPopover window sender has no window. Unable to open")
            }
        }
    }
    
    public override var contentViewController: NSViewController? {
        get{
            return super.contentViewController
        }
        set {
            assert(false, "contentViewController should not be set on UTPopover")
            super.contentViewController = newValue
        }
    }
    
    public func isContentViewController(viewController:NSViewController?) -> Bool {
        guard let vc = viewController else { return false }
        return popoverViewController?.isMainContenetViewController(viewController: vc) == true
    }
    
    public func setThemeColors() {
        self.popoverViewController.setThemeColors()
    }

}
