//
//  UTNavigationTabButton.swift
//  UIToolkit
//
//  Created by James Nestor on 01/07/2021.
//

import Cocoa

public class UTNavigationTabButton : UTTabButton {
    
    public var showBadge: Bool = true
    public var iconColorToken: String = ""
    public var coBrandingIconColorStates: UTColorStates!
    public var coBrandingIconBackgroundColorStates: UTColorStates!
    public var coBrandingIconBackgroundOnColorStates: UTColorStates!
    public var canNavigateWithArrowKeys: Bool = true
    private var badge:UTBadge!
    
    public var unreadCount:Int = 0{
        didSet {
            updateBadge()
        }
    }
    
    override func initialise() {
        preventFirstResponder = true
        
        elementSize.imageWidth = 20
        badge = UTBadge()
        badge.showTooltip = false
        self.addSubview(badge)
        self.addConstraints( [NSLayoutConstraint.createTopSpaceToViewConstraint(firstItem: badge, secondItem: self, constant: 6),
                              NSLayoutConstraint.createTrailingSpaceToViewConstraint(firstItem: badge, secondItem: self, constant: 0)])
        
        badge.translatesAutoresizingMaskIntoConstraints = false
        updateBadge()
        super.initialise()
        super.style = .tabs
        
        super.buttonType = .round
        super.fontIconSize = 24
    }
    
    override func toCGFloat(height: ButtonHeight) -> CGFloat {
        return 48
    }
    
    public func coBrandingOverrideIconColors(_ iconColorStates: UTColorStates, _ iconBackgroundColorStates: UTColorStates,  _ iconBackgroundOnColorStates: UTColorStates) {
        self.badge.isLegacyCoBrandingEnabled = true
        self.coBrandingIconColorStates = iconColorStates
        self.coBrandingIconBackgroundColorStates = iconBackgroundColorStates
        self.coBrandingIconBackgroundOnColorStates = iconBackgroundOnColorStates
    }
    
    override var backgroundColors: UTColorStates {
        if state == .on {
            if let coBrandingIconBackgroundOnColorStates = coBrandingIconBackgroundOnColorStates {
                return coBrandingIconBackgroundOnColorStates
            }
        } else {
            if let coBrandingIconBackgroundColorStates = coBrandingIconBackgroundColorStates {
                return coBrandingIconBackgroundColorStates
            }
        }
        return super.backgroundColors
    }
    
    override var textColors: UTColorStates {
        if let coBrandingIconColorStates = coBrandingIconColorStates {
            return coBrandingIconColorStates
        }
        return iconColorToken.isEmpty ? super.textColors : UIToolkit.shared.getThemeManager().getColors(tokenName: iconColorToken)
    }
    
    public func updateTooltip(_ tooltip: String) {
        self.toolTip = unreadCount > badge.maxCount ? "\(tooltip) (\(unreadCount))" : tooltip
    }
    
    private func updateBadge() {
        badge.count = unreadCount
        badge.isHidden = unreadCount == 0 || !showBadge
    }
    
    public override func setThemeColors() {
        super.setThemeColors()
        badge.setThemeColors()
    }
    

    public override var acceptsFirstResponder: Bool {
        return true
    }

    public override var canBecomeKeyView: Bool {
        return true
    }

    //result is really only useful in testing
    @discardableResult public  func addIcon(image: NSImage) -> NSImage? {
        let resizedImage = image.size.width > self.elementSize.imageWidth ? image.resizeImage(maxWidth: self.elementSize.imageWidth) : image
        if let resizedImage = resizedImage {
            if fontIcon != nil {
                removeUIElement(element: .FontIcon(fontIcon))
            }
            super.addUIElement(element: .Image(resizedImage))
        }
        return resizedImage
    }
    
    override public func accessibilitySubrole() -> NSAccessibility.Subrole? {
        if #available(OSX 10.13, *) {
            return .tabButtonSubrole
        } else {
            return super.accessibilitySubrole()
        }
    }
}
