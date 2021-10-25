//
//  UTView.swift
//  UIToolkit
//
//  Created by James Nestor on 10/06/2021.
//

import Cocoa

public class UTView: NSView, ThemeableProtocol {
    
    ///Allow users to configure if the coordinate system is flipped
    ///In a flipped coordinte system the origin is in the upper right
    @IBInspectable var flipCoordinateSystem:Bool = false
    public override var isFlipped: Bool{
        return flipCoordinateSystem
    }
    
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    internal func initialise(){
        self.wantsLayer = true
        setThemeColors()
    }
    
    public func setThemeColors() {
        self.needsDisplay = true
    }
    
}
