//
//  GlobalShortcutHandlerHelper.swift
//  WebexTeams
//
//  Created by Archie on 5/18/21.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Foundation
import CommonHead

protocol GlobalShortcutHandlerHelperProtocol {
    func registerHandler(_ handler: NSObject & GlobalShortcutHandler)
    func unRegisterHandler(_ handler: NSObject & GlobalShortcutHandler)
    func setup(callControllManager: CallControllerManager)
}

enum GlobalShortcutHandlerActionType {
    case openShareSelectionWindow
    case stopShare
    case pauseOrResumeShare
    case startRDC
    case stopRDC
    case makeLocalShareControlBarKeyWindow
}

enum GlobalShortcutHandlerPriority: Int {
    case invlaid = -1 //If hanler return invalid, will be removed
    case l0 = 0
    case l1 = 1
    case l2 = 2
    case l3 = 3
    case l4 = 4
    case l5 = 5
    case l6 = 6
    
    static func <(left: GlobalShortcutHandlerPriority, right:GlobalShortcutHandlerPriority) ->Bool {
        left.rawValue < right.rawValue
    }
    
    static func >(left: GlobalShortcutHandlerPriority, right:GlobalShortcutHandlerPriority) ->Bool {
        return !(left < right)
    }
}

protocol GlobalShortcutHandler: AnyObject {
    var id: String { get }
    var priority: GlobalShortcutHandlerPriority { get }
    func validateAction(actionType: GlobalShortcutHandlerActionType) -> Bool
    func globalShortcutOpenShareSelectionWindow()
    func globalShortcutStopShare()
    func globalShortcutPauseOrResumeShare()
    func globalShortcutStartRDC()
    func globalShortcutStopRDC()
    func globalShortcutMakeLocalShareControlBarKeyWindow()
}

extension GlobalShortcutHandler {
    func globalShortcutOpenShareSelectionWindow() {}
    func globalShortcutStopShare() {}
    func globalShortcutPauseOrResumeShare() {}
    func globalShortcutStartRDC() {}
    func globalShortcutStopRDC() {}
    func globalShortcutMakeLocalShareControlBarKeyWindow() {}
}

class GlobalShortcutHandlerHelper: NSObject, GlobalShortcutHandlerHelperProtocol {
    private var handlers = [Weak<NSObject>]()
    private var globalShortcutHandler: GlobalShortcutHanderProtocol
    private weak var shareTelemetryManager: CHShareTelemetryManagerProtocol?
    
    private var onceFlag = true
    
    init(globalShortcutHandler : GlobalShortcutHanderProtocol) {
        self.globalShortcutHandler = globalShortcutHandler
        super.init()
    }
    
    deinit {
        unregisterGlobalShortCut()
    }
    
    func setup(callControllManager: CallControllerManager) {
        shareTelemetryManager = callControllManager.shareManager.telemetryManager
    }
    
    func registerHandler(_ handler: NSObject & GlobalShortcutHandler) {
        SPARK_LOG_DEBUG("[register] handler:\(handler.className)")
        let weakHandler = Weak<NSObject>(value: handler)
        handlers.append(weakHandler)
        
        if onceFlag {
            onceFlag = false
            registerGlobalShortCut()
        }
    }
    
    func unRegisterHandler(_ handler: NSObject & GlobalShortcutHandler) {
        SPARK_LOG_DEBUG("[unRegister] handler:\(handler.className)")
        handlers.removeAll{ $0.value === handler }
    }
    
    private func findHandler(actionType: GlobalShortcutHandlerActionType) -> (NSObject & GlobalShortcutHandler)? {
        handlers.removeAll {
            let priority = ($0.value as? GlobalShortcutHandler)?.priority
            return priority == nil || priority == .invlaid
        }
        
        let handlerList: [NSObject & GlobalShortcutHandler] = handlers.compactMap { weakHandler in
            if let handler = weakHandler.value as? NSObject & GlobalShortcutHandler, handler.validateAction(actionType: actionType) {
                return handler
            }
            return nil
        }
        
        guard !handlerList.isEmpty else {
            SPARK_LOG_DEBUG("[find] handler: NOT FOUND")
            return nil
            
        }
        
        var resultList = [handlerList[0]]
        
        for handler in handlerList {
            SPARK_LOG_DEBUG("[find] handler:\(handler.className) id: \(handler.id) priority:\(handler.priority)")
            if resultList[0].priority < handler.priority {
                resultList.removeAll()
                resultList.append(handler)
            } else if resultList[0].priority == handler.priority {
                resultList.append(handler)
            }
        }
        
        if let result = resultList.last {
            if resultList.contains(where: { $0.id != result.id }) {
                SPARK_LOG_DEBUG("[find] handler: handlers in different id have same priority, return NOT FOUND")
                return nil
            } else {
                SPARK_LOG_DEBUG("[find] handler:FOUNDED \(result.className)")
                return result
            }
        } else {
            sparkAssert(false, "empty resultList")
            return nil
        }
    }
    
