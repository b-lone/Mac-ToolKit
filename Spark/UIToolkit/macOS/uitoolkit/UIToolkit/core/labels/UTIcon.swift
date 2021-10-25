//
//  UTIcon.swift
//  UIToolkit
//
//  Created by James Nestor on 10/06/2021.
//

import Cocoa

public class UTIcon : UTTokenIcon {
    
    public var style:UTIconLabelStyle = .primary {
        didSet {
            setThemeColors()
        }
    }
    
    public var colorToken:UTColorTokens? {
        didSet {
            setThemeColors()
        }
    }
    
    public init(iconType: MomentumRebrandIconType, style:UTIconLabelStyle, size: IconSize = .extraSmall){
        self.style = style
        super.init(iconType: iconType, tokenName: style.textToken, size: size)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)        
    }
    
    public func configure(iconType: MomentumRebrandIconType, style:UTIconLabelStyle, size: IconSize = .extraSmall) {
        self.style = style
        super.configure(iconType: iconType, tokenName: style.textToken, size: size)
    }
    
    public func configure(iconType: MomentumRebrandIconType, colorToken:UTColorTokens) {
        self.colorToken = colorToken
        super.configure(iconType: iconType, tokenName: colorToken.rawValue, size: size)
    }
    
    override public func setThemeColors() {
        
        if let colorToken = colorToken {
            if self.tokenName != colorToken.rawValue {
                self.tokenName = colorToken.rawValue
            }
        }
        else {
            if self.tokenName != style.textToken {
                self.tokenName = style.textToken
            }
        }
        
        super.setThemeColors()
    }
    
}
