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

typealias ILocalShareControlButtonsViewController = LocalShareControlButtonsViewControllerProtocol & NSViewController

protocol LocalShareControlButtonsViewControllerProtocol: ShareManagerComponentSetup, ShareManagerComponentListener, EdgeCollaborator, WindowAnimationCollaborator, WindowDragCollaborator {
    var animator: WindowAnimator? { get set }
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

class LocalShareControlButtonsViewController: ILocalShareControlButtonsViewController {
    weak var animator: WindowAnimator?
    
    @IBOutlet weak var contentStackView: NSStackView!
    @IBOutlet weak var dragLabel: NSTextField!
    @IBOutlet weak var annotateButton: UTRoundButton!
    @IBOutlet weak var rdcButton: UTRoundButton!
    @IBOutlet weak var pauseButton: UTRoundedCornerButton!
    @IBOutlet weak var stopButton: UTRoundedCornerButton!
    
    fileprivate weak var shareComponent: ShareManagerComponentProtocol?
    private var isSharePaused = false {
        didSet {
            updatePauseButton()
        }
    }
    
    fileprivate var edge = Edge.top
    fileprivate var blockShowTooltips = false {
        didSet {
            updateButtonTooltip()
        }
    }
    
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
        button.shouldExcludeTooltipsInShare = true
    }
    
    fileprivate func updateButtonTooltip() {
        SPARK_LOG_DEBUG("")
        if blockShowTooltips {
            annotateButton?.addUTToolTip(toolTip: .plain(""))
            rdcButton?.addUTToolTip(toolTip: .plain(""))
            pauseButton?.addUTToolTip(toolTip: .plain(""))
            stopButton?.addUTToolTip(toolTip: .plain(""))
        } else {
            annotateButton?.addUTToolTip(toolTip: ShareControlButtonType.annotate.getUTToolTip(preferredEdge: edge.tooltipPreferredEdge))
            rdcButton?.addUTToolTip(toolTip: ShareControlButtonType.remoteControlStart.getUTToolTip(preferredEdge: edge.tooltipPreferredEdge))
            let pauseButtonType = isSharePaused ? ShareControlButtonType.resume : ShareControlButtonType.pause
            pauseButton?.addUTToolTip(toolTip: pauseButtonType.getUTToolTip(preferredEdge: edge.tooltipPreferredEdge))
            stopButton?.addUTToolTip(toolTip: ShareControlButtonType.stop.getUTToolTip(preferredEdge: edge.tooltipPreferredEdge))
        }
    }
    
    fileprivate func setupDragLabel() {
        dragLabel.font = NSFont(name: Constants.momentumRebrandIconFont, size: 16)
        dragLabel.textColor = getUIToolkitColor(token: .sharewindowControlTextPrimary).normal
    }
    
    fileprivate func setupPauseButton() {
        updatePauseButton()
    }
    
    private func updatePauseButton() {
        setupShareControlButton(button: pauseButton, type: isSharePaused ? .resume : .pause)
    }
    
    fileprivate func setupStopButton() {
        setupShareControlButton(button: stopButton, type: .stop)
    }
    
    @IBAction func onShowShareContentWindow(_ sender: Any) {
        SPARK_LOG_DEBUG("")
        shareComponent?.showShareContentWindow()
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
        isSharePaused = !isSharePaused
    }
    
    @IBAction func onStopButton(_ sender: Any) {
        SPARK_LOG_DEBUG("")
        shareComponent?.stopShare()
    }
    
    //MARK: ShareManagerComponentSetup
    func setup(shareComponent: ShareManagerComponentProtocol) {
        self.shareComponent = shareComponent
        shareComponent.registerListener(self)
    }
    
    //MARK: EdgeCollaborator
    func updateEdge(edge: Edge) {
        self.edge = edge
        
        updateButtonTooltip()
    }
    
    //MARK: WindowAnimationCollaborator
    func getFittingSize() -> NSSize {
        return .zero
    }
    
    func windowWillStartAnimation() {}
    
    func windowDidStopAnimation() {}
    
    //MARK: WindowDragCollaborator
    func windowWillStartDrag() {
        blockShowTooltips = true
    }
    
    func windowDidStopDrag() {
        blockShowTooltips = false
    }
    
    //MARK: ShareManagerComponentListener
    func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onLocalShareControlBarInfoChanged info: CHLocalShareControlBarInfo) {
        isSharePaused = info.isSharePaused
    }
}

//MARK: Horizontal
class LocalShareControlButtonsHorizontalViewController: LocalShareControlButtonsViewController {
    @IBOutlet weak var leftLabel: NSTextField!
    @IBOutlet weak var rightLabel: CustomToolTipsClickableTextField!
    
