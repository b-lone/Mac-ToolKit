//
//  ButtonElement.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 12/06/2021.
//

import Foundation
import Cocoa

internal enum ButtonElement : Hashable {
    case Label(String)
    case UnreadPill
    case Badge(Int)
    case FontIcon(MomentumRebrandIconType)
    case ArrowIcon //while this is also a font, we handle different as state will change its orientation
    case Image(NSImage)
    
    
    //inorder to ignore the enums associated value in keys for maps, we created our own hasher
    func hash(into hasher: inout Hasher) {
        switch self {
        case .ArrowIcon: hasher.combine("ArrowIcon")
        case .Badge(_): hasher.combine("Badge")
        case .FontIcon(_): hasher.combine("Hashable")
        case .Image(_): hasher.combine("FontIcon")
        case .Label(_): hasher.combine("label")
        case .UnreadPill: hasher.combine("UnreadPill")
        }
    }
    
    static func == (lhs: ButtonElement, rhs: ButtonElement) -> Bool {
            switch (lhs, rhs) {
            case (.Label, .Label), (.UnreadPill, .UnreadPill), (.Badge, .Badge), (.FontIcon, .FontIcon), (.ArrowIcon, .ArrowIcon),  (.Image, .Image):
                return true
            default:
                return false
            }
    }
}
