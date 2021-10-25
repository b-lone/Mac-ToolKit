//
//  LocalShareControlHorizontalBarViewController.swift
//  WebexTeams
//
//  Created by Archie You on 2021/10/27.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa
import UIToolkit
import CommonHead

//MARK: Base
protocol LocalShareControlBarViewControllerProtocol: AnyObject {
    func setEdge(edge: Edge)
    var animator: WindowAnimator? { get set }
}

class LocalShareControlBarViewController: NSViewController, LocalShareControlBarViewControllerProtocol, ShareManagerComponentSetup, ShareManagerComponentListener {
    weak var animator: WindowAnimator?
    
    @IBOutlet var contentView: RoundSameSideCornerView!
    private weak var shareComponent: ShareManagerComponentProtocol?
    fileprivate var shareFactory: ShareFactoryProtocol
    private var isSharePaused = false
    private var isContentBlank: Bool {
        if let shareContext = shareComponent?.shareContext {
            if shareContext.shareSourceType == .window || shareContext.shareSourceType == .application {
                return shareContext.sharingWindowNumberList.isEmpty
            } else {
                return false
            }
        }
        return true
    }
    fileprivate var edge = Edge.top
    
    init(shareFactory: ShareFactoryProtocol, nibName: NSNib.Name?) {
        self.shareFactory = shareFactory
        super.init(nibName: nibName, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        shareComponent?.unregisterListener(self)
    }
    
    override func viewDidLoad() {
        contentView.cornerRadius = 8.0
    }
    
    func setEdge(edge: Edge) {
        self.edge = edge
        contentView.cornerDirection = edge.cornerDirection
    }
    
    func setup(shareComponent: ShareManagerComponentProtocol) {
        self.shareComponent = shareComponent
        shareComponent.registerListener(self)
        
        updateBackgroundColor()
    }
    
    private func updateBackgroundColor() {
        SPARK_LOG_DEBUG("isSharePaused: \(isSharePaused), isContentBlank: \(isContentBlank)")
        contentView.backgroundColor = (!isSharePaused && !isContentBlank) ? getUIToolkitColor(token: .sharewindowBorderActive).normal : getUIToolkitColor(token: .sharewindowBorderInactive).normal
    }
    
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onLocalShareControlBarInfoChanged info: CHLocalShareControlBarInfo) {
        isSharePaused = info.isSharePaused
        updateBackgroundColor()
    }
    
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onSharingContentChanged sharingContent: CHSharingContent) {
        updateBackgroundColor()
    }
}

//MARK: Horizontal Bar
typealias ILocalShareControlHorizontalBarViewController = WindowAnimationCollaborator & LocalShareControlBarViewController

class LocalShareControlHorizontalBarViewController: LocalShareControlBarViewController {
    private enum ExpandState {
        case collapsed
        case hover
        case expended
        
        var height: CGFloat {
            switch self {
            case .collapsed:
                return 40
            case .hover:
                return 56
            case .expended:
                return 284
            }
        }
    }
    
    @IBOutlet weak var controlButtonsContainerView: NSView!
    @IBOutlet weak var previewContainerView: NSView!
    @IBOutlet weak var expandContainerView: NSView!
    @IBOutlet weak var expandButton: SparkButton!
    @IBOutlet weak var mouseTrackView: MouseTrackView!
    
    @IBOutlet var contentViewHeightConstaint: NSLayoutConstraint!
    @IBOutlet var contentViewWidthConstaint: NSLayoutConstraint!
    
    @IBOutlet var controlButtonsContainerViewTopConstraint: NSLayoutConstraint!
    private lazy var controlButtonsContainerViewBottomConstraint: NSLayoutConstraint = controlButtonsContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    @IBOutlet var expandContainerViewBottomConstraint: NSLayoutConstraint!
    private lazy var expandContainerViewTopConstraint: NSLayoutConstraint = expandContainerView.topAnchor.constraint(equalTo: contentView.topAnchor)
    @IBOutlet var previewContainerViewBottomConstraint: NSLayoutConstraint!
    private lazy var previewContainerViewTopConstraint: NSLayoutConstraint = previewContainerView.topAnchor.constraint(equalTo: expandContainerView.bottomAnchor)
    
    private lazy var controlButtonsViewController: ILocalShareControlButtonsHorizontalViewController = shareFactory.makeLocalShareControlButtonsHorizontalViewController()
    
    private var expandState = ExpandState.expended {
        didSet {
            onExpandStateUpdate()
        }
    }
    private var isExpanded: Bool { expandState == .expended }
    
    init(shareFactory: ShareFactoryProtocol) {
        super.init(shareFactory: shareFactory, nibName: "LocalShareControlHorizontalBarViewController")
        let _ = view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEdge(edge: .top)
        
        expandButton.buttonColor = getUIToolkitColor(token: .sharewindowControlButtonSecondaryBackground).normal
        expandButton.buttonHoverColor = getUIToolkitColor(token: .sharewindowControlButtonSecondaryBackground).hover
        expandButton.buttonPressedBackgroundColor = getUIToolkitColor(token: .sharewindowControlButtonSecondaryBackground).pressed
        updateExpandButtonIcon()
        
        mouseTrackView.mouseTrackDelegate = self
        mouseTrackView.trackingAreaOptions = [.activeAlways, .mouseEnteredAndExited, .inVisibleRect]
        
        previewContainerView.wantsLayer = true
        previewContainerView.layer?.backgroundColor = NSColor.blue.cgColor
        
        controlButtonsContainerView.addSubviewAndFill(subview: controlButtonsViewController.view)
    }
    
