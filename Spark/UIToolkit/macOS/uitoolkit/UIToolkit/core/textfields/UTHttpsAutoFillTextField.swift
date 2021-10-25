//
//  UTHttpsAutoFillTextField.swift
//  UIToolkit
//
//  Created by James Nestor on 05/10/2021.
//

import Cocoa

public class UTHttpsAutoFillTextField: UTTextField {
    
    public var fullUrl: String {
        return httpsStr + stringValue
    }

    private var customPlaceholderString: String = ""
    private let xPadding:CGFloat = 12.0
    private let httpsStr:String = "https://"
    
    private var httpsAttrString:NSAttributedString{
        let textFontAttributes = [
            NSAttributedString.Key.font: self.font ?? UTFontType.bodyPrimary.font(),
            NSAttributedString.Key.foregroundColor: super.style.placeholderTextColorStates.normal
            ] as [NSAttributedString.Key : Any]
        
        return NSAttributedString(string: "https://", attributes: textFontAttributes)
    }
    
    private var customPlaceholderAttrString: NSAttributedString {
        let textFontAttributes = [
            NSAttributedString.Key.font: self.font ?? UTFontType.bodyPrimary.font(),
            NSAttributedString.Key.foregroundColor: super.style.placeholderTextColorStates.normal
            ] as [NSAttributedString.Key : Any]
        
        return NSAttributedString(string: customPlaceholderString, attributes: textFontAttributes)
    }
    
    private var leftString: NSAttributedString {
        if isFocused || !self.stringValue.isEmpty {
            return httpsAttrString
        }
        
        return customPlaceholderAttrString
    }
    
    override func initialise(){
        super.initialise()
        setLeftPadding()
    }
    
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let currentStringSize = leftString.size()
        let y = (self.bounds.height - currentStringSize.height) / 2
        
        let drawPoint = NSMakePoint(xPadding, y)
        leftString.draw(at: drawPoint)
    }
    
    override func onPasteAction(_ sender: Any?) -> Bool {
        guard let fieldEdior = self.currentEditor() else { return false }
        
        if let string = NSPasteboard.general.string(forType: .string) {
            let lowercaseString = string.lowercased()
            
            let httpStr = "http://"
            let httpsStr = "https://"
            
            if lowercaseString.hasPrefix(httpStr) {
                let pasteString = string.dropFirst(httpStr.count)
                fieldEdior.insertText(pasteString)
                return true
            }
            else if lowercaseString.hasPrefix(httpsStr) {
                let pasteString = string.dropFirst(httpsStr.count)
                fieldEdior.insertText(pasteString)
                return true
            }
        }
        
        return false
    }
    
    override func updatePlaceholderStringStyle(){
        //since a custom placeholder string is being used override base class functionality
    }
    
    public override var placeholderAttributedString: NSAttributedString? {
        set {
            assert(false, "requires custom placeholder string use placeholder string")
            self.placeholderString = newValue?.string
        }
        get {
            return customPlaceholderAttrString
        }
    }
    
    public override var placeholderString: String? {
        set{
            customPlaceholderString = newValue ?? ""
        }
        get{
            return customPlaceholderString
        }
    }
    
    public override func accessibilityTitle() -> String? {
        return fullUrl
    }
    
    private func setLeftPadding(){
        if let c = self.cell as? UTBaseTextFieldCellProtocol {
            let paddingAfterHttps:CGFloat = xPadding + 2
            c.updateLeftPadding(value: httpsAttrString.size().width + paddingAfterHttps)
        }
    }
}
