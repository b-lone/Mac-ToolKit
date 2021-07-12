//
//  LayerDelegate.swift
//  Test-Mac
//
//  Created by Archie You on 2021/7/11.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

//https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/CoreAnimation_Cookbook/Introduction/Introduction.html
//https://www.raywenderlich.com/3096-calayers-tutorial-for-ios-introduction-to-calayers

class LayerDelegate: NSObject, CALayerDelegate, CAAnimationDelegate {
    var layer: CALayer?
    
    func draw(_ layer: CALayer, in ctx: CGContext) {
        let nsGraphicsContext = NSGraphicsContext(cgContext: ctx, flipped: false)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = nsGraphicsContext

        // ...Draw content using NS APIs...
        let aRect = NSMakeRect(10, 10, 30, 30)
        let thePath = NSBezierPath(rect: aRect)
        NSColor.red.set()
        thePath.fill()

        NSGraphicsContext.restoreGraphicsState()
        
//        let bgColor: CGColor = NSColor.red.cgColor
//        ctx.setFillColor(bgColor)
//        ctx.fill(layer.bounds)
    }
    
    func layerWillDraw(_ layer: CALayer) {
    }
    
    func addAnimation(_ layer: CALayer) {
        // create the path for the keyframe animation
        let thePath = CGMutablePath()
        thePath.move(to: NSMakePoint(265, 265))
        thePath.addCurve(to: NSMakePoint(365, 365), control1: NSMakePoint(265, 365), control2: NSMakePoint(365, 265))
         
        // create an explicit keyframe animation that animates the target layer's position property and set the animation's path property
        let theAnimation = CAKeyframeAnimation(keyPath: "position")
        theAnimation.path = thePath
         
        let colorKeyframeAnimation = CAKeyframeAnimation(keyPath: "backgroundColor")

        colorKeyframeAnimation.values = [NSColor.red.cgColor,
                                         NSColor.green.cgColor,
                                         NSColor.blue.cgColor]
        colorKeyframeAnimation.keyTimes = [0, 0.5, 1]
        colorKeyframeAnimation.duration = 2
        
        // create an animation group and add the keyframe animation
        let theGroup = CAAnimationGroup()
        theGroup.animations = [theAnimation, colorKeyframeAnimation]
         
        // set the timing function for the group and the animation duration
        theGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
        theGroup.duration = 2
        theGroup.autoreverses = false
        theGroup.delegate = self
        // Set "isRemovedOnCompletion = false" and "fillMode = .forwards" will remain visible in its final state when the animation is completed. Otherwise it will change back.
        theGroup.isRemovedOnCompletion = false
        theGroup.fillMode = .forwards
         
        // adding the animation to the target layer causes itto begin animating
        layer.add(theGroup, forKey: "animatePosition")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        if flag {
//            layer?.position = NSMakePoint(365, 365)
//        }
    }
}

class LayerView: NSView {
    let layerDelegate = LayerDelegate()
    lazy var subLayer: CALayer = {
        let layer = CALayer()
        layer.delegate = layerDelegate
        layer.backgroundColor = NSColor.green.withAlphaComponent(0.5).cgColor
        layer.frame = NSMakeRect(15, 15, 500, 500)
        layerDelegate.layer = layer
        return layer
    }()
    
    init() {
        super.init(frame: NSMakeRect(0, 0, 1000, 1000))
        
        wantsLayer = true
        layer?.backgroundColor = NSColor.blue.withAlphaComponent(0.5).cgColor
        layer?.addSublayer(subLayer)
        //The layer object's setNeedsDisplay must be called. Simply adding the layer as a sublayer doesn't call draw(_:in:) for you.
        subLayer.setNeedsDisplay()
//        layerDelegate.addAnimation(subLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
