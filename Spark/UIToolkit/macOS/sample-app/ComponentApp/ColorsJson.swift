//
//  ColorsJson.swift
//  TestApp
//
//  Created by Jimmy Coyne on 19/04/2021.
//

import Foundation
import Cocoa

struct RGBA: Decodable {
    let r: CGFloat
    let g: CGFloat
    let b: CGFloat
    let a: CGFloat
    
    func getColor() -> NSColor {
        return NSColor(srgbRed: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a) 
    }
}
struct Variation: Decodable {
    let name: String
    let hex: String
    let rgba: RGBA
}

struct Variations : Decodable{
    let color: String
    let variations: [Variation]
}

struct Colors: Decodable {
    let colors: [Variations]
}
