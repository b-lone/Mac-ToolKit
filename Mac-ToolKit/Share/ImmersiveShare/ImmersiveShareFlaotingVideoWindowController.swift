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
    private let drawingBoardManager: MagicDrawingBoardManagerProtocol
    private weak var shareComponent: ShareManagerComponentProtocol?
    private lazy var videoViewController: IImmersiveShareLocalVideoViewController = shareFactory.makeImmersiveShareLocalVideoViewController(callId: shareComponent?.callId ?? "")
    
    private var outerFrame: CGRect = .zero {
        didSet {
            onOuterFrameUpdated()
        }
    }
    private var resetOnceFalg = true
    private var mouseDownLocation: CGPoint = . zero
    private var isMouseDown = false
    
    override var windowNibName: NSNib.Name? { "ImmersiveShareFlaotingVideoWindowController" }
    override init(appContext: AppContext) {
        self.shareFactory = appContext.shareFactory
        self.drawingBoardManager = appContext.drawingBoardManager
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
        window?.styleMask.insert(.resizable)
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
        if videoViewController.view.window == nil {
            window?.contentView?.addSubviewAndFill(subview: videoViewController.view)
        }
        super.showWindow(sender)
        onOuterFrameUpdated()
    }
    
    override func close() {
        super.close()
    }
    
    private func resetOrigin() {
        guard let window = window else { return }
        var frame = window.frame
        frame.origin.x = outerFrame.maxX - frame.width
        frame.origin.y = outerFrame.minY
        window.setFrame(frame, display: true, animate: false)
    }
    
    private func updateOuterFrame() {
        guard let shareContext = shareComponent?.shareContext else { return outerFrame = .zero }
        if shareContext.shareSourceType == .desktop {
            return outerFrame = shareContext.screenToDraw.visibleFrame
        } else {
            let sharingWindowInfoList = drawingBoardManager.getWindowInfoList(exclude: true, onScreenOnly: true).filter {
                shareContext.sharingWindowNumberList.contains($0.windowNumber)
            }
            if !sharingWindowInfoList.isEmpty {
                outerFrame = sharingWindowInfoList[0].frame
                for windowInfo in sharingWindowInfoList[1...] {
                    outerFrame = outerFrame.union(windowInfo.frame)
                }
                
                return outerFrame = outerFrame.intersection(shareContext.screenToDraw.visibleFrame)
            }
        }
        outerFrame = .zero
    }
    
    private func onOuterFrameUpdated() {
        guard let window = window else { return }
        if outerFrame.width < 160 || outerFrame.height < 90 {
            window.close()
        } else {
            if resetOnceFalg {
                resetOnceFalg = false
                resetOrigin()
            }
            window.setFrame(window.frame.moveAndResize(into: outerFrame), display: false, animate: false)
            window.orderFront(self)
        }
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

extension ImmersiveShareFlaotingVideoWindowController: NSWindowDelegate {
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        var size = NSSize()
        size.width = min(sender.frame.maxX - outerFrame.minX, frameSize.width)
        size.height = min(sender.frame.maxY - outerFrame.minY, frameSize.height)
        return size
    }
}
