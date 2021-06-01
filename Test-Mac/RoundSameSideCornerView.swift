//
//  RoundSameSideCornerView.swift
//  WebexTeams
//
//  Created by Archie You on 2021/1/27.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa

enum SparkDirection {
    case Up
    case Down
    case Left
    case Right
    case diagonally //topLeft - bottomRight
    case antidiagonal //bottomLeft - topRight
}

class RoundSameSideCornerView: NSView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            needsDisplay = true
        }
    }
    var backgroundColor = NSColor.clear {
        didSet {
            needsDisplay = true
        }
    }
    
    var borderWidth: CGFloat = 0 {
        didSet {
            needsDisplay = true
        }
    }
    var borderColor = NSColor.clear {
        didSet {
            needsDisplay = true
        }
    }
    
    var cornerDirection = SparkDirection.Down {
        didSet {
            updateCorners()
        }
    }
    
    private var shouldRoundTopRightWhenRounding = false {
        didSet {
            if !shouldRoundTopRightWhenRounding {
                layer?.cornerRadius = 0
            }
        }
    }
    private var shouldRoundTopLeftWhenRounding = false {
        didSet {
            if !shouldRoundTopLeftWhenRounding {
                layer?.cornerRadius = 0
            }
        }
    }
    private var shouldRoundBottomRightWhenRounding = true {
        didSet {
            if !shouldRoundBottomRightWhenRounding {
                layer?.cornerRadius = 0
            }
        }
    }
    private var shouldRoundBottomLeftWhenRounding = true {
        didSet {
            if !shouldRoundBottomLeftWhenRounding {
                layer?.cornerRadius = 0
            }
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let path = getBezierPathWithSomeRoundedCorners()
        backgroundColor.setFill()
        path.fill()
        if borderWidth > 0 {
            let borderPath = getBezierPathWithSomeRoundedCorners(withInset: borderWidth / 2)
            borderColor.setStroke()
            borderPath.lineWidth = borderWidth
            borderPath.stroke()
        }
    }
    
    private func updateCorners() {
        switch cornerDirection {
        case .Up:
            shouldRoundTopLeftWhenRounding = true
            shouldRoundTopRightWhenRounding = true
            shouldRoundBottomLeftWhenRounding = false
            shouldRoundBottomRightWhenRounding = false
        case .Down:
            shouldRoundTopLeftWhenRounding = false
            shouldRoundTopRightWhenRounding = false
            shouldRoundBottomLeftWhenRounding = true
            shouldRoundBottomRightWhenRounding = true
        case .Left:
            shouldRoundTopLeftWhenRounding = true
            shouldRoundTopRightWhenRounding = false
            shouldRoundBottomLeftWhenRounding = true
            shouldRoundBottomRightWhenRounding = false
        case .Right:
            shouldRoundTopLeftWhenRounding = false
            shouldRoundTopRightWhenRounding = true
            shouldRoundBottomLeftWhenRounding = false
            shouldRoundBottomRightWhenRounding = true
        case .diagonally:
            shouldRoundTopLeftWhenRounding = true
            shouldRoundTopRightWhenRounding = false
            shouldRoundBottomLeftWhenRounding = false
            shouldRoundBottomRightWhenRounding = true
        case .antidiagonal:
            shouldRoundTopLeftWhenRounding = false
            shouldRoundTopRightWhenRounding = true
            shouldRoundBottomLeftWhenRounding = true
            shouldRoundBottomRightWhenRounding = false
        }
        needsDisplay = true
    }
    
    private func getBezierPathWithSomeRoundedCorners(withInset inset: CGFloat = 0) -> NSBezierPath {
        // manually draw bezier path with only the specified corners rounded
        let clipPath = NSBezierPath()
        let rect = NSInsetRect(bounds, inset, inset)

        // Start drawing from upper left corner
        let topLeftCorner = NSMakePoint(rect.minX, rect.maxY)
        if shouldRoundTopLeftWhenRounding {
            clipPath.move(to: NSMakePoint(rect.minX + cornerRadius, rect.maxY))
        } else {
            clipPath.move(to: topLeftCorner)
        }

        // draw top right corner
        let topRightCorner = NSMakePoint(rect.maxX, rect.maxY)
        if shouldRoundTopRightWhenRounding {
            clipPath.line(to: NSMakePoint(rect.maxX - cornerRadius, rect.maxY))
            clipPath.appendArc(withCenter: NSMakePoint(rect.maxX - cornerRadius, rect.maxY - cornerRadius), radius: cornerRadius, startAngle: 90, endAngle: 0, clockwise: true)
        } else {
            clipPath.line(to: topRightCorner)
        }

        // draw bottom right corner
        let bottomRightCorner = NSMakePoint(rect.maxX, rect.minY)
        if shouldRoundBottomRightWhenRounding {
            clipPath.line(to: NSMakePoint(rect.maxX, rect.minY + cornerRadius))
            clipPath.appendArc(withCenter: NSMakePoint(rect.maxX - cornerRadius, rect.minY + cornerRadius), radius: cornerRadius, startAngle: 360, endAngle: 270, clockwise: true)
        } else {
            clipPath.line(to: bottomRightCorner)
        }

        // draw bottom left corner
        let bottomLeftCorner = NSMakePoint(rect.minX, rect.minY)
        if shouldRoundBottomLeftWhenRounding {
            clipPath.line(to: NSMakePoint(rect.minX + cornerRadius, rect.minY))
            clipPath.appendArc(withCenter: NSMakePoint(rect.minX + cornerRadius, rect.minY + cornerRadius), radius: cornerRadius, startAngle: 270, endAngle: 180, clockwise: true)
        } else {
            clipPath.line(to: bottomLeftCorner)
        }

        // connect back to top left corner
        if shouldRoundTopLeftWhenRounding {
            clipPath.line(to: NSMakePoint(rect.minX, rect.maxY - cornerRadius))
            clipPath.appendArc(withCenter: NSMakePoint(rect.minX + cornerRadius, rect.maxY - cornerRadius), radius: cornerRadius, startAngle: 180, endAngle: 90, clockwise: true)
        } else {
            clipPath.line(to: topLeftCorner)
        }

        return clipPath
    }
}
