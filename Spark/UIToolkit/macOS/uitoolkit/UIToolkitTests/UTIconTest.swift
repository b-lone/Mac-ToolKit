//
//  UTIconTest.swift
//  UIToolkitTests
//
//  Created by James Nestor on 31/08/2021.
//

import XCTest
import UIToolkit

class UTIconTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let sampleThemeManager = TestThemeManager()
        let toolkit = UIToolkit.shared
        toolkit.registerThemeManager(themeManager: sampleThemeManager)
        NSFont.loadUIToolKitFonts()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConfigureUTIcon() throws {
        
        let icon = UTIcon(iconType: .privateBold, style: .error, size: .mediumSmall)
        
        XCTAssertTrue(icon.style == .error)
        XCTAssertTrue(icon.iconType == .privateBold)
        XCTAssertTrue(icon.size == .mediumSmall)
        
        icon.configure(iconType: .settingsBold, style: .warning, size: .large)
        
        XCTAssertTrue(icon.style == .warning)
        XCTAssertTrue(icon.iconType == .settingsBold)
        XCTAssertTrue(icon.size == .large)
    }

}
