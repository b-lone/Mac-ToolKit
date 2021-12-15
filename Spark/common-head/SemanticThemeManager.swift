//
//  SemanticThemeManager.swift
//  CiscoSparkPlugin
//
//  Created by jnestor on 24/06/2020.
//  Copyright © 2020 Cisco Systems. All rights reserved.
//

import Cocoa
import UIToolkit

class SemanticThemeManager : IThemeManagerAdapter{

    static var shared = SemanticThemeManager()
    private(set) var themeMapCollection:[String:ThemeTokens] = [:]
    private(set) var currentTheme: ThemeTokens!
    private(set) var colorMap: [String:RGBA]!
//    private let proxy: SemanticThemeManagerProxy = SemanticThemeManagerProxy()
    
    // MARK: - Private variables
    
    init(){
        self.colorMap = getColorMap()
        self.themeMapCollection = getThemeColors()
        self.currentTheme = themeMapCollection["MomentumDefault"]
    }
    
    static func getColors(for token: CHSemanticToken) -> UTColorStates {
        return shared.getColorStates(token: token)
    }
    
    static func getLegacyColors(for token: CHSemanticToken) -> UTColorStates {
        return shared.getLegacyColors(token: token)
    }
    
    private func getLegacyColors(token:CHSemanticToken) -> UTColorStates{
        return getColorStates(token: token)
    }
    
    private func getColorStates(token:CHSemanticToken) -> UTColorStates{
        return UTColorStates(normal: .black, pressed: nil)
    }
    
    func getColors(tokenName: String) -> UTColorStates {
        return currentTheme?.tokens[tokenName] ?? UTColorStates(normal: NSColor.clear, pressed: NSColor.clear)
    }
        
    func getColors(token: UTColorTokens) -> UTColorStates {
        getColors(tokenName: token.rawValue)
    }
    
    func setTheme(themeName: String) {
        self.currentTheme = themeMapCollection[themeName]
    }
    
    func isDarkTheme() -> Bool {
        guard let currentTheme = currentTheme else { return false }
        return isDarkTheme(name: currentTheme.name)
    }
    
    func getCurrentTheme() -> String {
        guard let currentTheme = currentTheme else { return "MomentumDefault" }
        return currentTheme.name
    }
    
