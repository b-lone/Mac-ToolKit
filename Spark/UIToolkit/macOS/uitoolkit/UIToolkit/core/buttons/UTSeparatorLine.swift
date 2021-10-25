//
//  UTSeparatorLine.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 20/07/2021.
//

import Cocoa


internal class UTSeparatorLine: UTView {
    
    enum Direction {
        case horizontal
        case vertical
    }
    
    var direction: Direction = .horizontal
    
    var lineWidth:CGFloat = 0.5
    var lineToken:UTColorTokens!
    
    init(length: CGFloat, direction: Direction  = .horizontal , token: UTColorTokens, lineWidth:CGFloat) {
        lineToken = token
        self.lineWidth = lineWidth
        self.direction = direction
        if direction == .horizontal {
            super.init(frame: NSMakeRect(0, 0, length, lineWidth))
        } else {
            super.init(frame: NSMakeRect(0, 0, lineWidth, length))
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    override func initialise() {
        super.initialise()
        setThemeColors()
    }
    
    override func setThemeColors() {

        let color = UIToolkit.shared.getThemeManager().getColors(tokenName: lineToken.rawValue)
        self.layer?.backgroundColor  = color.normal.cgColor
    }
    
    override var intrinsicContentSize: NSSize {
        if direction == .horizontal {
            return NSMakeSize(NSWidth(frame), lineWidth)
        } else {
            return NSMakeSize(lineWidth, NSHeight(frame))
        }
    }
}

