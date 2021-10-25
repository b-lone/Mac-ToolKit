//
//  NSAppearance+Extensions.swift
//  Mac-ToolKit
//
//  Created by Archie You on 2021/10/28.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Foundation
extension NSAppearance {
    static var inDarkMode: Bool {
        let mode = UserDefaults.standard.string(forKey: "AppleInterfaceStyle")
        return mode == "Dark"
    }
    
    static func getVibrantThemedAppearance() -> NSAppearance?{
        if inDarkMode {
            return NSAppearance(named: NSAppearance.Name.vibrantDark)
        }
        
        return NSAppearance(named: NSAppearance.Name.vibrantLight)
    }
}
