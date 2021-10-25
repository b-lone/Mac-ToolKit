//
//  NSBezierPath+Extensions.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 17/06/2021.
//

import Foundation

import Quartz
import Foundation

extension NSBezierPath{


    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            @unknown default:
                break
            }
        }
        
        return path
    }
    
    
    internal static func getBezierPathWithSomeRoundedCorners(roundedCorners: RoundedCornerStyle, cornerRadius:CGFloat, bounds:NSRect, circle: Bool = true) -> NSBezierPath {
        // manually draw bezier path with only the specified corners rounded
        let clipPath = NSBezierPath()
        
        
        // Start drawing from upper left corner
        let topLeftCorner = NSPoint(x: bounds.minX, y: bounds.maxY)
        if roundedCorners.shouldRounMinXMaxYCorner {
            clipPath.move(to: NSPoint(x: bounds.minX + cornerRadius, y: bounds.maxY))
        } else {
            clipPath.move(to: topLeftCorner)
        }
        
        // draw top right corner
        let topRightCorner = NSPoint(x: bounds.maxX, y: bounds.maxY)
        if roundedCorners.shouldRoundMaxXMaxYCorner {
            clipPath.line(to: NSPoint(x: bounds.maxX - cornerRadius, y: bounds.maxY))
            clipPath.appendArc(withCenter: NSPoint(x: bounds.maxX - cornerRadius, y: bounds.maxY - cornerRadius), radius: cornerRadius, startAngle: 90, endAngle: 0, clockwise: true)
        } else {
            clipPath.line(to: topRightCorner)
        }
        
        // draw bottom right corner
        let bottomRightCorner = NSPoint(x: bounds.maxX, y: bounds.minY)
        if roundedCorners.shouldRoundMaxXMinYCorner  {
            clipPath.line(to: NSPoint(x: bounds.maxX, y: bounds.minY + cornerRadius))
            clipPath.appendArc(withCenter: NSPoint(x: bounds.maxX - cornerRadius, y: bounds.minY + cornerRadius), radius: cornerRadius, startAngle: 360, endAngle: 270, clockwise: true)
        } else {
            clipPath.line(to: bottomRightCorner)
        }
        
        // draw bottom left corner
        let bottomLeftCorner = NSPoint(x: bounds.minX, y: bounds.minY)
        if roundedCorners.shouldRoundMinXMinYCorner {
            clipPath.line(to: NSPoint(x: bounds.minX + cornerRadius, y: bounds.minY))
            clipPath.appendArc(withCenter: NSPoint(x: bounds.minX + cornerRadius, y: bounds.minY + cornerRadius), radius: cornerRadius, startAngle: 270, endAngle: 180, clockwise: true)
        } else {
            clipPath.line(to: bottomLeftCorner)
        }
        
        // connect back to top left corner
        if circle {
            if roundedCorners.shouldRounMinXMaxYCorner {
                clipPath.line(to: NSPoint(x: bounds.minX, y: bounds.maxY - cornerRadius))
                clipPath.appendArc(withCenter: NSPoint(x: bounds.minX + cornerRadius, y: bounds.maxY - cornerRadius), radius: cornerRadius, startAngle: 180, endAngle: 90, clockwise: true)
            } else {
                clipPath.line(to: topLeftCorner)
            }
        }

        return clipPath
    }
    
    
    
}
