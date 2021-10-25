//
//  TestToastWindowManager.swift
//  ComponentApp
//
//  Created by James Nestor on 08/07/2021.
//

import Cocoa
import UIToolkit

class TestToastWindowManager : NSObject, ThemeableProtocol{

    static var shared:TestToastWindowManager = TestToastWindowManager()
    
    private var toastWindows:[UTToastWindow] = []
    
    override init() {
        super.init()
        UIToolkit.shared.themeableProtocolManager.subscribe(listener: self)
    }
    
    deinit{
        UIToolkit.shared.themeableProtocolManager.unsubscribe(listener: self)
    }
    
    func createToast() {
        let toastView = UTToastView(frame: NSMakeRect(0, 100, 200, 100))
        let window = UTToastWindow(contentView: toastView, hasWindowCloseButton: true)
        addToastWindow(window: window)
    }
    
    func createTextToast() {
        let toastView = UTToastView(style: .text, frame: NSMakeRect(0, 100, 200, 100))
        let window = UTToastWindow(contentView: toastView, hasWindowCloseButton: true)
        addToastWindow(window: window)
    }
    
    func createReminderToast() {
        let toastViewVC = TestMeetingReminderVC()
        let window = UTToastWindow(contentViewController: toastViewVC, hasWindowCloseButton: true)
        addToastWindow(window: window)
    }
    
    func createInfoToast() {
        let toastViewVC = TestMeetingInfoToast()
        let window = UTToastWindow(contentViewController: toastViewVC, hasWindowCloseButton: false)
        addToastWindow(window: window)
    }
    
    func createCallToast() {
        let toastViewVC = TestCallToast()
        let window = UTToastWindow(contentViewController: toastViewVC, hasWindowCloseButton: false)
        addToastWindow(window: window)
    }
    
    func orderToasts() {
        
        guard let mainScreenRect = NSScreen.main?.visibleFrame else {
            return
        }
        
        let horizontalMargin: CGFloat = 20
        let verticalMargin: CGFloat = 10
        
        var x = mainScreenRect.origin.x + mainScreenRect.size.width - horizontalMargin
        var y = mainScreenRect.origin.y + verticalMargin
        
        for window in toastWindows {
            window.layoutIfNeeded()
            let callToastSize = window.frame.size
            let toastPosition = NSPoint(x: x - callToastSize.width, y: y)
            let toastHeight = callToastSize.height

            if !NSEqualPoints(window.frame.origin, toastPosition) {
                if NSEqualPoints(window.frame.origin, NSPoint(x: 0, y: 0)) {
                    window.setFrameOrigin(toastPosition)
                } else {
                    var frame = window.frame
                    frame.origin = toastPosition
                    window.setFrame(frame, display: true, animate: true)
                }
            }

            y += verticalMargin + callToastSize.height

            if (y + toastHeight) > mainScreenRect.size.height {
                x -= (callToastSize.width + horizontalMargin)
                y = mainScreenRect.origin.y + verticalMargin
            }
        }
    }
    
    func setThemeColors() {
        for w in toastWindows {
            w.setThemeColors()
        }
    }
    
    private func addToastWindow(window:UTToastWindow){
        window.delegate = self
        toastWindows.append(window)
        
        orderToasts()
        window.fadeIn()
    }
}

extension TestToastWindowManager : NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        if let w = notification.object as? NSWindow {
            toastWindows.removeAll(where: {$0 == w})
            orderToasts()
        }
    }
}
