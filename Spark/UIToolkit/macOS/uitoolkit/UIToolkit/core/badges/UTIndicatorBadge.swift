//
//  UTIndicatorBadge.swift
//  UIToolkit
//
//  Created by James Nestor on 18/05/2021.
//

import Cocoa

public enum UTIndicatorBadgeType {
    case noBadge
    case unread
    case mention
    case muted
    case alert
    case outgoingCall
    case newlyAdded
    case blocked
    case errorAlert
}

//@IBDesignable
public class UTIndicatorBadge: UTView {
    
    
    //MARK: - Public variables
    
    ///Used to determine what badge is shown.
    ///When a space is unread there is a hirearchy of notification states to show
    ///The badge type to display should mirror this hirearchy
    public var badgeType:UTIndicatorBadgeType = .unread{
        didSet{
            if badgeType == .noBadge {
                self.isHidden = true
            }
            else{
                needsDisplay = true
            }
            
        }
    }
    
    ///When displayed in a table the text colour of some of the indicators change
    ///based on if the row is selected or not. Setting this property causes a redraw
    public var isSelected:Bool = false{
        didSet{
            needsDisplay = true
        }
    }
    
    public override var intrinsicContentSize: NSSize{
        return NSMakeSize(12, 12)
    }

    
    //MARK: - Private variables
    
    private var backgroundToken:String {
        return UIToolkit.shared.isUsingLegacyTokens ? "mainList-indicator" : UTColorTokens.badgeNotificationIndicator.rawValue
    }
    
    private var iconColor:CCColor{
        
        if badgeType == .unread {
            return UIToolkit.shared.getThemeManager().getColors(tokenName: backgroundToken).normal
        }
        
        var tokenName = isSelected ? UTIconLabelStyle.primary.textToken : UTIconLabelStyle.secondary.textToken
        
        if badgeType == .mention || badgeType == .newlyAdded {
            tokenName = backgroundToken
        }
        
        if badgeType == .errorAlert {
            tokenName = UTIconLabelStyle.error.textToken
        }
        
        return  UIToolkit.shared.getThemeManager().getColors(tokenName: tokenName).normal
    }
    
    private var icon:NSAttributedString{
        return NSAttributedString.getAttributedString(iconType: iconType, iconSize: 12, color: iconColor)
    }
    
    private var iconType:MomentumRebrandIconType{
        switch badgeType{
        case .unread,
             .noBadge:
            return ._invalid
        case .mention:
            return .mentionBold
        case .muted:
            return .alertMutedBold
        case .alert:
            return .alertRegular
        case .outgoingCall:
            return .outgoingCallLegacyBold
        case .newlyAdded:
            return .enterRoomBold
        case .blocked:
            return .blockedBold
        case .errorAlert:
            return .priorityCircleFilled
        }
    }
    
    private var circle:NSBezierPath{
        return NSBezierPath(ovalIn: self.bounds.getAdjustedRect(adjust: 1))
    }
        
    //MARK: - Public
    
    internal override func initialise() {
        super.initialise()
        self.setContentHuggingPriority(.init(751), for: .horizontal)
        self.setContentHuggingPriority(.init(751), for: .vertical)
    }
    
    public override func prepareForInterfaceBuilder() {
        invalidateIntrinsicContentSize()
        super.prepareForInterfaceBuilder()
    }
    
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if badgeType == .noBadge {
            return
        }
        
        if badgeType == .unread{
            iconColor.setFill()
            circle.fill()
        }
        else{
            let theIcon = icon
            let drawRect = self.bounds.centredRect(for: theIcon)
            icon.draw(in: drawRect)
        }
    }
    
    public override func setThemeColors() {
        self.needsDisplay = true
    }
}
