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
    @IBOutlet weak var videoContainerView: NSView!
    @IBOutlet weak var hoverContainerView: NSView!
    @IBOutlet weak var mouseTrackView: MouseTrackView!
    
    private let shareFactory: ShareFactoryProtocol
    private let drawingBoardManager: MagicDrawingBoardManagerProtocol
    private weak var shareComponent: ShareManagerComponentProtocol?
    private lazy var videoViewController: IImmersiveShareLocalVideoViewController = shareFactory.makeImmersiveShareLocalVideoViewController(callId: shareComponent?.callId ?? "")
    private lazy var hoverViewController: IImmersiveShareHoverViewController = shareFactory.makeImmersiveShareHoverViewController()
    
    private var outerFrame: CGRect = .zero {
        didSet {
            if oldValue != outerFrame {
                onOuterFrameUpdated()
            }
        }
    }
    private var mouseDownLocation: CGPoint = . zero
    private var isMouseDown = false
    private var windowFrameDuringResize: CGRect = .zero
    private var showWindow = false
    
    typealias Position = (deviationX: CGFloat, deviationY: CGFloat)
    var position: Position = (deviationX: 1, deviationY: 0)
    
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
        window?.backgroundColor = .red
        window?.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window?.styleMask.insert(.resizable)
        window?.hasShadow = false
        window?.level = .floating + 2
        
        mouseTrackView.mouseTrackDelegate = self
        mouseTrackView.shouldAcceptsFirstMouse = true
        mouseTrackView.trackingAreaOptions = [.mouseEnteredAndExited, .activeAlways, .inVisibleRect]
        
        hoverContainerView.addSubviewAndFill(subview: hoverViewController.view)
        hoverContainerView.isHidden = true
    }
    
    override func showWindow(_ sender: Any?) {
        guard shareComponent != nil else { return }
        if videoViewController.view.window == nil {
            videoContainerView.addSubviewAndFill(subview: videoViewController.view)
        }
        super.showWindow(sender)
        showWindow = true
        onOuterFrameUpdated()
    }
    
    override func close() {
        showWindow = false
        super.close()
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
                var outerFrame = sharingWindowInfoList[0].frame
                for windowInfo in sharingWindowInfoList[1...] {
                    outerFrame = outerFrame.union(windowInfo.frame)
                }
                
                return self.outerFrame = outerFrame.intersection(shareContext.screenToDraw.visibleFrame)
            }
        }
        outerFrame = .zero
    }
    
    private func onOuterFrameUpdated() {
        guard let window = window, showWindow else { return }
        SPARK_LOG_DEBUG("\(outerFrame)")
        if outerFrame.width < 160 || outerFrame.height < 90 {
            window.close()
        } else {
            updateFrame()
            window.orderFront(self)
        }
    }
    
    private func updateFrame() {
        guard var frame = window?.frame else { return }
        frame.origin.x = outerFrame.minX + outerFrame.width * position.deviationX - frame.width / 2
        frame.origin.y = outerFrame.minY + outerFrame.height * position.deviationY - frame.height / 2
        frame = frame.resizeAndMove(into: outerFrame)
        window?.setFrame(frame, display: false, animate: false)
    }
    
    private func updatePosition() {
        guard let frame = window?.frame, outerFrame.size.width != 0, outerFrame.size.height != 0 else { return }
        let deviationX = (frame.center.x - outerFrame.minX) / outerFrame.width
        let deviationY = (frame.center.y - outerFrame.minY) / outerFrame.height
        position = (deviationX, deviationY)
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
        updatePosition()
    }
    
    func mouseTrackViewMouseDragged(with event: NSEvent) {
        guard isMouseDown, let window = window else { return }

        var windowFrame = window.frame
        let originY = NSEvent.mouseLocation.y - mouseDownLocation.y
        windowFrame.origin = NSMakePoint(NSEvent.mouseLocation.x - mouseDownLocation.x, originY)
        windowFrame = windowFrame.resizeAndMove(into: outerFrame)
        window.setFrame(windowFrame, display: false, animate: false)
    }
    
    func mouseTrackViewMouseEntered(with event: NSEvent) {
        hoverContainerView.isHidden = false
    }
    
    func mouseTrackViewMouseExited(with event: NSEvent) {
        hoverContainerView.isHidden = true
    }
}

extension ImmersiveShareFlaotingVideoWindowController: NSWindowDelegate {
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        windowFrameDuringResize = sender.frame
        return frameSize
    }
    
    func windowDidResize(_ notification: Notification) {
        guard let window = window else { return }
        if !window.frame.check(in: outerFrame) {
            window.setFrame(windowFrameDuringResize, display: false, animate: false)
        }
        updatePosition()
    }
}
