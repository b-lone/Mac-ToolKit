//
//  BaseViewController.swift
//  WebexTeams
//
//  Created by jnestor on 17/07/2020.
//  Copyright © 2020 Cisco Systems. All rights reserved.
//

import Cocoa

open class UTBaseViewController: NSViewController, ThemeableProtocol, FontProtocol, LanguageProtocol {
    
    private var currentTheme:String?    
    
    deinit{
        unsubscribeForThemeUpdates()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open override func viewWillAppear() {
        super.viewWillAppear()
        subscribeForThemeUpdates()
        subscribeForFontUpdates()
        subscribeForLanguageUpdates()
        
        if currentTheme != UIToolkit.shared.getThemeManager().getCurrentTheme(){
            currentTheme = UIToolkit.shared.getThemeManager().getCurrentTheme()
            setThemeColors()
        }
        
        //TODO: - If font or language is updated fire notification
    }
    
    open override func viewDidDisappear() {
        super.viewDidDisappear()
        unsubscribeForThemeUpdates()
        unsubscribeForFontUpdates()
        unsubscribeForLanguageUpdates()
    }
    
    open func subscribeForThemeUpdates(){
        UIToolkit.shared.themeableProtocolManager.subscribe(listener: self)
    }
    
    open func unsubscribeForThemeUpdates(){
        UIToolkit.shared.themeableProtocolManager.unsubscribe(listener: self)
    }
    
    open func subscribeForFontUpdates(){
        UIToolkit.shared.fontManager.subscribe(listener: self)
    }
    
    open func unsubscribeForFontUpdates(){
        UIToolkit.shared.fontManager.unsubscribe(listener: self)
    }
    
    open func subscribeForLanguageUpdates() {
        UIToolkit.shared.localizationManager.subscribe(listener: self)
    }
    
    open func unsubscribeForLanguageUpdates() {
        UIToolkit.shared.localizationManager.unsubscribe(listener: self)
    }
    
    open func setThemeColors() {
        currentTheme = UIToolkit.shared.getThemeManager().getCurrentTheme()
    }
    
    open func updateFont(){}
    
    open func onLanguageChanged() {}
}
