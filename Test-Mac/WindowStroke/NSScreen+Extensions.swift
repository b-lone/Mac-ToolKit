//
//  NSScreen+Extensions.swift
//  Test-Mac
//
//  Created by Archie You on 2021/5/28.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Foundation
extension NSScreen {
    var uuid: String {
//        let screenNumber = ((deviceDescription as! [String: Any])["NSScreenNumber"] as! NSNumber).uint32Value
//        let cfUuid = CGDisplayCreateUUIDFromDisplayID(screenNumber)
//        let cfUuidStr = CFUUIDCreateString(nil, cfUuid as! CFUUID)
//        return cfUuidStr as! String
        let screens = NSScreen.screens
        var number = 0
        for screen in screens {
            if self == screen {
                return "\(number)"
            }
            number += 1
        }
        fatalError()
    }
}
