//
//  TestBonjour.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/7/16.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class TestBonjour: NSObject {
    let caseName = "Bonjour Browser"
    let bonjourClient = BonjourClient()
    
    private func startBrowser(_ start: Bool = true) {
        if start {
            bonjourClient.start()
        } else {
            bonjourClient.stop()
        }
    }
}

extension TestBonjour: TestCasesManager {
    var testName: String { "Bonjour" }
    
    func getTestCases() -> TestCaseList {
        var testCaseList = TestCaseList()
        let testCase = TestCase(name: caseName)
        testCaseList.append(testCase)
        
        return testCaseList
    }
    
    func onButton(caseName: String, actionName: String) {
        if caseName == caseName {
            if actionName == TestAction.startAction {
                startBrowser()
            } else if actionName == TestAction.stopAction {
                startBrowser(false)
            }
        }
    }
}
