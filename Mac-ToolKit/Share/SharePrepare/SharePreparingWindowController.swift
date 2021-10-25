//
//  SharePreparingWindowController.swift
//  WebexTeams
//
//  Created by Archie You on 2021/3/16.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa
import CommonHead

protocol SharePreparingWindowControllerProtocol {
    func update(notification: CHShareNotification)
}

class SharePreparingWindowController: NSWindowController {
    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var spinner: LoadingImageView!
    @IBOutlet weak var label: NSTextField!
    
    private var timer: Timer?
    
    convenience init() {
        self.init(windowNibName: "SharePreparingWindowController")
        window?.level = .floating
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.backgroundColor = .clear
        contentView.wantsLayer = true
        contentView.layer?.cornerRadius = 4
        contentView.layer?.borderWidth = 1
        contentView.layer?.backgroundColor = SemanticThemeManager.getColors(for: .wxPopupLabelBackground).normal.cgColor
        contentView.layer?.borderColor = SemanticThemeManager.getColors(for: .wxPopupLabelBorder).normal.cgColor
        label.textColor = SemanticThemeManager.getColors(for: .wxBalloonText).normal
        spinner.loadImageIfNeeded(onLightBackground: false, spinnerSize: .small)
    }
    
    private func showWindow() {
        window?.orderFront(self)
        window?.center()
        spinner.startAnimation()
        scheduledTimer()
    }
    
    override func close() {
        super.close()
        
        spinner?.stopAnimation()
    }
    
    private func updateLabel(text: String) {
        label.stringValue = text
    }
    
    private func scheduledTimer() {
        invalidateTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: false){ [weak self] _ in
            if let weakSelf = self {
                weakSelf.timer = nil
                weakSelf.close()
            }
        }
    }
    
    private func invalidateTimer() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
    }
}

extension SharePreparingWindowController: SharePreparingWindowControllerProtocol {
    func update(notification: CHShareNotification) {
        switch notification.action {
        case .show:
            updateLabel(text: notification.message)
            showWindow()
        case .update:
            updateLabel(text: notification.message)
        case .hide:
            close()
        @unknown default: break
        }
    }
}
