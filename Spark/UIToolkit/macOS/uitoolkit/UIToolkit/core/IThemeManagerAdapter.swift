//
//  IThemeManagerAdapter.swift
//  uitoolkit
//
//  Created by Jimmy Coyne on 22/03/2021.
//

import Foundation
import Cocoa

public struct Component {
    
    public init() {}
    
    public var background: UTColorStates!
    public var border: UTColorStates!
    public var text: UTColorStates!
    public var icon: UTColorStates!
}

public protocol IThemeManagerAdapter {
    func getColors(tokenName: String) -> UTColorStates
    func getColors(token: UTColorTokens) -> UTColorStates
    func setTheme(themeName:String)
    func isDarkTheme() -> Bool
    func getCurrentTheme() -> String
}
