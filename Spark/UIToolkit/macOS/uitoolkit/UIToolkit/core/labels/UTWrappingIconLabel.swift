//
//  UTWrappingIconLabel.swift
//  UIToolkit
//
//  Created by James Nestor on 17/06/2021.
//

import Cocoa

public class UTWrappingIconLabel : UTTokenWrappingLabel {
        
    public var style:UTIconLabelStyle = .primary {
        didSet {
            icon.tokenName  = style.textToken
            label.tokenName = style.textToken
        }
    }
    
    //MARK: - Initialisation
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
    }
    
    public init(iconType:MomentumIconsRebrandType, style:UTIconLabelStyle, iconSize:IconSize, label:String, fontType:UTFontType, iconAlignment:IconAlignment = .left){
        super.init(frame: NSZeroRect)
        configure(iconType: iconType, style: style, iconSize: iconSize, label: label, fontType: fontType, iconAlignment: iconAlignment)        
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    internal override func initialise() {
        super.initialise()
        icon.tokenName = style.textToken
        label.tokenName = style.textToken
        
        self.containerStackView.edgeInsets = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.containerStackView.spacing = 6
        self.iconStackView.edgeInsets.top = 2
    }
    
    //Mark: - Public functions
    public func configure(iconType:MomentumIconsRebrandType, style:UTIconLabelStyle, iconSize:IconSize, label:String, fontType:UTFontType, iconAlignment:IconAlignment = .left) {
        super.configure(iconType: iconType, iconSize: iconSize, label: label, fontType: fontType)
        self.style = style
    }
    
}
