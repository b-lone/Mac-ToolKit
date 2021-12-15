//
//  UTIconDualWithTitleButtonTests.swift
//  UIToolkitTests
//
//  Created by Joe Leonard on 03/11/2021.
//

import XCTest
import UIToolkit

class UTIconDualWithTitleButtonTests: XCTestCase, UTIconDualButtonWithTitleDelegate {
    
    var expectation: XCTestExpectation?
    var rhsClicked = false
    var lhsClicked = false
    var middleClicked = false
    
    var clickedButton: UTButton?
    
    func leadingButtonClicked(sender: UTIconDualWithTitleButton, button: UTButton) {
        expectation?.fulfill()
        expectation = nil
        clickedButton = button
        lhsClicked = true
    }
    
    func rhsButtonCLicked(sender: UTIconDualWithTitleButton, button: UTButton) {
        expectation?.fulfill()
        expectation = nil
        clickedButton = button
        rhsClicked = true
    }
    
    func middleButtonCLicked(sender: UTIconDualWithTitleButton, button: UTButton) {
        expectation?.fulfill()
        expectation = nil
        clickedButton = button
        middleClicked = true
    }    

    override func setUpWithError() throws {        
        let sampleThemeManager = TestThemeManager()
        let toolkit = UIToolkit.shared
        toolkit.registerThemeManager(themeManager: sampleThemeManager)
        NSFont.loadUIToolKitFonts()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testClickLeadingButton() throws {
        let theButton = UTIconDualWithTitleButton(frame: NSZeroRect)
        theButton.delegate = self
        expectation = expectation(description: "clicked button")
        theButton.getLeadingButton()?.performClick(self)
        waitForExpectations(timeout: 1)
        XCTAssertTrue(clickedButton == theButton.getLeadingButton())
        XCTAssertTrue(lhsClicked)
    }
    
    func testClickTrailingButton() throws {
        let theButton = UTIconDualWithTitleButton(frame: NSZeroRect)
        theButton.delegate = self
        expectation = expectation(description: "clicked button")
        theButton.getTrailingButton()?.performClick(self)
        waitForExpectations(timeout: 1)
        XCTAssertTrue(clickedButton == theButton.getTrailingButton())
        XCTAssertTrue(rhsClicked)
    }
    
    func testClickMiddleButton() throws {
        let theButton = UTIconDualWithTitleButton(frame: NSZeroRect)
        theButton.delegate = self
        expectation = expectation(description: "clicked button")
        theButton.getMiddleButton()?.performClick(self)
        waitForExpectations(timeout: 1)
        XCTAssertTrue(clickedButton == theButton.getMiddleButton())
        XCTAssertTrue(middleClicked)
    }
}
