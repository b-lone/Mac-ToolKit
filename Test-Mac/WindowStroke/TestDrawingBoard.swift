//
//  TestDrawingBoard.swift
//  Test-Mac
//
//  Created by Archie You on 2021/6/22.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

let OnWindowCoverStateChanged = "OnWindowCoverStateChanged"
let OnShareShouldExcludeWindow = "OnShareShouldExcludeWindow"

class TestDrawingBoard: TestCases {
    private var windowInfoList = [MagicWindowInfo]()
    private var drawingBorder: MagicDrawingBoardManager = MagicDrawingBoardManager()
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onWindowCoverStateChanged), name: NSNotification.Name(OnWindowCoverStateChanged), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func getTestCases() -> [String] {
        return [
//            "frame in screen",
//            "main screen",
            "cover state",
            "application border",
            "screen border",
            "screen label",
        ]
    }
    
    override func onStartButton(caseName: String) {
        if caseName == "main screen" {
            testMainScreen()
        } else if caseName == "frame in screen" {
            testScreenFrame()
        } else if caseName == "cover state" {
            testCoverState()
        } else if caseName == "application border" {
            testDrawApplicationBorder()
        } else if caseName == "screen border" {
            testDrawScreenBorder()
        } else if caseName == "screen label" {
            testDrawScreenLabel()
        }
    }
    
    override func onStopButton(caseName: String) {
        if caseName == "main screen" {
            testMainScreen(start: false)
        } else if caseName == "frame in screen" {
            testScreenFrame(start: false)
        } else if caseName == "cover state" {
            testCoverState(start: false)
        } else if caseName == "application border" {
            testDrawApplicationBorder(start: false)
        } else if caseName == "screen border" {
            testDrawScreenBorder(start: false)
        } else if caseName == "screen label" {
            testDrawScreenLabel(start: false)
        }
    }
    
    //MARK: Case - Main Screen
    private var testMainScreenTimer: Timer?
    func testMainScreen(start: Bool = true) {
        testMainScreenTimer?.invalidate()
        SPARK_LOG_DEBUG(NSScreen.screens[0].uuid())
        if start {
            testMainScreenTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                SPARK_LOG_DEBUG(NSScreen.main!.uuid()!)
            }
        }
    }
    
    //MARK: Case - Screen Frame
    func testScreenFrame(start: Bool = true) {
        for screen in NSScreen.screens {
            SPARK_LOG_DEBUG("screenFrame: \(screen.frame)")
        }
        let windowInfoList = getWindowInfoList(pName: "Terminal")
        for windowInfo in windowInfoList {
            SPARK_LOG_DEBUG("windowFrame: \(windowInfo.frame)")
        }
    }

    //MARK: Case - cover state
    private var testCoverStateDrawingId = MagicDrawing.inValidDrawingId
    func testCoverState(start: Bool = true) {
        drawingBorder.removeDrawing(drawingId: testCoverStateDrawingId)
        testCoverStateDrawingId = MagicDrawing.inValidDrawingId
        if start {
            let list = getWindowInfoList(pName: "Terminal")
            if !list.isEmpty {
                testCoverStateDrawingId = drawingBorder.addDrawing(drawing: MagicDrawing.calculateWindowCoverState(windowList: [list[0].windowNumber], screenOfCoverWindows: NSScreen.screens[1].uuid()!))
            }
        }
    }
    
    @objc func onWindowCoverStateChanged(_ notification: Notification) {
//        if let userInfo = notification.userInfo, let coverState = userInfo["state"] as? Bool {
//            SPARK_LOG_DEBUG("\(coverState)")
//        }
    }
    
    //MARK: Case - application border
    private var testDrawApplicationBorderDrawingId = MagicDrawing.inValidDrawingId
    func testDrawApplicationBorder(start: Bool = true) {
        drawingBorder.removeDrawing(drawingId: testDrawApplicationBorderDrawingId)
        testDrawApplicationBorderDrawingId = MagicDrawing.inValidDrawingId
        if start {
            let list = getWindowInfoList(pName: "Terminal")
//            let list = getWindowInfoList(pName: "Any")
            if !list.isEmpty {
                testDrawApplicationBorderDrawingId = drawingBorder.addDrawing(drawing: MagicDrawing.applicationBorderDrawing(applicationList: [list[0].pid]))
            } else {
                SPARK_LOG_DEBUG("Can't find window.")
            }
        }
    }
    
    //MARK: Case - screen border
    private var testDrawScreenBorderDrawingId = MagicDrawing.inValidDrawingId
    func testDrawScreenBorder(start: Bool = true) {
        drawingBorder.removeDrawing(drawingId: testDrawScreenBorderDrawingId)
        testDrawScreenBorderDrawingId = MagicDrawing.inValidDrawingId
        if start {
            testDrawScreenBorderDrawingId = drawingBorder.addDrawing(drawing: MagicDrawing.screenBorderDrawing(screen: NSScreen.main!))
        }
    }
    
    //MARK: Case - screen label
    private var testDrawScreenLabelDrawingId = MagicDrawing.inValidDrawingId
    func testDrawScreenLabel(start: Bool = true) {
        drawingBorder.removeDrawing(drawingId: testDrawScreenLabelDrawingId)
        testDrawScreenLabelDrawingId = MagicDrawing.inValidDrawingId
        if start {
            testDrawScreenLabelDrawingId = drawingBorder.addDrawing(drawing: MagicDrawing.screenLabel())
        }
    }
    
    //MARK: private function
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
                windowInfo.alpha = CGFloat(alpha.floatValue)
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
        if windowInfo.level == kCGMainMenuWindowLevel || windowInfo.level == kCGStatusWindowLevel || windowInfo.level == kCGDockWindowLevel || windowInfo.level == kCGUtilityWindowLevel || windowInfo.level == kCGPopUpMenuWindowLevel {
            return false
        }
        return true
    }
    
    private func getWindowInfoList(pName: String) -> [MagicWindowInfo] {
        updateWindowInfoList()
        return windowInfoList.filter {
            $0.pName.contains(pName)
        }
    }
}
