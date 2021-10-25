//
//  TestScreenChangeHelper.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/9/30.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class TestScreenChangeHelper: NSObject, ScreenChangeHelperObserver {
    let caseNameScreenChange = "Screen Change"
    
    var screenChangeHelper = ScreenChangeHelper(screenAdapter: SparkScreenAdapter())
    
    override init() {
        super.init()
    }
    
    func onScreenFrameChanged(screenId: ScreenId) {
        SPARK_LOG_DEBUG(screenId)
    }
    
    func onScreenConnect(screenId: ScreenId) {
        SPARK_LOG_DEBUG(screenId)
    }
    
    func onScreenDisconnect(screenId: ScreenId) {
        SPARK_LOG_DEBUG(screenId)
    }
}

extension TestScreenChangeHelper: TestCasesManager {
    var testName: String { "Screen Helper" }
    
    func getTestCases() -> TestCaseList {
        var testCaseList = TestCaseList()
        let testCase = TestCase(name: caseNameScreenChange)
        testCase.actionList = [
            TestAction(title: "Start"),
            TestAction(title: "Stop"),
        ]
        testCaseList.append(testCase)
        
        return testCaseList
    }
    
    func onButton(caseName: String, actionName: String) {
        if caseName == caseNameScreenChange {
            if actionName == "Start" {
            } else if actionName == "Stop" {
            }
        }
    }
}
