//
//  ThemeableProtocol.swift
//  WebexTeams
//
//  Created by jnestor on 17/07/2020.
//  Copyright © 2020 Cisco Systems. All rights reserved.
//

import Cocoa

public protocol ThemeableProtocol: AnyObject {
    func setThemeColors()
}

public class ThemeableProtocolManager : UTBaseManager {    
    
    //MARK: - Public API
    @discardableResult
    public func subscribe(listener: ThemeableProtocol) -> Bool{
        return _subscribe(listener: listener)
    }
    
    @discardableResult
    public func unsubscribe(listener: ThemeableProtocol) -> Bool{
        return _unsubscribe(listener: listener)
    }
    
    public func notifyListenersOnThemeUpdated(){
        notifyListenersOnUpdate()
        
        for listener in listeners{
            (listener.value as? ThemeableProtocol)?.setThemeColors()
        }
    }
}
