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
    var canAnimation: Bool { get }
    func startAnimationForSizeChanged()
}

protocol EdgeCollaborator: AnyObject {
    func updateEdge(edge: Edge)
}

typealias ILocalShareControlBarWindowController = LocalShareControlBarWindowControllerProtocol & ShareManagerComponentSetup & BaseWindowController

protocol LocalShareControlBarWindowControllerProtocol: AnyObject {
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

class LocalShareControlBarWindowController: BaseWindowController {
    @IBOutlet weak var contenView: NSView!
    @IBOutlet weak var mouseTrackView: MouseTrackView!
    
    typealias Position = (edge: Edge, deviation: CGFloat)
    private var positionMap = [ScreenId: Position]()
    private var isMouseDown = false
    private var mouseDownLocation: CGPoint = . zero
    private var edgeInDrag: Edge?
    
    private weak var shareComponent: ShareManagerComponentProtocol?
    private var sharedScreenUuid: ScreenId { shareComponent?.shareContext.screenToDraw.uuid() ?? "" }
    private var screenAdapter: SparkScreenAdapterProtocol
    
    private lazy var horizontalViewController: ILocalShareControlHorizontalBarViewController = appContext.shareFactory.makeLocalShareControlHorizontalBarViewController()
    private lazy var verticalViewController: ILocalShareControlVerticalBarViewController = appContext.shareFactory.makeLocalShareControlVerticalBarViewController()
    private weak var currentViewController: (WindowAnimationCollaborator & LocalShareControlBarViewControllerProtocol)?
    
    override var windowNibName: NSNib.Name? { "LocalShareControlBarWindowController" }
    
    override init(appContext: AppContext) {
        screenAdapter = appContext.screenAdapter
        super.init(appContext: appContext)
        
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
        
        horizontalViewController.animator = self
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
    
    private func switchContentView(edge: Edge) {
        switch edge {
        case .top, .bottom:
            verticalViewController.view.removeFromSuperview()
            contenView.addSubviewAndFill(subview: horizontalViewController.view)
            currentViewController = horizontalViewController
        case .right, .left:
            horizontalViewController.view.removeFromSuperview()
            contenView.addSubviewAndFill(subview: verticalViewController.view)
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
}

extension LocalShareControlBarWindowController: LocalShareControlBarWindowControllerProtocol {
}

extension LocalShareControlBarWindowController: ShareManagerComponentListener {
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onSharingContentChanged sharingContent: CHSharingContent) {
        switchContentView(edge: getPosition(screen: sharedScreenUuid).edge)
        updateFrame(animate: false)
    }
}

extension LocalShareControlBarWindowController: ShareManagerComponentSetup {
    func setup(shareComponent: ShareManagerComponentProtocol) {
        self.shareComponent = shareComponent
        
        shareComponent.registerListener(self)
        
        horizontalViewController.setup(shareComponent: shareComponent)
        verticalViewController.setup(shareComponent: shareComponent)
        switchContentView(edge: .top)
    }
}

extension LocalShareControlBarWindowController: WindowAnimator {
    var canAnimation: Bool { !isMouseDown }
    
    func startAnimationForSizeChanged() {
        guard let window = window else { return }
        let newSize = horizontalViewController.getFittingSize()
        SPARK_LOG_DEBUG("\(newSize)")
        let screenFrame = getScreenFrame()
        var windowFrame = window.frame
        let position = getPosition(screen: sharedScreenUuid)
        Geometry.resizeAndKeepSnap(&windowFrame, newSize: newSize, edge: position.edge, outer: screenFrame)
        Geometry.move(&windowFrame, into: screenFrame)
        currentViewController?.windowWillStartAnimation()
        window.setFrame(windowFrame, display: true, animate: true)
        currentViewController?.windowDidStopAnimation()
    }
}

extension LocalShareControlBarWindowController: MouseTrackViewDelegate {
    func mouseTrackViewMouseDown(with event: NSEvent) {
        mouseDownLocation = event.locationInWindow
        isMouseDown = true
    }
    
    func mouseTrackViewMouseUp(with event: NSEvent) {
        isMouseDown = false
        updatePosition(mouseUpLocation: NSEvent.mouseLocation)
    }
    
    func mouseTrackViewMouseDragged(with event: NSEvent) {
        guard isMouseDown, let window = window else { return }
        let screenFrame = getScreenFrame()
        var windowFrame = window.frame
        var mouseLocation = NSEvent.mouseLocation
        Geometry.convertCoordinateOrigin(&mouseLocation, to: screenFrame.origin)
        let edge = Geometry.getSnapEdge(point: mouseLocation, of: screenFrame)
        if edgeInDrag != edge {
            switchContentView(edge: edge)
            edgeInDrag = edge
        } else
        {
            windowFrame.origin = NSMakePoint(NSEvent.mouseLocation.x - mouseDownLocation.x, NSEvent.mouseLocation.y - mouseDownLocation.y)
        }
        
        Geometry.move(&windowFrame, into: screenFrame)
        
        window.setFrame(windowFrame, display: true, animate: false)
    }
    
    private func updateFrame(animate: Bool) {
        guard let window = window else { return }
        let position = getPosition(screen: sharedScreenUuid)
        
        let screenFrame = getScreenFrame()
        var windowFrame = window.frame
        
        Geometry.snap(&windowFrame, to: position.edge, of: screenFrame)
        
        switch position.edge {
        case .top, .bottom:
            windowFrame.origin.x = screenFrame.minX + screenFrame.width * position.deviation - windowFrame.width / 2
        case .left, .right:
            windowFrame.origin.y = screenFrame.minY + screenFrame.height * position.deviation - windowFrame.height / 2
        }
        Geometry.move(&windowFrame, into: screenFrame)
        
        horizontalViewController.updateEdge(edge: position.edge)
        verticalViewController.updateEdge(edge: position.edge)
        window.setFrame(windowFrame, display: true, animate: animate)
    }
    
    private func updatePosition(mouseUpLocation: NSPoint) {
        guard let window = window, sharedScreenUuid == window.screen?.uuid() else { return }
        let screenFrame = getScreenFrame()
        
        var mouseRelativeLocation = mouseUpLocation
        Geometry.convertCoordinateOrigin(&mouseRelativeLocation, to: screenFrame.origin)
        let edge = Geometry.getSnapEdge(point: mouseRelativeLocation, of: screenFrame)
        
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
