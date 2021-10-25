//
//  NSRect+Extensions.swift
//  Mac-ToolKit
//
//  Created by Archie You on 2021/10/28.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Foundation

extension NSRect {
    var center: CGPoint {
      get {
        return CGPoint(x: midX, y: midY)
      }
      set {
        origin = CGPoint(x: newValue.x - (size.width * 0.5),
                         y: newValue.y - (size.height * 0.5))
      }
    }
}
