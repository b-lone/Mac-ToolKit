//
//  ThemesJson.swift
//  TestApp
//
//  Created by Jimmy Coyne on 19/04/2021.
//

import Foundation
import UIToolkit

struct ElementToken: Decodable {
    let normal: String!
    let hovered: String!
    let pressed: String!
    let checked: String!
    let disabled: String!
    let focused: String!
}

struct ThemesMap: Decodable {
    var name: String!
    var tokens: [String: ElementToken]!
}

struct RebrandThemeMap: Decodable {
    var name: String!
    var tokens: [String: RebrandElementToken]!
}

struct RebrandElementToken: Decodable {
    var normal: RGBA!
    let hovered: RGBA!
    let pressed: RGBA!
    let checked: RGBA!
    let disabled: RGBA!
    let focused: RGBA!
}

class ThemeTokens {
    var name: String!
    var tokens: [String: UTColorStates] = [:]
}
