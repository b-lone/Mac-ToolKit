//
//  NSView+Extensions.swift
//  SparkMacDesktop
//
//  Created by jimmcoyn on 27/11/2015.
//  Copyright © 2015 Cisco Systems. All rights reserved.
//

import Foundation

extension NSView{
    
    
    @discardableResult func addConstraintUsingFrameSize(_ width:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal, height:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal ) -> (widthConstraint: NSLayoutConstraint, heightConstraint:NSLayoutConstraint){
        
        let widthConstraint = NSLayoutConstraint(item: self,
                                                 attribute: NSLayoutConstraint.Attribute.width,
                                                 relatedBy: width,
                                                 toItem: nil,
                                                 attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                 multiplier: 1,
                                                 constant: self.frame.width)
        
        let heightConstraint = NSLayoutConstraint(item: self,
                                                  attribute: NSLayoutConstraint.Attribute.height,
                                                  relatedBy: height,
                                                  toItem: nil,
                                                  attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                  multiplier: 1,
                                                  constant: self.frame.height)
        
        self.addConstraints([widthConstraint, heightConstraint])
        
        return (widthConstraint, heightConstraint)
        
    }
    
    
    func addWidthAndHeightConstraints(_ width:CGFloat, height:CGFloat , relatedByWidth:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal, relatedByHeight:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal  ){
        
        let constraints = self.constraints
        self.removeConstraints(constraints)
        let widthConstraint = NSLayoutConstraint(item: self,
                                                 attribute: NSLayoutConstraint.Attribute.width,
                                                 relatedBy: relatedByWidth,
                                                 toItem: nil,
                                                 attribute: NSLayoutConstraint.Attribute.width,
                                                 multiplier: 1,
                                                 constant: width)
        
        widthConstraint.identifier = "widthConstraint"
        
        let heightConstraint = NSLayoutConstraint(item: self,
                                                  attribute: NSLayoutConstraint.Attribute.height,
                                                  relatedBy: relatedByHeight,
                                                  toItem: nil,
                                                  attribute: NSLayoutConstraint.Attribute.height,
                                                  multiplier: 1,
                                                  constant: height)
        
        heightConstraint.identifier = "heightConstraint"
        
 
        
        self.addConstraints([widthConstraint, heightConstraint])
        
    }
    
    
    func addHeightConstraints( height:CGFloat) {
    
        var constraints = self.constraints        
        let heightConstraint = NSLayoutConstraint(item: self,
                                                  attribute: NSLayoutConstraint.Attribute.height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: NSLayoutConstraint.Attribute.height,
                                                  multiplier: 1,
                                                  constant: height)
        
        heightConstraint.identifier = "heightConstraint"
        
        constraints.append(heightConstraint)
        self.addConstraints(constraints)
        
    }
	
	@discardableResult func addWidthRangeConstraints(minWidth:CGFloat, maxWidth:CGFloat) -> (NSLayoutConstraint,NSLayoutConstraint) {
        var constraints = self.constraints
        let minWidthConstraint = NSLayoutConstraint(item: self,
                                                  attribute: NSLayoutConstraint.Attribute.width,
                                                  relatedBy: .greaterThanOrEqual,
                                                  toItem: nil,
                                                  attribute: NSLayoutConstraint.Attribute.width,
                                                  multiplier: 1,
                                                  constant: minWidth)
        
        minWidthConstraint.identifier = "minWidthConstraint"
        
        constraints.append(minWidthConstraint)
		
        let maxWidthConstraint = NSLayoutConstraint(item: self,
                                                  attribute: NSLayoutConstraint.Attribute.width,
                                                  relatedBy: .lessThanOrEqual,
                                                  toItem: nil,
                                                  attribute: NSLayoutConstraint.Attribute.width,
                                                  multiplier: 1,
                                                  constant: maxWidth)
        
        maxWidthConstraint.identifier = "maxWidthConstraint"
        
        constraints.append(maxWidthConstraint)
        self.addConstraints(constraints)
        return (minWidthConstraint, maxWidthConstraint)
	}
    
