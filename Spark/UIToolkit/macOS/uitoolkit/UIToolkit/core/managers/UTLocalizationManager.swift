//
//  UTLocalizationManager.swift
//  UIToolkit
//
//  Created by James Nestor on 05/07/2021.
//

import Cocoa

public protocol LanguageProtocol : AnyObject{
    func onLanguageChanged()
}

public class UTLocalizationManager: UTBaseManager {
    
    //MARK: - Public API
    @discardableResult
    public func subscribe(listener: LanguageProtocol) -> Bool{
        return _subscribe(listener: listener)
    }
    
    @discardableResult
    public func unsubscribe(listener: LanguageProtocol) -> Bool {
        return _unsubscribe(listener: listener)
    }
    
    public func notifyListenersOnLanguageUpdated() {
        super.notifyListenersOnUpdate()
        
        for listener in listeners{
            (listener.value as? LanguageProtocol)?.onLanguageChanged()
        }
    }
    
    public func getLanguageBundle() -> Bundle {
        if let language = UserDefaults.standard.value(forKey: "UserLangauge") as? String,
           let path = Bundle.main.path(forResource: language, ofType: "lproj"),
           let bundle = Bundle(path: path){
            
            
            return bundle
        }
        
        return Bundle.main
    }
}
