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
    @IBOutlet weak var remoteControlButton: UTRoundButton!
    @IBOutlet weak var pauseButton: UTRoundedCornerButton!
    @IBOutlet weak var stopButton: UTRoundedCornerButton!
    
    fileprivate weak var shareComponent: ShareManagerComponentProtocol?
    private var isSharePaused = false {
        didSet {
            onIsSharePausedChanged()
        }
    }
    private var pauseButtonType: ShareControlButtonType { isSharePaused ? .resume : .pause }
    private var shareFactory: ShareFactoryProtocol
    private var remoteControlManager: RDCControleeHelperProtocol?
    private let mainMenuHandlerHelper: MainMenuHandlerHelperProtocol
    private let globalShortcutHanderHelper: GlobalShortcutHandlerHelperProtocol

    fileprivate var edge = Edge.top
    fileprivate var blockShowTooltips = false {
        didSet {
            updateButtonTooltip()
        }
    }
    
    init(shareFactory: ShareFactoryProtocol, mainMenuHandlerHelper: MainMenuHandlerHelperProtocol, globalShortcutHanderHelper: GlobalShortcutHandlerHelperProtocol, nibName: String?) {
        self.shareFactory = shareFactory
        self.mainMenuHandlerHelper = mainMenuHandlerHelper
        self.globalShortcutHanderHelper = globalShortcutHanderHelper
        super.init(nibName: nibName, bundle: Bundle.getSparkBundle())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        shareComponent?.unregisterListener(self)
        remoteControlManager?.unregisterListener(self)
        mainMenuHandlerHelper.unRegisterHandler(handler: self)
        globalShortcutHanderHelper.unRegisterHandler(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDragLabel()
        
        setupShareControlButton(button: annotateButton, type: .annotate)
        updateAnnotateButton()
        setupShareControlButton(button: remoteControlButton, type: .remoteControlStart)
        updateRemoteControlButton()
        
        setupPauseButton()
        setupStopButton()
        updateButtonTooltip()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        globalShortcutHanderHelper.registerHandler(self)
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        globalShortcutHanderHelper.unRegisterHandler(self)
    }
    
    fileprivate func setupShareControlButton(button: UTButton, type: ShareControlButtonType) {
        button.style = type.style
        button.buttonHeight = type.buttonHeight
        button.fontIcon = type.fontIcon
        button.setAccessibilityTitle(type.accessibilityLabel)
        button.setAccessibilityValue(type.accessibilityValue)
        button.shouldExcludeTooltipsInShare = true
    }
    
    fileprivate func updateButtonTooltip() {
        if blockShowTooltips {
            annotateButton?.addUTToolTip(toolTip: .plain(""))
            stopButton?.addUTToolTip(toolTip: .plain(""))
        } else {
            annotateButton?.addUTToolTip(toolTip: ShareControlButtonType.annotate.getUTToolTip(preferredEdge: edge.tooltipPreferredEdge))
            stopButton?.addUTToolTip(toolTip: ShareControlButtonType.stop.getUTToolTip(preferredEdge: edge.tooltipPreferredEdge))
        }
        updateRemoteControlButtonTooltip()
        updatePauseButtonTooltip()
    }
    
    fileprivate func setupDragLabel() {
        dragLabel.font = NSFont(name: Constants.momentumRebrandIconFont, size: 16)
        dragLabel.textColor = getUIToolkitColor(token: .sharewindowControlTextPrimary).normal
    }
    
    private func updateAnnotateButton() {
        guard let info = shareComponent?.getLocalShareControlBarInfo()?.viewInfo.annotateButton else { return }
        annotateButton.isHidden = info.isHidden
    }
    
    private func updateRemoteControlButton() {
        if let info = remoteControlManager?.remoteControlButtonInfo {
            updateRemoteControlButton(info: info)
        } else {
            updateRemoteControlButton(info: (type: .remoteControlStart, buttonInfo: ButtonInfo()))
        }
    }
    
    private func updateRemoteControlButtonTooltip() {
        if blockShowTooltips {
            remoteControlButton?.addUTToolTip(toolTip: .plain(""))
        } else {
            if remoteControlManager?.isSessionEstablished == true {
                remoteControlButton?.addUTToolTip(toolTip: ShareControlButtonType.remoteControlStop.getUTToolTip(preferredEdge: edge.tooltipPreferredEdge))
            } else {
                SPARK_LOG_DEBUG("\(isSharePaused)")
                if isSharePaused {
                    remoteControlButton?.addUTToolTip(toolTip: ShareControlButtonType.remoteControlStart.getUTToolTip(preferredEdge: edge.tooltipPreferredEdge, tooltip: LocalizationStrings.remoteControlDisableWhenSharePaused))
                } else {
                    remoteControlButton?.addUTToolTip(toolTip: ShareControlButtonType.remoteControlStart.getUTToolTip(preferredEdge: edge.tooltipPreferredEdge))
                }
            }
        }
    }
    
    fileprivate func setupPauseButton() {
        updatePauseButton()
    }
    
    private func updatePauseButtonTooltip() {
        if blockShowTooltips {
            pauseButton?.addUTToolTip(toolTip: .plain(""))
        } else {
            pauseButton?.addUTToolTip(toolTip: pauseButtonType.getUTToolTip(preferredEdge: edge.tooltipPreferredEdge))
        }
    }
    
    private func updatePauseButton() {
        setupShareControlButton(button: pauseButton, type: pauseButtonType)
        updatePauseButtonTooltip()
        SPARK_LOG_DEBUG("")
        if let info = shareComponent?.getLocalShareControlBarInfo()?.viewInfo.pauseButton {
            SPARK_LOG_DEBUG("")
            pauseButton.isHidden = info.isHidden
            setupStopButton()
        }
    }
    
    fileprivate func setupStopButton() {
        setupShareControlButton(button: stopButton, type: .stop)
    }
    
    private func onIsSharePausedChanged() {
        SPARK_LOG_DEBUG("\(isSharePaused)")
        updatePauseButton()
        updateRemoteControlButton()
    }
    
    @IBAction func onShowShareContentWindow(_ sender: Any) {
        SPARK_LOG_DEBUG("")
        shareComponent?.showShareContentWindow()
    }
    
    fileprivate func canShowShareContentWindow() -> Bool {
        return false
    }
    
    @IBAction func onAnnotateButton(_ sender: Any) {
        SPARK_LOG_DEBUG("")
        guard remoteControlManager?.canStartAnnotateWhenRDCisSessionEstablished() == true else { return SPARK_LOG_DEBUG("canStartAnnotateWhenRDCisSessionEstablished == false") }
        
        shareComponent?.annotate()
    }
    
    @IBAction func onRemoteControlButton(_ sender: Any) {
        SPARK_LOG_DEBUG("")
        remoteControlManager?.showGiveControlPopover(sender: remoteControlButton, preferredEdge: edge.tooltipPreferredEdge)
    }
    
    @IBAction func onPauseButton(_ sender: Any) {
        SPARK_LOG_DEBUG("")
        shareComponent?.pauseShare(doPause: pauseButton.fontIcon == MomentumIconsRebrandType.pauseBold)
    }
    
    @IBAction func onStopButton(_ sender: Any) {
        SPARK_LOG_DEBUG("")
        shareComponent?.stopShare()
        remoteControlManager?.closeGiveRemoteControlPopOver()
        remoteControlManager?.closeRemoteControlHintWindowController()
    }
    
    //MARK: ShareManagerComponentSetup
    func setup(shareComponent: ShareManagerComponentProtocol) {
        self.shareComponent = shareComponent
        shareComponent.registerListener(self)
        mainMenuHandlerHelper.registerHandler(callId: shareComponent.callId, handler: self)
        globalShortcutHanderHelper.registerHandler(self)
        
        updateAnnotateButton()
        updatePauseButton()
        remoteControlManager = shareComponent.remoteControlManager
        remoteControlManager?.registerListener(self)
        updateRemoteControlButton()
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
        updateAnnotateButton()
    }
}

