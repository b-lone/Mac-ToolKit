//
//  NSView+Extensions.swift
//  UIToolkit
//
//  Created by James Nestor on 19/05/2021.
//

import Cocoa

extension NSView {
    
    public var isMouseInView: Bool {
        if let mouseLocation = self.window?.mouseLocationOutsideOfEventStream {
            let pt = self.convert(mouseLocation, from: nil)
            return NSPointInRect(pt, self.bounds)
        }
        return false
    }

    public var isMouseInVisibleRect:Bool{
        if let mouseLocation = self.window?.mouseLocationOutsideOfEventStream{
            let pt = self.convert(mouseLocation, from: nil)
            if NSPointInRect( pt, self.visibleRect ){
                return true
            }
        }
        return false
    
    }
    
    @objc public func setAsOnlySubviewAndFill(subview:NSView, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        for view in subviews{
            if view != subview{
                view.removeFromSuperview()
            }
        }
        
        if subviews.contains(subview) == false{
            self.addSubview(subview, positioned: .above, relativeTo: nil)
            addFillConstraints(subview: subview)
        }
        
        if subview.isHidden{
           subview.isHidden = false
        }
    }
    
    func addFillConstraints(subview:NSView, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required){
        
        let topConstraint = NSLayoutConstraint(item:subview, attribute:NSLayoutConstraint.Attribute.top,
                                               relatedBy:NSLayoutConstraint.Relation.equal,
                                               toItem: self, attribute:NSLayoutConstraint.Attribute.top,
                                               multiplier:1,
                                               constant:0)
        
        topConstraint.identifier = "topFillConstraint"
        topConstraint.priority = priority
        
        let bottomConstraint = NSLayoutConstraint(item:subview, attribute:NSLayoutConstraint.Attribute.bottom,
                                                  relatedBy:NSLayoutConstraint.Relation.equal,
                                                  toItem: self, attribute:NSLayoutConstraint.Attribute.bottom,
                                                  multiplier:1,
                                                  constant:0)
        
        bottomConstraint.identifier = "bottomFillConstraint"
        bottomConstraint.priority = priority
        
        let leadingConstraint = NSLayoutConstraint(item:subview, attribute:NSLayoutConstraint.Attribute.leading,
                                                   relatedBy:NSLayoutConstraint.Relation.equal,
                                                   toItem: self, attribute:NSLayoutConstraint.Attribute.leading,
                                                   multiplier:1,
                                                   constant:0)
        
        leadingConstraint.identifier = "leadingFillConstraint"
        leadingConstraint.priority = priority
        
        let trailingConstraint = NSLayoutConstraint(item:subview, attribute:NSLayoutConstraint.Attribute.trailing,
                                                    relatedBy:NSLayoutConstraint.Relation.equal,
                                                    toItem: self, attribute:NSLayoutConstraint.Attribute.trailing,
                                                    multiplier:1,
                                                    constant:0)
        
        trailingConstraint.identifier = "trailingFillConstraint"
        trailingConstraint.priority = priority
        
        NSLayoutConstraint.activate([topConstraint,bottomConstraint,leadingConstraint,trailingConstraint])
    }
}
