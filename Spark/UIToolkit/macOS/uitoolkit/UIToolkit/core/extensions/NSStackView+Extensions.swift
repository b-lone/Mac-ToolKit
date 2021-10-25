//
//  NSStackView+Extensions.swift
//  UIToolkit
//
//  Created by James Nestor on 11/06/2021.
//

import Cocoa

extension NSStackView {

    public func removeAllViews() {
        for view in self.views {
            removeView(view)
        }
    }
    
    public func containsItem(item:NSView) -> Bool {
        return self.views.contains(item)
    }
    
    public func removeViews(items:[NSView]){
        for item in items {
            safeRemoveView(view: item)
        }
    }
    
    public func safeRemoveView(view:NSView) {
        if containsItem(item: view) {
            removeView(view)
        }
    }
    
    var visibleViewCount:Int{
        return visibleViews.count
    }
    
    var visibleViews:[NSView] {
        return views.filter({ visibilityPriority(for: $0) != NSStackView.VisibilityPriority.notVisible && $0.isHidden == false })
    }
    
    func getView(after view: NSView) -> NSView?{
        if let index = views.firstIndex(of: view){
            
            let nextIndex = index + 1
            if nextIndex < views.count {
                return views[nextIndex]
            }
        }
        
        return nil
    }
    
    public func setThemeableViewColors(){
        for view in views{
            if let v = view as? ThemeableProtocol{
                v.setThemeColors()
            }
        }
    }
    
    public func updateFontProtocolFonts() {
        for view in views {
            if let v = view as? FontProtocol {
                v.updateFont()
            }
        }
    }
    
}
