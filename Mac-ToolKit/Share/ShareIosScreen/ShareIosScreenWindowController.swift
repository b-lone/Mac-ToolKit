//
//  ShareIosScreenWindowController.swift
//  Webex
//
//  Created by Archie You on 2021/7/11.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

typealias IShareIosScreenWindowController = NSWindowController & ShareIosScreenWindowControllerProtocol

protocol ShareIosScreenWindowControllerProtocol {
    func setup(iosScreenCaptureManager: ShareIosScreenCaptureManagerProtocol)
    var previewRatio: CGFloat? { get set }
    var windowTitle: String { get set }
    func showWindow(screen: ScreenId?)
}

class CanBecomeKeyWindow: NSWindow {
    override var canBecomeKey: Bool { true }
}

class ShareIosScreenWindowController: NSWindowController {
    override var windowNibName: NSNib.Name? { "ShareIosScreenWindowController" }
    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var previewView: NSView!

    var previewRatio: CGFloat? {
        willSet {
            if let frame = window?.frame, let previewRatio = previewRatio {
                frameMap[previewRatio] = frame
            }
        }
        didSet {
            if oldValue != previewRatio {
                updateWindowFrame()
            }
        }
    }
    
    var windowTitle: String {
        get { window?.title ?? "" }
        set { window?.title = newValue }
    }
    
    private var frameMap = [CGFloat: NSRect]()
    private var sharedScreenUuid: ScreenId?
    
    private var mouseDownLocation: NSPoint = .zero
    private var isMouseDown: Bool = false
    
    private let miniSideLenth: CGFloat = 200
    
    init() {
        super.init(window: nil)
        window?.setContentSize(.zero)
        window?.orderBack(nil)
        if let windowNumber = window?.windowNumber {
            NotificationCenter.default.post(name: Notification.Name(rawValue: OnShareShouldExcludeWindow), object: self, userInfo: ["windowNumber": windowNumber, "onlyExcludeFromShareSourceList": true])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        
        contentView.wantsLayer = true
        contentView.layer?.borderWidth = 1
        contentView.layer?.borderColor = .black
        
        previewView.wantsLayer = true
        
        window?.delegate = self
        window?.styleMask.insert(.resizable)
        window?.backgroundColor = .clear
        window?.hasShadow = true
    }
    
    override func mouseDown(with event: NSEvent) {
        mouseDownLocation = event.locationInWindow
        isMouseDown = true
    }
    
    override func mouseUp(with event: NSEvent) {
        isMouseDown = false
    }
    
    override func mouseDragged(with event: NSEvent) {
        guard isMouseDown else { return }
        let origin = NSMakePoint(NSEvent.mouseLocation.x - mouseDownLocation.x, NSEvent.mouseLocation.y - mouseDownLocation.y)
        window?.setFrameOrigin(getAdjustedWindowOrigin(origin))
    }
    
    private func getAdjustedWindowOrigin(_ newOrigin: NSPoint) -> NSPoint {
        guard let frame = window?.frame else { return .zero }
        var result = newOrigin
        let screenFrame = NSScreen.screen(uuid: sharedScreenUuid).visibleFrame
        if newOrigin.x < screenFrame.minX {
            result.x = screenFrame.minX
        }
        if newOrigin.y < screenFrame.minY {
            result.y = screenFrame.minY
        }
        if newOrigin.x + frame.width > screenFrame.maxX {
            result.x = screenFrame.maxX - frame.width
        }
        if newOrigin.y + frame.height > screenFrame.maxY {
            result.y = screenFrame.maxY - frame.height
        }
        return result
    }
    
    private func getSizeKeepRatio(_ size: NSSize) -> NSSize {
        var result = size
        if let previewRatio = previewRatio {
            let width = round(size.height * previewRatio)
            let height = round(size.width / previewRatio)
            result = NSMakeSize(min(size.width, width), min(size.height, height))
            if result.width < miniSideLenth || result.height < miniSideLenth  {
                if previewRatio >= 1 {
                    result = NSMakeSize(miniSideLenth * previewRatio, miniSideLenth)
                } else {
                    result = NSMakeSize(miniSideLenth, miniSideLenth / previewRatio)
                }
                
            }
        } else {
            result.width = max(miniSideLenth, size.width)
            result.height = max(miniSideLenth, size.height)
        }
        return result
        
    }
    
    private func updateWindowFrame() {
        guard let window = window else { return }
        if let previewRatio = previewRatio, let frame = frameMap[previewRatio]  {
            window.setFrame(frame, display: true, animate: true)
        } else {
            let screenFrame = NSScreen.screen(uuid: sharedScreenUuid).frame
            let size = getSizeKeepRatio(NSMakeSize(screenFrame.width * 0.6, screenFrame.height * 0.6))
            let frame = NSMakeRect(screenFrame.minX + (screenFrame.width - size.width) / 2,
                                   screenFrame.minY + (screenFrame.height - size.height) / 2,
                                   size.width,
                                   size.height)
            window.setFrame(frame, display: true, animate: true)
        }
    }
}

extension ShareIosScreenWindowController: ShareIosScreenWindowControllerProtocol {
    func setup(iosScreenCaptureManager: ShareIosScreenCaptureManagerProtocol) {
        previewView.layer = iosScreenCaptureManager.captureVideoPreviewLayer
    }
    
    func showWindow(screen: ScreenId?) {
        showWindow(nil)
        sharedScreenUuid = screen
        updateWindowFrame()
    }
}

extension ShareIosScreenWindowController: NSWindowDelegate {
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        return getSizeKeepRatio(frameSize)
    }
}
