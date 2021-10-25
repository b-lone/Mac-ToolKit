//
//  NSRect+Extensions.swift
//  SparkMacDesktop
//
//  Created by James Nestor on 18/10/2017.
//  Copyright © 2017 Cisco Systems. All rights reserved.
//
import CoreGraphics
import Cocoa

extension CCRect {
    
    enum RectPosition {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }
    
    func makeRect(x: CGFloat, y: CGFloat , width: CGFloat, height: CGFloat) -> CCRect {
            #if TARGET_OS_OSX
            return  NSRect(x: x,y: y,width: width,height: height)
            #else
            return  CGRect(x: x,y: y,width: width,height: height)
            #endif
    }
    
    func getAdjustedRect(adjust:CGFloat) -> CCRect{
        return makeRect(x: origin.x + adjust, y: origin.y + adjust, width: size.width - adjust * 2, height: size.height - adjust * 2)
    }
    
#if os(macOS)
    func centre() -> NSPoint {
        return NSPoint(x: origin.x + size.width/2.0, y: origin.y + size.height/2.0)
    }
    
    func getPoint(position: RectPosition) -> NSPoint {
        switch position {
        case .topLeft:
            return NSPoint(x: origin.x, y: origin.y + size.height)
        case .topRight:
            return NSPoint(x: origin.x + size.width, y: origin.y + size.height)
        case .bottomLeft:
            return origin
        case .bottomRight:
            return NSPoint(x: origin.x + size.width, y: origin.y)
        }
    }

    func centredRect(for str: NSAttributedString) -> NSRect {
        
        let strSize = str.size()
                
        let y = max(0, ((self.height - strSize.height) / 2))
        let x = max(0, ((self.width  - strSize.width ) / 2))
        
        return NSMakeRect(x, y, strSize.width, strSize.height)
    }

#endif
}
