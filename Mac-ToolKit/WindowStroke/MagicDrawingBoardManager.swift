//
//  MagicDrawingBoardManager.swift
//  WebexTeams
//
//  Created by Archie You on 2021/5/28.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa

typealias MagicDrawingId = Int

protocol MagicDrawingBoardManagerProtocol: AnyObject {
    func addDrawing(drawing: MagicDrawing) -> MagicDrawingId
    func removeDrawing(drawingId: MagicDrawingId)
    func setKeyScreen(screen: String)
    func getWindowInfoList(exclude: Bool, onScreenOnly: Bool) -> MagicWindowInfoList
}

enum MagicDrawingStyle {
    case sharingScreen
    case hoverScreen
    case sharingApplication
    case unsharedApplication
    case unsharedScreen
    
    var lineColor: NSColor {
        switch self {
        case .sharingScreen, .sharingApplication:
            return getUIToolkitColor(token: .sharewindowBorderActive).normal
        case .hoverScreen:
            return getUIToolkitColor(token: .sharewindowBorderSelected).normal
        case .unsharedApplication, .unsharedScreen:
            return getUIToolkitColor(token: .sharewindowBorderInactive).normal
        }
    }
    
    var lineWidth: CGFloat {
        switch self {
        case .sharingScreen, .hoverScreen, .unsharedScreen:
            return 8
        case .sharingApplication, .unsharedApplication:
            return 4
        }
    }
}

class MagicDrawing: NSObject {
    enum DrawingType: Int {
        case screenBorder
        case windowBorder
        case applicationBorder
        case screenLabel
    }
    let id: MagicDrawingId
    var type = DrawingType.screenBorder
    var style = MagicDrawingStyle.sharingScreen
    var screen: SparkScreen?
    var windowNumberList: [CGWindowID]?
    var pidList: [String]?
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
    
    class func screenBorderDrawing(screen: SparkScreen, style: MagicDrawingStyle = .sharingScreen) -> MagicDrawing {
        let drawing = MagicDrawing()
        drawing.type = .screenBorder
        drawing.style = style
        drawing.screen = screen
        return drawing
    }
    
    class func applicationBorderDrawing(applicationList: [String]) -> MagicDrawing {
        let drawing = MagicDrawing()
        drawing.type = .applicationBorder
        drawing.pidList = applicationList
        drawing.style = .sharingApplication
        return drawing
    }
    
    class func windowBorderDrawing(windowNumberList: [CGWindowID]) -> MagicDrawing {
        let drawing = MagicDrawing()
        drawing.type = .windowBorder
        drawing.windowNumberList = windowNumberList
        drawing.needDraw = true
        drawing.needCalculateCoverState = false
        drawing.style = .sharingApplication
        return drawing
    }
    
    class func calculateWindowCoverState(windowList: [CGWindowID], screenOfCoverWindows: String) -> MagicDrawing {
        let drawing = MagicDrawing()
        drawing.type = .windowBorder
        drawing.windowNumberList = windowList
        drawing.needDraw = false
        drawing.needCalculateCoverState = true
        drawing.screenOfCoverWindows = screenOfCoverWindows
        return drawing
    }
    
    class func screenLabel() -> MagicDrawing {
        let drawing = MagicDrawing()
        drawing.type = .screenLabel
        return drawing
    }
}

class MagicWindowInfo: NSObject {
    var name = ""
    var windowNumber: CGWindowID = 0
    var frame: CGRect = .zero
    var level: Int = 0
    var stackingOrder: Int = 0
    var pid = ""
    var pName = ""
    var screen = ""
    var alpha: CGFloat = 1
    
    var fullName: String {
        var fullName = name.isEmpty ? pName : name
        if !name.isEmpty, !pName.isEmpty, name != pName {
            fullName = "\(pName) - \(name)"
        }
        return fullName
    }
}

typealias MagicWindowInfoList = [MagicWindowInfo]

