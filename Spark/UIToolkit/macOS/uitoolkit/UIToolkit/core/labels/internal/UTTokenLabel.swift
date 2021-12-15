//
//  UTTokenLabel.swift
//  UIToolkit
//
//  Created by James Nestor on 16/07/2021.
//

import Cocoa

public class UTTokenLabel: NSTextField, ThemeableProtocol, FontProtocol {

    var tokenName:String = "text-primary"{
        didSet{
            setThemeColors()
        }
    }
    
    public var fontType:UTFontType = .bodySecondary {
        didSet{
            self.font = fontType.font()
        }
    }
    
    convenience init(stringValue:String = "", fontType:UTFontType, tokenName: String, lineBreakMode: NSLineBreakMode = .byTruncatingMiddle) {
        self.init(wrappingLabelWithString: stringValue)
        self.fontType = fontType
        self.tokenName = tokenName
        self.lineBreakMode = lineBreakMode
        self.isSelectable = false
        initialise()
    }
  
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
        lineBreakMode = .byTruncatingMiddle
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    internal func initialise(){
        self.wantsLayer = true
        font = fontType.font()
        isEditable = false
        drawsBackground = false
        isBordered = false
        cell?.truncatesLastVisibleLine = true
        setThemeColors()
    }
    
    public func setAttributedString(stringProperties:UTStringProperties){
        self.attributedStringValue = NSAttributedString.getAttributedString(stringProperties: stringProperties, fontSize: fontType.font().pointSize)
    }
    
    public func setAttributedString(stringPropertiesList:[UTStringProperties]){
        self.attributedStringValue = NSAttributedString.getAttributedString(stringPropertiesList: stringPropertiesList, fontSize: fontType.font().pointSize)
    }
    
    public func setThemeColors() {
        self.textColor = isEnabled ? UIToolkit.shared.getThemeManager().getColors(tokenName: tokenName).normal : UIToolkit.shared.getThemeManager().getColors(tokenName: tokenName).disabled
    }
    
    public func updateFont() {
        self.font = fontType.font()
        self.invalidateIntrinsicContentSize()
    }
    
    override public var isEnabled: Bool {
        didSet {
            setThemeColors()
        }
    }
    
}
