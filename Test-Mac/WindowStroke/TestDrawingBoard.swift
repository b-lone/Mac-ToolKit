//
//  TestDrawingBoard.swift
//  Test-Mac
//
//  Created by Archie You on 2021/6/22.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class TestDrawingBoard: NSObject {
    private var windowInfoList = [MagicWindowInfo]()
    private var drawingBorder: MagicDrawingBoardManager = MagicDrawingBoardManager()
    private var drawingId = MagicDrawing.inValidDrawingId
    
    func start() {
        removeDraw()
        updateWindowInfoList()
        let list = getWindowInfoList(pName: "Terminal")
        if !list.isEmpty {
            drawingId = drawingBorder.addDrawing(drawing: MagicDrawing.applicationBorderDrawing(applicationList: [list[0].pid]))
        }
        print("\(list.count)")
    }
    
    func stop() {
        removeDraw()
    }
    
    private func removeDraw() {
        drawingBorder.removeDrawing(drawingId: drawingId)
    }
    
    private func updateWindowInfoList() {
        if let windowDescriptionList = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as? Array<[CFString: AnyObject]> {
            windowInfoList = getWindowInfoList(from: windowDescriptionList)
        }
    }
    
    private func getWindowInfoList(from windowDescriptionList: Array<[CFString: AnyObject]>) -> [MagicWindowInfo] {
        var windowInfoList = [MagicWindowInfo]()
        
        for windowDescription in windowDescriptionList {
            let windowInfo = MagicWindowInfo()
            if let alpha = windowDescription[kCGWindowAlpha] as? NSNumber {
                windowInfo.windowAlpha = alpha.floatValue
            }
            if let isOnscreen = windowDescription[kCGWindowIsOnscreen] as? Bool {
                windowInfo.isOnscreen = isOnscreen
            }
            if let name = windowDescription[kCGWindowName] {
                windowInfo.name = String(name as! CFString)
            }
            if let pName = windowDescription[kCGWindowOwnerName] {
                windowInfo.pName = String(pName as! CFString)
            }
            if let windowLevel = windowDescription[kCGWindowLayer] as? Int {
                windowInfo.level = windowLevel
            }
            if let windowNumber = windowDescription[kCGWindowNumber] as? Int {
                windowInfo.windowNumber = windowNumber
            }
            if let bounds = CGRect(dictionaryRepresentation: windowDescription[kCGWindowBounds] as! CFDictionary) {
                windowInfo.frame = covertRectToScreen(bounds)
            }
            if let pid = windowDescription[kCGWindowOwnerPID] as? NSNumber {
                windowInfo.pid = String(pid.intValue)
            }
            
            if !isValidWindow(windowInfo: windowInfo) { continue }
            
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
    
    private func covertRectToScreen(_ rect: CGRect) -> CGRect {
        guard !NSScreen.screens.isEmpty else { return .zero }
        
        let screenFrame = NSScreen.screens[0].frame
        return NSMakeRect(rect.minX, screenFrame.maxY - rect.maxY, rect.width, rect.height)
    }
    
    private func isValidWindow(windowInfo: MagicWindowInfo) -> Bool {
        var logEnable = false
        if windowInfo.pName == "Terminal" {
            logEnable = true
            print("logEnable \(windowInfo.level)")
        }
        if windowInfo.level == kCGMainMenuWindowLevel || windowInfo.level == kCGStatusWindowLevel || windowInfo.level == kCGDockWindowLevel || windowInfo.level == kCGUtilityWindowLevel || windowInfo.level == kCGPopUpMenuWindowLevel {
            return false
        }
        if drawingBorder.drawingBoardWindowControllers.values.contains(where:  { $0.window!.windowNumber == windowInfo.windowNumber }) {
            return false
        }
        return true
    }
    
    private func getWindowInfoList(pName: String) -> [MagicWindowInfo] {
        return windowInfoList.filter {
            $0.pName == pName
        }
    }
}
