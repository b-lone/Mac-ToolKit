//
//  UTTeamView.swift
//  UIToolkit
//
//  Created by James Nestor on 12/10/2021.
//

import Cocoa

public class UTTeamColorView: UTView {
    
    public var style:UTTeamStyle = .defaultStyle {
        didSet {
            setThemeColors()
        }
    }
    
    public var customColor:CCColor?
    
    var colorStates:UTColorStates {
        return style.avatarColors
    }
    
    public init() {
        super.init(frame: NSZeroRect)
        initialise()
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    public override func initialise() {
        self.wantsLayer = true
    }
    
    ///If the style is custom and the custom color is not nil the marker
    ///will use the custom color otherwise it will set the color based on the style
    public func configure(style:UTTeamStyle, customColor: CCColor?){
        self.customColor = customColor
        self.style = style
    }
    
    public override func setThemeColors() {
        super.setThemeColors()
        
        if style == .custom {
            if let color = customColor {
                self.layer?.backgroundColor = color.cgColor
            }
            else {
                self.layer?.backgroundColor = colorStates.normal.cgColor
            }
        }
        else {
            self.layer?.backgroundColor = colorStates.normal.cgColor
        }
    }
}