    func addMinWidthConstraints(minWidth: CGFloat) {
        var constraints = self.constraints
        let minWidthConstraint = NSLayoutConstraint(item: self,
                                                  attribute: NSLayoutConstraint.Attribute.width,
                                                  relatedBy: .greaterThanOrEqual,
                                                  toItem: nil,
                                                  attribute: NSLayoutConstraint.Attribute.width,
                                                  multiplier: 1,
                                                  constant: minWidth)
        
        minWidthConstraint.identifier = "minWidthConstraint"
        
        constraints.append(minWidthConstraint)
        self.addConstraints(constraints)
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
        
        
        do{
            try ObjCExceptionCatcher.catchException{ [] in
                NSLayoutConstraint.activate([topConstraint,bottomConstraint,leadingConstraint,trailingConstraint])
            }
        }
        catch let error{
            assert(false)
            SPARK_LOG_ERROR("Error thrown from Objc NSLayoutConstraint.activate: \(error)")
        }
    }
    
    func addLeadingSpaceToViewConstraint(subview:NSView, constant:CGFloat = 0, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required, relatedBy:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal){
        let leadingConstraint = NSLayoutConstraint(item:subview,
                                                   attribute:NSLayoutConstraint.Attribute.leading,
                                                   relatedBy:relatedBy,
                                                   toItem: self,
                                                   attribute:NSLayoutConstraint.Attribute.leading,
                                                   multiplier:1,
                                                   constant:constant)
        
        leadingConstraint.identifier = "leadingConstraint"
        leadingConstraint.priority = priority
        
        self.addConstraint(leadingConstraint)
    }
    
    func addBottomSpaceToViewConstraint(subview:NSView, constant:CGFloat = 0, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required, relatedBy:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal){
        let bottomConstraint = NSLayoutConstraint(item:subview,
                                                  attribute:NSLayoutConstraint.Attribute.bottom,
                                                  relatedBy:relatedBy,
                                                  toItem: self,
                                                  attribute:NSLayoutConstraint.Attribute.bottom,
                                                  multiplier:1,
                                                  constant:constant)
        
        bottomConstraint.identifier = "bottomConstraint"
        bottomConstraint.priority = priority
        
        self.addConstraint(bottomConstraint)
    }
    
    func addTrailingSpaceToViewConstraint(subview:NSView, constant:CGFloat = 0, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required, relatedBy:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal){
        let trailingConstraint = NSLayoutConstraint(item:subview,
                                                  attribute:NSLayoutConstraint.Attribute.trailing,
                                                  relatedBy:relatedBy,
                                                  toItem: self,
                                                  attribute:NSLayoutConstraint.Attribute.trailing,
                                                  multiplier:1,
                                                  constant:constant)
        
        trailingConstraint.identifier = "trailingConstraint"
        trailingConstraint.priority = priority
        
        self.addConstraint(trailingConstraint)
    }
    
    func addTopSpaceToViewConstraint(subview:NSView, constant:CGFloat = 0, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required, relatedBy:NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal){
        let topConstraint = NSLayoutConstraint(item:subview,
                                                  attribute:NSLayoutConstraint.Attribute.top,
                                                  relatedBy:relatedBy,
                                                  toItem: self,
                                                  attribute:NSLayoutConstraint.Attribute.top,
                                                  multiplier:1,
                                                  constant:constant)
        
        topConstraint.identifier = "topConstraint"
        topConstraint.priority = priority
        
        self.addConstraint(topConstraint)
    }
    
    func addCenterXAlignConstraints(subview:NSView, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required) {
        let centerXConstraint = NSLayoutConstraint(item:subview,
                                                   attribute:NSLayoutConstraint.Attribute.centerX,
                                                   relatedBy:NSLayoutConstraint.Relation.equal,
                                                   toItem: self,
                                                   attribute:NSLayoutConstraint.Attribute.centerX,
                                                   multiplier:1,
                                                   constant:0)
        
        centerXConstraint.identifier = "centerXConstraint"
        centerXConstraint.priority = priority
        
        do {
            try ObjCExceptionCatcher.catchException { [] in
                NSLayoutConstraint.activate([centerXConstraint])
            }
        }
        catch let error {
            assert(false)
            SPARK_LOG_ERROR("Error thrown from Objc NSLayoutConstraint.activateConstraints: \(error)")
        }
    }
    
