//
//  UTTextFieldCell.swift
//  UTToolKit
//
//  Created by jnestor on 12/05/2021.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa

//MARK: - NSTextFieldCell Extension
extension NSTextFieldCell{
    
    ///Comptues an adjusted drawing rect for the cell. It will align the cell vertically in the textField allowing the
    ///y axis to be adjusted via the y padding. The leading and trailing padding can be adjusted to leave space for sub views
    ///like a clear icon to be added to the NSTextField
    func getShiftedDrawingRect(forBounds theRect: NSRect, leadingPadding:CGFloat, trailingPadding: CGFloat, yPadding:CGFloat, yCentred: Bool, fixedHeight:CGFloat) -> NSRect{
        var newRect = self.drawingRect(forBounds: theRect)
        
        if yCentred {
            let textSize = cellSize(forBounds: theRect)
            let textHeight = fixedHeight == 0 ? textSize.height : fixedHeight
            let heightDelta = newRect.size.height - textHeight
            if(heightDelta > 0){
                newRect.size.height -= heightDelta
                let halfHeightDelta = CGFloat(ceil(heightDelta / 2))
                newRect.origin.y += halfHeightDelta
            }
        }
        
        newRect.origin.y += yPadding
        
        if NSApp.userInterfaceLayoutDirection == .rightToLeft {
            if leadingPadding != 0 {
                newRect = NSMakeRect(newRect.origin.x, newRect.origin.y, newRect.width - leadingPadding, newRect.height)
            }

            if trailingPadding != 0 {
                newRect.origin.x += trailingPadding
                newRect = NSMakeRect(newRect.origin.x, newRect.origin.y, newRect.width - trailingPadding, newRect.height)
            }

        } else {
            if trailingPadding != 0 {
                newRect = NSMakeRect(newRect.origin.x, newRect.origin.y, newRect.width - trailingPadding, newRect.height)
            }
            
            if leadingPadding != 0 {
                newRect.origin.x += leadingPadding
                newRect = NSMakeRect(newRect.origin.x, newRect.origin.y, newRect.width - leadingPadding, newRect.height)
            }
        }
        
        return newRect
    }
    
    convenience init(with textField: NSTextField) {
        self.init()
        stringValue        = textField.stringValue
        isBordered         = textField.isBordered
        isEnabled          = textField.isEnabled
        isSelectable       = textField.isSelectable
        isEditable         = textField.isEditable
        drawsBackground    = textField.drawsBackground
        usesSingleLineMode = textField.usesSingleLineMode
        alignment          = textField.alignment
        textColor          = textField.textColor
        lineBreakMode      = textField.lineBreakMode
        isScrollable       = true
        allowsEditingTextAttributes = textField.allowsEditingTextAttributes        
        
        if let attrString = textField.placeholderAttributedString {
            placeholderAttributedString = attrString
        }
        else{
            placeholderString  = textField.placeholderString
        }
    }
}

//MARK: - UTBaseTextFieldCellProtocol
protocol UTBaseTextFieldCellProtocol : AnyObject{
    func updateTrailingPadding(value:CGFloat)
    func updateLeadingPadding(value:CGFloat)
    func getUpdatedDrawingRect() -> NSRect
    func setYCentred(value:Bool)
    func setFixedHeight(value:CGFloat)
}

let UTTextFieldCellDefaultLeadingPadding:CGFloat = 8
let UTTextFieldCellLargeIconLeadingPadding:CGFloat = 27
let UTTextFieldCellSmallIconLeadingPadding:CGFloat = 16
let UTTextFieldCellGlobalHeaderIconLeadingPadding:CGFloat = 40

let UTTextFieldCellDefaultTrailingPadding:CGFloat = 8
let UTTextFieldCellTrailingIconPadding:CGFloat = 26

//MARK: - UTTextFieldCell
class UTTextFieldCell : NSTextFieldCell, UTBaseTextFieldCellProtocol{
    
    //MARK: - Internal
    internal var updatedDrawingRect:NSRect = NSZeroRect
    
    //MARK: - variables
    private var trailingPadding:CGFloat = UTTextFieldCellTrailingIconPadding
    private var leadingPadding:CGFloat = 8
    private var yPadding:CGFloat = 0
    private var yCentred:Bool = true
    private var fixedHeight:CGFloat = 0
    
    //MARK: - UTBaseTextFieldCellProtocol implementation
    func updateTrailingPadding(value:CGFloat) {
        trailingPadding = value
    }
    
