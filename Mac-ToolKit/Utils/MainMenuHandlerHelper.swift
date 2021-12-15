//
//  MainMenuHandlerHelper.swift
//  WebexTeams
//
//  Created by Archie on 5/18/21.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Foundation

protocol MainMenuHandlerHelperProtocol: StartAnnotationMainMenuHandler, StopAnnotationMainMenuHandler {
    func registerHandler(callId: String, handler: NSObject & MainMenuHandler)
    func unRegisterHandler(handler: NSObject & MainMenuHandler)
}

protocol MainMenuHandler: AnyObject {}

protocol StartAnnotationMainMenuHandler: MainMenuHandler {
    func canStartAnnotation(callId: String) -> Bool
    func mainMenuStartAnnotation(callId: String)
}

protocol StopAnnotationMainMenuHandler: MainMenuHandler {
    func canStopAnnotation(callId: String) -> Bool
    func mainMenuStopAnnotation(callId: String)
}

class MainMenuHandlerHelper: NSObject, MainMenuHandlerHelperProtocol {
    private var handlers = [(String, Weak<NSObject>)]()
    func registerHandler(callId: String, handler: NSObject & MainMenuHandler) {
        SPARK_LOG_DEBUG("[register] callId:\(callId) handler:\(handler.className)")
        let weakHandler = Weak<NSObject>(value: handler)
        handlers.append((callId, weakHandler))
    }
    
    func unRegisterHandler(handler: NSObject & MainMenuHandler) {
        SPARK_LOG_DEBUG("[unRegister] handler:\(handler.className)")
        handlers.removeAll{ $0.1.value === handler }
    }
    
    private func findHandler<T>(callId: String, where predicate: (T) -> Bool) -> T? {
        for (handlerCallId, weakHandler) in handlers {
            if handlerCallId == callId, let handler = weakHandler.value as? T, predicate(handler) {
                return handler
            }
        }
        return nil
    }
    
    func canStartAnnotation(callId: String) -> Bool {
        return findHandler(callId: callId, where: {(handler: StartAnnotationMainMenuHandler) -> Bool in handler.canStartAnnotation(callId: callId)}) != nil
    }
    
    func mainMenuStartAnnotation(callId: String) {
        let handler = findHandler(callId: callId){(handler: StartAnnotationMainMenuHandler) -> Bool in handler.canStartAnnotation(callId: callId)}
        if let handler = handler {
            SPARK_LOG_DEBUG("handler: \((handler as! NSObject).className)")
            handler.mainMenuStartAnnotation(callId: callId)
        }
    }
    
    func canStopAnnotation(callId: String) -> Bool {
        return findHandler(callId: callId, where: {(handler: StopAnnotationMainMenuHandler) -> Bool in handler.canStopAnnotation(callId: callId)}) != nil
    }
    
    func mainMenuStopAnnotation(callId: String) {
        let handler = findHandler(callId: callId){(handler: StopAnnotationMainMenuHandler) -> Bool in handler.canStopAnnotation(callId: callId)}
        if let handler = handler {
            SPARK_LOG_DEBUG("handler: \((handler as! NSObject).className)")
            handler.mainMenuStopAnnotation(callId: callId)
        }
    }
    
}
