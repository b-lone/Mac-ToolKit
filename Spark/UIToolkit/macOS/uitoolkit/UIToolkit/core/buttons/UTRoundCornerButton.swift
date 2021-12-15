//
//  UTRoundedButton.swift
//  UIToolkit
//
//  Created by Archie You on 2021/8/19.
//

import Cocoa

public class UTRoundedCornerButton: UTPillButton {
    override func initialise(){
        super.initialise()
        elementSize.minIntrinsicWidth = 28
    }

    public var roundSetting: RoundedCornerStyle = .leading {
        didSet {
            updateLayerMask()
            needsDisplay = true
        }
    }
    
    private func updateLayerMask() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = NSBezierPath.getBezierPathWithSomeRoundedCorners(roundedCorners: roundSetting, cornerRadius: heightFloat/2, bounds: bounds).cgPath
        layer?.mask = shapeLayer
    }
    
    //add mask for layer will get discontinuous border, so we should draw border by ourselves
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        //Because of the transparency, the superposition of two border colors will result in a wrong color, so we don't draw the rhs overlapping part of the border
        
        
        let path = NSBezierPath.getBezierPathWithSomeRoundedCorners(roundedCorners: roundSetting, cornerRadius: heightFloat/2, bounds: bounds, circle: roundSetting != (isLayoutDirectionRightToLeft() ? rightToLeftRoundedCornerStyle() : .trailing))
        NSColor(cgColor: borderColor.cgColor)?.setStroke()
       
        path.stroke()
    }
    
    open var horizontalPadding: CGFloat = 12
    open var elementPadding: CGFloat = 8 {
        didSet {
            elementSize.elementPadding = elementPadding
        }
    }
    
    override var trailingPadding: CGFloat { horizontalPadding }
    override var leadingPadding: CGFloat { horizontalPadding }
    
    override func updateBorderWidth() {
        layer?.borderWidth = 0
    }
    
    public override func updateCorners() {
        layer?.cornerRadius = 0
        updateLayerMask()
    }

    open override func drawFocusRingMask() {
        let path = NSBezierPath.getBezierPathWithSomeRoundedCorners(roundedCorners: roundSetting, cornerRadius: heightFloat/2, bounds: bounds)
        path.fill()
    }
    
    private func rightToLeftRoundedCornerStyle() -> RoundedCornerStyle {
        return self.roundSetting == .leading ? .trailing : .leading
    }
}

public class UTDownArrowRoundedCornerButton: UTRoundedCornerButton {
    override func initialise(){
        addUIElement(element: .ArrowIcon)
        super.initialise()
    }
}
