//
//  LocalShareControlBarWindowController.swift
//  WebexTeams
//
//  Created by Archie You on 2021/10/12.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa
import CommonHead

protocol WindowAnimationCollaborator: AnyObject {
    func windowWillStartAnimation()
    func windowDidStopAnimation()
    func getFittingSize() -> NSSize
}

protocol WindowAnimator: AnyObject {
    func startAnimationForSizeChanged()
}

protocol WindowDragCollaborator: AnyObject {
    func windowWillStartDrag()
    func windowDidStopDrag()
}

protocol EdgeCollaborator: AnyObject {
    func updateEdge(edge: Edge)
}

typealias ILocalShareControlBarWindowController = LocalShareControlBarWindowControllerProtocol & NSWindowController

protocol LocalShareControlBarWindowControllerProtocol: ShareManagerComponentSetup, ShareManagerComponentListener {
}

class CanBecomeKeyPanel: NSPanel {
    override var canBecomeKey: Bool { true }
}

extension Edge {
    var cornerDirection: SparkDirection {
        switch self {
        case .top:
            return .down
        case .bottom:
            return .up
        case .right:
            return .left
        case .left:
            return .right
        }
    }
    
    var vmPosition: CHDragPosition {
        switch self {
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .right:
            return .right
        case .left:
            return .left
        }
    }
}

class LocalShareControlBarWindowController: ILocalShareControlBarWindowController {
    @IBOutlet weak var contenView: NSView!
    @IBOutlet weak var mouseTrackView: MouseTrackView!
    
    typealias Position = (edge: Edge, deviation: CGFloat)
    private var positionMap = [ScreenId: Position]()
    private var isMouseDown = false
    private var mouseDownLocation: CGPoint = . zero
    private var edgeInDrag: Edge?
    private var windowWillStartDragFlag = false
    private var isInFullScreenSpaceWithoutCameraHousing = false
    
    private weak var shareComponent: ShareManagerComponentProtocol?
    private let telemetryManager: CHShareTelemetryManagerProtocol
    private var sharedScreenUuid: ScreenId? { shareComponent?.shareContext.screenToDraw.uuid() }
    private var isImOnlyShareForAccept = true
    private let screenAdapter: SparkScreenAdapterProtocol
    private let shareFactory: ShareFactoryProtocol
    private let fullScreenDetector: FullScreenDetectorProtocol
    
    private var horizontalViewController: ILocalShareControlBarViewController?
    private var verticalViewController: ILocalShareControlBarViewController?
    private weak var currentViewController: ILocalShareControlBarViewController?
    
    override var windowNibName: NSNib.Name? { "LocalShareControlBarWindowController" }
    
    init(shareFactory: ShareFactoryProtocol, screenAdapter: SparkScreenAdapterProtocol, telemetryManager: CHShareTelemetryManagerProtocol) {
        self.shareFactory = shareFactory
        self.screenAdapter = screenAdapter
        self.fullScreenDetector = shareFactory.makeFullScreenDetector()
        self.telemetryManager = telemetryManager
        super.init(window: nil)
        
        _ = window
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        SPARK_LOG_DEBUG("")
        shareComponent?.unregisterListener(self)
        fullScreenDetector.unregisterListener(self)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.styleMask = [.borderless, .nonactivatingPanel]
        window?.backgroundColor = .clear
        window?.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window?.hasShadow = false
        if let panel = window as? NSPanel {
            panel.worksWhenModal = true
            panel.isFloatingPanel = true
        }
        
        mouseTrackView.mouseTrackDelegate = self
        mouseTrackView.shouldAcceptsFirstMouse = true
        
        fullScreenDetector.registerListener(self)
        isInFullScreenSpaceWithoutCameraHousing = fullScreenDetector.isFullScreen()
        updateWindowLevel()
    }
    
    override func showWindow(_ sender: Any?) {
        updateFrame(animate: false)
        super.showWindow(self)

        SPARK_LOG_DEBUG("")
    }
    
    override func close() {
        super.close()
        SPARK_LOG_DEBUG("")
    }
    
    private func updateWindowLevel() {
        window?.level = isInFullScreenSpaceWithoutCameraHousing ? .popUpMenu + 1 : .floating + 2
    }
    
