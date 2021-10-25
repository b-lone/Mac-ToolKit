//
//  UTWebView.swift
//  UIToolkit
//
//  Created by James Nestor on 27/09/2021.
//

import Cocoa
import WebKit

public class UTWebView: WKWebView, ThemeableProtocol {
    
    public enum Style {
        case eula
        
        var borderToken : String {
            switch self {
            case .eula:
                return UIToolkit.shared.isUsingLegacyTokens ? "legacy-separator-primary" : UTColorTokens.separatorPrimary.rawValue
            }
        }
        
        var borderColorStates: UTColorStates {
            return UIToolkit.shared.getThemeManager().getColors(tokenName: borderToken)
        }
    }
    
    public var style:Style = .eula {
        didSet {
            if oldValue != style {
                
            }
        }
    }
    
    public init() {
        super.init(frame: .zero, configuration: WKWebViewConfiguration())
        initialise()
    }
    
    public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        initialise()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }    
    
    private func initialise() {
        self.wantsLayer = true
        setValue(false, forKey: "drawsBackground")
        updateStyle()
    }
    
    
    public func setThemeColors() {
        
        self.layer?.borderColor = style.borderColorStates.normal.cgColor
        
    }
    
    private func updateStyle() {
        if style == .eula {
            self.layer?.borderWidth = 1
            self.layer?.cornerRadius = 8
        }
        
        setThemeColors()
    }

}
