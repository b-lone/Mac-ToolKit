//
//  UTTableRowView.swift
//  UIToolkit
//
//  Created by James Nestor on 19/05/2021.
//

import Cocoa

public enum UTTableRowViewStyle{
    case pill
    case rounded
    case rectangle
}

public class UTTableRowView: NSTableRowView {
    
    var mouseInside:Bool = false{
        didSet{
            updateBackgroundColor()
            onMouseInsideChanged()
        }
    }
    
    var rowColors: UTColorStates {
        // Legacy, to let new UI show hover effect
        return UIToolkit.shared.isUsingLegacyTokens ? UIToolkit.shared.getThemeManager().getColors(tokenName: "listItem-primary") : UIToolkit.shared.getThemeManager().getColors(tokenName: UTColorTokens.listitemBackground.rawValue)
    }
    
    var selectedIsActive:Bool = true
    
    private var trackingArea:NSTrackingArea!
    private var style:UTTableRowViewStyle = .pill
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
    }
    
    deinit{
        if let _ = trackingArea{
            self.removeTrackingArea(trackingArea)
        }
    }
    
    func initialise(style: UTTableRowViewStyle){
        self.style = style
        updateBackgroundColor()
    }
    
    public override func selectAll(_ sender: Any?) {}
    
    public override func prepareForReuse() {
        resetRowState()
        super.prepareForReuse()
        updateCornerRadius()
    }
    
    public override var isSelected: Bool{
        didSet{
            if selectedIsActive{
                isActiveRow = isSelected
            }
            updateBackgroundColor()
        }
    }
    
    public var isActiveRow: Bool = false {
        didSet{
            updateBackgroundColor()
        }
    }
    
    public override func updateTrackingAreas() {
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
        
        if isMouseInVisibleRect{
            mouseInside = true
        }
        else{
            mouseInside = false
        }
    }
    
    public override func mouseEntered(with theEvent: NSEvent) {
        super.mouseEntered(with: theEvent)
        guard theEvent.trackingArea == trackingArea else { return }
        mouseInside = true
    }
    
    public override func mouseExited(with theEvent: NSEvent) {
        super.mouseExited(with: theEvent)
        guard theEvent.trackingArea == trackingArea else { return }
        mouseInside = false
    }

    func updateBackgroundColor() {
        
        updateCornerRadius()
        
        if mouseInside && !isSelected{
            backgroundColor = rowColors.hover 
        }
        else if isSelected && !isActiveRow {
            backgroundColor = rowColors.hover
        }
        else if isActiveRow {
            backgroundColor = rowColors.pressed
        }
        else {
            backgroundColor = rowColors.normal
        }
        
        needsDisplay = true
    }
    
    func onMouseInsideChanged(){
        guard self.numberOfColumns > 0 else {  return }
        
        if let cell = self.view(atColumn: 0) as? UTTableCellView {
            cell.mouseInRowUpdated(mouseInside: mouseInside)
        }
    }
    
    public class func makeWithIdentifier(_ tableView: NSTableView, rowIdentifier:String, owner: Any?, style: UTTableRowViewStyle) -> UTTableRowView {
        
        let identifier = NSUserInterfaceItemIdentifier(rawValue: rowIdentifier)
        if let rowView = tableView.makeView(withIdentifier: identifier, owner: owner) as? UTTableRowView {
            rowView.initialise(style: style)
            return rowView
        }
        
        let rowView = UTTableRowView(frame: NSZeroRect)
        rowView.identifier = identifier
        rowView.initialise(style: style)
        
        return rowView
    }
    
    fileprivate func resetRowState() {
        isSelected = false
        isActiveRow = false
        mouseInside = false
    }
    
    fileprivate func updateCornerRadius(){
        guard let layer = layer else { return }
        let cornerRadius = getCornerRadiusForStyle(style: style)
        
        if layer.cornerRadius != cornerRadius{
            layer.cornerRadius = cornerRadius
        }
    }
    
    private func getCornerRadiusForStyle(style: UTTableRowViewStyle) -> CGFloat {
        if style == .rectangle {
            return 0
        }
        else if style == .rounded {
            return 8
        }
        
        return self.frame.height / 2
    }
}
