//
//  TestCoreAnimation.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/7/11.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class TestCoreAnimation: NSObject {
    let caseNameLayerDelegate = "Layer Delegate"
    let windowController = CommonTestWindowController()
    let layerView = LayerView()
    
    //MARK:Layer Delegate
    private func testLayerDelegate(start: Bool = true) {
        if let view = windowController.window?.contentView {
            windowController.window?.setContentSize(NSMakeSize(2000, 2000))
            windowController.window?.close()
            if start {
                view.addSubviewAndFill(subview: layerView)
                windowController.window?.makeKeyAndOrderFront(self)
            }
        }
    }
    
    private func testLayerAnimation() {
        layerView.layerDelegate.addAnimation(layerView.subLayer)
    }
}

extension TestCoreAnimation: TestCasesManager {
    var testName: String { "Core Animation" }
    
    func getTestCases() -> TestCaseList {
        var testCaseList = TestCaseList()
        let testCase = TestCase(name: caseNameLayerDelegate)
        testCase.actionList.append(TestAction(title: "Animation"))
        testCaseList.append(testCase)
        
        return testCaseList
    }
    
    func onButton(caseName: String, actionName: String) {
        if caseName == caseNameLayerDelegate {
            if actionName == TestAction.startAction {
                testLayerDelegate()
            } else if actionName == TestAction.stopAction {
                testLayerDelegate(start: false)
            } else if actionName == "Animation" {
                testLayerAnimation()
            }
        }
    }
}
