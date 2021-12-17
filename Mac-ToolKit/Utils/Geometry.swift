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

extension NSRect {
    func check(in outer: CGRect) -> Bool {
        return minX >= outer.minX && minY >= outer.minY && maxX <= outer.maxX && maxY <= outer.maxY
    }
    
    func expand(width deviation: CGFloat) -> CGRect {
        return NSMakeRect(origin.x - deviation, origin.y - deviation, width + deviation * 2, height + deviation * 2)
    }
    
    func expand(dx: CGFloat = 0, dy: CGFloat = 0) -> CGRect {
        return NSMakeRect(origin.x - dx, origin.y - dy, width + dx * 2, height + dy * 2)
    }
    
    func cut(with insets: NSEdgeInsets) -> CGRect {
        return NSMakeRect(origin.x + insets.left, origin.y + insets.bottom, width - insets.left - insets.right, height - insets.bottom - insets.top)
    }
    
    func move(into outer: CGRect) -> CGRect {
        var rect = self
        rect.origin.x = max(rect.minX, outer.minX)
        rect.origin.y = max(rect.minY, outer.minY)
        rect.origin.x = min(rect.maxX - width, outer.maxX - width)
        rect.origin.y = min(rect.maxY - height, outer.maxY - height)
        return rect
    }
    
    func resizeAndMove(into outer: CGRect) -> CGRect {
        var rect = self
        rect.size.width = min(rect.width, outer.width)
        rect.size.height = min(rect.height, outer.height)
        return rect.move(into: outer)
    }
    
    func resizeAndKeepCenter(newSize: CGSize) -> CGRect {
        var rect = self
        rect.origin.x = rect.minX - (newSize.width - rect.width) / 2
        rect.origin.y = rect.minY - (newSize.height - rect.height) / 2
        rect.size = newSize
        return rect
    }
    
    func resizeAndKeepSnap(newSize: CGSize, edge: Edge, outer: CGRect) -> CGRect {
        var rect = self
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
    
    func convertCoordinateOrigin(to newCoordinateOrigin: NSPoint) -> CGRect {
        var rect = self
        rect.origin = rect.origin.convertCoordinateOrigin(to: newCoordinateOrigin)
        return rect
    }
    
    func snap(to theEdge: Edge, of outer: NSRect) -> CGRect {
        var rect = self
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
}

extension NSPoint {
    func move(into outer: CGRect) -> NSPoint {
        var point = self
        point.x = min(point.x, outer.maxX)
        point.x = max(point.x, outer.minX)
        point.y = min(point.y, outer.maxY)
        point.y = max(point.y, outer.minY)
        return point
    }
    
    func convertCoordinateOrigin(to newCoordinateOrigin: NSPoint) -> NSPoint {
        return NSMakePoint(x - newCoordinateOrigin.x, y - newCoordinateOrigin.y)
    }
    
    func getSnapEdge(of outer: NSRect) -> Edge {
        var edge = Edge.top
        var minInset = outer.height - y
        
        if x < minInset {
            edge = .left
            minInset = x
        }
        
        if y < minInset {
            edge = .bottom
            minInset = y
        }
        
        if (outer.width - x) < minInset {
            edge = .right
        }
        
        return edge
    }
}
