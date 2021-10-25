//
//  UTNavigationTabButton.swift
//  UIToolkitTests
//
//  Created by Jimmy Coyne on 02/09/2021.
//

import XCTest
import UIToolkit

class UTNavigationTabButtonTests: XCTestCase {

    override func setUpWithError() throws {
        let sampleThemeManager = TestThemeManager()
        let toolkit = UIToolkit.shared
        toolkit.registerThemeManager(themeManager: sampleThemeManager)
        NSFont.loadUIToolKitFonts()
    }


    func testAddLargeImage () throws {
        let resizedImageWidth: CGFloat = 20.0
        let image = try loadImage(name: "swift")
        let size = image.size.width
        XCTAssert(size > resizedImageWidth)
        let navtabButton = UTNavigationTabButton()
        if let resizedImage = navtabButton.addIcon(image: image) {
            XCTAssert(resizedImage.size.width == 20)
        } else {
            XCTAssert(true, "Image has failed ...")
        }
       
    }
    
    func testSmallImage () throws {
        let resizedImageWidth: CGFloat = 20.0
        let image = try loadImage(name: "swift_small")
        let size = image.size.width
        XCTAssert(size < resizedImageWidth)
        let navtabButton = UTNavigationTabButton()
        if let resizedImage = navtabButton.addIcon(image: image) {
            XCTAssert(resizedImage.size.width == size)
        } else {
            XCTAssert(true, "Image should not have resized ...")
        }
       
    }
    
    
    func loadImage( name: String) throws -> NSImage {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: name, ofType: "png") else {
            throw NSError(domain: "loadImage", code: 1, userInfo: nil)
        }
        guard let image = NSImage(contentsOfFile: path) else {
            throw NSError(domain: "loadImage", code: 2, userInfo: nil)
        }
        return image
    }

}
