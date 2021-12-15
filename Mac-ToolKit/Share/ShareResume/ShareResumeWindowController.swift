//
//  ShareResumeWindowController.swift
//  WebexTeams
//
//  Created by Archie You on 2021/6/9.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa
import CommonHead
import UIToolkit

protocol ShareResumeWindowControllerDelegate: AnyObject {
}

protocol ShareResumeWindowControllerProtocol: AnyObject {
    func update(component: ShareManagerComponentProtocol, info: CHShareNotification)
}

class ShareResumeWindowController: BaseWindowController {
    @IBOutlet weak var contentView: RoundSameSideCornerView!
    @IBOutlet weak var messageLabel: SparkTextField!
    @IBOutlet weak var okButton: UTPillButton!
    @IBOutlet weak var resumeButton: UTPillButton!
    
    private weak var component: ShareManagerComponentProtocol?
    private let globalShortcutHanderHelper: GlobalShortcutHandlerHelperProtocol
    
    override var windowNibName: NSNib.Name? { "ShareResumeWindowController" }
    
    override init(appContext: AppContext) {
        globalShortcutHanderHelper = appContext.globalShortcutHanderHelper
        super.init(appContext: appContext)
        let _ = window
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        globalShortcutHanderHelper.unRegisterHandler(self)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        if let window = window as? NSPanel {
            window.backgroundColor = .clear
            window.collectionBehavior = NSWindow.CollectionBehavior(rawValue: NSWindow.CollectionBehavior.canJoinAllSpaces.rawValue | NSWindow.CollectionBehavior.fullScreenAuxiliary.rawValue)
            window.isFloatingPanel = true
            window.worksWhenModal = true
            window.level = .popUpMenu + 1
        }
        
        okButton.buttonHeight = .small
        okButton.style = .shareWindowSecondary
        resumeButton.buttonHeight = .small
        resumeButton.style = .shareWindowPrimary
    }
    
    override func setThemeColors() {
        contentView?.backgroundColor = SemanticThemeManager.getLegacyColors(for: .wxShareResumeBarColor).normal
        
        okButton?.setThemeColors()
        resumeButton?.setThemeColors()
    }
    
    private func update(info: CHShareNotification) {
        let attributedText = NSMutableAttributedString(string: info.stressedMessage)
        attributedText.addAttribute(.font, value: NSFont.boldSystemFont(ofSize: 16) , range: NSMakeRange(0, attributedText.length))
        
        let label = NSMutableAttributedString(string: info.message + " ")
        label.addAttribute(.font, value: NSFont.systemFont(ofSize: 16), range: NSMakeRange(0, label.length))
        
        label.append(attributedText)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        label.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: label.length))
        
        messageLabel?.attributedStringValue = label
        
        if info.actions.count == 2 {
            okButton?.title = info.actions[0].text
            resumeButton?.title = info.actions[1].text
            resumeButton?.isEnabled = info.actions[1].isEnabled
        }
        
        window?.layoutIfNeeded()
    }
    
    @IBAction func onOKButtonClicked(_ sender: Any) {
        close()
    }
    
    @IBAction func onResumeButtonClicked(_ sender: Any) {
        resumeShare()
    }
    
    private func resumeShare() {
        component?.resumeShare()
        close()
    }
    
    private func getCentredFrame() -> NSRect {
        if let screenFrame = component?.shareContext.screenToDraw.visibleFrame {
            contentView.layout()
            let contenSize = contentView.frame.size
            return NSMakeRect(screenFrame.minX + (screenFrame.width - contenSize.width) / 2, screenFrame.maxY - contenSize.height, contenSize.width, contenSize.height)
        }
        return .zero
    }
}

extension ShareResumeWindowController: ShareResumeWindowControllerProtocol {
    func update(component: ShareManagerComponentProtocol, info: CHShareNotification) {
        switch info.action {
        case .show:
            update(info: info)
            self.component = component
            window?.setFrame(getCentredFrame(), display: true)
            window?.makeKeyAndOrderFront(self)
            globalShortcutHanderHelper.registerHandler(self)
        case .update:
            update(info: info)
            window?.setFrame(getCentredFrame(), display: true)
        case .hide:
            if self.component === component, window?.isVisible == true {
                close()
            }
            globalShortcutHanderHelper.unRegisterHandler(self)
        @unknown default: break
        }
    }
}

extension ShareResumeWindowController: GlobalShortcutHandler {
    var id: String { component?.callId ?? "" }
    
    var priority: GlobalShortcutHandlerPriority {
        if component?.getShareCallType() == .imOnlyShare {
            return .l1
        } else {
            return .l2
        }
    }
    
    func validateAction(actionType: GlobalShortcutHandlerActionType) -> Bool {
        switch actionType {
        case .pauseOrResumeShare:
            return window?.isVisible == true
        default:
            return false
        }
    }
    
    func globalShortcutPauseOrResumeShare() {
        resumeShare()
    }
}
