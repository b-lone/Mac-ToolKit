//
//  NSScreen+Extensions.swift
//  SparkMacDesktop
//
//  Created by Alan McCann on 09/10/2017.
//  Copyright © 2017 Cisco Systems. All rights reserved.
//

import Cocoa

//enum DockPosition {
//    case bottom
//    case left
//    case right
//}

extension NSScreen{
//    static func getDisplayId() -> NSNumber {
//        var displayId = NSNumber()
//
//        for screen in NSScreen.screens {
//            if let d = screen.displayID() {
//                displayId = d
//                break
//            }
//        }
//
//        return displayId
//    }

    //This logic is definied by the visual design team and has no real meaning
    func getScreenNumberName() -> String {
        let screens = NSScreen.screens
        
        if screens.count < 2 {
            return "Screen"
        }
        
        var screenNumber = 1
        
        for s in screens {
            if self == s {
                break
            }
            screenNumber += 1
        }
        
        return String.localizedStringWithFormat("Screen %@", String(screenNumber))
    }
//
//    static func mainScreenScaleFactor() -> CGFloat{
//        if let screen = NSScreen.main{
//            return screen.backingScaleFactor
//        }
//
//        return 1.0
//    }
////
//    func getDockPosition() -> DockPosition {
//        if visibleFrame.origin.y == 0 {
//            if visibleFrame.origin.x == 0 { return .right }
//            return .left
//        }
//        return .bottom
//    }
//
//    func getDockLength() -> CGFloat {
//        let dockPosition = getDockPosition()
//        let size: CGFloat
//        switch dockPosition {
//        case .right:
//            size = frame.width - visibleFrame.width
//        case .left:
//            size = visibleFrame.origin.x
//        case .bottom:
//            size = visibleFrame.origin.y
//        }
//        return size
//    }
}
