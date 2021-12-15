//
//  UIToolKit.swift
//  uitoolkit
//
//  Created by Jimmy Coyne on 22/03/2021.
//

import Foundation
public class UIToolkit {
    
    public static let shared = UIToolkit()
    private init() {}
    private var themeManager:IThemeManagerAdapter! = nil
    public var themeableProtocolManager:ThemeableProtocolManager = ThemeableProtocolManager()
    public var fontManager:UTFontManager = UTFontManager()
    public var localizationManager:UTLocalizationManager = UTLocalizationManager()
    
    public func registerThemeManager(themeManager: IThemeManagerAdapter) {
        self.themeManager = themeManager
    }
    
    public func getThemeManager() -> IThemeManagerAdapter {
        if themeManager == nil {
            fatalError("themeManager needs to be set before proceeding ")
        }
        return themeManager
    }
    
}