    func addCenterYAlignConstraints(subview:NSView, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required) {
        let centerYConstraint = NSLayoutConstraint(item:subview,
                                                   attribute:NSLayoutConstraint.Attribute.centerY,
                                                   relatedBy:NSLayoutConstraint.Relation.equal,
                                                   toItem: self,
                                                   attribute:NSLayoutConstraint.Attribute.centerY,
                                                   multiplier:1,
                                                   constant:0)
        
        centerYConstraint.identifier = "centerYConstraint"
        centerYConstraint.priority = priority
        
        do {
            try ObjCExceptionCatcher.catchException { [] in
                NSLayoutConstraint.activate([centerYConstraint])
            }
        }
        catch let error {
            assert(false)
            SPARK_LOG_ERROR("Error thrown from Objc NSLayoutConstraint.activateConstraints: \(error)")
        }
    }
    
    func addCenterAlignConstraints(subview:NSView, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required){
        let centerXConstraint = NSLayoutConstraint(item:subview,
                                                   attribute:NSLayoutConstraint.Attribute.centerX,
                                                   relatedBy:NSLayoutConstraint.Relation.equal,
                                                   toItem: self,
                                                   attribute:NSLayoutConstraint.Attribute.centerX,
                                                   multiplier:1,
                                                   constant:0)
        
        centerXConstraint.identifier = "centerXConstraint"
        centerXConstraint.priority = priority
        
        let centerYConstraint = NSLayoutConstraint(item:subview,
                                                   attribute:NSLayoutConstraint.Attribute.centerY,
                                                   relatedBy:NSLayoutConstraint.Relation.equal,
                                                   toItem: self,
                                                   attribute:NSLayoutConstraint.Attribute.centerY,
                                                   multiplier:1,
                                                   constant:0)
        
        centerYConstraint.identifier = "centerYConstraint"
        centerYConstraint.priority = priority
        
        do{
            try ObjCExceptionCatcher.catchException{ [] in
                NSLayoutConstraint.activate([centerXConstraint,centerYConstraint])
            }
        }
        catch let error{
            assert(false)
            SPARK_LOG_ERROR("Error thrown from Objc NSLayoutConstraint.activateConstraints: \(error)")
        }
    }
    
    
    func getConstraintsWithIdentifiers(identifiers:[String]) -> [NSLayoutConstraint]{
        var foundConstraints:[NSLayoutConstraint] = []
        
        for i in identifiers{
            for con in self.constraints{
                
                if con.identifier == i{
                    foundConstraints.append(con)
                    break
                }
            }
            
        }
        
        return foundConstraints
    }
    
    func getTopSubView() -> NSView? {
        if self.subviews.count > 0 {
            return self.subviews[self.subviews.count - 1]
        }
        return nil
    }
    
