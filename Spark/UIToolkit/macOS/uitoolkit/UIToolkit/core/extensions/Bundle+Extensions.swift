//
//  Bundle+Extensions.swift
//  UIToolkit
//
//  Created by James Nestor on 31/05/2021.
//

import Cocoa

extension Bundle {

    @objc public class func getUIToolKitBundle() -> Bundle? {
        return Bundle.allFrameworks.first(where: { $0.bundleIdentifier == "com.cisco.webex.UIToolkit" })
    }
    
}
