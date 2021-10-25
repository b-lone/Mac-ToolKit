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
        elementSize.minIntrinsicWidth = 30
    }

    public var roundSetting: RoundedCornerStyle = .lhs {
        didSet {
            updateLayerMask()
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
        let path = NSBezierPath.getBezierPathWithSomeRoundedCorners(roundedCorners: roundSetting, cornerRadius: heightFloat/2, bounds: bounds, circle: roundSetting != .rhs)
        NSColor(cgColor: borderColor.cgColor)?.setStroke()
       
        path.stroke()
    }
    
    override var trailingPadding: CGFloat { trailingLeadingPadding }
    
    override var leadingPadding: CGFloat { trailingLeadingPadding }
    
    private var trailingLeadingPadding:CGFloat {
        switch roundSetting {
        case .pill, .lhs:
            switch buttonHeight {
            case .extralarge:
                assert(false, "extralarge not supported for UTPillButton")
                return 16
            case .large: return 16
            case .medium: return 12
            case .small: return 10
            case .extrasmall: return 10
            default:
                assert(false)
                return 40
            }
        case .rhs, .none, .top, .bottom:
            switch buttonHeight {
            case .extralarge:
                assert(false, "extralarge not supported for UTPillButton")
                return 7
            case .large, .medium, .small, .extrasmall: return 7
            default:
                assert(false)
                return 7
            }
        }
    }
    
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
}

public class UTDownArrowRoundedCornerButton: UTRoundedCornerButton {
    override func initialise(){
        addUIElement(element: .ArrowIcon)
        super.initialise()
    }
}
