//
//  String+Extensions.swift
//  Mac-ToolKit
//
//  Created by Archie You on 2021/10/28.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Foundation

extension String {
    var intValue: Int {
        return NSString(string: self).integerValue
    }
    
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
}
