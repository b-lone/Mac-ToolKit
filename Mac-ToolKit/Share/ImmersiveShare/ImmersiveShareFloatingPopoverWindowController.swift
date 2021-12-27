//
//  ImmersiveShareFloatingPopoverWindowController.swift
//  Mac-ToolKit
//
//  Created by Archie You on 2021/12/17.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa
import UIToolkit

protocol ImmersiveShareFloatingPopoverWindowControllerDelegate: AnyObject {
    func immersiveShareFloatingPopoverWindowControllerDidClose(_ windowController: IImmersiveShareFloatingPopoverWindowController)
}

typealias IImmersiveShareFloatingPopoverWindowController = ImmersiveShareFloatingPopoverWindowControllerProtocol & BaseWindowController

protocol ImmersiveShareFloatingPopoverWindowControllerProtocol {
    var delegate: ImmersiveShareFloatingPopoverWindowControllerDelegate? { get set }
}

class ImmersiveShareFloatingPopoverWindowController: IImmersiveShareFloatingPopoverWindowController {
    @IBOutlet var sparkWindow: SparkPopoverWindow!
    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var tableView: CSITableView!
    
    weak var delegate: ImmersiveShareFloatingPopoverWindowControllerDelegate?
    override var windowNibName: NSNib.Name? { "ImmersiveShareFloatingPopoverWindowController" }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        sparkWindow.closeOnClickOutsideFrame = true
        sparkWindow.backgroundColor = .clear
        sparkWindow.sparkPopoverWindowDelegate = self
        contentView.wantsLayer = true
        contentView.layer?.cornerRadius = 6
        contentView.layer?.borderWidth = 1
        tableView.csiTableViewDelegate = self
        tableView.backgroundColor = .clear
        
        setThemeColors()
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        contentView.layer?.backgroundColor = SemanticThemeManager.getLegacyColors(for: .backgroundPrimary).normal.cgColor
        contentView.layer?.borderColor = SemanticThemeManager.getLegacyColors(for: .wxShareSelectionWindowPopoverBorderColor).normal.cgColor
        tableView.reloadData()
    }
}

extension ImmersiveShareFloatingPopoverWindowController: SparkPopoverWindowDelegate {
    func popoverWindowDidClose(window: SparkPopoverWindow) {
        delegate?.immersiveShareFloatingPopoverWindowControllerDidClose(self)
    }
}

extension ImmersiveShareFloatingPopoverWindowController: NSTableViewDelegate, NSTableViewDataSource {
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ImmersiveShareFloatingPopoverCellView"), owner: tableView) as? ImmersiveShareFloatingPopoverCellView else {
            return nil
        }
        
        if row == 0 {
            view.setup(iconType: .settingsBold, title: LocalizationStrings.showMeInFrontOfPresentation, isSelected: true)
        } else {
            view.setup(iconType: .settingsBold, title: LocalizationStrings.cameraSettings, isSelected: false)
        }
        
        
        return view
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ImmersiveShareFloatingPopoverRowView"), owner: tableView) as? CSITableRowView ?? CSITableRowView.init(frame: NSZeroRect)
        view.identifier = NSUserInterfaceItemIdentifier(rawValue: "ImmersiveShareFloatingPopoverRowView")
        view.initialise(rowType: .Primary)
        view.showSelectedColor = false
        return view
    }
}

extension ImmersiveShareFloatingPopoverWindowController: CSITableViewDelegate {
    func isSelectable(row: Int) -> Bool {
        return true
    }

    func rowClicked(row: Int, clickCount: Int) {
        if row == 0 {
            //TODO
        } else {
//            NotificationCenter.default.post(name: Notification.Name(rawValue: OnPreferencesActionShortcut), object:nil, userInfo: [PreferencesIdenitfierKey:NSUserInterfaceItemIdentifier.preferencesVideoTab.rawValue])
        }
        sparkWindow.close()
    }

    func invokeActionForSelectedRow(sender: CSITableView) {}

    func firstResponderStatusChanged(sender: CSITableView, isFirstResponder: Bool) {}

    func canShowMenu() -> Bool {
        return false
    }
}

class ImmersiveShareFloatingPopoverCellView: NSView, ThemeableProtocol {
    @IBOutlet weak var icon: UTIcon!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var selectIndicator: UTIcon!
    
    func setup(iconType: MomentumIconsRebrandType, title: String, isSelected: Bool) {
        titleLabel.stringValue = title
        
        icon?.configure(iconType: .settingsBold, style: .primary, size: .mediumSmall)
        
        selectIndicator?.configure(iconType: .checkBold, style: .primary, size: .mediumSmall)
        selectIndicator?.colorToken = .buttonHyperlinkText
        selectIndicator?.isHidden = !isSelected
        
        setThemeColors()
    }
    
    func setThemeColors() {
        icon?.setThemeColors()
        titleLabel.textColor = SemanticThemeManager.getLegacyColors(for: .textPrimary).normal
        selectIndicator?.setThemeColors()
    }
}