    @objc func setAsOnlySubviewAndFill(subview:NSView, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required) {
        
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
    
    @objc func addSubviewAndFill(_ translatesMaskToConstraints:Bool = false ,subview:NSView, hideSubviews hide:Bool = false, priority:NSLayoutConstraint.Priority = NSLayoutConstraint.Priority.required, place: NSWindow.OrderingMode = .above ) {
        
        subview.translatesAutoresizingMaskIntoConstraints = translatesMaskToConstraints
        
        if hide {
            hideSubviews()
        }
        
        subview.isHidden = false
        self.addSubview(subview, positioned: place, relativeTo: nil)
        
        addFillConstraints(subview: subview, priority:priority)
    }
    
    /*
     func addSubviewAndConstrainToEdges
     This NSView Extension function (addSubviewAndConstrainToEdges) adds a subview to this view
     and then sets the top, bottom, leading & trailing constraints of the subview to be equal
     to the top, bottom, leading & trailing constraints of this view. This gives allows changes
     of the height of the subview to affect the height of this view unlike the addSubviewAndFill
     function where the height and width of the subview is equal to the height and width of the
     this view such that if the height of this view changed then the height of the subview would
     change.
     */
    
    func addSubviewAndConstrainToEdges(_ translatesMaskToConstraints:Bool = false ,subview:NSView, hideSubviews hide:Bool = false) {
        
        subview.translatesAutoresizingMaskIntoConstraints = translatesMaskToConstraints
        
        if hide {
            hideSubviews();
        }
        
        self.addSubview(subview, positioned: .above, relativeTo: nil)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subview]|", options: [], metrics: nil, views: ["subview":subview]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subview]|", options: [], metrics: nil, views: ["subview":subview]))
    }
    
    func hideSubviews(){
        for view in subviews{
            view.isHidden = true
        }
    }
    
    func removeSubviews() {
         subviews.forEach({ $0.removeFromSuperview() })
    }
   
    
    func hideSubviewsWithException(_ subview:NSView){
        for view in subviews{
            if  subview != view {
                view.isHidden = true
            }
        }
    }
    
    func hasSubView(_ subview: NSView) -> Bool {
        for view in subviews {
            if subview == view {
                return true
            }
        }
        return false
    }
    
    func hasDescendantView(_ descendantView: NSView) -> Bool {
        return allSubviews.contains(descendantView)
    }
    
    var allSubviews: [NSView] {
        return self.subviews.flatMap { [$0] + $0.allSubviews }
    }
    
    func activateConstraints(_ activate:Bool){
        for constraint in self.constraints{
            constraint.isActive = activate
        }
    }
    
    func isMouseInView() -> Bool{
        
        if let mouseLocation = self.window?.mouseLocationOutsideOfEventStream {
            let pt = self.convert(mouseLocation, from: nil)
            return NSPointInRect(pt, self.bounds)
        }
        
        
        return false
    }
    
    static func recursiveFindSubviewWithIdentifier(theView:NSView, identifier:NSUserInterfaceItemIdentifier?) -> NSView?{
        
        let currentViewIdentifier = theView.identifier
        
        if currentViewIdentifier == identifier{
            return theView
        }
        
        for v in theView.subviews{
            let returnedView = recursiveFindSubviewWithIdentifier(theView: v, identifier: identifier)
            if returnedView != nil{
                return returnedView
            }
        }
        
        return nil
    }
    
    func backgroundColor(color: NSColor) {
        wantsLayer = true
        layer?.backgroundColor = color.cgColor
    }
    
    func getBoundsCenterX()->CGFloat{
        let width = frame.size.width
        return width > 0 ? width / 2 : 0
    }
    
    func getBoundsCenterY()->CGFloat{
        let height = frame.size.height
        return height > 0 ? height / 2 : 0
    }
    
    func getFrameCenterX()->CGFloat{
        let width = frame.origin.x + frame.size.width
        return width > 0 ? width / 2 : 0
    }
    
    func getFrameCenterY()->CGFloat{
        let height = frame.origin.y + frame.size.height
        return height > 0 ? height / 2 : 0
    }
    
    func addBottomBorder(borderColor: NSColor, borderWidth: CGFloat) {
        let layer = CALayer()
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: borderWidth)
        self.layer?.addSublayer(layer)
    }
    
    /** available with OSX 10.13 or later*/
    func roundCorners(radius: CGFloat, corners: CACornerMask, maskToBounds: Bool = false) {
        if #available(OSX 10.13, *) {
            layer?.cornerRadius  = radius
            layer?.maskedCorners = corners
            layer?.masksToBounds = maskToBounds
        }
    }
    
    // Prints results of internal Apple API method `_subtreeDescription` to console.
    public func dump() {
        Swift.print(perform(Selector(("_subtreeDescription")))!)
    }

}



