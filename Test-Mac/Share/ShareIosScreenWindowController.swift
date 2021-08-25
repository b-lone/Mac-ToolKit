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

class ShareIosScreenWindowController: NSWindowController {
    override var windowNibName: NSNib.Name? { "ShareIosScreenWindowController" }
    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var previewView: NSView!
    let iosScreenCaptureManager: ShareIosScreenCaptureManagerProtocol = ShareIosScreenCaptureManager()
    
    var previewRatio:CGFloat = 1 {
        didSet {
            if let size = window?.frame.size {
                window?.animator().setContentSize(getSizeKeepRatio(size))
                window?.animator().center()
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
        
        previewView.wantsLayer = true
        previewView.layer = iosScreenCaptureManager.captureVideoPreviewLayer
        
        window?.delegate = self
        iosScreenCaptureManager.delegate = self
        
    }
    
    private func getSizeKeepRatio(_ size: NSSize) -> NSSize {
        let width = floor(size.height * previewRatio)
        let height = floor(size.width / previewRatio)
        return NSMakeSize(min(size.width, width), min(size.height, height))
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
