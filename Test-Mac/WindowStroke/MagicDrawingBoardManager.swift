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
    func addDrawing(drawing: MagicDrawing) -> MagicDrawingId
    func removeDrawing(drawingId: MagicDrawingId)
    func setKeyScreen(screen: String)
    func setExcludedWindowList(windowList: [Int])
}

enum MagicDrawingStyle {
    case sharingScreen
    case hoverScreen
    case sharingApplication
    case unsharedApplication
    
    var lineColor: NSColor {
        switch self {
        case .sharingScreen, .sharingApplication:
            return .orange
        case .hoverScreen:
            return .green
        case .unsharedApplication:
            return .gray
        }
    }
    
    var lineWidth: CGFloat {
        switch self {
        case .sharingScreen, .hoverScreen:
            return 8
        case .sharingApplication, .unsharedApplication:
            return 5
        }
    }
}

class MagicDrawing: NSObject {
    enum DrawingType: Int {
        case screenBorder
        case windowBorder
        case applicationBorder
    }
    let id: MagicDrawingId
    var type = DrawingType.screenBorder
    var style = MagicDrawingStyle.sharingScreen
    var screen: NSScreen?
    var windowList: [Int]?
    var applicationList: [String]?
    var needDraw: Bool = true
    var needCalculateCoverState: Bool = false
    var screenOfCoverWindows: String?
    
    static private var drawingIdHelper: MagicDrawingId = 0
    static let inValidDrawingId: MagicDrawingId = -1
    
    override init() {
        MagicDrawing.drawingIdHelper += 1
        id = MagicDrawing.drawingIdHelper
        super.init()
    }
    
    class func screenBorderDrawing(screen: NSScreen, style: MagicDrawingStyle = .sharingScreen) -> MagicDrawing {
        let drawing = MagicDrawing()
        drawing.type = .screenBorder
        drawing.style = style
        drawing.screen = screen
        return drawing
    }
    
    class func applicationBorderDrawing(applicationList: [String]) -> MagicDrawing {
        let drawing = MagicDrawing()
        drawing.type = .applicationBorder
        drawing.applicationList = applicationList
        drawing.style = .sharingApplication
        return drawing
    }
    
    class func calculateWindowCoverState(windowList: [Int], screenOfCoverWindows: String) -> MagicDrawing {
        let drawing = MagicDrawing()
        drawing.type = .windowBorder
        drawing.windowList = windowList
        drawing.needDraw = false
        drawing.needCalculateCoverState = true
        drawing.screenOfCoverWindows = screenOfCoverWindows
        return drawing
    }
}

class MagicWindowInfo: NSObject {
    var name = ""
    var windowNumber: Int = 0
    var frame: CGRect = .zero
    var level: Int = 0
    var stackingOrder: Int = 0
    var pid: String = ""
    var pName = ""
    var screen: String = ""
    var windowAlpha: Float = 1
    var isOnscreen = false
}

class MagicDrawingBoardManager: NSObject {
    var drawingBoardWindowControllers = [String: MagicDrawingBoardWindowController]()
    private var windowInfoList = [MagicWindowInfo]()
    private var drawingList = [MagicDrawing]()
    private var keyScreen: String? {
        didSet {
            if let keyScreen = keyScreen {
                drawingBoardWindowControllers.values.forEach{ $0.isKeyScreen = false }
                drawingBoardWindowControllers[keyScreen]?.isKeyScreen = true
            }
        }
    }
    private var excludedWindowList = [Int]()
    private var coverState = [MagicDrawingId: Bool]()
    
