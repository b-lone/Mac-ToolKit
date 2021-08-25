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
    var iosScreenCaptureManager: ShareIosScreenCaptureManagerProtocol { shareIosScreenWindowController.iosScreenCaptureManager }
    let shareIosScreenWindowController: IShareIosScreenWindowController = ShareIosScreenWindowController()
    
    override init() {
        super.init()
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
                shareIosScreenWindowController.showWindow(nil)
            } else if actionName == "Stop" {
                iosScreenCaptureManager.stop()
                shareIosScreenWindowController.close()
            }
        }
    }
}
