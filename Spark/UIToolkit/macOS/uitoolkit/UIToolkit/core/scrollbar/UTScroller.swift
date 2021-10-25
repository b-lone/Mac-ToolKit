//
//  UTScroller.swift
//  UIToolkit
//
//  Created by James Nestor on 19/05/2021.
//

import Cocoa

public enum UTLegacyScrollerStyle{
    case defaultBackground
    case noBackground
    case customBackground
}

class UTScroller: NSScroller, ThemeableProtocol {
    
    //MARK: - Public variables

    ///If legacy style NSScroller.style is set this dictates how we draw the knob slot.
    ///default background will call to NSScroller to draw
    ///No background will draw nothing where for the knob slot and only draw the knob
    ///custom background will draw a custom knob slot
    ///(legacy/overlay is dictated by the OS setting. Default is to show if a mouse is plugged in and not if a trackpad. This is configuratble in OS settings)
    var legacyScrollerStyle:UTLegacyScrollerStyle = .defaultBackground{
        didSet{
            needsDisplay = true
        }
    }
    
    override class var isCompatibleWithOverlayScrollers : Bool{
        return true
    }
    
    //MARK: - Private custom knob style background colours
    
    private var knobSlotBackgroundColor:CCColor{
        return UIToolkit.shared.getThemeManager().getColors(tokenName: "scrollbar-backgroundGutter").normal
    }
    
    //MARK: - ThemeableProtocol
    
    func setThemeColors() {
        needsDisplay = true
    }
    
    //MARK: - Overridden NSScroller functions for drawing
    init(legacyScrollerStyle: UTLegacyScrollerStyle){
        super.init(frame: NSZeroRect)
        self.legacyScrollerStyle = legacyScrollerStyle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func scrollerWidth(for controlSize: NSControl.ControlSize, scrollerStyle: NSScroller.Style) -> CGFloat{
        return NSScroller.scrollerWidth(for: controlSize, scrollerStyle: scrollerStyle)
    }
    
    override func drawKnobSlot(in slotRect: NSRect, highlight flag: Bool) {
        
        if legacyScrollerStyle == .defaultBackground{
            super.drawKnobSlot(in: slotRect, highlight: flag)
        }
        else if legacyScrollerStyle == .customBackground{
            
            knobSlotBackgroundColor.setFill()
            let path = NSBezierPath(roundedRect: slotRect, xRadius: 8, yRadius: 8)
            path.fill()
        }
    }
    
}