class MagicDrawingBoardManager: NSObject {
    private var screenBorderDrawingBoardMap = [String: IMagicDrawingBoardWindowController]()
    private var windowBorderDrawingBoardMap = [String: IMagicDrawingBoardWindowController]()
    private var fullWindowInfoList = MagicWindowInfoList()
    private var drawingList = [MagicDrawing]()
    private var keyScreen: String? {
        didSet {
            if oldValue != keyScreen {
                updateKeyFrame()
            }
        }
    }
    private var excludedWindowNumberList = [CGWindowID]()
    private var excludedDrawWindowNumberList = [CGWindowID]()
    private var coverState = [MagicDrawingId: Bool]()
    
    private var timer: SparkTimerProtocol
    
    //[uuid: label]
    private var screenLabelList = [String: String]()
    
    private let pNameBlacklist = ["screencapture"]
    private let factory: ShareFactoryProtocol
    private let screenAdapter: SparkScreenAdapterProtocol
    private let quartzWindowServicesAdapter: QuartzWindowServicesAdapterProtocol
    
    init(factory: ShareFactoryProtocol, screenAdapter: SparkScreenAdapterProtocol, quartzWindowServicesAdapter: QuartzWindowServicesAdapterProtocol) {
        self.factory = factory
        self.timer = factory.makeTimer()
        self.screenAdapter = screenAdapter
        self.quartzWindowServicesAdapter = quartzWindowServicesAdapter
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onChangeScreenParametersNotification), name: NSApplication.didChangeScreenParametersNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onShareShouldExcludeWindow), name: NSNotification.Name(rawValue: OnShareShouldExcludeWindow), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDrawShouldExcludeWindow), name: NSNotification.Name(rawValue: OnDrawShouldExcludeWindow), object: nil)
        onChangeScreenParametersNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        timer.stopTimer()
    }
    
    @objc private func onChangeScreenParametersNotification() {
        var frameString = ""
        screenAdapter.screens.forEach {
            frameString += $0.frameInfo()
        }
        SPARK_LOG_DEBUG(frameString)
        updateDrawingBoards()
        updateScreenList()
        updateKeyFrame()
    }
    
    private func updateDrawingBoards() {
        var boards = [String: IMagicDrawingBoardWindowController]()
        screenAdapter.screens.forEach {
            if let uuid = $0.uuid() {
                boards[uuid] = factory.makeMagicDrawingBoardWindowController(screen: $0, level: .screenBorder)
            }
        }
        screenBorderDrawingBoardMap.values.forEach { $0.close() }
        screenBorderDrawingBoardMap = boards
        
        boards = [String: IMagicDrawingBoardWindowController]()
        screenAdapter.screens.forEach {
            if let uuid = $0.uuid() {
                boards[uuid] = factory.makeMagicDrawingBoardWindowController(screen: $0, level: .windowBorder)
            }
        }
        windowBorderDrawingBoardMap.values.forEach { $0.close() }
        windowBorderDrawingBoardMap = boards
        
        drawingList.forEach{
            if $0.type == .screenBorder {
                drawingScreenBorder(drawing: $0)
            }
        }
    }
    
    private func updateScreenList() {
        let uuidList = screenAdapter.screens.compactMap{ $0.uuid() }
        
        screenLabelList.removeAll()
        if uuidList.count > 1 {
            for (index, uuid) in uuidList.enumerated() {
                screenLabelList[uuid] = "\(index + 1)"
            }
        }
        
        drawingList.forEach{
            if $0.type == .screenLabel {
                drawScreenLabel(drawing: $0)
            }
        }
    }
    
    private func updateKeyFrame() {
        if keyScreen == nil || !screenAdapter.screens.contains(where: {$0.uuid() == keyScreen}) {
            keyScreen = screenAdapter.main?.uuid()
        } else {
            if let keyScreen = keyScreen {
                windowBorderDrawingBoardMap.values.forEach{ $0.isKeyScreen = false }
                windowBorderDrawingBoardMap[keyScreen]?.isKeyScreen = true
            }
        }
    }
   
    //MARK: generate window info
    private func isValidWindow(windowInfo: MagicWindowInfo) -> Bool {
        if windowInfo.level > kCGFloatingWindowLevel || windowInfo.level < kCGNormalWindowLevel {
            return false
        }
        if windowInfo.alpha == 0 {
            return false
        }
        if screenBorderDrawingBoardMap.values.contains(where: { $0.window?.windowNumber == Int(windowInfo.windowNumber) }) {
            return false
        }
        if windowBorderDrawingBoardMap.values.contains(where: { $0.window?.windowNumber == Int(windowInfo.windowNumber) }) {
            return false
        }
        if excludedDrawWindowNumberList.contains(windowInfo.windowNumber) {
            return false
        }
        if pNameBlacklist.contains(windowInfo.pName) {
            return false
        }
        return true
    }
    
    private func covertRectToScreen(_ rect: CGRect) -> CGRect {
        guard !screenAdapter.screens.isEmpty else { return .zero }
        
        let screenFrame = screenAdapter.screens[0].frame
        return NSMakeRect(rect.minX, screenFrame.maxY - rect.maxY, rect.width, rect.height)
    }
    
    private func getWindowScreen(windowInfo: MagicWindowInfo) -> String {
        var result = ""
        var maxArea: CGFloat = 0
        for screen in screenAdapter.screens {
            if let uuid = screen.uuid() {
                let area =  calculateOverlapArea(screen.frame, windowInfo.frame)
                if area > maxArea {
                    result = uuid
                    maxArea = area
                }
            }
        }
        return result
    }
    
    private func calculateOverlapArea(_ rect1: CGRect, _ rect2: CGRect) -> CGFloat {
        guard !(rect1.minX > rect2.maxX || rect1.minY > rect2.maxY || rect1.maxX < rect2.minX || rect1.maxY < rect2.minY) else {
            return 0
        }
        let width = min(rect1.maxX, rect2.maxX) - max(rect1.minX, rect2.minX)
        let height = min(rect1.maxY, rect2.maxY) - max(rect1.minY, rect2.minY)
        
        return width * height
    }
    
    
    private func transferToWindowInfoList(from windowDescriptionList: Array<[CFString: AnyObject]>) -> MagicWindowInfoList {
        var windowInfoList = MagicWindowInfoList()
        
        for windowDescription in windowDescriptionList {
            let windowInfo = MagicWindowInfo()
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
                windowInfo.windowNumber = CGWindowID(windowNumber)
            }
            if let bounds = CGRect(dictionaryRepresentation: windowDescription[kCGWindowBounds] as! CFDictionary) {
                windowInfo.frame = covertRectToScreen(bounds)
            }
            if let pid = windowDescription[kCGWindowOwnerPID] as? NSNumber {
                windowInfo.pid = String(pid.intValue)
            }
            if let alpha = windowDescription[kCGWindowAlpha] as? NSNumber {
                windowInfo.alpha = CGFloat(alpha.floatValue)
            }
            
            if !isValidWindow(windowInfo: windowInfo) { continue }
            
            windowInfo.screen = getWindowScreen(windowInfo: windowInfo)
            
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
    
    private func updatefullWindowInfoList() {
        if let windowDescriptionList = quartzWindowServicesAdapter.windowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as? Array<[CFString: AnyObject]> {
            fullWindowInfoList = transferToWindowInfoList(from: windowDescriptionList)
        }
    }
    
    //MARK: full window info list
    private func getWindowInfo(by windowNumber: CGWindowID) -> MagicWindowInfo? {
        return fullWindowInfoList.first { $0.windowNumber == windowNumber }
    }
    
    private func getWindowInfoList(windowNumberList: [CGWindowID]) -> MagicWindowInfoList {
        return fullWindowInfoList.filter{ windowNumberList.contains($0.windowNumber) }
    }
    
    private func getWindowInfoList(pidList: [String], exclude: Bool = false) -> MagicWindowInfoList {
        var result = fullWindowInfoList.filter{ pidList.contains($0.pid) }
        if exclude {
            result = result.filter{ !excludedWindowNumberList.contains($0.windowNumber) }
        }
        return result
    }
    
    private func getAboveWindowInfoList(bottomWindowInfo: MagicWindowInfo, screen: String) -> MagicWindowInfoList {
        if let bottomIndex = fullWindowInfoList.firstIndex(where: { $0.windowNumber == bottomWindowInfo.windowNumber }) {
            let result = Array(fullWindowInfoList[(bottomIndex + 1)...])
            return result.filter{ $0.screen == screen }
        }
        return []
    }
    
    @objc private func onShareShouldExcludeWindow(notification: NSNotification) {
        guard let windowNumber = notification.userInfo?["windowNumber"] as? Int, windowNumber > 0 else { return }
        if !excludedWindowNumberList.contains(CGWindowID(windowNumber)) {
            excludedWindowNumberList.append(CGWindowID(windowNumber))
        }
    }
    
    @objc private func onDrawShouldExcludeWindow(notification: NSNotification) {
        guard let windowNumber = notification.userInfo?["windowNumber"] as? Int, windowNumber > 0 else { return }
        if !excludedDrawWindowNumberList.contains(CGWindowID(windowNumber)) {
            excludedDrawWindowNumberList.append(CGWindowID(windowNumber))
        }
    }
    
    //MARK: draw screen border
    private func drawingScreenBorder(drawing: MagicDrawing) {
        guard let screen = drawing.screen else { return }
        if let uuid = screen.uuid(), let drawingBoard = screenBorderDrawingBoardMap[uuid] {
            drawingBoard.drawScreenBorder(drawing: drawing)
        } else {
            SPARK_LOG_DEBUG("failed to find drawing board!")
        }
    }
    
    //MARK: draw window border
    private func drawingWindowBorder(drawing: MagicDrawing) {
        startTimer()
    }
    
    private func startTimer() {
        guard timer.isValid != true else { return }
        
        timer.startTimer(timeInterval: 0.2, target: self, selector: #selector(updateDrawing), userInfo: nil, repeats: true, forMode: .common)
    }
    
    private func stopTimer() {
        guard !drawingList.contains(where: { $0.type == .applicationBorder || $0.type == .windowBorder }) else { return }
        
        timer.stopTimer()
    }
    
    @objc func updateDrawing() {
        updatefullWindowInfoList()
        for drawing in drawingList {
            switch drawing.type {
            case .applicationBorder:
                processDrawApplicationBorder(drawing: drawing)
            case .windowBorder:
                if drawing.needCalculateCoverState {
                    processCalculateCoverState(drawing: drawing)
                }
                if drawing.needDraw {
                    processDrawWindowBorder(drawing: drawing)
                }
            default: break
            }
        }
    }
    
    private func processDrawApplicationBorder(drawing: MagicDrawing) {
        if let pidList = drawing.pidList {
            let targetWindowInfoList = getWindowInfoList(pidList: pidList, exclude: true)
            drawWindowBorder(targetWindowInfoList: targetWindowInfoList, drawing: drawing)
        }
    }
    
    private func processDrawWindowBorder(drawing: MagicDrawing) {
        if let windowNumberList = drawing.windowNumberList {
            let targetWindowInfoList = getWindowInfoList(windowNumberList: windowNumberList)
            drawWindowBorder(targetWindowInfoList: targetWindowInfoList, drawing: drawing)
        }
    }
    
    private func drawWindowBorder(targetWindowInfoList: MagicWindowInfoList, drawing: MagicDrawing) {
        for (screen, drawingBoard) in  windowBorderDrawingBoardMap {
            let subTargetWindowInfoList = targetWindowInfoList.filter{ $0.screen == screen }
            if !subTargetWindowInfoList.isEmpty {
                let aboveWindowInfoList = getAboveWindowInfoList(bottomWindowInfo: subTargetWindowInfoList[0], screen: screen)
                drawingBoard.drawWindowsBorder(aboveWindowInfoList: aboveWindowInfoList, targetWindowInfoList: subTargetWindowInfoList, drawing: drawing)
            } else {
                drawingBoard.removeDrawing(drawingId: drawing.id)
            }
        }
    }
    
    //MARK: cover state
    private func processCalculateCoverState(drawing: MagicDrawing) {
        if let windowNumberList = drawing.windowNumberList {
            if let screen = drawing.screenOfCoverWindows, let drawingBoard = windowBorderDrawingBoardMap[screen] {
                let targetWindowInfoList = getWindowInfoList(windowNumberList: windowNumberList)
                guard !targetWindowInfoList.isEmpty else { return }
                let aboveWindowInfoList = getAboveWindowInfoList(bottomWindowInfo: targetWindowInfoList[0], screen: screen)
                var coveredWindowInfoSet = Set<MagicWindowInfo>()
                let isCovered = drawingBoard.getIsCovered(aboveWindowInfoList: aboveWindowInfoList, targetWindowInfoList: targetWindowInfoList, drawing: drawing, coveredWindowInfoSet: &coveredWindowInfoSet)
                processCoverStateResult(isCovered, drawing: drawing, coveredWindowInfoSet: coveredWindowInfoSet)
            }
        }
    }
    
    private func processCoverStateResult(_ isCovered: Bool, drawing: MagicDrawing, coveredWindowInfoSet: Set<MagicWindowInfo>) {
        if coverState[drawing.id] != isCovered {
            SPARK_LOG_DEBUG("id: \(drawing.id) isCovered:\(isCovered)")
            if isCovered {
                coveredWindowInfoSet.forEach {
                    SPARK_LOG_DEBUG("covered by: \($0.pName)%\($0.name) \($0.frame)")
                }
            }
            NotificationCenter.default.post(Notification(name: Notification.Name(OnWindowCoverStateChanged), object: self, userInfo: ["drawingId" : drawing.id, "state": isCovered]))
            
            coverState[drawing.id] = isCovered
        }
    }
    //MARK: screen label
    private func drawScreenLabel(drawing: MagicDrawing) {
        screenBorderDrawingBoardMap.forEach {
            if let label = screenLabelList[$0.key] {
                $0.value.drawScreenLabel(label: label, drawing: drawing)
            }
        }
    }
}

extension MagicDrawingBoardManager: MagicDrawingBoardManagerProtocol {
    @discardableResult func addDrawing(drawing: MagicDrawing) -> MagicDrawingId {
        SPARK_LOG_DEBUG("id: \(drawing.id)  type: \(drawing.type.rawValue)")
        drawingList.append(drawing)
        
        switch drawing.type {
        case .screenBorder:
            drawingScreenBorder(drawing: drawing)
        case .windowBorder: fallthrough
        case .applicationBorder:
            drawingWindowBorder(drawing: drawing)
        case .screenLabel:
            drawScreenLabel(drawing: drawing)
        }
        
        return drawing.id
    }
    
    func removeDrawing(drawingId: MagicDrawingId) {
        guard drawingId > MagicDrawing.inValidDrawingId else { return  }
        SPARK_LOG_DEBUG("id: \(drawingId)")
        
        drawingList.removeAll { $0.id == drawingId }
        
        screenBorderDrawingBoardMap.values.forEach { $0.removeDrawing(drawingId: drawingId) }
        windowBorderDrawingBoardMap.values.forEach { $0.removeDrawing(drawingId: drawingId) }
        
        stopTimer()
    }
    
    func setKeyScreen(screen: String) {
        SPARK_LOG_DEBUG("\(screen)")
        keyScreen = screen
    }
    
    func getWindowInfoList(exclude: Bool, onScreenOnly: Bool) -> MagicWindowInfoList {
        let option: CGWindowListOption = onScreenOnly ? [.optionOnScreenOnly, .excludeDesktopElements] : [.excludeDesktopElements]
        if let windowDescriptionList = quartzWindowServicesAdapter.windowListCopyWindowInfo(option, kCGNullWindowID) as? Array<[CFString: AnyObject]> {
            let windowInfoList = transferToWindowInfoList(from: windowDescriptionList)
            return exclude ? windowInfoList.filter{ !excludedWindowNumberList.contains($0.windowNumber) } : windowInfoList
        }
        return []
    }
}