    private func makeLocalShareControlBarViewController(orientation: Orientation) -> ILocalShareControlBarViewController {
        let viewController =  shareFactory.makeLocalShareControlBarViewController(orientation: orientation)
        viewController.animator = self
        if let shareComponent = shareComponent {
            viewController.setup(shareComponent: shareComponent)
        }
        return viewController
    }
    
    private func switchContentView(edge: Edge) {
        switch edge {
        case .top, .bottom:
            verticalViewController?.view.removeFromSuperview()
            let viewController = horizontalViewController ?? makeLocalShareControlBarViewController(orientation: .horizontal)
            horizontalViewController = viewController
            contenView.addSubviewAndFill(subview: viewController.view)
            currentViewController = horizontalViewController
        case .right, .left:
            horizontalViewController?.view.removeFromSuperview()
            let viewController = verticalViewController ?? makeLocalShareControlBarViewController(orientation: .vertical)
            verticalViewController = viewController
            contenView.addSubviewAndFill(subview: viewController.view)
            currentViewController = verticalViewController
        }
        currentViewController?.updateEdge(edge: edge)
    }
    
    private func getScreenFrame() -> NSRect {
        if isInFullScreenSpaceWithoutCameraHousing {
            return screenAdapter.screen(uuid: sharedScreenUuid).frame
        } else {
            return screenAdapter.screen(uuid: sharedScreenUuid).visibleFrame
        }
    }
    
    private func getOrientation(edge: Edge) -> Orientation {
        switch edge {
        case .top, .bottom:
            return .horizontal
        case .right, .left:
            return .vertical
        }
    }
    
    private func getPosition(screen: ScreenId) -> Position {
        var result: Position = (edge: Edge.top, deviation: 0.5)
        if let position = positionMap[screen] {
            result = position
        } else {
            positionMap[screen] = result
        }
        SPARK_LOG_DEBUG("[\(screen)](\(result.edge.rawValue):\(result.deviation))")
        return result
    }
    
    private func recordPositionTelemetry(_ newEdge: Edge) {
        if let sharedScreenUuid = sharedScreenUuid, let position = positionMap[sharedScreenUuid], position.edge != newEdge, let callId = shareComponent?.callId {
            telemetryManager.recordControlBarDragPosition(callId: callId, position: newEdge.vmPosition)
        }
    }
    
    //MARK: ShareManagerComponentListener
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onSharingContentChanged sharingContent: CHSharingContent) {
        if let sharedScreenUuid = sharedScreenUuid {
            switchContentView(edge: getPosition(screen: sharedScreenUuid).edge)
        }
        updateFrame(animate: false)
    }
    
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onLocalShareControlBarInfoChanged info: CHLocalShareControlBarInfo) {
        isImOnlyShareForAccept = info.isImOnlyShareForAccept
    }
    
    //MARK: ShareManagerComponentSetup
    func setup(shareComponent: ShareManagerComponentProtocol) {
        self.shareComponent = shareComponent
        
        shareComponent.registerListener(self)
        isImOnlyShareForAccept = shareComponent.getLocalShareControlBarInfo()?.isImOnlyShareForAccept ?? true
        
        horizontalViewController?.setup(shareComponent: shareComponent)
        verticalViewController?.setup(shareComponent: shareComponent)
        switchContentView(edge: .top)
    }
}

extension LocalShareControlBarWindowController: WindowAnimator {
    func startAnimationForSizeChanged() {
        guard let window = window, let currentViewController = currentViewController, let sharedScreenUuid = sharedScreenUuid else { return }
        let newSize = currentViewController.getFittingSize()
        SPARK_LOG_DEBUG("\(newSize)")
        let screenFrame = getScreenFrame()
        var windowFrame = window.frame
        let position = getPosition(screen: sharedScreenUuid)
        windowFrame = windowFrame.resizeAndKeepSnap(newSize: newSize, edge: position.edge, outer: screenFrame)
        windowFrame = windowFrame.move(into: screenFrame)
        currentViewController.windowWillStartAnimation()
        window.setFrame(windowFrame, display: true, animate: true)
        currentViewController.windowDidStopAnimation()
    }
}

