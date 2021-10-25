//
//  ProcessInfo+Extensions.swift
//  Mac-ToolKit
//
//  Created by Archie You on 2021/10/28.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Foundation

extension ProcessInfo {
    static func isRunningDevHarnessTests() -> Bool {
        return false
    }
}
