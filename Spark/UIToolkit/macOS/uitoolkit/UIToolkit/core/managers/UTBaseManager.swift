//
//  UTBaseManager.swift
//  UIToolkit
//
//  Created by James Nestor on 05/07/2021.
//

import Cocoa

public class UTBaseManager {
    internal var listeners:[WeakWrapper] = []
    
    //MARK: - Public API
    @discardableResult
    internal func _subscribe(listener: AnyObject) -> Bool{
        
        removeNilProtocols()
        
        if listeners.contains(where: {$0.value === listener}){
            return false
        }
        
        let weakListener = WeakWrapper(value: listener)
        listeners.append(weakListener)
        
        return true
    }
    
    @discardableResult
    internal func _unsubscribe(listener: AnyObject) -> Bool {
        if let firstIndex = listeners.firstIndex(where: { $0.value === listener } ){
            listeners.remove(at: firstIndex)
            return true
        }
        
        return false
    }
    
    public func notifyListenersOnUpdate() {
        removeNilProtocols()
    }
    
    //MARK: - Private API
    private func removeNilProtocols(){
        listeners = listeners.filter({$0.value != nil})
    }
}
