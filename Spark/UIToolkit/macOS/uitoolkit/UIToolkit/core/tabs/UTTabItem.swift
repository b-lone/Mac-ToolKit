//
//  UTTab.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 28/05/2021.
//

import Cocoa


public class UTTabItem : NSObject {
    
    public var viewController: NSViewController?
    public var representedObject: Any?

    
    internal var label : String!
    internal var accessibilityLabel: String
    internal var tooltip: String
    internal var lhsElement: MomentumIconsRebrandType!
    internal var lhsIconColorToken: String?
    internal var enableArrow = false
    internal var image:NSImage!
    internal var showUnreadPill = false
    internal var badgeCount = 0
    
    public convenience init(showUnreadPill: Bool = false, label:String, accessibilityLabel:String, enableArrow: Bool = false) {
        self.init(showUnreadPill:showUnreadPill, lhsIcon: nil, lhsIconColorToken: nil, image:nil, label:label, accessibilityLabel:accessibilityLabel, tooltip: "", enableArrow: enableArrow)
    }
    
    public convenience init(showUnreadPill: Bool = false, label:String, accessibilityLabel:String, tooltip: String, enableArrow: Bool = false) {
        self.init(showUnreadPill:showUnreadPill, lhsIcon: nil, lhsIconColorToken: nil, image:nil, label:label, accessibilityLabel:accessibilityLabel, tooltip: tooltip, enableArrow: enableArrow)
    }
    
    public convenience init(showUnreadPill: Bool  = false, label:String, lhsIcon: MomentumIconsRebrandType, accessibilityLabel:String, enableArrow: Bool = false) {
        self.init(showUnreadPill:showUnreadPill,lhsIcon: lhsIcon, lhsIconColorToken: nil, image:nil, label:label, accessibilityLabel:accessibilityLabel, tooltip: "", enableArrow: enableArrow)
    }
    
    public convenience init(showUnreadPill: Bool  = false, label:String, lhsIcon: MomentumIconsRebrandType, lhsIconColorToken: String? = nil, accessibilityLabel: String, tooltip: String, enableArrow: Bool = false) {
        self.init(showUnreadPill:showUnreadPill,lhsIcon: lhsIcon, lhsIconColorToken: lhsIconColorToken, image:nil, label:label, accessibilityLabel:accessibilityLabel, tooltip: tooltip, enableArrow: enableArrow)
    }
    
    public convenience init(badgeCount: Int , label:String, lhsIcon: MomentumIconsRebrandType, accessibilityLabel:String, enableArrow: Bool, vc:NSViewController?) {
        self.init(badgeCount:badgeCount, showUnreadPill: false, lhsIcon: lhsIcon, lhsIconColorToken: nil, image:nil, label:label, accessibilityLabel:accessibilityLabel, tooltip: "", enableArrow: enableArrow, vc:vc)
    }
    
    public convenience init(badgeCount: Int , label:String, accessibilityLabel:String, enableArrow: Bool) {
        self.init(badgeCount:badgeCount, showUnreadPill: false, lhsIcon: nil, lhsIconColorToken: nil, image:nil, label:label, accessibilityLabel:accessibilityLabel, tooltip: "", enableArrow: enableArrow)
    }
    
    public convenience init(showUnreadPill: Bool = false,label:String, showAlert: Bool, image:NSImage, accessibilityLabel:String, enableArrow: Bool) {
        self.init(showUnreadPill:showUnreadPill, lhsIcon: nil, lhsIconColorToken: nil, image:image, label:label, accessibilityLabel:accessibilityLabel, tooltip: "", enableArrow: enableArrow)
    }
    
    public convenience init(showUnreadPill: Bool = false, label:String, showAlert: Bool, image:NSImage, accessibilityLabel:String, tooltip: String, enableArrow: Bool) {
        self.init(showUnreadPill:showUnreadPill, lhsIcon: nil, lhsIconColorToken: nil, image:image, label:label, accessibilityLabel:accessibilityLabel, tooltip: tooltip, enableArrow: enableArrow)
    }

       
    private init(badgeCount:Int = 0, showUnreadPill: Bool, lhsIcon: MomentumIconsRebrandType?, lhsIconColorToken: String?, image:NSImage?, label:String!, accessibilityLabel:String, tooltip: String, enableArrow: Bool, vc:NSViewController? = nil) {
        self.showUnreadPill = showUnreadPill
        self.badgeCount = badgeCount
        self.label = label
        self.accessibilityLabel = accessibilityLabel
        self.image = image
        self.lhsElement = lhsIcon
        self.lhsIconColorToken = lhsIconColorToken
        self.enableArrow = enableArrow
        self.tooltip = tooltip
        self.viewController = vc
    }
}

