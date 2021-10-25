//
//  ShareIosScreenManager.swift
//  WebexTeams
//
//  Created by Archie You on 2021/8/30.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa

protocol ShareIosScreenManagerProtocol {
    var isSharingIosScreen: Bool { get set }
    func setup(shareComponent: ShareManagerComponentProtocol)
    func start()
    func stop()
    
    func getPreviewWindow() -> NSWindow?
}

class ShareIosScreenManager: NSObject {
    private lazy var playingWindowController: IShareIosScreenWindowController = shareFactory.makeShareIosScreenWindowController()
    private lazy var promptWindowController: IShareIosScreenPromptWindowController = shareFactory.makeShareIosScreenPromptWindowController()
    private lazy var iosScreenCaptureManager: ShareIosScreenCaptureManagerProtocol = ShareIosScreenCaptureManager()
    
    private var isStarted = false
    var isSharingIosScreen = false {
        didSet {
            switchWindow()
        }
    }
    
    private var shareFactory: ShareFactoryProtocol
    private weak var shareComponent: ShareManagerComponentProtocol?
    
    init(shareFactory: ShareFactoryProtocol) {
        self.shareFactory = shareFactory
        super.init()
        iosScreenCaptureManager.delegate = self
    }
    
    private func switchWindow() {
        guard isStarted, let shareComponent = shareComponent else {
            playingWindowController.close()
            promptWindowController.close()
            return
        }
        
        if iosScreenCaptureManager.isIosDeviceAvailable {
            playingWindowController.showWindow(screen: shareComponent.shareContext.screenToDraw.uuid())
        } else {
            playingWindowController.close()
        }
        
        if !iosScreenCaptureManager.isIosDeviceAvailable, isSharingIosScreen {
            promptWindowController.showWindow(screen: shareComponent.shareContext.screenToDraw.uuid())
        } else {
            promptWindowController.close()
        }
    }
}

extension ShareIosScreenManager: ShareIosScreenManagerProtocol {
    func setup(shareComponent: ShareManagerComponentProtocol) {
        self.shareComponent = shareComponent
    }
    
    func start() {
        guard !isStarted else { return }
        isStarted = true
        playingWindowController.setup(iosScreenCaptureManager: iosScreenCaptureManager)
        iosScreenCaptureManager.start()
        switchWindow()
    }
    
    func stop() {
        guard isStarted else { return }
        isStarted = false
        iosScreenCaptureManager.stop()
        switchWindow()
    }
    
    func getPreviewWindow() -> NSWindow? {
        return playingWindowController.window
    }
}

extension ShareIosScreenManager: ShareIosScreenCaptureManagerDelegate {
    func shareIosScreenCaptureManager(_ manager: ShareIosScreenCaptureManager, onIosDeviceAvailableChanged isAvailable: Bool) {
        switchWindow()
    }
    
    func shareIosScreenCaptureManager(_ manager: ShareIosScreenCaptureManager, onPreviewSizeChanged size: NSSize) {
        playingWindowController.previewRatio = size.width / size.height
    }
    
    func shareIosScreenCaptureManager(_ manager: ShareIosScreenCaptureManager, onCaptureSessionStateChanged isRunning: Bool) {
        if isRunning {
            playingWindowController.windowTitle = iosScreenCaptureManager.deviceName ?? ""
        }
    }
}
