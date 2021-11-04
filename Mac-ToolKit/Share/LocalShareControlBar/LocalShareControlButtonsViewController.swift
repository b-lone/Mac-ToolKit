//
//  LocalShareControlButtonsViewController.swift
//  Mac-ToolKit
//
//  Created by Archie You on 2021/11/3.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa
import UIToolkit
import CommonHead

protocol LocalShareControlButtonsViewControllerProtocol: ShareManagerComponentSetup, ShareManagerComponentListener, EdgeCollaborator {
}

fileprivate extension Edge {
    var tooltipPreferredEdge: NSRectEdge {
        switch self {
        case .top:
            return .minY
        case .bottom:
            return .maxY
        case .left:
            return .maxX
        case .right:
            return .minX
        }
    }
}

class LocalShareControlButtonsViewController: NSViewController, LocalShareControlButtonsViewControllerProtocol {
    @IBOutlet weak var dragLabel: NSTextField!
    @IBOutlet weak var annotateButton: UTRoundButton!
    @IBOutlet weak var rdcButton: UTRoundButton!
    @IBOutlet weak var pauseButton: UTRoundedCornerButton!
    @IBOutlet weak var stopButton: UTRoundedCornerButton!
    
    private weak var shareComponent: ShareManagerComponentProtocol?
    private var isSharePaused = false {
        didSet {
            updatePauseButtonIcon()
        }
    }
    
    fileprivate var edge = Edge.top
    
    deinit {
        shareComponent?.unregisterListener(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDragLabel()
        
        setupShareControlButton(button: annotateButton, type: .annotate)
        setupShareControlButton(button: rdcButton, type: .remoteControlStart)
        
        setupPauseButton()
        setupStopButton()
    }
    
    fileprivate func setupShareControlButton(button: UTButton, type: ShareControlButtonType) {
        button.style = type.style
        button.buttonHeight = type.buttonHeight
        button.fontIcon = type.fontIcon
        button.addUTToolTip(toolTip: type.getUTToolTip(preferredEdge: edge.tooltipPreferredEdge))
        button.setAccessibilityTitle(type.accessibilityLabel)
        button.setAccessibilityValue(type.accessibilityValue)
    }
    
    func setup(shareComponent: ShareManagerComponentProtocol) {
        self.shareComponent = shareComponent
        shareComponent.registerListener(self)
    }
    
    func updateEdge(edge: Edge) {
        self.edge = edge
        
        updateButtonTooltip()
    }
    
    fileprivate func updateButtonTooltip() {
        annotateButton?.addUTToolTip(toolTip: ShareControlButtonType.annotate.getUTToolTip(preferredEdge: edge.tooltipPreferredEdge))
        rdcButton?.addUTToolTip(toolTip: ShareControlButtonType.remoteControlStart.getUTToolTip(preferredEdge: edge.tooltipPreferredEdge))
        pauseButton?.addUTToolTip(toolTip: ShareControlButtonType.pause.getUTToolTip(preferredEdge: edge.tooltipPreferredEdge))
        stopButton?.addUTToolTip(toolTip: ShareControlButtonType.stop.getUTToolTip(preferredEdge: edge.tooltipPreferredEdge))
    }
    
    fileprivate func setupDragLabel() {
        dragLabel.font = NSFont(name: Constants.momentumRebrandIconFont, size: 16)
        dragLabel.textColor = getUIToolkitColor(token: .sharewindowControlTextPrimary).normal
    }
    
    fileprivate func setupPauseButton() {
        setupShareControlButton(button: pauseButton, type: .pause)
    }
    
    private func updatePauseButtonIcon() {
        pauseButton.fontIcon = isSharePaused ? MomentumRebrandIconType.playBold : MomentumRebrandIconType.pauseBold
    }
    
    fileprivate func setupStopButton() {
        setupShareControlButton(button: stopButton, type: .stop)
    }
    
    @IBAction func onShowShareContentWindow(_ sender: Any) {
    }
    
    @IBAction func onAnnotateButton(_ sender: Any) {
        SPARK_LOG_DEBUG("")
    }
    
    @IBAction func onRdcButton(_ sender: Any) {
        SPARK_LOG_DEBUG("")
    }
    
    @IBAction func onPauseButton(_ sender: Any) {
        SPARK_LOG_DEBUG("")
        shareComponent?.pauseShare(doPause: pauseButton.fontIcon == MomentumRebrandIconType.pauseBold)
    }
    
    @IBAction func onStopButton(_ sender: Any) {
        SPARK_LOG_DEBUG("")
        shareComponent?.stopShare()
    }
    
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onLocalShareControlBarInfoChanged info: CHLocalShareControlBarInfo) {
        isSharePaused = info.isSharePaused
    }
    
