//
//  TestShare.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/8/23.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa
import CommonHead

extension CHRect {
    static var zero: CHRect {
        CHRect(x: NSNumber(0), y: NSNumber(0), width: NSNumber(0), height: NSNumber(0))
    }
}

class TestShare: NSObject {
    let caseNameCaptureIosScreen = "capture iOS screen"
    let caseNameLocalShareControlBar = "control bar"
    let caseNameImmersiveShare = "Immersive Share"
    
    let shareManager = ShareManager(appContext: AppContext.shared)
    lazy var shareIosScreenManager: ShareIosScreenManagerProtocol = ShareIosScreenManager(shareFactory: AppContext.shared.shareFactory)
    
    lazy var localShareControlBarManager = LocalShareControlBarManager(shareFactory: AppContext.shared.shareFactory)
    
    var currentScreen: ScreenId = ""
    
    var barInfo: CHLocalShareControlBarInfo = {
        let labelInfo = CHLocalShareControlViewLabelInfo(modifiedString: "You're sharing ", detailsString: "Screen", tooltips: "You're sharing Screen")
        let label = CHLabel(text: "", isHidden: true, isEnabled: false, tooltip: "")
        let button = CHButton(buttonState: .none, text: "", isHidden: true, isEnabled: false, tooltip: "")
        let viewInfo = CHLocalShareControlViewInfo(labelInfo: labelInfo, recordingState: CHMeetingRecordingState.recordingPaused, recordingSvgLabel: label, meetingLockedLabel: label, shareTitleButton: button, rdcButton: button, annotateButton: button, pauseButton: button, stopButton: button, showPreviewView: true)
        let windowInfo = CHLocalShareControlWindowInfo(shouldShowWindow: true, shouldShowScreenBorder: true, colorMode: .orange)
        let barInfo = CHLocalShareControlBarInfo(windowInfo: windowInfo, viewInfo: viewInfo, isSharePaused: false, isImOnlyShareForAccept: false)
        AppContext.shared.commonHeadFrameworkAdapter.shareVM.localShareControlBarInfo = barInfo
        return barInfo
    }()
    
    private var immersiveShareManager = ImmersiveShareManager(shareFactory: AppContext.shared.shareFactory)
    
    override init() {
        super.init()
    }
    
    private var windowInfoList = [MagicWindowInfo]()
    private func getWindowInfoList(pName: String) -> [MagicWindowInfo] {
        windowInfoList = AppContext.shared.drawingBoardManager.getWindowInfoList(exclude: true, onScreenOnly: true)
        return windowInfoList.filter {
            $0.pName.contains(pName)
        }
    }
    
    private func setupWindowShare() {
        let list = getWindowInfoList(pName: "Terminal")
        let sharingContent = CHSharingContent(sourceType: .window, captureRect: .zero, shareSourceList: [], capturedWindows: list.map( { "\($0.windowNumber)" } ))
        AppContext.shared.commonHeadFrameworkAdapter.shareVM.sharingContent = sharingContent
        (shareManager.getComponent(callId: "1") as? ShareManagerComponent)?.shareViewModel(AppContext.shared.commonHeadFrameworkAdapter.shareVM, onSharingContentChanged: sharingContent)
    }
}

extension TestShare: TestCasesManager {
    var testName: String { "Share" }
    
    func getTestCases() -> TestCaseList {
        var testCaseList = TestCaseList()
        var testCase = TestCase(name: caseNameCaptureIosScreen)
        testCase.actionList = [
            TestAction(title: "Start"),
            TestAction(title: "Stop"),
        ]
        testCaseList.append(testCase)
        
        testCase = TestCase(name: caseNameLocalShareControlBar)
        testCase.actionList = [
            TestAction(title: "Show"),
            TestAction(title: "Hide"),
            TestAction(title: "Change Screen"),
            TestAction(title: "Label"),
        ]
        testCaseList.append(testCase)
        
        testCase = TestCase(name: caseNameImmersiveShare)
        testCase.actionList = [
            TestAction(title: "Show"),
            TestAction(title: "Hide"),
        ]
        testCaseList.append(testCase)
        
        return testCaseList
    }
    
    func onButton(caseName: String, actionName: String) {
        if caseName == caseNameCaptureIosScreen {
            shareIosScreenManager.setup(shareComponent: shareManager.getComponent(callId: "1")!)
            if actionName == "Start" {
                shareIosScreenManager.start()
                shareIosScreenManager.isSharingIosScreen = true
                testLabel()
            } else if actionName == "Stop" {
                shareIosScreenManager.isSharingIosScreen = false
                shareIosScreenManager.stop()
            }
        } else if caseName == caseNameLocalShareControlBar {
            localShareControlBarManager.setup(shareComponent: shareManager.getComponent(callId: "1")!)
            currentScreen = shareManager.getComponent(callId: "1")?.shareContext.screenToDraw.uuid() ?? ""
            if actionName == "Show" {
                localShareControlBarManager.showShareControlBar()
            } else if actionName == "Hide" {
                localShareControlBarManager.hideShareControlBar()
            } else if actionName == "Change Screen" {
                testChangeScreen()
            } else if actionName == "Label" {
                testLabel()
            }
        } else if caseName == caseNameImmersiveShare {
            immersiveShareManager.setup(shareComponent: shareManager.getComponent(callId: "1")!)
            if actionName == "Show" {
                setupWindowShare()
                immersiveShareManager.showFlaotingVideoWindow()
            } else if actionName == "Hide" {
                immersiveShareManager.hideFlaotingVideoWindow()
            }
        }
    }
    
    private func testChangeScreen() {
        let screenIdList = NSScreen.screens.compactMap { $0.uuid() }
        var screenId = screenIdList.first { $0 != currentScreen }
        if screenId == nil {
            screenId = currentScreen
        }
        let screen = SparkScreenAdapter().screen(uuid: screenId)
        
        let rect = CHRect(x: NSNumber(value: Float(screen.frame.minX)), y: NSNumber(value: Float(screen.frame.minY)), width: NSNumber(value: Float(screen.frame.width)), height: NSNumber(value: Float(screen.frame.height)))
        let sharingContent = CHSharingContent(sourceType: .desktop, captureRect: rect, shareSourceList: [CHShareSource(shareSourceType: .desktop, sourceId: screenId!, uniqueName: "screen", name: "screen", x: NSNumber(value: 0), y: NSNumber(value: 0), width: NSNumber(value: 0), height: NSNumber(value: 0), windowHandle: NSNumber(value: 0))], capturedWindows: [])
        AppContext.shared.commonHeadFrameworkAdapter.shareVM.sharingContent = sharingContent
    
        (shareManager.getComponent(callId: "1")! as! ShareManagerComponent).shareViewModel(CHShareViewModel(), onSharingContentChanged: sharingContent)
        
        currentScreen = screenId ?? ""
    }
    
    private func testLabel() {
        (shareManager.getComponent(callId: "1")! as! ShareManagerComponent).shareViewModel(CHShareViewModel(), onLocalShareControlBarInfoChanged: barInfo)
    }
}