    func updateLeadingPadding(value:CGFloat) {
        leadingPadding = value
    }
    
    func setYCentred(value:Bool){
        yCentred = value
    }
    
    func getUpdatedDrawingRect() -> NSRect{
        return updatedDrawingRect
    }
    
    func setFixedHeight(value: CGFloat) {
        fixedHeight = value
    }
    
    //MARK: - Overridden draw functions
    override func edit(withFrame aRect: NSRect, in controlView: NSView, editor textObj: NSText, delegate anObject: Any?, event theEvent: NSEvent?) {
        super.edit(withFrame: shiftedDrawingRect(forBounds: aRect), in: controlView, editor: textObj, delegate: anObject, event: theEvent)
    }
    
    override func select(withFrame aRect: NSRect,in controlView: NSView, editor textObj: NSText, delegate anObject: Any?, start selStart: Int, length selLength: Int) {
        super.select(withFrame: shiftedDrawingRect(forBounds: aRect), in: controlView, editor: textObj, delegate: anObject, start: selStart, length: selLength)
    }
    
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
        super.draw(withFrame: shiftedDrawingRect(forBounds: cellFrame), in: controlView)
    }
    
    override func drawFocusRingMask(withFrame cellFrame: NSRect, in controlView: NSView) {
        let radius = controlView.layer?.cornerRadius ?? 0
        let path = NSBezierPath(roundedRect: cellFrame, xRadius: radius, yRadius: radius)
        path.fill()
    }
    
    //MARK: - Private API
    private func shiftedDrawingRect(forBounds theRect: NSRect) -> NSRect {
        updatedDrawingRect = getShiftedDrawingRect(forBounds: theRect, leadingPadding: leadingPadding, trailingPadding: trailingPadding, yPadding: yPadding, yCentred: yCentred, fixedHeight: fixedHeight)
        return updatedDrawingRect
    }
}

//MARK: - UTSecureTextFieldCell
class UTSecureTextFieldCell : NSSecureTextFieldCell, UTBaseTextFieldCellProtocol{
    
    //Mark: - variables
    private var trailingPadding:CGFloat = UTTextFieldCellTrailingIconPadding
    private var leadingPadding:CGFloat = UTTextFieldCellDefaultLeadingPadding
    private var yPadding:CGFloat = 0
    private var updatedDrawingRect:NSRect = NSZeroRect
    private var yCentred:Bool = true
    private var fixedHeight:CGFloat = 0
    
    //MARK: - UTBaseTextFieldCellProtocol implementation
    func updateTrailingPadding(value:CGFloat){
        trailingPadding = value
    }
    
    func updateLeadingPadding(value:CGFloat){
        leadingPadding = value
    }
    
    func getUpdatedDrawingRect() -> NSRect{
        return updatedDrawingRect
    }
    
    func setYCentred(value:Bool) {
        yCentred = value
    }
    
    func setFixedHeight(value: CGFloat) {
        fixedHeight = value
    }
    
    //MARK: - Overridden draw functions
    override func edit(withFrame aRect: NSRect, in controlView: NSView, editor textObj: NSText, delegate anObject: Any?, event theEvent: NSEvent?) {
        super.edit(withFrame: shiftedDrawingRect(forBounds: aRect), in: controlView, editor: textObj, delegate: anObject, event: theEvent)
    }
    
    override func select(withFrame aRect: NSRect,in controlView: NSView,
                         editor textObj: NSText, delegate anObject: Any?,
                         start selStart: Int, length selLength: Int) {
        super.select(withFrame: shiftedDrawingRect(forBounds: aRect), in: controlView, editor: textObj, delegate: anObject, start: selStart, length: selLength)
    }
    
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
        super.draw(withFrame: shiftedDrawingRect(forBounds: cellFrame), in: controlView)
    }
    
    override func drawFocusRingMask(withFrame cellFrame: NSRect, in controlView: NSView) {
        let radius = controlView.layer?.cornerRadius ?? 0
        let path = NSBezierPath(roundedRect: cellFrame, xRadius: radius, yRadius: radius)
        path.fill()
    }
        
    //MARK: - Private API
    private func shiftedDrawingRect(forBounds theRect: NSRect) -> NSRect {
        updatedDrawingRect = getShiftedDrawingRect(forBounds: theRect, leadingPadding: leadingPadding, trailingPadding: trailingPadding, yPadding: yPadding, yCentred: yCentred, fixedHeight: fixedHeight)
        return updatedDrawingRect
    }
}