    fileprivate enum ShareControlButtonType {
        case switchShare
        case annotate
        case remoteControlStart
        case remoteControlStop
        case pause
        case resume
        case stop
        
        var style: UTButton.Style { .shareWindowSecondary }
        
        var buttonHeight: ButtonHeight {
            switch self {
            case .switchShare, .annotate, .remoteControlStart, .remoteControlStop:
                return .extrasmall
            case .pause, .resume, .stop:
                return .small
            }
        }
        
        var fontIcon: MomentumRebrandIconType {
            switch self {
            case .switchShare:
                return .shareScreenBold
            case .annotate:
                return .annotateBold
            case .remoteControlStart:
                return .remoteDesktopControlBold
            case .remoteControlStop:
                return .endRemoteDesktopControlBold
            case .pause:
                return .pauseBold
            case .resume:
                return .playBold
            case .stop:
                return .stopBold
            }
        }
        
        private var tooltip: String {
            switch self {
            case .switchShare:
                return LocalizationStrings.share
            case .annotate:
                return LocalizationStrings.annotate
            case .remoteControlStart:
                return LocalizationStrings.remoteControlGiveRemoteControl
            case .remoteControlStop:
                return LocalizationStrings.remoteControlHotKeyToolTip
            case .pause:
                return LocalizationStrings.pauseSharing
            case .resume:
                return LocalizationStrings.resumeSharing
            case .stop:
                return LocalizationStrings.stopSharing
            }
        }
        
        func getUTToolTip(preferredEdge: NSRectEdge, tooltip: String? = nil) -> UTTooltipType {
            let tooltipDetails = UTRichTooltipDetails(tooltip: NSAttributedString(string: tooltip ?? self.tooltip), size: .medium, preferredEdge: preferredEdge)
            return .rich(tooltipDetails)
        }
        
        var accessibilityLabel: String {
            switch self {
            case .switchShare:
                return LocalizationStrings.share
            case .annotate:
                return LocalizationStrings.annotate
            case .remoteControlStart:
                return LocalizationStrings.remoteControlACC
            case .remoteControlStop:
                return LocalizationStrings.remoteControlACC
            case .pause:
                return LocalizationStrings.pauseSharing
            case .resume:
                return LocalizationStrings.resumeSharing
            case .stop:
                return LocalizationStrings.stopSharing
            }
        }
        
        var accessibilityValue: String? {
            switch self {
            case .remoteControlStart:
                return LocalizationStrings.notStart
            case .remoteControlStop:
                return LocalizationStrings.start
            default:
                return nil
            }
        }
    }
}

//MARK: Horizontal
typealias ILocalShareControlButtonsHorizontalViewController = LocalShareControlButtonsViewController

class LocalShareControlButtonsHorizontalViewController: LocalShareControlButtonsViewController {
    init() {
        super.init(nibName: "LocalShareControlButtonsHorizontalViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupDragLabel() {
        super.setupDragLabel()
        dragLabel.stringValue = MomentumRebrandIconType.formatControlPanelDraggerBold.ligature
    }
    
    override func setupPauseButton() {
        super.setupPauseButton()
        pauseButton.horizontalPadding = 7
        pauseButton.roundSetting = .lhs
    }
    
    override func setupStopButton() {
        super.setupStopButton()
        stopButton.horizontalPadding = 10
        stopButton.elementPadding = 4
        stopButton.roundSetting = .rhs
        stopButton.title = LocalizationStrings.stop
    }
}

//MARK: Vertical
typealias ILocalShareControlButtonsVerticalViewContrller = LocalShareControlButtonsViewController

class LocalShareControlButtonsVerticalViewContrller: LocalShareControlButtonsViewController {
    @IBOutlet weak var switchShareButton: UTRoundButton!
    
    init() {
        super.init(nibName: "LocalShareControlButtonsVerticalViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupShareControlButton(button: switchShareButton, type: .switchShare)
    }
    
    override func updateButtonTooltip() {
        super.updateButtonTooltip()
        switchShareButton?.addUTToolTip(toolTip: ShareControlButtonType.switchShare.getUTToolTip(preferredEdge: edge.tooltipPreferredEdge))
    }
    
    override func setupDragLabel() {
        super.setupDragLabel()
        dragLabel.stringValue = MomentumRebrandIconType.formatControlPanelDraggerHorizontalBold.ligature
    }
    
    override func setupPauseButton() {
        super.setupPauseButton()
        pauseButton.horizontalPadding = 5
        pauseButton.roundSetting = .top
    }
    
    override func setupStopButton() {
        super.setupStopButton()
        stopButton.horizontalPadding = 5
        stopButton.roundSetting = .bottom
    }
}
