//
//  LayerDelegate.swift
//  Test-Mac
//
//  Created by Archie You on 2021/7/11.
//  Copyright © 2021 Cisco. All rights reserved.
//
//https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html
//https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/CoreAnimation_Cookbook/Introduction/Introduction.html
//https://www.raywenderlich.com/3096-calayers-tutorial-for-ios-introduction-to-calayers
//https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html
//
//       -----------------------
//      |      UIKit/AppKit     |
//       -----------------------
//      |     Core Animation    |
//       -----------------------
//      | Metal | Core Graphics |
//       -----------------------
//      |    Graphics Hardware  |
//       -----------------------
// point-based coordinate systems and unit coordinate systems
//The bounds defines the coordinate system of the layer itself and encompasses the layer’s size on the screen. The position property defines the location of the layer relative to its parent’s coordinate system.
//In iOS, the origin of the bounds rectangle is in the top-left corner of the layer by default, and in OS X it is in the bottom-left corner.
//The position property is located in the middle of the layer.
//You must not mark a layer as opaque if it also has a nonzero corner radius
//the corner radius does not affect the image in the layer’s contents property unless the masksToBounds property is set to YES. However, the corner radius always affects how the layer’s background color and border are drawn.
//The main reason for doing so is that once added to the layer, you cannot modify the CIFilter object itself. However, you can use the layer’s setValue:forKeyPath: method to change filter values after the fact.

import Cocoa



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
    
    override func makeBackingLayer() -> CALayer {
        let layer = CALayer()
        return layer
    }
}
