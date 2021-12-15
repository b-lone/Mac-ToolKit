//
//  UTMaxCharacterCountTextField.swift
//  UIToolkit
//
//  Created by James Nestor on 04/10/2021.
//

import Cocoa

public class UTMaxCharacterCountTextField: UTTextField {

    @IBInspectable public var maxCharacterCount:Int = 75 {
        didSet {
            calculateTrailingPadding()
        }
    }
    
    public var allowClearIcon:Bool = false {
        didSet {
            wantsClearIcon = allowClearIcon
            updateClearIconVisibility()
            self.needsDisplay = true
        }
    }
    
    private var drawPoint: NSPoint{
        let attributedString = characterCountAttrString
        let currentStringSize = attributedString.size()
        let x = self.bounds.width - 6
        let y = (self.bounds.height - currentStringSize.height) / 2

        return NSMakePoint(x - currentStringSize.width, y)
    }
    
    override func initialise() {
        super.initialise()
        self.wantsClearIcon = allowClearIcon
        calculateTrailingPadding()
    }
    
    private var characterCountDrawPoint: NSPoint {
        let attributedString = characterCountAttrString
        let currentStringSize = attributedString.size()
        let x = isLayoutDirectionRightToLeft() ? currentStringSize.width + 6 : self.bounds.width - 6
        let y = (self.bounds.height - currentStringSize.height) / 2

        return NSMakePoint(x - currentStringSize.width, y)
    }
    
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if !wantsClearIcon {
            characterCountAttrString.draw(at: characterCountDrawPoint)
        }
    }

    var characterCountString:String{
        return String(format: "%02d", stringValue.count) + "/" + String(maxCharacterCount)
    }

    var characterCountAttrString:NSAttributedString{
        let textFontAttributes = [
            NSAttributedString.Key.font: self.font ?? UTFontType.bodyPrimary.font(),
            NSAttributedString.Key.foregroundColor: super.style.placeholderTextColorStates.normal
            ] as [NSAttributedString.Key : Any]

        return NSAttributedString(string: characterCountString, attributes: textFontAttributes)
    }

    public override func textDidChange(_ notification: Notification) {
        updateTrailingCellPadding()
        if stringValue.count > maxCharacterCount {
            let index = stringValue.index(stringValue.startIndex, offsetBy: maxCharacterCount)
            stringValue = String(stringValue[stringValue.startIndex..<index])
        }
        else{
            super.textDidChange(notification)
        }
    }
    
    private func calculateTrailingPadding() {
        if let cell = self.cell as? UTBaseTextFieldCellProtocol{
            if drawPoint != NSZeroPoint {
                let xPadding:CGFloat = 12
                let diff = self.bounds.width - drawPoint.x
                cell.updateTrailingPadding(value: diff + xPadding)
            }
        }
    }
    
    override internal func updateTrailingCellPadding(){
        //override to avoid base class functionality
    }
}
