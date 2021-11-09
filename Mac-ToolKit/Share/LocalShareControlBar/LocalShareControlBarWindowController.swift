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
}

class LocalShareControlBarWindowController: ILocalShareControlBarWindowController {
    @IBOutlet weak var contenView: NSView!
    @IBOutlet weak var mouseTrackView: MouseTrackView!
    
    typealias Position = (edge: Edge, deviation: CGFloat)
    private var positionMap = [ScreenId: Position]()
    private var isMouseDown = false
    private var mouseDownLocation: CGPoint = . zero
    private var edgeInDrag: Edge?
    
    private weak var shareComponent: ShareManagerComponentProtocol?
    private var sharedScreenUuid: ScreenId { shareComponent?.shareContext.screenToDraw.uuid() ?? "" }
    private let screenAdapter: SparkScreenAdapterProtocol
    private let shareFactory: ShareFactoryProtocol
    
    private var horizontalViewController: ILocalShareControlBarViewController?
    private var verticalViewController: ILocalShareControlBarViewController?
    private weak var currentViewController: ILocalShareControlBarViewController?
    
    override var windowNibName: NSNib.Name? { "LocalShareControlBarWindowController" }
    
    init(shareFactory: ShareFactoryProtocol, screenAdapter: SparkScreenAdapterProtocol) {
        self.shareFactory = shareFactory
        self.screenAdapter = screenAdapter
        super.init(window: nil)
        
        let _ = window
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        SPARK_LOG_DEBUG("")
        shareComponent?.unregisterListener(self)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.styleMask = [.borderless, .nonactivatingPanel]
        window?.backgroundColor = .clear
        window?.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window?.hasShadow = false
        window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.floatingWindow)) + 2)
        if let panel = window as? NSPanel {
            panel.worksWhenModal = true
            panel.isFloatingPanel = true
        }
        
        mouseTrackView.mouseTrackDelegate = self
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
        screenAdapter.screen(uuid: sharedScreenUuid).visibleFrame
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
        return result
    }
    
    //MARK: ShareManagerComponentListener
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onSharingContentChanged sharingContent: CHSharingContent) {
        switchContentView(edge: getPosition(screen: sharedScreenUuid).edge)
        updateFrame(animate: false)
    }
    
    //MARK: ShareManagerComponentSetup
    func setup(shareComponent: ShareManagerComponentProtocol) {
        self.shareComponent = shareComponent
        
        shareComponent.registerListener(self)
        
        horizontalViewController?.setup(shareComponent: shareComponent)
        verticalViewController?.setup(shareComponent: shareComponent)
        switchContentView(edge: .top)
    }
}

extension LocalShareControlBarWindowController: WindowAnimator {
    func startAnimationForSizeChanged() {
        guard let window = window, let currentViewController = currentViewController else { return }
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
        
        horizontalViewController?.windowWillStartDrag()
        verticalViewController?.windowWillStartDrag()
    }
    
    func mouseTrackViewMouseUp(with event: NSEvent) {
        isMouseDown = false
        updatePosition(mouseUpLocation: NSEvent.mouseLocation)
        
        horizontalViewController?.windowDidStopDrag()
        verticalViewController?.windowDidStopDrag()
    }
    
    func mouseTrackViewMouseDragged(with event: NSEvent) {
        guard isMouseDown, let window = window else { return }

        let screenFrame = getScreenFrame()
        var windowFrame = window.frame
        windowFrame.origin = NSMakePoint(NSEvent.mouseLocation.x - mouseDownLocation.x, NSEvent.mouseLocation.y - mouseDownLocation.y)
        windowFrame = windowFrame.move(into: screenFrame)
        window.setFrame(windowFrame, display: false, animate: false)
        
        let mouseLocation = NSEvent.mouseLocation.convertCoordinateOrigin(to: screenFrame.origin)
        let edge = mouseLocation.getSnapEdge(of: screenFrame)
        if edgeInDrag != edge {
            switchContentView(edge: edge)
            edgeInDrag = edge
        }
    }
    
    private func updateFrame(animate: Bool) {
        guard let window = window else { return }
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
        guard let window = window, sharedScreenUuid == window.screen?.uuid() else { return }
        let screenFrame = getScreenFrame()
        
        let mouseRelativeLocation = mouseUpLocation.convertCoordinateOrigin(to: screenFrame.origin)
        let edge = mouseRelativeLocation.getSnapEdge(of: screenFrame)
        
        let windowFrame =  window.frame
        var deviation: CGFloat = 0
        switch edge {
        case .bottom, .top:
            deviation = (windowFrame.center.x - screenFrame.minX) / screenFrame.width
        case .left, .right:
            deviation = (windowFrame.center.y - screenFrame.minY) / screenFrame.height
            
        }
        positionMap[sharedScreenUuid] = (edge: edge, deviation: deviation)
        updateFrame(animate: true)
    }
}
