//
//  SparkVideoLayer.swift
//  Mac-ToolKit
//
//  Created by Archie You on 2021/11/10.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

enum VideoFrameType {
    case YUV420
    case BGRA
    case NV12
}

class SparkVideoLayer: NSView {

    var videoFrameType = VideoFrameType.BGRA
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let bezierPath = NSBezierPath(rect: dirtyRect)
        NSColor.black.setFill()
        bezierPath.fill()
    }
    
}
