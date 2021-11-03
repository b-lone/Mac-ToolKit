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

protocol LocalShareControlButtonsViewControllerProtocol {
}

class LocalShareControlButtonsViewController: NSViewController, LocalShareControlButtonsViewControllerProtocol, ShareManagerComponentSetup, ShareManagerComponentListener {
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
    
    deinit {
        shareComponent?.unregisterListener(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDragLabel()
        
        annotateButton.style = .shareWindowSecondary
        annotateButton.buttonHeight = .extrasmall
        annotateButton.fontIcon = MomentumRebrandIconType.annotateBold
        let tooltipDetails = UTRichTooltipDetails(tooltip: NSAttributedString(string: LocalizationStrings.annotate), size: .medium, preferredEdge: .minY)
        annotateButton.addUTToolTip(toolTip: .rich(tooltipDetails))
        
        rdcButton.style = .shareWindowSecondary
        rdcButton.buttonHeight = .extrasmall
        rdcButton.fontIcon = MomentumRebrandIconType.remoteDesktopControlBold
        
        setupPauseButton()
        setupStopButton()
    }
    
    func setup(shareComponent: ShareManagerComponentProtocol) {
        self.shareComponent = shareComponent
        shareComponent.registerListener(self)
    }
    
    fileprivate func setupDragLabel() {
        dragLabel.font = NSFont(name: Constants.momentumRebrandIconFont, size: 16)
        dragLabel.textColor = getUIToolkitColor(token: .sharewindowControlTextPrimary).normal
    }
    
    fileprivate func setupPauseButton() {
        pauseButton.style = .shareWindowSecondary
        pauseButton.buttonHeight = .small
        updatePauseButtonIcon()
    }
    
    private func updatePauseButtonIcon() {
        pauseButton.fontIcon = isSharePaused ? MomentumRebrandIconType.playBold : MomentumRebrandIconType.pauseBold
    }
    
    fileprivate func setupStopButton() {
        stopButton.style = .shareWindowSecondary
        stopButton.buttonHeight = .small
        stopButton.fontIcon = MomentumRebrandIconType.stopBold
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
        
        switchShareButton.style = .shareWindowSecondary
        switchShareButton.buttonHeight = .extrasmall
        switchShareButton.fontIcon = MomentumRebrandIconType.shareScreenBold
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