    override func setEdge(edge: Edge) {
        super.setEdge(edge: edge)
        
        if edge == .top {
            controlButtonsContainerViewTopConstraint.isActive = true
            controlButtonsContainerViewBottomConstraint.isActive = false
            expandContainerViewBottomConstraint.isActive = true
            expandContainerViewTopConstraint.isActive = false
            previewContainerViewBottomConstraint.isActive = true
            previewContainerViewTopConstraint.isActive = false
        } else if edge == .bottom {
            controlButtonsContainerViewTopConstraint.isActive = false
            controlButtonsContainerViewBottomConstraint.isActive = true
            expandContainerViewBottomConstraint.isActive = false
            expandContainerViewTopConstraint.isActive = true
            previewContainerViewBottomConstraint.isActive = false
            previewContainerViewTopConstraint.isActive = true
        }
        updateExpandButtonIcon()
    }
    
    private func updateExpandButtonIcon() {
        let font = NSFont(name: Constants.momentumRebrandIconFont, size: 8)!
        let iconColor = getUIToolkitColor(token: .sharewindowControlTextPrimary).normal
        var icon = ""
        if edge == .top {
            icon = isExpanded ? MomentumRebrandIconType.arrowUpBold.ligature : MomentumRebrandIconType.arrowDownBold.ligature
        } else if edge == .bottom {
            icon = isExpanded ? MomentumRebrandIconType.arrowDownBold.ligature : MomentumRebrandIconType.arrowUpBold.ligature
        }
        
        expandButton.attributedTitle = NSAttributedString(string: icon, attributes: [
            .font: font,
            .foregroundColor: iconColor,
        ])
        expandButton.setAccessibilityTitle(isExpanded ? LocalizationStrings.collapse : LocalizationStrings.expand)
    }
    
    private func onExpandStateUpdate() {
        animator?.startAnimationForSizeChanged()
    }
    
    private func getControlBarFittingSize() -> NSSize {
        NSMakeSize(500 , expandState.height)
    }
    
    @IBAction func onExpandButton(_ sender: Any) {
        expandState = isExpanded ? .collapsed : .expended
    }
}

extension LocalShareControlHorizontalBarViewController: MouseTrackViewDelegate {
    func mouseTrackViewMouseEntered(with event: NSEvent) {
        guard animator?.canAnimation == true else { return }
        if expandState == .collapsed {
            expandState = .hover
        }
    }
    
    func mouseTrackViewMouseExited(with event: NSEvent) {
        guard animator?.canAnimation == true else { return }
        if expandState == .hover {
            expandState = .collapsed
        }
    }
}

extension LocalShareControlHorizontalBarViewController: WindowAnimationCollaborator {
    func windowWillStartAnimation() {
        previewContainerView.isHidden = false
        expandContainerView.isHidden = false
        contentViewHeightConstaint.isActive = false
        contentViewWidthConstaint.isActive = false
    }
    
    func windowDidStopAnimation() {
        contentViewHeightConstaint.constant = expandState.height
        contentViewHeightConstaint.isActive = true
        contentViewWidthConstaint.isActive = isExpanded
        
        updateExpandButtonIcon()
        
        previewContainerView.isHidden = expandState != .expended
        expandContainerView.isHidden = expandState == .collapsed
    }
    
    func getFittingSize() -> NSSize {
        isExpanded ? NSMakeSize(408, expandState.height) : getControlBarFittingSize()
    }
}

//MARK: Vertical Bar
typealias ILocalShareControlVerticalBarViewController = WindowAnimationCollaborator & LocalShareControlBarViewController


class LocalShareControlVerticalBarViewController: LocalShareControlBarViewController {
    private lazy var controlButtonsViewController: ILocalShareControlButtonsVerticalViewContrller = shareFactory.makeLocalShareControlButtonsVerticalViewContrller()
    
    init(shareFactory: ShareFactoryProtocol) {
        super.init(shareFactory: shareFactory, nibName: "LocalShareControlVerticalBarViewController")
        let _ = view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.addSubviewAndFill(subview: controlButtonsViewController.view)
    }
}

extension LocalShareControlVerticalBarViewController: WindowAnimationCollaborator {
    func windowWillStartAnimation() {
    }
    
    func windowDidStopAnimation() {
    }
    
    func getFittingSize() -> NSSize {
        return NSMakeSize(40, 174)
    }
}

func getUIToolkitColor(tokenName: String) -> UTColorStates {
    UIToolkit.shared.getThemeManager().getColors(tokenName: tokenName)
}

func getUIToolkitColor(token: UTColorTokens) -> UTColorStates {
    UIToolkit.shared.getThemeManager().getColors(token: token)
}