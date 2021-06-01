//
//  MagicDrawingBoardManager.swift
//  WebexTeams
//
//  Created by Archie You on 2021/5/28.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa

protocol MagicDrawingBoardManagerProtocol {
    func drawScreenBorder(screen: NSScreen)
    func drawWindowsBorder(windowList: [Int])
}

class MagicWindowInfo: NSObject {
    var windowNumber: UInt32
    var bounds: CGRect
    var windowBasedFrame: CGRect = .zero
    var level: Int
    var stackingOrder: Int
    
    init(windowNumber: UInt32 = 0, bounds: CGRect = .zero, level: Int = 0, stackingOrder: Int = 0) {
        self.windowNumber = windowNumber
        self.bounds = bounds
        self.level = level
        self.stackingOrder = stackingOrder
    }
    
    override var description: String {
        return "windowNumber:\(windowNumber) bounds:\(bounds) level:\(level)"
    }
    
    func descripte() {
        print(description)
    }
}

class MagicDrawingBoardManager: NSObject {
    private var drawingBoardWindowControllers = [String: MagicDrawingBoardWindowController]()
    private var windowInfoList = [MagicWindowInfo]()
    
    override init() {
        super.init()
        
        let screens = NSScreen.screens
        screens.forEach {
            drawingBoardWindowControllers[$0.uuid] = MagicDrawingBoardWindowController(screen: $0)
        }
        drawingBoardWindowControllers.values.forEach { windowController in
            windowController.window?.makeKeyAndOrderFront(nil)
        }
    }
    
    func isValidWindow(windowInfo: MagicWindowInfo) -> Bool {
        if windowInfo.level == kCGMainMenuWindowLevel || windowInfo.level == kCGStatusWindowLevel || windowInfo.level == kCGDockWindowLevel || windowInfo.level == kCGUtilityWindowLevel || windowInfo.level == kCGPopUpMenuWindowLevel {
            return false
        }
        if drawingBoardWindowControllers.values.contains(where:  { $0.window!.windowNumber == windowInfo.windowNumber }) {
            return false
        }
        return true
    }
    
    func getWindowInfoList(from windowDescriptionList: Array<[CFString: AnyObject]>) -> [MagicWindowInfo] {
        var windowInfoList = [MagicWindowInfo]()
        
        for windowDescription in windowDescriptionList {
            let windowInfo = MagicWindowInfo()
            if let windowLevel = windowDescription[kCGWindowLayer] as? Int {
                windowInfo.level = windowLevel
            }
            if let windowNumber = windowDescription[kCGWindowNumber] as? UInt32 {
                windowInfo.windowNumber = windowNumber
            }
            if let bounds = CGRect(dictionaryRepresentation: windowDescription[kCGWindowBounds] as! CFDictionary) {
                windowInfo.bounds = bounds
            }
            
            if !isValidWindow(windowInfo: windowInfo) { continue }
            windowInfo.descripte()
            
            windowInfoList.append(windowInfo)
        }
        windowInfoList.reverse()
        var stackingOrder = 0
        for windowInfo in windowInfoList {
            windowInfo.stackingOrder = stackingOrder
            stackingOrder += 1
        }
        return windowInfoList
    }
    
    func getWindowInfo(by windowNumber: UInt32) -> MagicWindowInfo? {
        return windowInfoList.first { $0.windowNumber == windowNumber }
    }
    
    func getBorderedWindowInfoList(windowList: [Int]) -> [MagicWindowInfo] {
        return windowInfoList.compactMap { windowList.contains(Int($0.windowNumber)) ? $0 : nil }
    }
    
    func getBottomWindowInfoIndex(windowList: [Int]) -> MagicWindowInfo? {
        let windowInfo = windowInfoList.first { windowList.contains(Int($0.windowNumber)) }
        return windowInfo
    }
    
    func getWindowInfoListAbove(bottomWindowInfo: MagicWindowInfo) -> [MagicWindowInfo] {
        if let bottomIndex = windowInfoList.firstIndex(where: { $0.windowNumber == bottomWindowInfo.windowNumber }) {
            return Array(windowInfoList[(bottomIndex + 1)...])
        }
        return []
    }
    
    func updateWindowInfoList() {
        if let windowDescriptionList = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as? Array<[CFString: AnyObject]> {
            windowInfoList = getWindowInfoList(from: windowDescriptionList)
        }
    }
}

extension MagicDrawingBoardManager: MagicDrawingBoardManagerProtocol {
    func drawWindowsBorder(windowList: [Int]) {
        updateWindowInfoList()
        if let windowInfo = getBottomWindowInfoIndex(windowList: windowList) {
            let windowInfoListAbove = getWindowInfoListAbove(bottomWindowInfo: windowInfo)
            windowInfoListAbove.forEach{ $0.descripte() }
            
            drawingBoardWindowControllers.values.forEach { windowController in
                windowController.drawWindowsBorder(aboveWindowInfoList: windowInfoListAbove, borderedWindowInfoList: getBorderedWindowInfoList(windowList: windowList))
            }
//            drawingBoardWindowControllers[NSScreen.screens[1].uuid]!.drawWindowsBorder(aboveWindowInfoList: windowInfoListAbove, borderedWindowInfoList: getBorderedWindowInfoList(windowList: windowList))
        }
    }
    
    func drawScreenBorder(screen: NSScreen) {
        if let windowController = drawingBoardWindowControllers[screen.uuid] {
            windowController.drawScreenBorder()
        }
    }
    
    func getIsCovered(for window: UInt32) -> Bool {
        updateWindowInfoList()
        
        if let windowInfo = getWindowInfo(by: window) {
            return drawingBoardWindowControllers.values.first?.getIsCovered(windowInfoList: windowInfoList, window: windowInfo) == true
        }
        return true
    }
}
