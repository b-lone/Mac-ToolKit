//
//  WeakWrapper.swift
//  uitoolkit
//
//  Created by Jimmy Coyne on 19/03/2021.
//

//  Copyright © 2017 Cisco Systems. All rights reserved.
//

import Cocoa

class WeakWrapper {
    weak var value: AnyObject?
    
    init(value: AnyObject) {
        self.value = value
    }
}
