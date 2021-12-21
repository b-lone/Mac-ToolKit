//
//  CSITableRowView.swift
//  SparkMacDesktop
//
//  Created by James Nestor on 18/10/2018.
//  Copyright © 2018 Cisco Systems. All rights reserved.
//

import Cocoa
import UIToolkit

protocol CSITableRowViewDelegate: AnyObject {
    func mouseInSparkTableRow(_ rowView: CSITableRowView, identifier: String)
    func mouseOutSparkTableRow(_ rowView: CSITableRowView, identifier: String)
    func shouldShowHoverState(_ identifier:String) -> Bool
    func shouldShowSelectedState(_ identifier:String) -> Bool
}

enum CSITableRowType{
    case MainList
    case MessageList
    case Primary
    case Secondary
    case Tertiary
    case Quaternary
    case Clear
}

class CSITableRowView: NSTableRowView {
    
    private var trackingArea:NSTrackingArea!
    private (set) var rowType:CSITableRowType = .MainList
    
    weak var csiTableRowViewDelegate: CSITableRowViewDelegate?
    
    var isMultipleSelection: Bool = false {
        didSet {
            if isMultipleSelection {
                backgroundColor = rowColors.pressed
            } else {
                backgroundColor = rowColors.normal
            }
        }
    }
    
    var mouseInside:Bool = false{
        didSet{
            if mouseInside != oldValue{
                if mouseInside {
                    csiTableRowViewDelegate?.mouseInSparkTableRow(self, identifier: self.identifier?.rawValue ?? "")
                }
                else {
                    csiTableRowViewDelegate?.mouseOutSparkTableRow(self, identifier: self.identifier?.rawValue ?? "")
                }
                
                updateBackgroundColor()
                onMouseInsideChanged()
            }
        }
    }
    
    var rowColors: UTColorStates {
        let state = UTColorStates(normal: .clear, hover: NSColor(red: 237, green: 237, blue: 237, alpha: 0), pressed:  NSColor(red: 222, green: 222, blue: 222, alpha: 0), on: nil, focused: nil, disabled: nil)
        return state
//        switch rowType {
//        case .Primary:
//            return ThemeManager.getListItemBGColour(legacyToken: .listItemPrimary)
//        case .Secondary:
//            return ThemeManager.getListItemBGColour(legacyToken: .listItemSecondary)
//        case .Tertiary:
//            return ThemeManager.getListItemBGColour(legacyToken: .listItemTertiary)
//        case .Quaternary:
//            return ThemeManager.getListItemBGColour(legacyToken: .listItemQuaternary)
//        case .MessageList:
//            return ThemeManager.getListItemBGColour(legacyToken: .messageListItem)
//        case .Clear:
//            return ThemeManager.getListItemBGColour(legacyToken: .wxTransparentBackground)
//        default:
//            return ThemeManager.getListItemBGColour(legacyToken: .mainListItem)
//        }
    }
    
    var selectedIsActive:Bool = true
    var showSelectedColor = true
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.wantsLayer = true
    }
    
    deinit{
        if let _ = trackingArea{
            self.removeTrackingArea(trackingArea)
        }
    }
    
    func initialise(rowType: CSITableRowType){
        self.wantsLayer = true
        self.rowType = rowType
        updateBackgroundColor()
    }
    
    override func selectAll(_ sender: Any?) {}
    
    override func prepareForReuse() {
        resetRowState()
        super.prepareForReuse()
    }
    
    private func resetRowState() {
        isSelected = false
        isActiveRow = false
        mouseInside = false
        isExpanded = false
    }
    
    override var isSelected: Bool{
        didSet{
            if selectedIsActive{
                isActiveRow = isSelected
            }
            updateBackgroundColor()
        }
    }
    
    var isActiveRow: Bool = false {
        didSet{
            updateBackgroundColor()
        }
    }
    
    var isExpanded: Bool = false {
        didSet{
            updateBackgroundColor()
        }
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        if trackingArea == nil{
            trackingArea = NSTrackingArea(rect: NSZeroRect,
                                          options: [NSTrackingArea.Options.inVisibleRect,
                                                    NSTrackingArea.Options.activeAlways,
                                                    NSTrackingArea.Options.mouseEnteredAndExited],
                                          owner: self,
                                          userInfo: nil)
        }
        
        if !self.trackingAreas.contains(trackingArea){
            self.addTrackingArea(trackingArea)
        }
        
        if let mouseLocation = self.window?.mouseLocationOutsideOfEventStream{
            let pt = self.convert(mouseLocation, from: nil)
            if NSPointInRect( pt, self.visibleRect ){
                mouseInside = true
            }
            else{
                mouseInside = false
            }
        }
    }
    
    override func mouseEntered(with theEvent: NSEvent) {
        super.mouseEntered(with: theEvent)
        guard theEvent.trackingArea == trackingArea else { return }
        mouseInside = true
    }
    
    override func mouseExited(with theEvent: NSEvent) {
        super.mouseExited(with: theEvent)
        guard theEvent.trackingArea == trackingArea else { return }
        mouseInside = false
    }

    func updateBackgroundColor() {
        
        if isMultipleSelection {
            return
        }
        
        if mouseInside && (!isSelected || !showSelectedColor) && csiTableRowViewDelegate?.shouldShowHoverState(self.identifier?.rawValue ?? "") ?? true {
            backgroundColor = rowColors.hover
        } else  if !showSelectedColor {
            backgroundColor = rowColors.normal
        } else if isSelected && !isActiveRow {
            backgroundColor = rowColors.hover
        } else if isActiveRow && csiTableRowViewDelegate?.shouldShowSelectedState(self.identifier?.rawValue ?? "") ?? true {
            backgroundColor = rowColors.pressed
        } else {
            backgroundColor = rowColors.normal
        }
        
        needsDisplay = true
    }
    
    func onMouseInsideChanged(){
        
    }
    
    class func makeWithIdentifier(_ tableView: NSTableView, rowIdentifier:String, owner: Any?, rowType: CSITableRowType) -> CSITableRowView {
        
        let identifier = NSUserInterfaceItemIdentifier(rawValue: rowIdentifier)
        if let rowView = tableView.makeView(withIdentifier: identifier, owner: owner) as? CSITableRowView {
            rowView.initialise(rowType: rowType)
            return rowView
        }
        
        let rowView = CSITableRowView(frame: NSZeroRect)
        rowView.identifier = identifier
        rowView.initialise(rowType: rowType)
        
        return rowView
    }
}
