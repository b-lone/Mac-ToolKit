//
//  NSControl+Extensions.swift
//  WebexTeams
//
//  Created by Archie on 5/25/21.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Foundation

extension NSControl {
    var canClick: Bool {
        return !isHidden && isEnabled
    }
}
