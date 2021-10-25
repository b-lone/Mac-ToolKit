//
//  NSLayoutConstraint+Extensions.swift
//  SparkMacDesktop
//
//  Created by James Nestor on 16/10/2017.
//  Copyright © 2017 Cisco Systems. All rights reserved.
//

import Cocoa

extension NSLayoutConstraint {
    
    static let LeadingConstraintIdentifier = "leadingConstraint"
    static let HeightConstraintIdentifier  = "heightConstraint"
    static let WidthConstraintIdentifier   = "widthConstraint"
    
    class func createLeadingSpaceToViewConstraint(firstItem:NSView, secondItem:NSView?, constant:CGFloat = 0, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required, relatedBy:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal) -> NSLayoutConstraint{
        
        let leadingConstraint = NSLayoutConstraint(item:firstItem,
                                                   attribute:NSLayoutConstraint.Attribute.leading,
                                                   relatedBy:relatedBy,
                                                   toItem: secondItem,
                                                   attribute:NSLayoutConstraint.Attribute.leading,
                                                   multiplier:1,
                                                   constant:constant)
        
        leadingConstraint.identifier = NSLayoutConstraint.LeadingConstraintIdentifier
        leadingConstraint.priority = priority
        
        return leadingConstraint
    }
    
    class func createBottomSpaceToViewConstraint(firstItem:NSView, secondItem:NSView?, constant:CGFloat = 0, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required, relatedBy:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal) -> NSLayoutConstraint{
        
        let bottomConstraint = NSLayoutConstraint(item:firstItem,
                                                  attribute:NSLayoutConstraint.Attribute.bottom,
                                                  relatedBy:relatedBy,
                                                  toItem: secondItem,
                                                  attribute:NSLayoutConstraint.Attribute.bottom,
                                                  multiplier:1,
                                                  constant:constant)
        
        bottomConstraint.identifier = "bottomConstraint"
        bottomConstraint.priority = priority
        
        return bottomConstraint
    }
    
    class func createBottomSpaceToViewTopConstraint(firstItem:NSView, secondItem:NSView?, constant:CGFloat = 0, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required, relatedBy:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal) -> NSLayoutConstraint{
        
        let bottomConstraint = NSLayoutConstraint(item:firstItem,
                                                  attribute:NSLayoutConstraint.Attribute.bottom,
                                                  relatedBy:relatedBy,
                                                  toItem: secondItem,
                                                  attribute:NSLayoutConstraint.Attribute.top,
                                                  multiplier:1,
                                                  constant:constant)
        
        bottomConstraint.identifier = "bottomToTopConstraint"
        bottomConstraint.priority = priority
        
        return bottomConstraint
    }
    
    class func createTrailingSpaceToViewConstraint(firstItem:NSView, secondItem:NSView?, constant:CGFloat = 0, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required, relatedBy:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal) -> NSLayoutConstraint{
        
        let trailingConstraint = NSLayoutConstraint(item:firstItem,
                                                    attribute:NSLayoutConstraint.Attribute.trailing,
                                                    relatedBy:relatedBy,
                                                    toItem: secondItem,
                                                    attribute:NSLayoutConstraint.Attribute.trailing,
                                                    multiplier:1,
                                                    constant:constant)
        
        trailingConstraint.identifier = "trailingConstraint"
        trailingConstraint.priority = priority
        
        return trailingConstraint
    }
    
    class func createTrailingSpaceToViewLeadingEdgeConstraint(firstItem:NSView, secondItem:NSView?, constant:CGFloat = 0, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required, relatedBy:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal) -> NSLayoutConstraint{
        
        let trailingToLeadingConstraint = NSLayoutConstraint(item:firstItem,
                                                            attribute:NSLayoutConstraint.Attribute.trailing,
                                                            relatedBy:relatedBy,
                                                            toItem: secondItem,
                                                            attribute:NSLayoutConstraint.Attribute.leading,
                                                            multiplier:1,
                                                            constant:constant)
        
        trailingToLeadingConstraint.identifier = "trailingToLeadingConstraint"
        trailingToLeadingConstraint.priority = priority
        
        return trailingToLeadingConstraint
    }
    
