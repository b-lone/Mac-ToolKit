//
//  LocalShareControlButtonsViewController.swift
//  Mac-ToolKit
//
//  Created by Archie You on 2021/11/3.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa
import UIToolkit

protocol LocalShareControlButtonsViewControllerProtocol {
}

class LocalShareControlButtonsViewController: NSViewController, LocalShareControlButtonsViewControllerProtocol {
    @IBOutlet weak var dragLabel: NSTextField!
    @IBOutlet weak var annotateButton: NSButton!
    @IBOutlet weak var rdcButton: NSButton!
    @IBOutlet weak var pauseButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDragLabel()
    }
    
    fileprivate func setupDragLabel() {
        dragLabel.font = NSFont(name: Constants.momentumRebrandIconFont, size: 16)
        dragLabel.textColor = getUIToolkitColor(token: .sharewindowControlTextPrimary).normal
    }
    
    @IBAction func onShowShareContentWindow(_ sender: Any) {
    }
    
    @IBAction func onAnnotateButton(_ sender: Any) {
    }
    
    @IBAction func onRdcButton(_ sender: Any) {
    }
    
    @IBAction func onPauseButton(_ sender: Any) {
    }
    
    @IBAction func onStopButton(_ sender: Any) {
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
        
//        switchShareButton.style = .
    }
    
    override func setupDragLabel() {
        super.setupDragLabel()
        dragLabel.stringValue = MomentumRebrandIconType.formatControlPanelDraggerHorizontalBold.ligature
    }
}
