//
//  Geometry.swift
//  Mac-ToolKit
//
//  Created by Archie You on 2021/10/29.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Foundation

enum Edge: Int {
    case top = 0
    case bottom = 1
    case left = 2
    case right = 3
}

enum Orientation : Int {
    case horizontal = 0
    case vertical = 1
}

class Geometry {
    @discardableResult static func expand(_ rect: inout CGRect, width deviation: CGFloat) -> CGRect {
        rect.origin.x -= deviation
        rect.origin.y -= deviation
        rect.size.width += deviation * 2
        rect.size.height += deviation * 2
        return rect
    }
    
    @discardableResult static func expand(_ rect: inout CGRect, dx: CGFloat = 0, dy: CGFloat = 0) -> CGRect {
        rect.origin.x -= dx
        rect.origin.y -= dy
        rect.size.width += dx * 2
        rect.size.height += dy * 2
        return rect
    }
    
    @discardableResult static func cut(_ rect: inout CGRect, with insets: NSEdgeInsets) -> CGRect {
        rect.origin.x += insets.left
        rect.origin.y += insets.bottom
        rect.size.width -= insets.left + insets.right
        rect.size.height -= insets.bottom + insets.top
        return rect
    }
    
    @discardableResult static func move(_ rect: inout CGRect, into outer: CGRect) -> CGRect {
        if rect.minX < outer.minX {
            rect.origin.x = outer.minX
        }
        if rect.minY < outer.minY {
            rect.origin.y = outer.minY
        }
        if rect.maxX > outer.maxX {
            rect.origin.x = outer.maxX - rect.width
        }
        if rect.maxY > outer.maxY {
            rect.origin.y = outer.maxY - rect.height
        }
        return rect
    }
    
    @discardableResult static func move(_ point: inout NSPoint, into outer: CGRect) -> NSPoint {
        point.x = min(point.x, outer.maxX)
        point.x = max(point.x, outer.minX)
        point.y = min(point.y, outer.maxY)
        point.y = max(point.y, outer.minY)
        return point
    }
    
    @discardableResult static func resizeAndKeepCenter(_ rect: inout CGRect, newSize: CGSize) -> CGRect {
        rect.origin.x = rect.minX - (newSize.width - rect.width) / 2
        rect.origin.y = rect.minY - (newSize.height - rect.height) / 2
        rect.size = newSize
        return rect
    }
    
    @discardableResult static func resizeAndKeepSnap(_ rect: inout CGRect, newSize: CGSize, edge: Edge, outer: CGRect) -> CGRect {
        switch edge {
        case .top:
            rect.origin.x = rect.minX - (newSize.width - rect.width) / 2
            rect.origin.y = outer.maxY - newSize.height
        case .bottom:
            rect.origin.x = rect.minX - (newSize.width - rect.width) / 2
            rect.origin.y = outer.minY
        case .left:
            rect.origin.x = outer.minX
            rect.origin.y = rect.minY - (newSize.height - rect.height) / 2
        case .right:
            rect.origin.x = outer.maxX - newSize.width
            rect.origin.y = rect.minY - (newSize.height - rect.height) / 2
        }
        
        rect.size = newSize
        return rect
    }
    
    @discardableResult static func convertCoordinateOrigin(_ point: inout NSPoint, to newCoordinateOrigin: NSPoint) -> NSPoint {
        point.x -= newCoordinateOrigin.x
        point.y -= newCoordinateOrigin.y
        return point
    }
    
    @discardableResult static func convertCoordinateOrigin(_ rect: inout NSRect, to newCoordinateOrigin: NSPoint) -> CGRect {
        convertCoordinateOrigin(&rect.origin, to: newCoordinateOrigin)
        return rect
    }
    
    @discardableResult static func snap(_ rect: inout NSRect, to theEdge: Edge, of outer: NSRect) -> CGRect {
        switch theEdge {
        case .top:
            rect.origin.y = outer.maxY - rect.height
        case .bottom:
            rect.origin.y = outer.minY
        case .right:
            rect.origin.x = outer.maxX - rect.width
        case .left:
            rect.origin.x = outer.minX
        }
        return rect
    }
    
    static func getSnapEdge(point: NSPoint, of outer: NSRect) -> Edge {
        var edge = Edge.top
        var minInset = outer.height - point.y
        
        if point.x < minInset {
            edge = .left
            minInset = point.x
        }
        
        if point.y < minInset {
            edge = .bottom
            minInset = point.y
        }
        
        if (outer.width - point.x) < minInset {
            edge = .right
        }
        
        return edge
    }
}
