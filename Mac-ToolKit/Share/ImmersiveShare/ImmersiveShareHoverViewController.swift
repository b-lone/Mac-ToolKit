//
//  ImmersiveShareHoverViewController.swift
//  Mac-ToolKit
//
//  Created by Archie You on 2021/12/17.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa
import UIToolkit


typealias IImmersiveShareHoverViewController = ImmersiveShareHoverViewControllerProtocol & BaseViewController

protocol ImmersiveShareHoverViewControllerProtocol {
}

class ImmersiveShareHoverViewController: IImmersiveShareHoverViewController {
    @IBOutlet weak var moreButton: UTRoundButton!
    
    private var shareFactory: ShareFactoryProtocol
    private lazy var popover: IImmersiveShareFloatingPopoverWindowController = {
        var windowController = shareFactory.makeImmersiveShareFloatingPopoverWindowController()
        windowController.delegate = self
        return windowController
    }()
    private var isPopoverShow = false {
        didSet {
            updateMoreButton()
        }
    }
    
    override init(appContext: AppContext) {
        shareFactory = appContext.shareFactory
        super.init(appContext: appContext)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moreButton.style = .secondary
        moreButton.buttonHeight = .medium
        moreButton.toolTip = LocalizationStrings.moreOptions
        moreButton.setAccessibilityTitle(LocalizationStrings.moreOptions)
        updateMoreButton()
    }
    
    private func updateMoreButton() {
        moreButton.fontIcon =  isPopoverShow ? .moreAdrBold : .moreBold
    }
    
    private func showPopover() {
        let window = popover.window as? SparkPopoverWindow
        SPARK_LOG_DEBUG("\(popover.window == nil)")
        window?.showRelativeToRect(posView: moreButton, edge: .minY, xPosition: .right, preventOffscreen: false)
        isPopoverShow = true
    }
    
    private func dismissPopover() {
        let window = popover.window as? SparkPopoverWindow
        window?.close()
        isPopoverShow = false
    }
    
    @IBAction func onMoreButton(_ sender: Any) {
        if isPopoverShow {
            dismissPopover()
        } else {
            showPopover()
        }
    }
}

extension ImmersiveShareHoverViewController: ImmersiveShareFloatingPopoverWindowControllerDelegate {
    func immersiveShareFloatingPopoverWindowControllerDidClose(_ windowController: IImmersiveShareFloatingPopoverWindowController) {
        isPopoverShow = false
    }
}

class ImmersiveShareHoverView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        NSColor.white.setFill()
        NSColor.blue.setStroke()
        var path = NSBezierPath(rect: NSMakeRect(dirtyRect.minX + 1, dirtyRect.minY + 1, 8, 8))
        path.fill()
        path.stroke()
        
        path = NSBezierPath(rect: NSMakeRect(dirtyRect.minX + 1, dirtyRect.maxY - 9, 8, 8))
        path.fill()
        path.stroke()
        
        path = NSBezierPath(rect: NSMakeRect(dirtyRect.maxX - 9, dirtyRect.minY + 1, 8, 8))
        path.fill()
        path.stroke()
        
        path = NSBezierPath(rect: NSMakeRect(dirtyRect.maxX - 9, dirtyRect.maxY - 9, 8, 8))
        path.fill()
        path.stroke()
        
        path = NSBezierPath()
        path.move(to: NSMakePoint(dirtyRect.minX + 9, dirtyRect.minY + 5))
        path.line(to: NSMakePoint(dirtyRect.maxX - 9, dirtyRect.minY + 5))
        path.move(to: NSMakePoint(dirtyRect.maxX - 5, dirtyRect.minY + 9))
        path.line(to: NSMakePoint(dirtyRect.maxX - 5, dirtyRect.maxY - 9))
        path.move(to: NSMakePoint(dirtyRect.maxX - 9, dirtyRect.maxY - 5))
        path.line(to: NSMakePoint(dirtyRect.minX + 9, dirtyRect.maxY - 5))
        path.move(to: NSMakePoint(dirtyRect.minX + 5, dirtyRect.maxY - 9))
        path.line(to: NSMakePoint(dirtyRect.minX + 5, dirtyRect.minY + 9))
        path.stroke()
    }
}