    class func createTopSpaceToViewConstraint(firstItem:NSView, secondItem:NSView?, constant:CGFloat = 0, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required, relatedBy:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal) -> NSLayoutConstraint{
       
        let topConstraint = NSLayoutConstraint(item:firstItem,
                                               attribute:NSLayoutConstraint.Attribute.top,
                                               relatedBy:relatedBy,
                                               toItem: secondItem,
                                               attribute:NSLayoutConstraint.Attribute.top,
                                               multiplier:1,
                                               constant:constant)
        
        topConstraint.identifier = "topConstraint"
        topConstraint.priority = priority
        
        return topConstraint
    }
    
    class func createVerticalSpaceConstraint(firstItem:NSView, secondItem:NSView, constant:CGFloat = 0, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required, relatedBy:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal) -> NSLayoutConstraint{
        
        let topConstraint = NSLayoutConstraint(item:firstItem,
                                               attribute:NSLayoutConstraint.Attribute.top,
                                               relatedBy:relatedBy,
                                               toItem:secondItem,
                                               attribute:NSLayoutConstraint.Attribute.bottom,
                                               multiplier:1,
                                               constant:constant)
        
        topConstraint.identifier = "verticalSpaceConstraint"
        topConstraint.priority = priority
        
        return topConstraint
    }
    
    class func createCenterYViewConstraint(firstItem:NSView, secondItem:NSView?, constant:CGFloat = 0, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required, relatedBy:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal) -> NSLayoutConstraint{
     
        let centerYConstraint = NSLayoutConstraint(item:firstItem,
                                                   attribute:NSLayoutConstraint.Attribute.centerY,
                                                   relatedBy:relatedBy,
                                                   toItem: secondItem,
                                                   attribute:NSLayoutConstraint.Attribute.centerY,
                                                   multiplier:1,
                                                   constant:constant)
        
        centerYConstraint.identifier = "centerYConstraint"
        centerYConstraint.priority = priority
        
        return centerYConstraint
    }
    
    class func createCenterXViewConstraint(firstItem:NSView, secondItem:NSView?, constant:CGFloat = 0, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required, relatedBy:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal) -> NSLayoutConstraint{
        
        let centerYConstraint = NSLayoutConstraint(item:firstItem,
                                                   attribute:NSLayoutConstraint.Attribute.centerX,
                                                   relatedBy:relatedBy,
                                                   toItem: secondItem,
                                                   attribute:NSLayoutConstraint.Attribute.centerX,
                                                   multiplier:1,
                                                   constant:constant)
        
        centerYConstraint.identifier = "centerXConstraint"
        centerYConstraint.priority = priority
        
        return centerYConstraint
    }
    
    class func createHeightConstraint(firstItem:NSView, constant:CGFloat = 0, secondItem:NSView? = nil, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required, relatedBy:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal, multiplier:CGFloat = 1) -> NSLayoutConstraint{
        
        let heightConstraint = NSLayoutConstraint(item: firstItem,
                                                  attribute: NSLayoutConstraint.Attribute.height,
                                                  relatedBy: relatedBy,
                                                  toItem: secondItem,
                                                  attribute: NSLayoutConstraint.Attribute.height,
                                                  multiplier: multiplier,
                                                  constant: constant)
        
        heightConstraint.identifier = NSLayoutConstraint.HeightConstraintIdentifier
        heightConstraint.priority = priority
        
        
        return heightConstraint
    }
    
    class func createWidthConstraint(firstItem:NSView, constant:CGFloat = 0, secondItem:NSView? = nil, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required, relatedBy:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal, multiplier:CGFloat = 1) -> NSLayoutConstraint{
        
        let widthConstraint = NSLayoutConstraint(item: firstItem,
                                                  attribute: NSLayoutConstraint.Attribute.width,
                                                  relatedBy: relatedBy,
                                                  toItem: secondItem,
                                                  attribute: NSLayoutConstraint.Attribute.width,
                                                  multiplier: multiplier,
                                                  constant: constant)
        
        widthConstraint.identifier = NSLayoutConstraint.WidthConstraintIdentifier
        widthConstraint.priority = priority
        
        
        return widthConstraint
    }
}
