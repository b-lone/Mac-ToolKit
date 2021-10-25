//
//  CALayer+Extensions.swift
//  UIToolkit
//
//  Created by James Nestor on 20/08/2021.
//

import Cocoa

extension CALayer {

    func updateCentrePoint(rotationPointX: CGFloat = 0.5, rotationPointY: CGFloat = 0.5) {
        let frame = self.frame
        let anchorPoint = CGPoint(x: rotationPointX,y: rotationPointY)
        
        let newPoint: CGPoint = CGPoint(x: frame.size.width * anchorPoint.x, y: frame.size.height * anchorPoint.y)
        let oldPoint: CGPoint = CGPoint(x: frame.size.width * self.anchorPoint.x, y: frame.size.height * self.anchorPoint.y)
        
        if newPoint != oldPoint {
            
            // re-centre the position / centre of the layer
            
            var newPosition = self.position
            
            newPosition.x -= oldPoint.x
            newPosition.x += newPoint.x
            newPosition.y -= oldPoint.y
            newPosition.y += newPoint.y
            
            self.anchorPoint = anchorPoint
            self.position = newPosition
        }
    }
    
    func animate(color: CGColor, keyPath: String, duration: Double) {
       if value(forKey: keyPath) as! CGColor? != color {
           let animation = CABasicAnimation(keyPath: keyPath)
           animation.toValue = color
           animation.fromValue = value(forKey: keyPath)
           animation.duration = duration
           animation.isRemovedOnCompletion = false
           animation.fillMode = CAMediaTimingFillMode.forwards
           add(animation, forKey: keyPath)
           setValue(color, forKey: keyPath)
       }
   }
    
}