extension LocalShareControlButtonsViewController: RemoteControleeManagerDelegate {
    func updateRemoteControlButton(info: RemoteControlButtonInfo) {
        SPARK_LOG_DEBUG("")
        setupShareControlButton(button: remoteControlButton, type: info.type)
        remoteControlButton.isHidden = info.buttonInfo.isHidden
        remoteControlButton.isEnabled = info.buttonInfo.isEnabled && !isSharePaused
        updateRemoteControlButtonTooltip()
    }
    
    func ignoresMouseEventsInSomeWindows(isIgnores: Bool) {
        view.window?.ignoresMouseEvents =  isIgnores
    }
}

extension LocalShareControlButtonsViewController: StartAnnotationMainMenuHandler {
    func canStartAnnotation(callId: String) -> Bool {
        annotateButton?.canClick == true && view.window?.isVisible == true
    }
    
    func mainMenuStartAnnotation(callId: String) {
        onAnnotateButton(self)
    }
}

extension LocalShareControlButtonsViewController: GlobalShortcutHandler {
    var id: String { shareComponent?.callId ?? "" }
    
    var priority: GlobalShortcutHandlerPriority {
        if let shareComponent = shareComponent {
            if shareComponent.getShareCallType() == .imOnlyShare {
                return .l1
            } else  {
                return .l2
            }
        }
        return .invlaid
    }
    
