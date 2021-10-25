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
    ///y axis to be adjusted via the y padding. The left and right padding can be adjusted to leave space for sub views
    ///like a clear icon to be added to the NSTextField
    func getShiftedDrawingRect(forBounds theRect: NSRect, leftPadding:CGFloat, rightPadding: CGFloat, yPadding:CGFloat, yCentred: Bool, fixedHeight:CGFloat) -> NSRect{
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
        
        if leftPadding != 0{
            newRect.origin.x += leftPadding
            newRect = NSMakeRect(newRect.origin.x, newRect.origin.y, newRect.width - leftPadding, newRect.height)
        }
        
        if rightPadding != 0 {
            newRect = NSMakeRect(newRect.origin.x, newRect.origin.y, newRect.width - rightPadding, newRect.height)
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
    func updateRightPadding(value:CGFloat)
    func updateLeftPadding(value:CGFloat)
    func getUpdatedDrawingRect() -> NSRect
    func setYCentred(value:Bool)
    func setFixedHeight(value:CGFloat)
}

let UTTextFieldCellDefaultLeftPadding:CGFloat = 8
let UTTextFieldCellLargeIconLeftPadding:CGFloat = 27
let UTTextFieldCellSmallIconLeftPadding:CGFloat = 16
let UTTextFieldCellGlobalHeaderIconLeftPadding:CGFloat = 40

let UTTextFieldCellDefaultRightPadding:CGFloat = 8
let UTTextFieldCellRightIconPadding:CGFloat = 26

//MARK: - UTTextFieldCell
class UTTextFieldCell : NSTextFieldCell, UTBaseTextFieldCellProtocol{
    
    //MARK: - Internal
    internal var updatedDrawingRect:NSRect = NSZeroRect
    
    //MARK: - variables
    private var rightPadding:CGFloat = UTTextFieldCellRightIconPadding
    private var leftPadding:CGFloat = 8
    private var yPadding:CGFloat = 0
    private var yCentred:Bool = true
    private var fixedHeight:CGFloat = 0
    
    //MARK: - UTBaseTextFieldCellProtocol implementation
    func updateRightPadding(value:CGFloat){
        rightPadding = value
    }
    
    func updateLeftPadding(value:CGFloat){
        leftPadding = value
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
        updatedDrawingRect = getShiftedDrawingRect(forBounds: theRect, leftPadding: leftPadding, rightPadding: rightPadding, yPadding: yPadding, yCentred: yCentred, fixedHeight: fixedHeight)
        return updatedDrawingRect
    }
}

//MARK: - UTSecureTextFieldCell
class UTSecureTextFieldCell : NSSecureTextFieldCell, UTBaseTextFieldCellProtocol{
    
    //Mark: - variables
    private var rightPadding:CGFloat = UTTextFieldCellRightIconPadding
    private var leftPadding:CGFloat = UTTextFieldCellDefaultLeftPadding
    private var yPadding:CGFloat = 0
    private var updatedDrawingRect:NSRect = NSZeroRect
    private var yCentred:Bool = true
    private var fixedHeight:CGFloat = 0
    
    //MARK: - UTBaseTextFieldCellProtocol implementation
    func updateRightPadding(value:CGFloat){
        rightPadding = value
    }
    
    func updateLeftPadding(value:CGFloat){
        leftPadding = value
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
        updatedDrawingRect = getShiftedDrawingRect(forBounds: theRect, leftPadding: leftPadding, rightPadding: rightPadding, yPadding: yPadding, yCentred: yCentred, fixedHeight: fixedHeight)
        return updatedDrawingRect
    }
}
