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
            calculateRightPadding()
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
        calculateRightPadding()
    }
    
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if !wantsClearIcon {
            characterCountAttrString.draw(at: drawPoint)
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
        updateRightCellPadding()
        if stringValue.count > maxCharacterCount {
            let index = stringValue.index(stringValue.startIndex, offsetBy: maxCharacterCount)
            stringValue = String(stringValue[stringValue.startIndex..<index])
        }
        else{
            super.textDidChange(notification)
        }
    }
    
    private func calculateRightPadding() {
        if let cell = self.cell as? UTBaseTextFieldCellProtocol{
            if drawPoint != NSZeroPoint {
                let xPadding:CGFloat = 12
                let diff = self.bounds.width - drawPoint.x
                cell.updateRightPadding(value: diff + xPadding)
            }
        }
    }
    
    override internal func updateRightCellPadding(){
        //override to avoid base class functionality
    }
}
