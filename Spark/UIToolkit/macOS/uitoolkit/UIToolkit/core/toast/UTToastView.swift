//
//  UTToastView.swift
//  UIToolkit
//
//  Created by James Nestor on 08/07/2021.
//

import Cocoa

public class UTToastView: NSView, ThemeableProtocol {
    
    public enum Style {
        case meeting
        case text
        
        var backgroundTokenName:UTColorTokens {
            switch self {
            case .meeting:
                return .modalPrimaryBackground
            case .text:
                return .modalSecondaryBackground
            }
        }
        
        var borderTokenName:UTColorTokens {
            switch self {
            case .meeting:
                return .modalPrimaryBorder
            case .text:
                return .modalSecondaryBorder
            }
        }
    }
    
    internal var style:Style = .meeting {
        didSet {
            setThemeColors()
        }
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
    }
    
    public init(style:UTToastView.Style, frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.style = style
        initialise()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    func initialise() {
        self.wantsLayer = true
        self.layer?.cornerRadius = 12
        self.layer?.borderWidth = 1
        setThemeColors()
    }
    
    public func setThemeColors() {
        self.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: style.backgroundTokenName.rawValue).normal.cgColor
        self.layer?.borderColor     = UIToolkit.shared.getThemeManager().getColors(tokenName: style.borderTokenName.rawValue).normal.cgColor
    }
}
