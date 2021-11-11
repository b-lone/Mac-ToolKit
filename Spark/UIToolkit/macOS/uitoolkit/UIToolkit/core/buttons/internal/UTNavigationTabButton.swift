//
//  UTNavigationTabButton.swift
//  UIToolkit
//
//  Created by James Nestor on 01/07/2021.
//

import Cocoa

public class UTNavigationTabButton : UTTabButton {
    
    public var supportsBadge: Bool = false
    public var iconColorToken: String = ""
    public var coBrandingIconColorStates: UTColorStates!
    public var coBrandingIconBackgroundColorStates: UTColorStates!
    public var coBrandingIconBackgroundOnColorStates: UTColorStates!
    public var canNavigateWithArrowKeys: Bool = true
    private static let maxTrailingPadding: CGFloat = 54.0
    private var badge:UTBadge!
    
    private var badgeConstraints: [NSLayoutConstraint] = []
    private var initialIntrinsicWidth:CGFloat = 0.0
    
    public var unreadCount:Int = 0 {
        didSet {
            updateBadge()
        }
    }
    
    public var isExpanded: Bool = false {
        didSet {
            if isExpanded {
                setBadgeConstraintsForWideTab()
            }
            else {
                setBadgeConstraintsForNarrowTab()
            }
            self.endAtTrailingPadding = isExpanded
        }
    }
    
    private func setBadgeConstraintsForNarrowTab() {
        self.removeConstraints(badgeConstraints)
        badgeConstraints = [NSLayoutConstraint.createTopSpaceToViewConstraint(firstItem: badge, secondItem: self, constant: 6),
                               NSLayoutConstraint.createTrailingSpaceToViewConstraint(firstItem: badge, secondItem: self, constant: 0)]
        self.addConstraints(badgeConstraints)
    }
    
    private func setBadgeConstraintsForWideTab() {
        self.removeConstraints(badgeConstraints)
        badgeConstraints = [NSLayoutConstraint.createCenterYViewConstraint(firstItem: badge, secondItem: self),
                               NSLayoutConstraint.createTrailingSpaceToViewConstraint(firstItem: badge, secondItem: self, constant: -12)]
        self.addConstraints(badgeConstraints)
       
    }
       
    override func initialise() {
        preventFirstResponder = true
        
        elementSize.imageWidth = 20
        badge = UTBadge()
        badge.showTooltip = false
        self.addSubview(badge)
        setBadgeConstraintsForNarrowTab()
        badge.translatesAutoresizingMaskIntoConstraints = false
        updateBadge()
        super.initialise()
        super.style = .tabs
        super.startAtLeadingPadding = true
        super.buttonType = .rounded
        super.fontIconSize = 24
        super.titleTruncationMode = .end
    }
    
    public var adjustedWitdh: CGFloat {
        get{
            if initialIntrinsicWidth == 0.0 {
                initialIntrinsicWidth = intrinsicContentSize.width
            }
            
            return initialIntrinsicWidth
        }
    }
    override var trailingPadding:CGFloat {
        if !supportsBadge {
            return leadingPadding
        }
        
        if initialIntrinsicWidth == 0.0 {
            return  UTNavigationTabButton.maxTrailingPadding
        }
        
        if badge.isHidden {
            return leadingPadding
        }
        
        return 2 * leadingPadding + badge.intrinsicContentSize.width
    }
    
    override var leadingPadding:CGFloat {
        return 12.0
    }
    
    public override var fontIcon: MomentumRebrandIconType! {
        didSet {
            super.fontIcon = fontIcon
        }
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
    
    override var textColors:UTColorStates {
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
        badge.isHidden = unreadCount == 0 || !supportsBadge
        
        if badge.isHidden {
            self.cell?.setAccessibilityChildren(nil)
        }
        else{
            self.cell?.setAccessibilityChildren([badge!])
        }
    }
    
    public func updateTitle(_ title: String) {
        super.title = title
      }
    
    public override func setThemeColors() {
        super.setThemeColors()
        badge.setThemeColors()
    }
    
    public override func updateCorners() {
           layer?.cornerRadius = self.heightFloat/2
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