    @objc private func onShortcutOpenShareSelectionWindow(_ sender: NSEvent) {
        SPARK_LOG_DEBUG("onShortcutOpenShareSelectionWindow")
        if let handler = findHandler(actionType: .openShareSelectionWindow) {
            handler.globalShortcutOpenShareSelectionWindow()
            recordTelemetry(callId: handler.id, shortcut: .openShareContentWindow)
        }
    }
    
    @objc private func onShortcutStopShare(_ sender: NSEvent) {
        SPARK_LOG_DEBUG("onShortcutStopShare")
        if let handler = findHandler(actionType: .stopShare) {
            handler.globalShortcutStopShare()
            recordTelemetry(callId: handler.id, shortcut: .stopSharing)
        }
    }
    
    @objc private func onShortcutPauseOrResumeShare(_ sender: NSEvent) {
        SPARK_LOG_DEBUG("onShortcutPauseOrResumeShare")
        if let handler = findHandler(actionType: .pauseOrResumeShare) {
            handler.globalShortcutPauseOrResumeShare()
            recordTelemetry(callId: handler.id, shortcut: .pauseResumeShare)
        }
    }
    
    @objc private func onShortcutStartRDC(_ sender: NSEvent) {
        SPARK_LOG_DEBUG("onShortcutStartRDC")
        if let handler = findHandler(actionType: .startRDC) {
            handler.globalShortcutStartRDC()
            recordTelemetry(callId: handler.id, shortcut: .startRemoteControl)
        }
    }
    
    @objc private func onShortcutStopRDC(_ sender: NSEvent) {
        SPARK_LOG_DEBUG("onShortcutStopRDC")
        if let handler = findHandler(actionType: .stopRDC) {
            handler.globalShortcutStopRDC()
            recordTelemetry(callId: handler.id, shortcut: .stopRemoteControl)
        }
    }
    
    @objc private func onShortcutMakeLocalShareControlBarKeyWindow(_ sender: NSEvent) {
        SPARK_LOG_DEBUG("onShortcutMakeLocalShareControlBarKeyWindow")
        if let handler = findHandler(actionType: .makeLocalShareControlBarKeyWindow) {
            handler.globalShortcutMakeLocalShareControlBarKeyWindow()
        }
    }
    
    private func recordTelemetry(callId: String, shortcut: CHShortcut) {
        shareTelemetryManager?.recordShortcutKeyPressed(callId: callId, shortcut: shortcut)
    }
    
    private func registerGlobalShortCut() {
        globalShortcutHandler.registerOpenShareSelectionWindowHotKey(self, selectorName: "onShortcutOpenShareSelectionWindow:")
        globalShortcutHandler.registerStopShareHotKey(self, selectorName: "onShortcutStopShare:")
        globalShortcutHandler.registerrPauseOrResumeShareHotKey(self, selectorName: "onShortcutPauseOrResumeShare:")
        globalShortcutHandler.registerrStartRDCHotKey(self, selectorName: "onShortcutStartRDC:")
        globalShortcutHandler.registerrStopRDCHotKey(self, selectorName: "onShortcutStopRDC:")
        globalShortcutHandler.registerMakeLocalShareControlBarKeyWindowHotKey(self, selectorName: "onShortcutMakeLocalShareControlBarKeyWindow:")
    }
    
    private func unregisterGlobalShortCut() {
        globalShortcutHandler.unregisterOpenShareSelectionWindowHotKey()
        globalShortcutHandler.unregisterStopShareHotKey()
        globalShortcutHandler.unregisterPauseOrResumeShareHotKey()
        globalShortcutHandler.unregisterStartRDCHotKey()
        globalShortcutHandler.unregisterStopRDCHotKey()
        globalShortcutHandler.unregisterMakeLocalShareControlBarKeyWindowHotKey()
    }
}