    func validateAction(actionType: GlobalShortcutHandlerActionType) -> Bool {
        switch actionType {
        case .openShareSelectionWindow:
            return canShowShareContentWindow()
        case .stopShare:
            return stopButton?.canClick == true
        case .pauseOrResumeShare:
            return pauseButton?.canClick == true
        case .startRDC:
            return remoteControlButton?.canClick == true && remoteControlManager?.isSessionEstablished == false
        case .stopRDC:
            return remoteControlButton?.canClick == true && remoteControlManager?.isSessionEstablished == true
        case .makeLocalShareControlBarKeyWindow:
            return true
        }
    }
    
    func globalShortcutOpenShareSelectionWindow() {
        onShowShareContentWindow(self)
    }
    
    func globalShortcutStopShare() {
        onStopButton(self)
    }
    
    func globalShortcutPauseOrResumeShare() {
        onPauseButton(self)
    }
    
    func globalShortcutStartRDC() {
        onRemoteControlButton(self)
    }
    
    func globalShortcutStopRDC() {
        SPARK_LOG_DEBUG("[RemoteControl-ui] onShortcutStopRDC")
        remoteControlManager?.endRemoteControlSession()
    }
    
    func globalShortcutMakeLocalShareControlBarKeyWindow() {
        view.window?.makeKey()
    }
}

extension LocalShareControlButtonsViewController: AppMenuCallsProtocol {
    @objc func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        guard let shareComponent = shareComponent else { return false }
        if menuItem.action == #selector(AppMenuCallsProtocol.appMenuStartShare) {
            return canShowShareContentWindow()
        } else if menuItem.action == #selector(AppMenuCallsProtocol.appMenuStopShare) {
            return stopButton?.canClick == true && view.window?.isVisible == true
        } else if menuItem.action == #selector(AppMenuCallsProtocol.appMenuStartAnnotation) {
            return mainMenuHandlerHelper.canStartAnnotation(callId: shareComponent.callId)
        } else if menuItem.action == #selector(AppMenuCallsProtocol.appMenuStartCall) ||
                    menuItem.action == #selector(AppMenuCallsProtocol.appMenuStartVideoCall) ||
                    menuItem.action == #selector(AppMenuCallsProtocol.appMenuEndCall) ||
                    menuItem.action == #selector(AppMenuCallsProtocol.appMenuToggleAudioMute) ||
                    menuItem.action == #selector(AppMenuCallsProtocol.appMenuToggleVideoMute) ||
                    menuItem.action == #selector(AppMenuCallsProtocol.appMenuStopAnnotation) ||
                    menuItem.action == #selector(AppMenuCallsProtocol.appMenuToggleMeetingControls) ||
                    menuItem.action == #selector(AppMenuCallsProtocol.appMenuAnswerCall) ||
                    menuItem.action == #selector(AppMenuCallsProtocol.appMenuDeclineCall) {
            return false
        }
        return false
    }
    
    func appMenuStartShare() {
        onShowShareContentWindow(self)
    }
    
    func appMenuStopShare() {
        onStopButton(self)
    }
    
    func appMenuStartAnnotation() {
        guard let shareComponent = shareComponent else { return }
        mainMenuHandlerHelper.mainMenuStartAnnotation(callId: shareComponent.callId)
    }
    
    func appMenuStartCall() {}
    func appMenuStartVideoCall() {}
    func appMenuEndCall() {}
    func appMenuToggleAudioMute() {}
    func appMenuToggleVideoMute() {}
    func appMenuStopAnnotation() {}
    func appMenuToggleMeetingControls() {}
    func appMenuAnswerCall() {}
    func appMenuDeclineCall() {}
}

