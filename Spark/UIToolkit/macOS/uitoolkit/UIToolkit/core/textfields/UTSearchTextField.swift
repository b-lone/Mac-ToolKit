//
//  UTSearchTextField.swift
//  UIToolkit
//
//  Created by James Nestor on 07/09/2021.
//

import Cocoa

public class UTSearchInputTextField : UTTextField{
    
    class UTSearchIcon: UTTokenIcon {
        
        var style: UTTextField.Style = .textInput {
            didSet{
                self.tokenName = style.textToken
                setThemeColors()
            }
        }
        
        init(){
            super.init(iconType: .searchBold, tokenName: style.textToken, size: .medium)
        }
        
        required init?(coder: NSCoder) {
            fatalError("do not use this constructor")
        }
    }
    
    
    var searchIcon:UTSearchIcon?
    
    var searchIconSize : IconSize {
        if size == .large || style == .globalSearch {
            return .mediumSmall
        }
        return .extraSmall
    }
    
    var searchIconLeadingPos : CGFloat {
        if style == .globalSearch {
            return 16
        }
        
        return searchIconSize == .extraSmall ? 8 : 6
    }
    
    override func initialise() {
        super.initialise()
        setupSearchIcon()
    }
        
    private func setupSearchIcon(){
        
        searchIcon = UTSearchIcon()
        
        if let searchIcon = searchIcon {

            searchIcon.isHidden  = false
            searchIcon.size = searchIconSize
            searchIcon.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(searchIcon)
            let wConstraint             = NSLayoutConstraint.createWidthConstraint(firstItem: searchIcon, constant: searchIcon.intrinsicContentSize.width)
            let hConstraint             = NSLayoutConstraint.createHeightConstraint(firstItem: searchIcon, constant: searchIcon.intrinsicContentSize.height)
            let verticalConstraint      = NSLayoutConstraint(item: searchIcon, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            let searchLeadingConstraint = NSLayoutConstraint.createLeadingSpaceToViewConstraint(firstItem: searchIcon, secondItem: self, constant: searchIconLeadingPos)

            NSLayoutConstraint.activate([wConstraint, hConstraint, verticalConstraint, searchLeadingConstraint])
        }
        
        updateLeadingCellPadding(addLeadingIconPadding: true)
    }
    
    public override func resetCursorRects() {
        
        guard let searchIcon = searchIcon else {
            super.resetCursorRects()
            return
        }
        
        discardCursorRects()
        addCursorRect(NSMakeRect(self.bounds.minX, self.bounds.minY, searchIcon.frame.maxX, self.bounds.height), cursor: .arrow)
                
        if clearIcon?.isHidden == false {
            addCursorRect(NSMakeRect(self.bounds.maxX - UTTextFieldCellTrailingIconPadding, self.bounds.minY, UTTextFieldCellTrailingIconPadding, self.bounds.height), cursor: .arrow)
            addCursorRect(NSMakeRect(searchIcon.frame.maxX, self.bounds.minY, self.bounds.width - UTTextFieldCellTrailingIconPadding - searchIcon.frame.maxX, self.bounds.height), cursor: .iBeam)
        }
        else{
            addCursorRect(NSMakeRect(searchIcon.frame.maxX, self.bounds.minY, self.bounds.width - searchIcon.frame.maxX, self.bounds.height), cursor: .iBeam)
        }
    }
    
    public override func setThemeColors() {
        super.setThemeColors()
        searchIcon?.style = style        
    }
    
    override func setFont() {
        super.setFont()
        searchIcon?.size = searchIconSize
        updateSearchIconConstraints()
    }
    
    override func onStyleUpdated() {
        searchIcon?.style = style
        super.onStyleUpdated()
    }
    
    private func updateSearchIconConstraints(){
        guard let searchIcon = searchIcon else { return }
        for constraint in searchIcon.constraints{
            
            if constraint.identifier == NSLayoutConstraint.WidthConstraintIdentifier ||
                constraint.identifier == NSLayoutConstraint.HeightConstraintIdentifier{
                
                if constraint.constant != searchIcon.intrinsicContentSize.height {
                    constraint.constant = searchIcon.intrinsicContentSize.height
                    
                }
            }
        }
        
        if let leadingConstraint = self.constraints.first(where: {return $0.identifier == NSLayoutConstraint.LeadingConstraintIdentifier}) {
            if leadingConstraint.constant != searchIconLeadingPos{
                leadingConstraint.constant = searchIconLeadingPos
            }
        }
    }
    
    public override func accessibilitySubrole() -> NSAccessibility.Subrole? {
        return NSAccessibility.Subrole.searchField
    }
}
