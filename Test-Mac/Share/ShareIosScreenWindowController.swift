//
//  ShareIosScreenWindowController.swift
//  Test-Mac
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
    
    private var previewRatio:CGFloat = 1680 / 1050 {
        didSet {
            if oldValue != previewRatio {
                updateWindowSize()
            }
        }
    }
    
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
        updateWindowSize()
    }
    
    private func getSizeKeepRatio(_ size: NSSize) -> NSSize {
        let width = size.height * previewRatio
        let height = size.width / previewRatio
        return NSMakeSize(min(size.width, width), min(size.height, height))
    }
    
    private func updateWindowSize() {
        guard let window = window else { return }
        guard let screen = window.screen ?? NSScreen.main else { return }
        let screenFrame = screen.frame
        let size = getSizeKeepRatio(NSMakeSize(screenFrame.height * 0.8, screenFrame.height * 0.8))
        window.animator().setContentSize(getSizeKeepRatio(size))
        window.animator().center()
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
