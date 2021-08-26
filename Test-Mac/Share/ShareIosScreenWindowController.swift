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
    var iosScreenCaptureManager: ShareIosScreenCaptureManagerProtocol { get }
}

class ShareIosScreenWindow: NSWindow {
    override var canBecomeKey: Bool { true }
}

class ShareIosScreenWindowController: NSWindowController {
    override var windowNibName: NSNib.Name? { "ShareIosScreenWindowController" }
    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var previewView: NSView!
    let iosScreenCaptureManager: ShareIosScreenCaptureManagerProtocol = ShareIosScreenCaptureManager()
    
    private var previewRatio:CGFloat? {
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
    
    private var frameMap = [CGFloat: NSRect]()
    
    init() {
        super.init(window: nil)
        let _ = window
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        
        contentView.wantsLayer = true
        contentView.layer?.cornerRadius = 8
        
        previewView.wantsLayer = true
        previewView.layer = iosScreenCaptureManager.captureVideoPreviewLayer
        
        iosScreenCaptureManager.delegate = self
        window?.delegate = self
        window?.styleMask.insert(.resizable)
        window?.backgroundColor = .clear
        window?.hasShadow = true
        window?.isMovableByWindowBackground = true
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
    }
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        updateWindowFrame()
    }
    
    private func getSizeKeepRatio(_ size: NSSize) -> NSSize {
        guard let previewRatio = previewRatio else { return size }
        let width = floor(size.height * previewRatio)
        let height = floor(size.width / previewRatio)
        return NSMakeSize(min(size.width, width), min(size.height, height))
    }
    
    private func updateWindowFrame() {
        guard let window = window else { return }
        if let previewRatio = previewRatio, let frame = frameMap[previewRatio]  {
            window.setFrame(frame, display: true, animate: true)
        } else if let screen = window.screen ?? NSScreen.main {
            let screenFrame = screen.frame
            let size = getSizeKeepRatio(NSMakeSize(screenFrame.width * 0.8, screenFrame.height * 0.8))
            window.animator().setContentSize(size)
            window.animator().center()
        }
    }
}

extension ShareIosScreenWindowController: ShareIosScreenWindowControllerProtocol {
}

extension ShareIosScreenWindowController: NSWindowDelegate {
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        return getSizeKeepRatio(frameSize)
    }
}

extension ShareIosScreenWindowController: ShareIosScreenCaptureManagerDelegate {
    func shareIosScreenCaptureManager(_ manager: ShareIosScreenCaptureManager, onIosDeviceAvailableChanged isAvailable: Bool) {
    }
    
    func shareIosScreenCaptureManager(_ manager: ShareIosScreenCaptureManager, onPreviewSizeChanged size: NSSize) {
        previewRatio = size.width / size.height
    }
    
    func shareIosScreenCaptureManager(_ manager: ShareIosScreenCaptureManager, onCaptureSessionStateChanged isRunning: Bool) {
        if isRunning {
            window?.title = iosScreenCaptureManager.deviceName ?? ""
        }
    }
}
