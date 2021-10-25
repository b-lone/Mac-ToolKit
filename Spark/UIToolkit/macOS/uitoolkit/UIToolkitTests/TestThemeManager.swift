//
//  TestThemeManager.swift
//  UIToolkitTests
//
//  Created by Jimmy Coyne on 14/07/2021.
//

import Foundation
import UIToolkit
public class TestThemeManager: IThemeManagerAdapter {
    public func getColors(token: UTColorTokens) -> UTColorStates {
        return UTColorStates(normal: .black, hover: .black, pressed: .black, on: .black, focused: .black, disabled: .black)
    }
    
    public func getColors(tokenName: String) -> UTColorStates {
        return UTColorStates(normal: .black, hover: .black, pressed: .black, on: .black, focused: .black, disabled: .black)
    }
    
    public func getComponentSetting(for token: String) -> Component {
        let dummyState = UTColorStates(normal: .black, hover: .black, pressed: .black, on: .black, focused: .black, disabled: .black)
        
        var dummyComponent = Component()
        dummyComponent.background = dummyState
        dummyComponent.border = dummyState
        
        return dummyComponent
    }
    
    public func setTheme(themeName: String) {
        
    }
    
    public func isDarkTheme() -> Bool {
        false
    }
    
    public func getCurrentTheme() -> String {
        "default"
    }
    
    
    
}
