//
//  NSPopover+Extensions.swift
//  SparkMacDesktop
//
//  Created by jimmcoyn on 07/02/2016.
//  Copyright © 2016 Cisco Systems. All rights reserved.
//

import Foundation

/*
 In order to properly test view controllers or classes that use NSPopover, instead of using the functionality at the bottom of this file ("extension NSPopover") directly,
 use SparkPopover instead. Using SparkPopover allows us to mock the popovers and return our own value (see MockSparkPopoverBuilder.swift and GroupedParticipantViewControllerTests.swift for use).
 This means we can use the swift unit tests instead of developer harness, which is significantly faster. 
 The wrapper in SparkPopover will create the popover, ensuring that we don't call the self.show method
 */
class SparkPopoverBuilder {
    func createPopover(contentViewController :NSViewController ,
                       sender:NSView, bounds:NSRect ,
                       preferredEdge:NSRectEdge =  NSRectEdge.maxY,
                       behavior:NSPopover.Behavior? = .transient,
                       animates:Bool = true,
                       delegate:NSPopoverDelegate? = nil,
                       shouldShow: Bool = true) -> NSPopover
    {
        return NSPopover(contentViewController: contentViewController , sender: sender, bounds: bounds , preferredEdge: preferredEdge, behavior: behavior, animates: animates, delegate: delegate, shouldShow: shouldShow)
    }
    
    func createInCallTooltipPopover(contentViewController :NSViewController ,
                                    sender:NSView, bounds:NSRect ,
                                    preferredEdge:NSRectEdge =  NSRectEdge.maxY,
                                    behavior:NSPopover.Behavior? = .semitransient,
                                    animates:Bool = false,
                                    delegate:NSPopoverDelegate? = nil,
                                    shouldShow: Bool = true) -> NSPopover
    {
        let popover = NSPopover(contentViewController: contentViewController , sender: sender, bounds: bounds , preferredEdge: preferredEdge, behavior: behavior, animates: animates, delegate: delegate, shouldShow: shouldShow)
        contentViewController.view.window?.level = .popUpMenu
        return popover
    }
}

extension NSPopover
{
    convenience init(contentViewController:NSViewController,
                     sender:NSView,
                     bounds:NSRect,
                     preferredEdge:NSRectEdge = NSRectEdge.maxY,
                     behavior:NSPopover.Behavior? = .transient,
                     animates:Bool = true,
                     delegate: NSPopoverDelegate? = nil,
                     shouldShow: Bool = true)
    {
        self.init()

        if let _ = sender.window {

            self.appearance = .current
            self.behavior = behavior!
            self.contentViewController = contentViewController
            self.animates = animates
            self.delegate = delegate
            if shouldShow{
                self.show(relativeTo: bounds, of: sender, preferredEdge: preferredEdge)
            }

        }
        else {
            assert(false)
            SPARK_LOG_ERROR("Attempted to open NSPopover with an invalid positioning specified. The sender (button) has no valid parent window.")
        }
    }
}
