//
//  UTOverlayView.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 09/09/2021.
//

import Foundation
import Cocoa

//this class capture the various different bg colors defined in figma
//https://www.figma.com/file/H19CutixoN8SJGO5EXwcc8/Components---MacOS?node-id=7813%3A33120

public class UTBackgroundView : UTView {
    
    private var gradient: CAGradientLayer!
    
    public enum Style {
        case clear
        case gradientPrimary
        case gradientSecondary
        case solidPrimary
        case solidSecondary
        case solidTertiary
        case fadePrimary
        case fadeSecondary
        case modalPrimary
        case modalSecondary
        case modalTertiary
    }
    
    public var style:Style = .solidPrimary {
        didSet{
            setThemeColors()
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    override func initialise() {
        self.wantsLayer = true
        setThemeColors()
    }
    
    
    public override func setThemeColors() {
        
        gradient?.removeFromSuperlayer()
        removeBorder()
        switch style {
        case .clear:
            self.layer?.backgroundColor = .clear
        case .gradientPrimary:
            setupGradient()
        case .gradientSecondary:
            setupGradient()
        case .solidPrimary:
            let token = UIToolkit.shared.isUsingLegacyTokens ? "background-primary" : UTColorTokens.panelPrimaryBackground.rawValue
            self.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: token).normal.cgColor
        case .solidSecondary:
            let token = UIToolkit.shared.isUsingLegacyTokens ? "background-primary" : UTColorTokens.panelSecondaryBackground.rawValue
            self.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: token).normal.cgColor
        case .solidTertiary:
            let token = UIToolkit.shared.isUsingLegacyTokens ? "background-primary" : UTColorTokens.panelTertiaryBackground.rawValue
            self.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: token).normal.cgColor
        case .fadePrimary:
            let token = UIToolkit.shared.isUsingLegacyTokens ? "wx-overlay-userGuidance" : UTColorTokens.overlayFadePrimaryBackground.rawValue
            self.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: token).normal.cgColor
        case .fadeSecondary:
            self.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(token: UTColorTokens.overlayFadeSecondaryBackground).normal.cgColor
        case .modalPrimary:
            setBorder()
            let bgTokenName =  UIToolkit.shared.isUsingLegacyTokens ? "modal-primary-background" : UTColorTokens.modalPrimaryBackground.rawValue
            self.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: bgTokenName).normal.cgColor
            let borderTokenName =  UIToolkit.shared.isUsingLegacyTokens ? "modal-primary-border" : UTColorTokens.modalPrimaryBorder.rawValue
            self.layer?.borderColor = UIToolkit.shared.getThemeManager().getColors(tokenName: borderTokenName).normal.cgColor
        case .modalSecondary:
            setBorder()
            self.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(token: UTColorTokens.modalSecondaryBackground).normal.cgColor
            self.layer?.borderColor = UIToolkit.shared.getThemeManager().getColors(token: UTColorTokens.modalSecondaryBorder).normal.cgColor
        case .modalTertiary:
            setBorder()
            self.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(token: UTColorTokens.modalTertiaryBackground).normal.cgColor
            self.layer?.borderColor = UIToolkit.shared.getThemeManager().getColors(token: UTColorTokens.modalTertiaryBorder).normal.cgColor
        }

        self.needsDisplay = true
    }
    
    func setupGradient() {
        
        if !UIToolkit.shared.isUsingLegacyTokens  {
    
            let colors:(UTColorTokens,UTColorTokens) = style == .gradientPrimary ? (.themeGradientPrimary0Background, .themeGradientPrimary1Background) : (.themeGradientSecondary0Background, .themeGradientSecondary1Background)
            let startGradient = UIToolkit.shared.getThemeManager().getColors(token: colors.0).normal.cgColor
            let endGradient = UIToolkit.shared.getThemeManager().getColors(token: colors.1).normal.cgColor

            gradient = CAGradientLayer()
            gradient.frame = self.bounds
            gradient.type = .axial
                gradient.colors = [
                    endGradient,
                    startGradient]
            gradient.locations = [0, 1]
            self.layer?.addSublayer(gradient)
        }
    }
    
    override public func layout() {
        super.layout()
        if let gradient = gradient {
            gradient.frame = self.bounds
        }
    }
    
    
    func removeBorder() {
        self.wantsLayer = true
        self.layer?.borderWidth = 0

    }
    
    func setBorder() {
        self.layer?.borderWidth = 1
        self.layer?.cornerRadius  = 12
    }
    
    public override func isAccessibilityElement() -> Bool {
        return true
    }
}
