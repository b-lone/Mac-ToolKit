//
//  NSScreenAdapter.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/9/30.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

protocol SparkScreen: AnyObject {
    func uuid() -> String?
    func frameInfo() -> String
    var frame: NSRect { get }
    var visibleFrame: NSRect { get }
}

extension NSScreen: SparkScreen {
}

protocol SparkScreenAdapterProtocol: AnyObject {
    var screens: [SparkScreen] { get }
    var main: SparkScreen? { get }
    func aScreen(uuid: String?) -> SparkScreen?
    func screen(uuid: String?) -> SparkScreen
}

class SparkScreenAdapter: NSObject & SparkScreenAdapterProtocol {
    var screens: [SparkScreen] { return NSScreen.screens }
    var main: SparkScreen? { return NSScreen.main }
    
    func aScreen(uuid: String?) -> SparkScreen? {
        if let uuid = uuid, !uuid.isEmpty {
            return screens.first{ $0.uuid() == uuid }
        }
        return nil
    }
    
    func screen(uuid: String?) -> SparkScreen {
        return aScreen(uuid: uuid) ?? (main ?? NSScreen())
    }
}
