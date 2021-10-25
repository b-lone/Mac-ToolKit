//
//  ThemeManager.swift
//  Mac-ToolKit
//
//  Created by Archie You on 2021/10/28.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

typealias CCColor = NSColor

class ThemeManager: NSObject {
    static func isDarkTheme() -> Bool {
        NSAppearance.inDarkMode
    }
}