    private func getColorMap() -> [String:RGBA]  {
        
        var colorsMap:[String:RGBA] = [:]
        if let path = Bundle.main.path(forResource: "colors", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            // let data = try! Data(contentsOf: resource!, options: .alwaysMapped)
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Colors.self, from: data)
                //print(jsonData)
                for colors in jsonData.colors {
                    for  varation in colors.variations {
                        let name = varation.name
                        let rgba = varation.rgba
                        colorsMap[name] = rgba
                    }
                }
            } catch {
                print("jsonData fail: \(error)")
            }
            
        }
        return colorsMap
    }
    
    private func decodeTheme(theme:String, baseThemeTokens:[String: ElementToken]) -> ThemesMap?{
        
        guard var themeMap = decodeTheme(theme: theme) else{
            NSLog("unable to decode theme with name: \(theme)")
            return nil
        }
        
        var combinedTheme = baseThemeTokens
        
        for (key, value) in themeMap.tokens{
            combinedTheme[key] = value
        }
        
        themeMap.tokens = combinedTheme
        return themeMap
    }
    
    private func decodeTheme(theme:String) -> ThemesMap?{
        
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: theme, ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            do {
                let decoder = JSONDecoder()
                let themesMap = try decoder.decode(ThemesMap.self, from: data)
                return themesMap
                
            } catch {
                print("jsonData fail: \(error)")
            }
        }
        return nil
    }
    
    private func decodeRebrandTheme(theme:String) -> RebrandThemeMap? {
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: theme, ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            do {
                let decoder = JSONDecoder()
                let themesMap = try decoder.decode(RebrandThemeMap.self, from: data)
                return themesMap
                
            } catch {
                print("jsonData fail: \(error)")
            }
        }
        return nil
    }
    
    private func convertThemeMapToThemeTokens(themeMap:ThemesMap) -> ThemeTokens{
        
        let themeTokens = ThemeTokens()
        themeTokens.name = themeMap.name
        
        for tokenName in themeMap.tokens.keys {
            
            var normal: NSColor = NSColor.clear
            var hovered: NSColor?
            var pressed: NSColor?
            var checked: NSColor?
            var focused: NSColor?
            var disabled: NSColor?
            
            
            if let token = themeMap.tokens[tokenName] {
                
                if let normalToken = token.normal {
                    if let normalColor = colorMap[normalToken] {
                        normal = normalColor.getColor()
                    }
                }
                
                if let hoverToken = token.hovered {
                    if let hoverColor = colorMap[hoverToken] {
                        hovered = hoverColor.getColor()
                    }
                }
                
                if let pressedToken = token.pressed {
                    if let pressedColor = colorMap[pressedToken] {
                        pressed = pressedColor.getColor()
                    }
                }
                
                if let checkedToken = token.checked {
                    if let checkedColor = colorMap[checkedToken] {
                        checked = checkedColor.getColor()
                    }
                }
                
                if let focusedToken = token.focused{
                    if let focusedColor = colorMap[focusedToken]{
                        focused = focusedColor.getColor()
                    }
                }
                
                if let disableToken = token.disabled {
                    if let disableColor = colorMap[disableToken] {
                        disabled = disableColor.getColor()
                    }
                }
            }
            
            themeTokens.tokens[tokenName] = UTColorStates(normal: normal,
                                                          hover: hovered,
                                                          pressed: pressed,
                                                          on: checked,
                                                          focused: focused,
                                                          disabled: disabled)
        }
        
        return themeTokens
    }
    
    private func convertRebrandThemeMapToThemeTokens(rebrandThemeMap:RebrandThemeMap) -> ThemeTokens{
        let themeTokens = ThemeTokens()
        themeTokens.name = rebrandThemeMap.name
        
        for tokenName in rebrandThemeMap.tokens.keys {
        
            var normal: NSColor = NSColor.clear
            var hovered: NSColor?
            var pressed: NSColor?
            var checked: NSColor?
            var focused: NSColor?
            var disabled: NSColor?
            
            
            if let token = rebrandThemeMap.tokens[tokenName] {
                
                if let normalColor = token.normal {
                    normal = normalColor.getColor()
                }
                
                if let hoverColor = token.hovered {
                    hovered = hoverColor.getColor()
                }
                
                if let pressedColor = token.pressed {
                    pressed = pressedColor.getColor()
                }
                
                if let checkedColor = token.checked {
                    checked = checkedColor.getColor()
                }
                
                if let focusedColor = token.focused{
                    focused = focusedColor.getColor()
                }
                
                if let disableColor = token.disabled {
                    disabled = disableColor.getColor()
                }
            }
            
            themeTokens.tokens[tokenName] = UTColorStates(normal: normal,
                                                          hover: hovered,
                                                          pressed: pressed,
                                                          on: checked,
                                                          focused: focused,
                                                          disabled: disabled)
            
        }
        
        return themeTokens
    }
    
    private func isDarkTheme(name:String) -> Bool {
        return name.lowercased().contains("dark")
    }
    
    private func getThemeColors(defaultThemeName: String, darkThemeName:String, supplementryThemeNames:[String]) -> [String:ThemeTokens]{
        
        var themeMapCollection:[String:ThemeTokens] = [:]
        
        guard let defaultThemeMap = decodeTheme(theme: defaultThemeName) else {
            assert(false, "unable to decode default theme")
            return themeMapCollection
        }
        
        let defaultTheme = convertThemeMapToThemeTokens(themeMap: defaultThemeMap)
        
        themeMapCollection[defaultTheme.name] = defaultTheme
        
        guard let darkThemeMap = decodeTheme(theme: darkThemeName) else {
            assert(false, "unable to decode dark theme")
            return [:]
        }
        
        let darkTheme = convertThemeMapToThemeTokens(themeMap: darkThemeMap)
        
        themeMapCollection[darkTheme.name] = darkTheme
        
        for theme in supplementryThemeNames{
         
            if let themeMap = decodeTheme(theme:theme, baseThemeTokens: isDarkTheme(name: theme) ? darkThemeMap.tokens : defaultThemeMap.tokens){
                themeMapCollection[themeMap.name] = convertThemeMapToThemeTokens(themeMap: themeMap)
            }
        }
        
        return themeMapCollection
    }
    
    private func getRebrandThemeColors(legacyThemes:[String:ThemeTokens]) -> [String: ThemeTokens]{
        
        var themeMapCollection:[String:ThemeTokens] = [:]
        
        let themes:[String] = [ "momentumDefault","momentumBronzeLight", "momentumJadeLight", "momentumLavenderLight",
                                "momentumDark",   "momentumBronzeDark",  "momentumJadeDark",  "momentumLavenderDark" ]
        
        for theme in themes {
            if let rebrandTheme = decodeRebrandTheme(theme: theme) {
                
                let themeToken = convertRebrandThemeMapToThemeTokens(rebrandThemeMap: rebrandTheme)
                
                var originalTheme = theme
                if let range = originalTheme.range(of: "momentum") {
                    originalTheme.removeSubrange(range)
                    
                    if let legacyTheme = legacyThemes[originalTheme]{
                        themeToken.tokens = themeToken.tokens.merging(legacyTheme.tokens){(current, _) in current}
                    }
                }
                                
                themeMapCollection[themeToken.name] = themeToken
            }
            
        }
        
        return themeMapCollection
    }
    
    private func getThemeColors() -> [String:ThemeTokens] {
        
        let themes:[String] = [ "bronzeLight", "jadeLight", "lavenderLight",
                                "bronzeDark", "jadeDark", "lavenderDark" ]
                
        var themeTokens = getThemeColors(defaultThemeName: "default", darkThemeName: "dark", supplementryThemeNames: themes)
        let rebrandTokens = getRebrandThemeColors(legacyThemes: themeTokens)
        themeTokens = themeTokens.merging(rebrandTokens){(current, _) in current}
        return themeTokens
    }
}
