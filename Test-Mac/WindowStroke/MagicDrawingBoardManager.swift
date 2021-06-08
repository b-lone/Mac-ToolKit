//
//  MagicDrawingBoardManager.swift
//  WebexTeams
//
//  Created by Archie You on 2021/5/28.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa

typealias MagicDrawingId = Int

protocol MagicDrawingBoardManagerProtocol {
    func drawScreenBorder(screen: NSScreen, style: MagicDrawingStyle) -> MagicDrawingId
    func drawWindowsBorder(windowList: [Int]) -> MagicDrawingId
    func removeDrawing(drawingId: MagicDrawingId)
}

enum MagicDrawingStyle {
    case sharingScreen
    case hoverScreen
    case sharingApplication
    case unsharedApplication
    
    var lineColor: NSColor {
        switch self {
        case .sharingScreen, .sharingApplication:
            return .orange//SemanticThemeManager.getColors(for: .wxShareSharingBorderColor).normal
        case .hoverScreen:
            return .blue//SemanticThemeManager.getColors(for: .wxShareSelectionBorderColor).normal
        case .unsharedApplication:
            return .gray//SemanticThemeManager.getColors(for: .wxShareUnsharedApplicationBorderColor).normal
        }
    }
}

class MagicWindowInfo: NSObject {
    var windowNumber: Int = 0
    var frame: CGRect = .zero
    var level: Int = 0
    var stackingOrder: Int = 0
    var screen: String = ""
}

class MagicDrawingBoardManager: NSObject {
    private var drawingBoardWindowControllers = [String: MagicDrawingBoardWindowController]()
    private var windowInfoList = [MagicWindowInfo]()
    private var drawingScreenInfoList = [(drawingId: MagicDrawingId, screen: NSScreen, style: MagicDrawingStyle)]()
    
    private var drawingIdHelper: Int = 0
    static let inValidDrawingId: MagicDrawingId = -1
    
    static let shared = MagicDrawingBoardManager()
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateDrawingBoardWindowController), name: NSApplication.didChangeScreenParametersNotification, object: nil)
        updateDrawingBoardWindowController()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func updateDrawingBoardWindowController() {
        NSScreen.screens.forEach {
            if let uuid = $0.uuid() {
                if let windowController = drawingBoardWindowControllers[uuid] {
                    windowController.onScreenUpdated()
                } else {
                    drawingBoardWindowControllers[uuid] = MagicDrawingBoardWindowController(screen: $0)
                }
            }
        }
        drawingScreenInfoList.forEach {
            if let uuid = $0.screen.uuid(), let windowController = drawingBoardWindowControllers[uuid] {
                windowController.removeDrawing(drawingId: $0.drawingId)
                windowController.drawScreenBorder(style: $0.style, drawingId: $0.drawingId)
            }
        }
    }
    
    private func isValidWindow(windowInfo: MagicWindowInfo) -> Bool {
        if windowInfo.level == kCGMainMenuWindowLevel || windowInfo.level == kCGStatusWindowLevel || windowInfo.level == kCGDockWindowLevel || windowInfo.level == kCGUtilityWindowLevel || windowInfo.level == kCGPopUpMenuWindowLevel {
            return false
        }
        if drawingBoardWindowControllers.values.contains(where:  { $0.window!.windowNumber == windowInfo.windowNumber }) {
            return false
        }
        return true
    }
    
    private func covertRectToScreen(_ rect: CGRect) -> CGRect {
        guard !NSScreen.screens.isEmpty else { return .zero }
        
        let screenFrame = NSScreen.screens[0].frame
        return NSMakeRect(rect.minX, screenFrame.maxY - rect.maxY, rect.width, rect.height)
    }
    
    private func getWindowInfoList(from windowDescriptionList: Array<[CFString: AnyObject]>) -> [MagicWindowInfo] {
        var windowInfoList = [MagicWindowInfo]()
        
        for windowDescription in windowDescriptionList {
            let windowInfo = MagicWindowInfo()
            if let windowLevel = windowDescription[kCGWindowLayer] as? Int {
                windowInfo.level = windowLevel
            }
            if let windowNumber = windowDescription[kCGWindowNumber] as? Int {
                windowInfo.windowNumber = windowNumber
            }
            if let bounds = CGRect(dictionaryRepresentation: windowDescription[kCGWindowBounds] as! CFDictionary) {
                windowInfo.frame = covertRectToScreen(bounds)
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
    
    private func getWindowInfo(by windowNumber: Int) -> MagicWindowInfo? {
        return windowInfoList.first { $0.windowNumber == windowNumber }
    }
    
    private func getBorderedWindowInfoList(windowList: [Int]) -> [MagicWindowInfo] {
        return windowInfoList.compactMap { windowList.contains(Int($0.windowNumber)) ? $0 : nil }
    }
    
    private func getBottomWindowInfoIndex(windowList: [Int]) -> MagicWindowInfo? {
        let windowInfo = windowInfoList.first { windowList.contains(Int($0.windowNumber)) }
        return windowInfo
    }
    
    private func getWindowInfoListAbove(bottomWindowInfo: MagicWindowInfo) -> [MagicWindowInfo] {
        if let bottomIndex = windowInfoList.firstIndex(where: { $0.windowNumber == bottomWindowInfo.windowNumber }) {
            return Array(windowInfoList[(bottomIndex + 1)...])
        }
        return []
    }
    
    private func updateWindowInfoList() {
        if let windowDescriptionList = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as? Array<[CFString: AnyObject]> {
            windowInfoList = getWindowInfoList(from: windowDescriptionList)
        }
    }
    
    private func generateDrawingId() -> MagicDrawingId {
        drawingIdHelper += 1
        return drawingIdHelper
    }
}

extension MagicDrawingBoardManager: MagicDrawingBoardManagerProtocol {
    func drawWindowsBorder(windowList: [Int]) -> MagicDrawingId {
        updateWindowInfoList()
        
        if let windowInfo = getBottomWindowInfoIndex(windowList: windowList) {
            let windowInfoListAbove = getWindowInfoListAbove(bottomWindowInfo: windowInfo)
            
            let drawingId = generateDrawingId()
            
            drawingBoardWindowControllers.values.forEach { windowController in
                windowController.drawWindowsBorder(aboveWindowInfoList: windowInfoListAbove, borderedWindowInfoList: getBorderedWindowInfoList(windowList: windowList), drawingId: drawingId)
            }
            
            return drawingId
        }
        
        return MagicDrawingBoardManager.inValidDrawingId
    }
    
    func drawScreenBorder(screen: NSScreen, style: MagicDrawingStyle) -> MagicDrawingId {
        if let windowController = drawingBoardWindowControllers[screen.uuid()!] {

            let drawingId = generateDrawingId()

            windowController.drawScreenBorder(style: style, drawingId: drawingId)
            drawingScreenInfoList.append((drawingId, screen, style))

            return drawingId
        }

        return MagicDrawingBoardManager.inValidDrawingId
    }
    
    func removeDrawing(drawingId: MagicDrawingId) {
        guard drawingId > MagicDrawingBoardManager.inValidDrawingId else { return  }
        
        drawingScreenInfoList.removeAll { $0.drawingId == drawingId }
        
        drawingBoardWindowControllers.values.forEach { $0.removeDrawing(drawingId: drawingId) }
    }
    
    func getIsCovered(for window: Int) -> Bool {
        updateWindowInfoList()
        
        if let windowInfo = getWindowInfo(by: window) {
            return drawingBoardWindowControllers.values.first?.getIsCovered(windowInfoList: windowInfoList, window: windowInfo) == true
        }
        return true
    }
}
