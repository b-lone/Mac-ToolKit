//
//  Bundle+Extensions.swift
//  UIToolkitTests
//
//  Created by James Nestor on 07/07/2021.
//

import Cocoa

extension Bundle {
    @objc public class func getUIToolKitTestBundle() -> Bundle? {
        return Bundle.allBundles.first(where: { $0.bundleIdentifier == "com.cisco.webex.UIToolkitTests" })
    }
}
