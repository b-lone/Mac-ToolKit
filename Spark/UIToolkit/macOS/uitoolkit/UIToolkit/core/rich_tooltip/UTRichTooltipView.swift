//
//  UTRichTooltipView.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 05/08/2021.
//

import Cocoa

public struct UTRichTooltipDetails {
    
    public enum Size {
        case small
        case medium
        case large
    }
    
    public var attTooltipString: NSAttributedString
    public var size: Size
    public var preferredEdge: NSRectEdge
    
    public init(tooltip:NSAttributedString, size:Size, preferredEdge: NSRectEdge = .maxY) {
        self.attTooltipString = tooltip
        self.size = size
        self.preferredEdge = preferredEdge
    }
}


public enum UTTooltipType {
    case plain(String)
    case rich(UTRichTooltipDetails)
}