    init() {
        super.init(nibName: "LocalShareControlButtonsHorizontalViewController", bundle: Bundle.getSparkBundle())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightLabel.clickableTextFieldDelegate = self
        rightLabel.shouldExcludeTooltipsInShare = true
        rightLabel.cursorType = .pointingHand
        rightLabel.tooltipDelegate = self
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
    
    private func updateShareLabel(info: CHLocalShareControlViewLabelInfo) {
        let leftAttributedString = NSMutableAttributedString(string: info.modifiedString)
        leftAttributedString.addAttribute(.font, value: NSFont.systemFont(ofSize: 16), range: NSMakeRange(0, leftAttributedString.length))
        
        let textColor = getUIToolkitColor(token: .sharewindowControlTextPrimary).normal
        leftAttributedString.addAttribute(.foregroundColor, value: textColor, range: NSMakeRange(0, leftAttributedString.length))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        leftAttributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, leftAttributedString.length))
        leftLabel?.attributedStringValue = leftAttributedString
        
        rightLabel.isHidden = info.detailsString.isEmpty
        if !info.detailsString.isEmpty {
            let rightAttributedString = NSMutableAttributedString(string: info.detailsString + "  ")
            rightAttributedString.addAttribute(.font, value: NSFont.systemFont(ofSize: 16, weight: .bold), range: NSMakeRange(0, rightAttributedString.length))
            rightAttributedString.addAttribute(.foregroundColor, value: textColor, range: NSMakeRange(0, rightAttributedString.length))
            rightAttributedString.addAttribute(.underlineStyle, value: NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue), range: NSMakeRange(0, rightAttributedString.length - 2))
            rightAttributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, rightAttributedString.length - 2))
            
            rightLabel?.attributedStringValue = rightAttributedString
        } else {
            rightLabel?.attributedStringValue = NSAttributedString()
        }
        
        animator?.startAnimationForSizeChanged()
    }
    
    //MARK: ShareManagerComponentSetup
    override func setup(shareComponent: ShareManagerComponentProtocol) {
        super.setup(shareComponent: shareComponent)
        if let viewInfo = shareComponent.getLocalShareControlBarInfo()?.viewInfo {
            updateShareLabel(info: viewInfo.labelInfo)
        }
    }
    
    //MARK: WindowAnimationCollaborator
    override func getFittingSize() -> NSSize {
        return NSMakeSize(min(contentStackView.fittingSize.width, 600), 40)
    }
    
    override func windowWillStartAnimation() {
        super.windowWillStartAnimation()
        leftLabel.setContentCompressionResistancePriority(.dragThatCannotResizeWindow, for: .horizontal)
        rightLabel.setContentCompressionResistancePriority(.dragThatCannotResizeWindow - 1, for: .horizontal)
    }
    
    override func windowDidStopAnimation() {
        super.windowDidStopAnimation()
        leftLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        rightLabel.setContentCompressionResistancePriority(.defaultHigh - 1, for: .horizontal)
    }
    
    //MARK: ShareManagerComponentListener
    override func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onLocalShareControlBarInfoChanged info: CHLocalShareControlBarInfo) {
        super.shareManagerComponent(shareManagerComponent, onLocalShareControlBarInfoChanged: info)
        updateShareLabel(info: info.viewInfo.labelInfo)
    }
}

extension LocalShareControlButtonsHorizontalViewController: ClickableTextFieldDelegate, CustomToolTipsClickableTextFieldDelegate {
    func mouseDown() {
        onShowShareContentWindow(self)
    }
    
    func getTooltip() -> String {
        guard !blockShowTooltips else { return "" }
        if shareComponent?.shareContext.shareSourceType == .window {
            return shareComponent?.getLocalShareControlWindowLabelTooltip() ?? ""
        } else {
            return shareComponent?.getLocalShareControlBarInfo()?.viewInfo.labelInfo.tooltips ?? ""
        }
    }
}

//MARK: Vertical
class LocalShareControlButtonsVerticalViewController: LocalShareControlButtonsViewController {
    @IBOutlet weak var switchShareButton: UTRoundButton!
    
    init() {
        super.init(nibName: "LocalShareControlButtonsVerticalViewController", bundle: Bundle.getSparkBundle())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupShareControlButton(button: switchShareButton, type: .switchShare)
    }
    
    override func getFittingSize() -> NSSize {
        return NSMakeSize(40, contentStackView.fittingSize.height + 16)
    }
    
    override func updateButtonTooltip() {
        super.updateButtonTooltip()
        if blockShowTooltips {
            switchShareButton?.addUTToolTip(toolTip: .plain(""))
        } else {
            switchShareButton?.addUTToolTip(toolTip: ShareControlButtonType.switchShare.getUTToolTip(preferredEdge: edge.tooltipPreferredEdge))
        }
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
        let tooltipDetails = UTRichTooltipDetails(tooltip: NSAttributedString(string: tooltip ?? self.tooltip), size: .large, preferredEdge: preferredEdge)
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
