//
//  TestWindow.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/7/8.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class TestWindow: NSObject {
    let caseName = "Case Name"
}

extension TestWindow: TestCasesManager {
    var testName: String { "Window" }
    
    func getTestCases() -> TestCaseList {
        var testCaseList = TestCaseList()
        let testCase = TestCase(name: caseName)
        testCase.actionList = [
            TestAction(title: "Action 1"),
            TestAction(title: "Action 2"),
            TestAction(title: "Action 3"),
            TestAction(title: "Action 4"),
            TestAction(title: "Action 5"),
            TestAction(title: "Action 6"),
            TestAction(title: "Action 7"),
            TestAction(title: "Action 8"),
            TestAction(title: "Action 9"),
        ]
        testCaseList.append(testCase)
        
        return testCaseList
    }
    
    func onButton(caseName: String, actionName: String) {
        if caseName == caseName {
            if actionName == TestAction.startAction {
            } else if actionName == TestAction.stopAction {
            }
        }
    }
}
