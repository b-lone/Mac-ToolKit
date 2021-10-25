//
//  UTGradientSeparator.swift
//  UIToolkit
//
//  Created by Senan Carroll on 12/10/2021.
//

import Cocoa

public class UTGradientSeparator : UTView {
    
    public enum Style {
        case normal
        case focused
        case warn
        case error
    }

    public enum Direction {
        case horizontal
        case vertical
    }

    public var direction: Direction = .horizontal {
        didSet {
            setThemeColors()
        }
    }

    public var style: Style = .normal {
        didSet {
             setThemeColors()
        }
    }

    private var gradient: CAGradientLayer!
    private var startPoint: CGPoint {
        return direction == .horizontal ? CGPoint(x: 0, y: 0.5) : CGPoint(x: 0.5, y: 0)
    }
    private var endPoint: CGPoint {
        return direction == .horizontal ? CGPoint(x: 1, y: 0.5) : CGPoint(x: 0.5, y: 1)
    }

    public override func setThemeColors() {
        super.setThemeColors()
        
        gradient?.removeFromSuperlayer()
        
        var baseToken: UTColorTokens = .separatorSecondary
        var edgeToken: UTColorTokens = .separatorClear
        switch style {
        case .normal:
            baseToken = .separatorSecondary
            edgeToken = .separatorClear
        case .focused:
            baseToken = .separatorAnnounce0
            edgeToken = .separatorAnnounce1
        case .warn:
            baseToken = .separatorWarn0
            edgeToken = .separatorWarn1
        case .error:
            baseToken = .separatorError0
            edgeToken = .separatorError1
        }
        
        let gradientBaseColour = UIToolkit.shared.getThemeManager().getColors(token: baseToken).normal.cgColor
        let gradientEdgeColour = UIToolkit.shared.getThemeManager().getColors(token: edgeToken).normal.cgColor
        setUpGradient(edgeColour: gradientEdgeColour, middleColour: gradientBaseColour)
    }
    
    
    public override var intrinsicContentSize: NSSize {
        if direction == .horizontal {
            return NSMakeSize(NSWidth(frame), 1)
        } else {
            return NSMakeSize(1, NSHeight(frame))
        }
    }
    
    override public func layout() {
        super.layout()
        if let gradient = gradient {
            gradient.frame = self.bounds
        }
    }
    
    private func setUpGradient(edgeColour: CGColor, middleColour: CGColor) {
        gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.type = .axial
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.colors = [NSColor.clear.cgColor, edgeColour, middleColour, middleColour, edgeColour, NSColor.clear.cgColor]
        self.layer?.addSublayer(gradient)
    }
}