    private weak var timer: Timer?
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateDrawingBoardWindowController), name: NSApplication.didChangeScreenParametersNotification, object: nil)
        updateDrawingBoardWindowController()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        timer?.invalidate()
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
        
        drawingList.filter({ return $0.type == .screenBorder }).forEach{
            if let uuid = $0.screen?.uuid(), let windowController = drawingBoardWindowControllers[uuid] {
                windowController.removeDrawing(drawingId: $0.id)
                windowController.drawScreenBorder(drawing: $0)
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
    
    private func getWindowInfo(by windowNumber: Int) -> MagicWindowInfo? {
        return windowInfoList.first { $0.windowNumber == windowNumber }
    }
    
    private func getBorderedWindowInfoList(windowList: [Int]) -> [MagicWindowInfo] {
        return windowInfoList.compactMap { windowList.contains(Int($0.windowNumber)) ? $0 : nil }
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
    
    private func drawingScreenBorder(drawing: MagicDrawing) {
        guard let screen = drawing.screen else { return }
        if let windowController = drawingBoardWindowControllers[screen.uuid()!] {
            windowController.drawScreenBorder(drawing: drawing)
        }
    }
    
    private func startTimer() {
        guard timer?.isValid != true else { return }
        
        let tmr = Timer(timeInterval: 0.2, target: self, selector: #selector(updateDrawing), userInfo: nil, repeats: true)
        RunLoop.current.add(tmr, forMode: .common)
        self.timer = tmr
    }
    
    private func stopTimer() {
        guard !drawingList.contains(where: { $0.type == .applicationBorder || $0.type == .windowBorder }) else { return }
        
        timer?.invalidate()
        timer = nil
    }
    
    @objc func updateDrawing() {
        updateWindowInfoList()
        for drawing in drawingList {
            switch drawing.type {
            case .applicationBorder:
                if let applicationList = drawing.applicationList {
                    let borderedWindowInfoList = windowInfoList.filter { applicationList.contains($0.pid) && !excludedWindowList.contains($0.windowNumber) }
                    if !borderedWindowInfoList.isEmpty {
                        let windowInfoListAbove = getWindowInfoListAbove(bottomWindowInfo: borderedWindowInfoList[0])
                        
                        drawingBoardWindowControllers.values.forEach { windowController in
                            windowController.drawWindowsBorder(aboveWindowInfoList: windowInfoListAbove, borderedWindowInfoList: borderedWindowInfoList, drawing: drawing)
                        }
                    } else {
                        drawingBoardWindowControllers.values.forEach { $0.removeDrawing(drawingId: drawing.id) }
                    }
                }
            case .windowBorder:
                if let windowList = drawing.windowList {
                    let windowInfoList = windowList.compactMap{ getWindowInfo(by: $0) }
                    guard !windowInfoList.isEmpty else { continue }
                    if drawing.needCalculateCoverState {
                        calculateCoverState(for: windowInfoList, drawing: drawing)
                    }
                }
            default: break
            }
        }
    }
    
    private func drawingWindowBorder(drawing: MagicDrawing) {
        startTimer()
    }
    
    private func drawingApplicationBorder(drawing: MagicDrawing) {
        startTimer()
    }
    
    private func calculateCoverState(for coveredWindowInfoList: [MagicWindowInfo], drawing: MagicDrawing) {
        if let screen = drawing.screenOfCoverWindows, let drawingBoardWindowController = drawingBoardWindowControllers[screen] {
            let isCovered = drawingBoardWindowController.getIsCovered(windowInfoList: windowInfoList, coveredWindowInfoList: coveredWindowInfoList, drawing: drawing)
            if let oldValue = coverState[drawing.id] {
                if isCovered != oldValue {
                    updateCoverState(isCovered, drawing: drawing)
                }
            } else {
                updateCoverState(isCovered, drawing: drawing)
            }
        }
    }
    
    private func updateCoverState(_ isCovered: Bool, drawing: MagicDrawing) {
        coverState[drawing.id] = isCovered
        NotificationCenter.default.post(Notification(name: Notification.Name(OnWindowCoverStateChanged), object: self, userInfo: ["drawingId" : drawing.id, "state": isCovered]))
    }
}

extension MagicDrawingBoardManager: MagicDrawingBoardManagerProtocol {
    func addDrawing(drawing: MagicDrawing) -> MagicDrawingId {
        SPARK_LOG_DEBUG("id: \(drawing.id)  type: \(drawing.type.rawValue)")
        drawingList.append(drawing)
        
        switch drawing.type {
        case .screenBorder:
            drawingScreenBorder(drawing: drawing)
        case .windowBorder:
            drawingWindowBorder(drawing: drawing)
        case .applicationBorder:
            drawingApplicationBorder(drawing: drawing)
        }
        
        return drawing.id
    }
    
    func removeDrawing(drawingId: MagicDrawingId) {
        guard drawingId > MagicDrawing.inValidDrawingId else { return  }
        SPARK_LOG_DEBUG("id: \(drawingId)")
        
        drawingList.removeAll { $0.id == drawingId }
        
        drawingBoardWindowControllers.values.forEach { $0.removeDrawing(drawingId: drawingId) }
        
        stopTimer()
    }
    
    func setKeyScreen(screen: String) {
        SPARK_LOG_DEBUG("\(screen)")
        keyScreen = screen
    }
    
    func setExcludedWindowList(windowList: [Int]) {
        SPARK_LOG_DEBUG("\(windowList.count)")
        excludedWindowList = windowList
    }
}
