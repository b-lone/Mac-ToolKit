//
//  CSIRotatingImageView.swift
//  SparkMacDesktop
//
//  Created by James Nestor on 14/03/2018.
//  Copyright © 2018 Cisco Systems. All rights reserved.
//

import Cocoa

class CSIRotationLayer: CALayer{
    
    override var anchorPoint: CGPoint{
        set{}
        get{
            return NSMakePoint(0.5, 0.5)
        }
    }
}

class CSIRotatingImageView: NSImageView {
    
    @objc private (set) var animating:Bool = false
    private var rotationLayer = CSIRotationLayer()
    
    override var wantsUpdateLayer: Bool{
        return true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
    }
    
    fileprivate func initialise(){
        self.wantsLayer = true
        self.layerContentsRedrawPolicy = NSView.LayerContentsRedrawPolicy.onSetNeedsDisplay
        self.canDrawSubviewsIntoLayer = true
        self.layer = rotationLayer
    }
    
    func startAnimation(speed:Double = 1.0, clockwise:Bool = true){
        
        animating = true
        addAnimationIfNeeded()
    
        self.isHidden = false
    }
    
    
    func stopAnimation(){
        animating = false
        if let layer = self.layer{
            layer.removeAllAnimations()
            self.isHidden = true
        }
    }

    override var layer:CALayer?{
        set{
            if newValue != rotationLayer{
                super.layer = rotationLayer
            }
            else{
                super.layer = newValue
            }
        }
        get{
            return super.layer
        }
    }
    
    override func makeBackingLayer() -> CALayer {
        return rotationLayer
    }
    
    private func addAnimationIfNeeded(){
        if animating{
            if let layer = layer{
                if let _ = layer.animation(forKey: Constants.rotationKeyPath){
                }
                else{
                    let spinningAnimation = layer.initializeSpinner(speed: 1.0, clockWise: true)
                    layer.add(spinningAnimation, forKey: Constants.rotationKeyPath)
                }
            }
        }
    }

}
