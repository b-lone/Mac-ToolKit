//
//  BaseWindowController.swift
//  WebexTeams
//
//  Created by joe leonard on 13/10/2020.
//  Copyright © 2020 Cisco Systems. All rights reserved.
//

import Cocoa

class BaseWindowController: NSWindowController, ThemeableProtocol {

    let appContext : AppContext
    
    private var currentTheme:String?
    
    init(appContext:AppContext){
        self.appContext = appContext
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        unsubscribeForThemeUpdates()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        subscribeForThemeUpdates()
        
//        if currentTheme != ThemeManager.currentTheme {
//            currentTheme = ThemeManager.currentTheme
//            setThemeColors()
//        }
    }
    
    func subscribeForThemeUpdates() {
//        appContext.themeableProtocolManager.subscribe(listener: self)
    }
    
    func unsubscribeForThemeUpdates(){
//        appContext.themeableProtocolManager.unsubscribe(listener: self)
    }
    
    func setThemeColors() {
//        currentTheme = ThemeManager.currentTheme
    }
}
