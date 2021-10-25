//
//  UTTokenIcon.swift
//  UIToolkit
//
//  Created by James Nestor on 24/08/2021.
//

import Cocoa

public class UTTokenIcon: UTView, FontProtocol {
    
    @IBInspectable var acceptsFirstMouseClick:Bool = false

    public var iconType:MomentumRebrandIconType = ._invalid
    public var size:IconSize = .small {
        didSet{
            needsDisplay = true
        }
    }
    
    public var isEnabled:Bool = true {
        didSet {
            needsDisplay = true
        }
    }
    
    //TODO: Make internal once calling team update
    //      button components to UTButton
    public var tokenName:String = ""
    
    init(iconType: MomentumRebrandIconType, tokenName:String, size: IconSize = .extraSmall){
        self.iconType  = iconType
        self.tokenName = tokenName
        self.size      = size
        super.init(frame: NSMakeRect(0, 0, size.floatValue, size.floatValue))
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    internal func configure(iconType: MomentumRebrandIconType, tokenName:String, size: IconSize = .extraSmall) {
        self.iconType  = iconType
        self.tokenName = tokenName
        self.size      = size
        
        setThemeColors()
    }
    
    public override func initialise() {
        super.initialise()
        self.setContentCompressionResistancePriority(.init(751), for: .horizontal)
        self.setContentCompressionResistancePriority(.init(751), for: .vertical)
    }
    
    public override var intrinsicContentSize: NSSize{
        return size.contentSize
    }
    
    public override func setThemeColors() {
        super.setThemeColors()
        needsDisplay = true
    }
    
    public override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        if acceptsFirstMouseClick{
            return true
        }
        return super.acceptsFirstMouse(for: event)
    }
    
    public func updateFont() {
        //Todo : scale icons with fonts
    }
    
    private var iconColor:CCColor{
        if tokenName.isEmpty {
            return CCColor.textColor
        }
        let color = UIToolkit.shared.getThemeManager().getColors(tokenName: tokenName)
        return isEnabled ? color.normal : color.disabled
    }
    
    private var icon:NSAttributedString {
        return NSAttributedString.getAttributedString(iconType: iconType, iconSize: size.floatValue, color: iconColor)
    }
    
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let theIcon = icon
        let drawRect = self.bounds.centredRect(for: theIcon)
        
        theIcon.draw(in: drawRect)
    }
    
}