//MARK: Horizontal
class LocalShareControlButtonsHorizontalViewController: LocalShareControlButtonsViewController {
    @IBOutlet weak var leftLabel: NSTextField!
    @IBOutlet weak var rightLabel: CustomToolTipsClickableTextField!
    
    init(shareFactory: ShareFactoryProtocol, mainMenuHandlerHelper: MainMenuHandlerHelperProtocol, globalShortcutHanderHelper: GlobalShortcutHandlerHelperProtocol) {
        super.init(shareFactory: shareFactory, mainMenuHandlerHelper: mainMenuHandlerHelper, globalShortcutHanderHelper: globalShortcutHanderHelper, nibName: "LocalShareControlButtonsHorizontalViewController")
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
        dragLabel.stringValue = MomentumIconsRebrandType.formatControlPanelDraggerBold.ligature
    }
    
    override func setupPauseButton() {
        super.setupPauseButton()
        pauseButton.horizontalPadding = 7
        pauseButton.roundSetting = .leading
    }
    
    override func setupStopButton() {
        super.setupStopButton()
        stopButton.horizontalPadding = 10
        stopButton.elementPadding = 4
        stopButton.roundSetting =  pauseButton.isHidden ? .pill : .trailing
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
    
    override func canShowShareContentWindow() -> Bool {
        return !rightLabel.isHidden
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
    
    init(shareFactory: ShareFactoryProtocol, mainMenuHandlerHelper: MainMenuHandlerHelperProtocol, globalShortcutHanderHelper: GlobalShortcutHandlerHelperProtocol) {
        super.init(shareFactory: shareFactory, mainMenuHandlerHelper: mainMenuHandlerHelper, globalShortcutHanderHelper: globalShortcutHanderHelper, nibName: "LocalShareControlButtonsVerticalViewController")
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
        dragLabel.stringValue = MomentumIconsRebrandType.formatControlPanelDraggerHorizontalBold.ligature
    }
    
    override func setupPauseButton() {
        super.setupPauseButton()
        pauseButton.horizontalPadding = 5
        pauseButton.roundSetting = .top
    }
    
    override func setupStopButton() {
        super.setupStopButton()
        stopButton.horizontalPadding = 5
        stopButton.roundSetting = pauseButton.isHidden ? .pill : .bottom
    }
    
    override func canShowShareContentWindow() -> Bool {
        return !switchShareButton.isHidden
    }
    
    private func updateSwitchShareButton() {
        guard let info = shareComponent?.getLocalShareControlBarInfo()?.viewInfo.labelInfo else { return }
        switchShareButton.isHidden = info.detailsString.isEmpty
    }
    
    //MARK: ShareManagerComponentListener
    override func shareManagerComponent(_ shareManagerComponent: ShareManagerComponentProtocol, onLocalShareControlBarInfoChanged info: CHLocalShareControlBarInfo) {
        super.shareManagerComponent(shareManagerComponent, onLocalShareControlBarInfoChanged: info)
        updateSwitchShareButton()
    }
    
    //MARK: ShareManagerComponentSetup
    override func setup(shareComponent: ShareManagerComponentProtocol) {
        super.setup(shareComponent: shareComponent)
        updateSwitchShareButton()
    }
}

enum ShareControlButtonType {
    case switchShare
    case annotate
    case remoteControlStart
    case remoteControlStop
    case pause
    case resume
    case stop
    
    var style: UTButton.Style {
        switch self {
        case .remoteControlStop:
            return .shareWindowActive
        default:
            return .shareWindowSecondary
        }
    }
    
    var buttonHeight: ButtonHeight {
        switch self {
        case .switchShare, .annotate, .remoteControlStart, .remoteControlStop:
            return .extrasmall
        case .pause, .resume, .stop:
            return .small
        }
    }
    
    var fontIcon: MomentumIconsRebrandType {
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
            return LocalizationStrings.selectShareButtonTooltip
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
        case .remoteControlStart, .remoteControlStop:
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
