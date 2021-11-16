//
//  FullScreenDetector FullScreenDetector FullScreenDetector FullScreenDetector FullScreenDetector.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/10/19.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

protocol FullScreenDetectorListener: AnyObject {
    func fullScreenDetectorFullScreenStateChanged(_ isFullScreen: Bool)
}

protocol FullScreenDetectorProtocol {
    func isFullScreen() -> Bool
    func registerListener(_ listener: FullScreenDetectorListener & NSObject)
    func unregisterListener(_ listener: FullScreenDetectorListener & NSObject)
}

//A  1 * 1 pixel window to detect if the user has gone into full screen
 class FullScreenDetector: NSWindowController, FullScreenDetectorProtocol {
    private var mIsFullScreen = false
    private var listenerList = [Weak<NSObject>]()
    
    deinit {
        close()
    }
    
    override func windowDidLoad()  {
        super.windowDidLoad()
        
        guard let window = window else {
            return
        }
        window.backgroundColor = .clear
        window.collectionBehavior = NSWindow.CollectionBehavior(rawValue: NSWindow.CollectionBehavior.canJoinAllSpaces.rawValue | NSWindow.CollectionBehavior.fullScreenNone.rawValue)
        window.level = .floating
        
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(onActiveSpaceDidChangeNotification), name:NSWorkspace.activeSpaceDidChangeNotification, object: nil)
    }
    
    public func isFullScreen() -> Bool {
        guard let window = window else {
            return false
        }
        return !window.isOnActiveSpace
    }
    
    override var windowNibName: NSNib.Name? {
        return "FullScreenDetector"
    }
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        if let windowNumber = window?.windowNumber {
            NotificationCenter.default.post(name: Notification.Name(rawValue: OnShareShouldExcludeWindow), object: self, userInfo: ["windowNumber": windowNumber])
        }
    }
    
    func registerListener(_ listener: FullScreenDetectorListener & NSObject) {
        guard !listenerList.contains(where: { $0.value === listener }) else { return }
        SPARK_LOG_DEBUG("listener:\(listener.className)")
        let weakListener = Weak<NSObject>(value: listener)
        listenerList.append(weakListener)
        
        showWindow(nil)
        mIsFullScreen = isFullScreen()
    }
    
    func unregisterListener(_ listener: FullScreenDetectorListener & NSObject) {
        SPARK_LOG_DEBUG("listener:\(listener.className)")
        listenerList.removeAll { $0.value === listener || $0.value == nil }
        
        if listenerList.isEmpty {
            close()
        }
    }
    
    @objc func onActiveSpaceDidChangeNotification(notification: NSNotification) {
        guard isFullScreen() != mIsFullScreen  else { return }
        mIsFullScreen = isFullScreen()
        for weakListener in listenerList {
            if let listener = weakListener.value as? FullScreenDetectorListener {
                listener.fullScreenDetectorFullScreenStateChanged(mIsFullScreen)
            }
        }
    }
}
