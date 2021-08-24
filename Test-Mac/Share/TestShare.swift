//
//  TestShare.swift
//  Test-Mac
//
//  Created by Archie You on 2021/8/23.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class TestShare: NSObject {
    let caseNameCaptureIosScreen = "capture iOS screen"
    let iosScreenCaptureManager: ShareIosScreenCaptureManagerProtocol = ShareIosScreenCaptureManager()
    let previewWindowController = CommonTestWindowController()
    
    override init() {
        super.init()
        iosScreenCaptureManager.delegate = self
        previewWindowController.contentView.wantsLayer = true
        previewWindowController.window?.setContentSize(NSMakeSize(640, 480))
        previewWindowController.contentView?.layer?.addSublayer(iosScreenCaptureManager.captureVideoPreviewLayer)
        
        previewWindowController.delegate = self
    }
}

extension TestShare: TestCasesManager {
    var testName: String { "Share" }
    
    func getTestCases() -> TestCaseList {
        var testCaseList = TestCaseList()
        let testCase = TestCase(name: caseNameCaptureIosScreen)
        testCase.actionList = [
            TestAction(title: "Start"),
            TestAction(title: "Stop"),
        ]
        testCaseList.append(testCase)
        
        return testCaseList
    }
    
    func onButton(caseName: String, actionName: String) {
        if caseName == caseNameCaptureIosScreen {
            if actionName == "Start" {
                iosScreenCaptureManager.start()
                previewWindowController.showWindow(nil)
            } else if actionName == "Stop" {
                iosScreenCaptureManager.stop()
                previewWindowController.close()
            }
        }
    }
}

extension TestShare: ShareIosScreenCaptureManagerDelegate {
    func shareIosScreenCaptureManager(_ manager: ShareIosScreenCaptureManager, onIosDeviceAvailableChanged isAvailable: Bool) {
    }
    
    func shareIosScreenCaptureManager(_ manager: ShareIosScreenCaptureManager, onPreviewSizeChanged size: NSSize) {
//        previewWindow.setContentSize(size)
    }
}

extension TestShare: CommonTestWindowControllerDelegate {
    func windowController(_ windowController: CommonTestWindowController, didResize size: NSSize) {
        iosScreenCaptureManager.captureVideoPreviewLayer.frame = NSMakeRect(0, 0, size.width, size.height)
    }
}
