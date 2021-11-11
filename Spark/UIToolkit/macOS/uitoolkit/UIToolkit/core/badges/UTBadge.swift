//
//  UTBadge.swift
//  UIToolkit
//
//  Created by James Nestor on 18/05/2021.
//

import Cocoa

//@IBDesignable
public class UTBadge: UTTextWithBackground {
    
    //MARK: - Public variables
    
    public var showTooltip: Bool = true
    public var isLegacyCoBrandingEnabled: Bool = false
    
    internal var backgroundColorToken:String {
        return UIToolkit.shared.isUsingLegacyTokens || isLegacyCoBrandingEnabled ? "appNav-badge" : UTColorTokens.badgeBackground.rawValue
    }
    
    internal var fontColorToken:String {
        return UIToolkit.shared.isUsingLegacyTokens || isLegacyCoBrandingEnabled ? "appNav-badge-text" : UTColorTokens.badgeText.rawValue
    }
    
    ///Maximum number the badge can show. If the count is larger than this number max number is shown
    ///Default value is 99.
    @IBInspectable public var maxCount:UInt = 99{
        didSet{
            assert(maxCount > 0, "Max count must be a positive number")            
            invalidateIntrinsicContentSize()
            needsDisplay = true
        }
    }
    
    ///The current number displayed on the badge.
    ///Value must be positive.
    ///If negative 0 will be displayed
    ///If value larger than maxCount, max count number and plus character will be displayed i.e. "99+"
    @IBInspectable public var count:Int = 0{
        didSet{
            if showTooltip {
                self.toolTip = count > maxCount ? String(count) : ""
            }
            invalidateIntrinsicContentSize()
            needsDisplay = true
        }
    }
    
    //MARK: - Internal
    
    var showPlusIfLargerThanMax: Bool = true {
        didSet{
            needsDisplay = true
        }
    }
    
    override internal var cornerRadius:CGFloat{
        return self.bounds.height / 2
    }
    
    override internal var stringValue:String {
        if count > maxCount {
            
            if showPlusIfLargerThanMax {
                return String(maxCount) + "+"
            }
            
            return String(maxCount)
        }
        
        return String(count)
    }
    
    override internal var fontColor:CCColor {
        return UIToolkit.shared.getThemeManager().getColors(tokenName: fontColorToken).normal
    }
    
    override internal var backgroundColor:CCColor {
        return UIToolkit.shared.getThemeManager().getColors(tokenName: backgroundColorToken).normal
    }
    
    //MARK: - Accessibility
    public override func isAccessibilityElement() -> Bool {
        return true
    }
    
    public override func accessibilityRole() -> NSAccessibility.Role? {
        return .valueIndicator
    }
    
    public override func accessibilityTitle() -> String? {
        return stringValue
    }
    
    public override func accessibilityValue() -> Any? {
        return count
    }
}