extension LocalShareControlBarWindowController: MouseTrackViewDelegate {
    func mouseTrackViewMouseDown(with event: NSEvent) {
        mouseDownLocation = event.locationInWindow
        isMouseDown = true
        
        if event.clickCount == 2 {
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    func mouseTrackViewMouseUp(with event: NSEvent) {
        isMouseDown = false
        updatePosition(mouseUpLocation: NSEvent.mouseLocation)
        
        if windowWillStartDragFlag {
            horizontalViewController?.windowDidStopDrag()
            verticalViewController?.windowDidStopDrag()
            windowWillStartDragFlag = false
        }
    }
    
    func mouseTrackViewMouseDragged(with event: NSEvent) {
        guard isMouseDown, let window = window else { return }
        
        if !windowWillStartDragFlag {
            horizontalViewController?.windowWillStartDrag()
            verticalViewController?.windowWillStartDrag()
            windowWillStartDragFlag = true
        }

        let screenFrame = getScreenFrame()
        var windowFrame = window.frame
        let originY = isImOnlyShareForAccept ? window.frame.minY : NSEvent.mouseLocation.y - mouseDownLocation.y
        windowFrame.origin = NSMakePoint(NSEvent.mouseLocation.x - mouseDownLocation.x, originY)
        windowFrame = windowFrame.move(into: screenFrame)
        window.setFrame(windowFrame, display: false, animate: false)
        
        let mouseLocation = NSEvent.mouseLocation.convertCoordinateOrigin(to: screenFrame.origin)
        let edge = isImOnlyShareForAccept ? .top : mouseLocation.getSnapEdge(of: screenFrame)
        if edgeInDrag != edge {
            switchContentView(edge: edge)
            edgeInDrag = edge
        }
    }
    
    private func updateFrame(animate: Bool) {
        guard let window = window, let sharedScreenUuid = sharedScreenUuid else { return }
        let position = getPosition(screen: sharedScreenUuid)
        
        let screenFrame = getScreenFrame()
        var windowFrame = window.frame.snap(to: position.edge, of: screenFrame)
        
        switch position.edge {
        case .top, .bottom:
            windowFrame.origin.x = screenFrame.minX + screenFrame.width * position.deviation - windowFrame.width / 2
        case .left, .right:
            windowFrame.origin.y = screenFrame.minY + screenFrame.height * position.deviation - windowFrame.height / 2
        }
        windowFrame = windowFrame.move(into: screenFrame)
        
        currentViewController?.updateEdge(edge: position.edge)
        window.setFrame(windowFrame, display: true, animate: animate)
    }
    
    private func updatePosition(mouseUpLocation: NSPoint) {
        guard let window = window, let sharedScreenUuid = sharedScreenUuid, sharedScreenUuid == window.screen?.uuid() else { return }
        let screenFrame = getScreenFrame()
        
        let mouseRelativeLocation = mouseUpLocation.convertCoordinateOrigin(to: screenFrame.origin)
        let edge = isImOnlyShareForAccept ? .top : mouseRelativeLocation.getSnapEdge(of: screenFrame)
        
        let windowFrame =  window.frame
        var deviation: CGFloat = 0
        switch edge {
        case .bottom, .top:
            deviation = (windowFrame.center.x - screenFrame.minX) / screenFrame.width
        case .left, .right:
            deviation = (windowFrame.center.y - screenFrame.minY) / screenFrame.height
            
        }
        
        recordPositionTelemetry(edge)
        
        positionMap[sharedScreenUuid] = (edge: edge, deviation: deviation)
        updateFrame(animate: true)
    }
}

extension LocalShareControlBarWindowController: FullScreenDetectorListener {
    func fullScreenDetectorFullScreenStateChanged(_ isFullScreen: Bool) {
        var hasCameraHousing = false
        if #available(macOS 12.0, *) {
            hasCameraHousing = screenAdapter.screen(uuid: sharedScreenUuid).safeAreaInsets.top > 0
        }
        isInFullScreenSpaceWithoutCameraHousing = isFullScreen && !hasCameraHousing
      
        SPARK_LOG_DEBUG("hasCameraHousing:\(hasCameraHousing) isFullScreen:\(isFullScreen)")
        window?.level = .popUpMenu + 1
        updateFrame(animate: true)
        updateWindowLevel()
    }
}
