//
//  UTTeamMarker.swift
//  UIToolkit
//
//  Created by James Nestor on 08/10/2021.
//

import Cocoa

public class UTTeamMarker: UTTeamColorView {
    
    public var isArchived:Bool = false

    override var colorStates: UTColorStates {
        return style.teamMarkerColors
    }
    
    override public func initialise() {
        super.initialise()
        self.layer?.cornerRadius = 4
    }
    
    public override var intrinsicContentSize: NSSize {
        return NSMakeSize(8, 64)
    }
    
    public override func setThemeColors() {
        if isArchived {
            //TODO: update with Archive colour when added
            self.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(token: .teamMarkerBackgroundDefault).normal.cgColor
        }
        else {
            super.setThemeColors()
        }
        
    }
    
}
