//
//  ImmersiveShareFlaotingVideoWindowController.swift
//  WebexTeams
//
//  Created by Archie You on 2021/12/13.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa
import CommonHead

typealias IImmersiveShareFlaotingVideoWindowController = ImmersiveShareFlaotingVideoWindowControllerProtocol & BaseWindowController

protocol ImmersiveShareFlaotingVideoWindowControllerProtocol: ShareManagerComponentSetup & ShareManagerComponentListener {
}

class ImmersiveShareFlaotingVideoWindowController: IImmersiveShareFlaotingVideoWindowController {
    @IBOutlet weak var mouseTrackView: MouseTrackView!
    
    private let shareFactory: ShareFactoryProtocol
    private weak var shareComponent: ShareManagerComponentProtocol?
    private lazy var videoViewController: IImmersiveShareLocalVideoViewController = shareFactory.makeImmersiveShareLocalVideoViewController(callId: shareComponent?.callId ?? "")
    
    private var outerFrame: CGRect = .zero
    private var mouseDownLocation: CGPoint = . zero
    private var isMouseDown = false
    
    override var windowNibName: NSNib.Name? { "ImmersiveShareFlaotingVideoWindowController" }
    override init(appContext: AppContext) {
        self.shareFactory = appContext.shareFactory
        super.init(appContext: appContext)
        
        let _ = window
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        shareComponent?.unregisterListener(self)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.styleMask = .borderless
        window?.backgroundColor = .black
        window?.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window?.hasShadow = false
        window?.level = .floating
        
        mouseTrackView.mouseTrackDelegate = self
        mouseTrackView.shouldAcceptsFirstMouse = true
    }
    
    override func setThemeColors() {
        super.setThemeColors()
    }
    
    override func showWindow(_ sender: Any?) {
        guard shareComponent != nil else { return }
        super.showWindow(sender)
        if videoViewController.view.window == nil {
            window?.contentView?.addSubviewAndFill(subview: videoViewController.view)
        }
    }
    
    override func close() {
        super.close()
    }
    
    private func updateOuterFrame() {
        guard let shareComponent = shareComponent else { return outerFrame = .zero }
        outerFrame = shareComponent.shareContext.captureRect
        
    }
    
    //MARK: ShareManagerComponentSetup
    func setup(shareComponent: ShareManagerComponentProtocol) {
        self.shareComponent = shareComponent
        shareComponent.registerListener(self)
        
        updateOuterFrame()
    }
    
    //MARK: ShareManagerComponentListener
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onSharingContentChanged sharingContent: CHSharingContent) {
        updateOuterFrame()
    }
}

extension ImmersiveShareFlaotingVideoWindowController: MouseTrackViewDelegate {
    func mouseTrackViewMouseDown(with event: NSEvent) {
        mouseDownLocation = event.locationInWindow
        isMouseDown = true
    }
    
    func mouseTrackViewMouseUp(with event: NSEvent) {
        isMouseDown = false
    }
    
    func mouseTrackViewMouseDragged(with event: NSEvent) {
        guard isMouseDown, let window = window else { return }

        var windowFrame = window.frame
        let originY = NSEvent.mouseLocation.y - mouseDownLocation.y
        windowFrame.origin = NSMakePoint(NSEvent.mouseLocation.x - mouseDownLocation.x, originY)
        windowFrame = windowFrame.move(into: outerFrame)
        window.setFrame(windowFrame, display: false, animate: false)
    }
}
