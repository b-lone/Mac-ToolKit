//
//  TestDrawingBoard.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/6/22.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa
import CommonHead

class TestDrawingBoard: NSObject {
    let caseNameCoverState = "cover state"
    let caseNameApplicationBorder = "application border"
    let caseNameScreenBorder = "screen border"
    let caseNameScreenLabel = "screen label"
    let caseNameFullScreenDetector = "full screen detector"
    
    private var windowInfoList = [MagicWindowInfo]()
    private var shareFactory = ShareFactory()
    private var screenAdapter =  SparkScreenAdapter()
    private var quartzWindowServicesAdapter =  QuartzWindowServicesAdapter()
    private lazy var drawingBoard: MagicDrawingBoardManager = MagicDrawingBoardManager(factory: shareFactory, screenAdapter: screenAdapter, quartzWindowServicesAdapter: quartzWindowServicesAdapter)
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onWindowCoverStateChanged), name: NSNotification.Name(OnWindowCoverStateChanged), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Case - cover state
    private var testCoverStateDrawingId = MagicDrawing.inValidDrawingId
    func testCoverState(start: Bool = true) {
        drawingBoard.removeDrawing(drawingId: testCoverStateDrawingId)
        testCoverStateDrawingId = MagicDrawing.inValidDrawingId
        if start {
            let list = getWindowInfoList(pName: "Terminal")
            if !list.isEmpty {
                testCoverStateDrawingId = drawingBoard.addDrawing(drawing: MagicDrawing.calculateWindowCoverState(windowList: [list[0].windowNumber], screenOfCoverWindows: NSScreen.screens[0].uuid()!))
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
        drawingBoard.removeDrawing(drawingId: testDrawApplicationBorderDrawingId)
        testDrawApplicationBorderDrawingId = MagicDrawing.inValidDrawingId
        if start {
            let list = getWindowInfoList(pName: "Terminal")
            if !list.isEmpty {
                testDrawApplicationBorderDrawingId = drawingBoard.addDrawing(drawing: MagicDrawing.applicationBorderDrawing(applicationList: [list[0].pid]))
            } else {
                SPARK_LOG_DEBUG("Can't find window.")
            }
        }
    }
    
    //MARK: Case - screen border
    private var testDrawScreenBorderDrawingId = MagicDrawing.inValidDrawingId
    func testDrawScreenBorder(start: Bool = true) {
        drawingBoard.removeDrawing(drawingId: testDrawScreenBorderDrawingId)
        testDrawScreenBorderDrawingId = MagicDrawing.inValidDrawingId
        if start {
            testDrawScreenBorderDrawingId = drawingBoard.addDrawing(drawing: MagicDrawing.screenBorderDrawing(screen: NSScreen.main!))
        }
    }
    
    //MARK: Case - screen label
    private var testDrawScreenLabelDrawingId = MagicDrawing.inValidDrawingId
    func testDrawScreenLabel(start: Bool = true) {
        drawingBoard.removeDrawing(drawingId: testDrawScreenLabelDrawingId)
        testDrawScreenLabelDrawingId = MagicDrawing.inValidDrawingId
        if start {
            testDrawScreenLabelDrawingId = drawingBoard.addDrawing(drawing: MagicDrawing.screenLabel())
        }
    }
    
    //MARK: full screen detector
    private var timer: Timer?
    private var detector = FullScreenDetector()
    func testFullScreenDetector(start: Bool = true) {
        if start {
            timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
                if let self = self {
                    SPARK_LOG_DEBUG("\(self.detector.isFullScreen())")
                }
            }
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    //MARK: private function
    private func getWindowInfoList(pName: String) -> [MagicWindowInfo] {
        windowInfoList = drawingBoard.getWindowInfoList(exclude: true, onScreenOnly: true)
        return windowInfoList.filter {
            $0.pName.contains(pName)
        }
    }
    
    private func getPowerPointWindowInfoList() -> MagicWindowInfoList {
        let windowInfoList = drawingBoard.getWindowInfoList(exclude: true, onScreenOnly: false)
        return windowInfoList.filter { $0.pName == "Keynote" }
    }
}

extension TestDrawingBoard: TestCasesManager {
    var testName: String { "Drawing Board" }
    
    func getTestCases() -> TestCaseList {
        var testCaseList = TestCaseList()
        var testCase = TestCase(name: caseNameCoverState)
        testCaseList.append(testCase)
        
        testCase = TestCase(name: caseNameApplicationBorder)
        testCaseList.append(testCase)
        
        testCase = TestCase(name: caseNameScreenBorder)
        testCaseList.append(testCase)
        
        testCase = TestCase(name: caseNameScreenLabel)
        testCaseList.append(testCase)
        
        testCase = TestCase(name: caseNameFullScreenDetector)
        testCaseList.append(testCase)
        
        return testCaseList
    }
    
    func onButton(caseName: String, actionName: String) {
        if caseName == caseNameCoverState {
            if actionName == TestAction.startAction {
                testCoverState()
            } else if actionName == TestAction.stopAction {
                testCoverState(start: false)
            }
        } else if caseName == caseNameApplicationBorder {
            if actionName == TestAction.startAction {
                testDrawApplicationBorder()
            } else if actionName == TestAction.stopAction {
                testDrawApplicationBorder(start: false)
            }
        }  else if caseName == caseNameScreenBorder {
            if actionName == TestAction.startAction {
                testDrawScreenBorder()
            } else if actionName == TestAction.stopAction {
                testDrawScreenBorder(start: false)
            }
        }  else if caseName == caseNameScreenLabel {
            if actionName == TestAction.startAction {
                testDrawScreenLabel()
            } else if actionName == TestAction.stopAction {
                testDrawScreenLabel(start: false)
            }
        } else if caseName == caseNameFullScreenDetector {
            if actionName == TestAction.startAction {
                testFullScreenDetector()
            } else if actionName == TestAction.stopAction {
                testFullScreenDetector(start: false)
            }
        }
    }
}
