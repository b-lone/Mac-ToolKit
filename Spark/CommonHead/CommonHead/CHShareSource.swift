//
//  CHShareSource.swift
//  CommonHead
//
//  Created by 尤坤 on 2022/3/8.
//

import Foundation

@objcMembers
open class CHShareSource: NSObject {

    public private(set) var shareSourceType: CHSourceType
    public private(set) var sourceId: String
    public private(set) var uniqueName: String
    public private(set) var name: String
    public private(set) var x: NSNumber
    public private(set) var y: NSNumber
    public private(set) var width: NSNumber
    public private(set) var height: NSNumber
    public private(set) var windowHandle: NSNumber

    public init(
        shareSourceType: CHSourceType,
        sourceId: String,
        uniqueName: String,
        name: String,
        x: NSNumber,
        y: NSNumber,
        width: NSNumber,
        height: NSNumber,
        windowHandle: NSNumber)
    {
        self.shareSourceType = shareSourceType
        self.sourceId = sourceId
        self.uniqueName = uniqueName
        self.name = name
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.windowHandle = windowHandle
        
    }
}
