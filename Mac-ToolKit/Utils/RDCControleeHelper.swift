//
//  RDCControleeHelper.swift
//  Mac-ToolKit
//
//  Created by Archie You on 2021/11/16.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa
import CommonHead

protocol RemoteControleeManagerDelegate: AnyObject {
    func updateRemoteControlButton(info: RemoteControlButtonInfo)
    func ignoresMouseEventsInSomeWindows(isIgnores : Bool)
}

protocol RDCControleeHelperProtocol : AnyObject {
    func canStartAnnotateWhenRDCisSessionEstablished()-> Bool
    func closeGiveRemoteControlPopOver()
    func closeRemoteControlHintWindowController()
    func registerCallViewModelDelegate()
    func unRegisterCallViewModelDelegate()
    func showGiveControlPopover(sender: NSButton, preferredEdge: NSRectEdge)
    var isSessionEstablished : Bool { get }
    func registerListener(_ listener: RemoteControleeManagerDelegate & NSObject)
    func unregisterListener(_ listener: RemoteControleeManagerDelegate & NSObject)
    var remoteControlButtonInfo: RemoteControlButtonInfo? { get }
    func endRemoteControlSession()
}

struct ButtonInfo {
    var isHidden: Bool = true
    var isEnabled: Bool = false
    var tooltip: String = ""
    var buttonState: CHButtonState = .none
    var text: String = ""
    
    init() {}
    
    init(_ info: CHButton) {
        isHidden = info.isHidden
        isEnabled = info.isEnabled
        tooltip = info.tooltip
        buttonState = info.buttonState
        text = info.text
    }
}

typealias RemoteControlButtonInfo = (type: ShareControlButtonType, buttonInfo: ButtonInfo)

class RDCControleeHelper: NSObject, RDCControleeHelperProtocol {
    
    
    let appContext: AppContext
    
    private let callId : String
    
    
    var isSessionEstablished : Bool = false
    private var isSharingControlBarDraggableEnabled: Bool { appContext.coreFramework.sparkFeatureFlagsProxy.isSharingControlBarDraggableEnabled() }
    private var listenerList = [Weak<NSObject>]()
    
    init(appContext: AppContext, callId : String) {
        self.appContext = appContext
        self.callId = callId
        super.init()
    }
    
    deinit {
        fireIgnoresMouseEventsInSomeWindows(isIgnores: false)
        unRegisterCallViewModelDelegate()
    }
    
    func closeGiveRemoteControlPopOver() {}
    func closeRemoteControlHintWindowController() {}
    
    func registerListener(_ listener: NSObject & RemoteControleeManagerDelegate) {
        guard !listenerList.contains(where: { $0.value === listener }) else { return }
        SPARK_LOG_DEBUG("listener:\(listener.className)")
        let weakListener = Weak<NSObject>(value: listener)
        listenerList.append(weakListener)
    }
    
    func unregisterListener(_ listener: NSObject & RemoteControleeManagerDelegate) {
        SPARK_LOG_DEBUG("listener:\(listener.className)")
        listenerList.removeAll { $0.value === listener || $0.value == nil }
    }
        
    func canStartAnnotateWhenRDCisSessionEstablished()-> Bool {
        return true
    }
    
    func endRemoteControlSession(){
    }
    
    var remoteControlButtonInfo: RemoteControlButtonInfo?
    
    private func updateRemoteControlButton(buttonInfo: ButtonInfo) {
        SPARK_LOG_DEBUG("")
        let type = isSessionEstablished ? ShareControlButtonType.remoteControlStop : .remoteControlStart
        for weakListener in listenerList {
            if let listener = weakListener.value as? RemoteControleeManagerDelegate {
                listener.updateRemoteControlButton(info: (type: type, buttonInfo: buttonInfo))
            }
        }
    }
    
    private func updateRemoteControlButton() {
        guard let remoteControlButtonInfo = remoteControlButtonInfo else { return }
        for weakListener in listenerList {
            if let listener = weakListener.value as? RemoteControleeManagerDelegate {
                listener.updateRemoteControlButton(info: remoteControlButtonInfo)
            }
        }
    }
        
    
    private func fireIgnoresMouseEventsInSomeWindows(isIgnores: Bool) {
        for weakListener in listenerList {
            if let listener = weakListener.value as? RemoteControleeManagerDelegate {
                listener.ignoresMouseEventsInSomeWindows(isIgnores: isIgnores)
            }
        }
    }
    
    func registerCallViewModelDelegate() {
    }
    
    func unRegisterCallViewModelDelegate() {
    }
}

extension RDCControleeHelper {
    func showGiveControlPopover(sender: NSButton, preferredEdge: NSRectEdge) {
    }
}

