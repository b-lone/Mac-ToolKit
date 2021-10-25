//
//  BaseViewController.swift
//  WebexTeams
//
//  Created by jnestor on 17/07/2020.
//  Copyright © 2020 Cisco Systems. All rights reserved.
//

import Cocoa

//protocol FontProtocol{
//    func setFonts()
//}
//
//typealias BaseViewController = BaseViewControllerClass & FontProtocol

class BaseViewController: NSViewController, ThemeableProtocol {

    let appContext : AppContext
    
    private var currentTheme:String?
    
    init(appContext:AppContext){
        self.appContext = appContext
        
        super.init(nibName: String(describing: Self.self), bundle: Bundle.getSparkBundle())
    }
    
    init(appContext:AppContext, nibName: String?){
        self.appContext = appContext
        
        super.init(nibName: nibName, bundle: Bundle.getSparkBundle())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        unsubscribeForThemeUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFonts()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        subscribeForThemeUpdates()
        
//        if currentTheme != ThemeManager.currentTheme{
//            currentTheme = ThemeManager.currentTheme
//            setThemeColors()
//        }
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        unsubscribeForThemeUpdates()
    }
    
    func subscribeForThemeUpdates(){
//        appContext.themeableProtocolManager.subscribe(listener: self)
    }
    
    func unsubscribeForThemeUpdates(){
//        appContext.themeableProtocolManager.unsubscribe(listener: self)
    }
    
    func setThemeColors() {
//        currentTheme = ThemeManager.currentTheme
    }
    
    func setFonts(){}
}
