//
//  UTIconLabel.swift
//  UIToolkit
//
//  Created by James Nestor on 19/06/2021.
//

import Cocoa


public class UTIconLabel : UTHoverableView {
    
    //MARK: - Public variables
    public var style:UTIconLabelStyle = .primary {
        didSet{
            setThemeColors()
        }
    }
    
    public var iconType:MomentumIconsRebrandType = ._invalid {
        didSet {
            self.invalidateIntrinsicContentSize()
            needsDisplay = true
        }
    }
    
    public var iconSize:IconSize = .medium{
        didSet {
            self.invalidateIntrinsicContentSize()
            needsDisplay = true
        }
    }
        
    public var label:String = "" {
        didSet {
            self.invalidateIntrinsicContentSize()
            needsDisplay = true
        }
    }
    
    public var fontType:UTFontType = .bodyPrimary {
        didSet {
            self.invalidateIntrinsicContentSize()
            needsDisplay = true
        }
    }
        
    public var iconAlignment:IconAlignment = .left {
        didSet{
            needsDisplay = true
        }
    }
    
    public var wantsIconBackground = false {
        didSet {
            needsDisplay = true
        }
    }
    
    public var iconBackgroundOffset: CGFloat = 2
  
    override public var intrinsicContentSize: NSSize{
        
        if label.isEmpty || self.bounds.height == 0{
            return iconSize.contentSize
        }
        
        let textAttrString = NSMutableAttributedString(string: label, attributes: attributes)
        let iconAttrString = icon
        
        let iconRect  = rectForIcon(attrString: textAttrString, icon: iconAttrString)
        let labelRect = rectForAttrString(attrString: textAttrString, icon: iconAttrString)
        
        let width  = max(iconRect.maxX, labelRect.maxX)
        let height = max(iconRect.height, labelRect.height)
        
        return NSMakeSize(width, height)
    }
    
    private var spacing:CGFloat = 2
      
    //MARK: Private variables
    private var attributes:[NSAttributedString.Key:Any]{

        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .center
        paraStyle.lineBreakMode = .byTruncatingMiddle

        return [NSAttributedString.Key.font : fontType.font(),
                NSAttributedString.Key.foregroundColor : color,
                NSAttributedString.Key.paragraphStyle : paraStyle]
    }
    
    private var icon:NSAttributedString{
        return NSAttributedString.getAttributedString(iconType: iconType, iconSize: iconSize.floatValue, color: color)
    }
    
    private var color:CCColor{
        return UIToolkit.shared.getThemeManager().getColors(tokenName: style.textToken).normal
    }
    
    private var backgroundColor: CCColor {
        return UIToolkit.shared.getThemeManager().getColors(token: .modalSecondaryBackground).normal
    }
    
    public init (iconType:MomentumIconsRebrandType, iconSize:IconSize, label:String, fontType:UTFontType, style:UTIconLabelStyle, iconAlignment:IconAlignment, enableHover:Bool){
        self.style         = style
        self.label         = label
        self.fontType      = fontType
        self.iconType      = iconType
        self.iconAlignment = iconAlignment
        super.init(frame: NSZeroRect)
        
        super.enableHover = enableHover
        super.initialise()
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func configure(iconType:MomentumIconsRebrandType, iconSize:IconSize, label:String, fontType:UTFontType, style:UTIconLabelStyle, iconAlignment:IconAlignment, enableHover:Bool) {
        self.style         = style
        self.iconSize      = iconSize
        self.label         = label
        self.fontType      = fontType
        self.iconType      = iconType
        self.iconAlignment = iconAlignment
        self.enableHover   = enableHover
    }
    
    override public func initialise() {
        super.initialise()
        self.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let textAttrString = NSMutableAttributedString(string: label, attributes: attributes)
        let iconAttrString = icon
        
        if wantsIconBackground {
            let iconRect = self.rectForIcon(attrString: textAttrString, icon: iconAttrString)
            let iconBackRectWidth = min(iconRect.width, iconRect.height)
            let iconBackRect = NSRect(x: iconRect.minX + iconBackgroundOffset, y: iconRect.minY + iconBackgroundOffset, width: iconBackRectWidth - 2*iconBackgroundOffset, height: iconBackRectWidth - 2*iconBackgroundOffset)
            NSGraphicsContext.saveGraphicsState()
            let clipPath = NSBezierPath(roundedRect: iconBackRect, xRadius: iconBackRect.width/2, yRadius: iconBackRect.width/2)
            backgroundColor.setFill()
            clipPath.fill()
            NSGraphicsContext.restoreGraphicsState()
        }
        
        textAttrString.draw(in: self.rectForAttrString(attrString:textAttrString, icon: iconAttrString))
        iconAttrString.draw(in: self.rectForIcon(attrString: textAttrString, icon: iconAttrString))
    }
    
    fileprivate func rectForAttrString(attrString:NSMutableAttributedString, icon: NSAttributedString) -> NSRect{
        
        let strSize = attrString.size()
        
        let y:CGFloat = max(0, ((self.bounds.height - strSize.height) / 2)) - 1
        var x:CGFloat = 0
        
        if iconAlignment == .left{
            
            let bRect = rectForIcon(attrString: attrString, icon: icon)
            x = max(bRect.maxX + spacing, (self.bounds.width  - strSize.width ) / 2)
        }
        else {
            //TODO: For now assume 0 as left but we may want to centre within a larger rect
        }
        
        return NSMakeRect(x, y, strSize.width, strSize.height)
    }
    
    private func rectForIcon(attrString:NSMutableAttributedString, icon: NSAttributedString) -> NSRect {
        
        let iconSize = icon.size()
        
        let y =  max(0, ((self.bounds.height - iconSize.height) / 2))
        var x:CGFloat = 0
        
        if iconAlignment == .left{
            //TODO: For now assume 0 as left but we may want to centre within a larger rect
        }
        else {
            let rect = rectForAttrString(attrString: attrString, icon: icon)
            x = max(0, (rect.maxX + spacing))
        }
        
        return NSMakeRect(x, y, iconSize.width, iconSize.height)
        
    }
    
}
