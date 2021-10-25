//
//  NSColor+Extensions.swift
//  Mac-ToolKit
//
//  Created by Archie You on 2021/10/28.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Foundation

extension NSColor {
    func withAlpha(_ alpha: Double) -> NSColor {
        withAlphaComponent(CGFloat(alpha))
    }
}
