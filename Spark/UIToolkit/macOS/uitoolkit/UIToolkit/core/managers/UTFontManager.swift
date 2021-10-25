//
//  FontProtocolManager.swift
//  UIToolkit
//
//  Created by James Nestor on 28/06/2021.
//

import Cocoa

public protocol FontProtocol: AnyObject {
    func updateFont()
}

public class UTFontManager : UTBaseManager {
    
    //MARK: - Public API
    @discardableResult
    public func subscribe(listener: FontProtocol) -> Bool{
        return _subscribe(listener: listener)
    }
    
    @discardableResult
    public func unsubscribe(listener: FontProtocol) -> Bool {
        return _unsubscribe(listener: listener)
    }
    
    public func notifyListenersOnFontUpdated() {
        super.notifyListenersOnUpdate()
        
        for listener in listeners{
            (listener.value as? FontProtocol)?.updateFont()
        }
    }
    
    public var scaleFactor:CGFloat = 1
}
