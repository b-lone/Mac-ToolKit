//
//  ScreenHelper.swift
//  WebexTeams
//
//  Created by Archie You on 2021/8/26.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa

class ScreenChangeHelper: NSObject {
    static let screenFrameChangedFromScreenHelper = NSNotification.Name("screenFrameChangedFromScreenHelper")
    static let screenCountChangedFromScreenHelper = NSNotification.Name("screenCountChangedFromScreenHelper")
    static let userInfoKeyAddedScreen = "userInfoKeyAddedScreen"
    static let userInfoKeyRemovedScreen = "userInfoKeyRemovedScreen"
    static let userInfoKeyUpdatedScreen = "userInfoKeyUpdatedScreen"
    
    private var screenFrameMap = [String: NSRect]()
    override init() {
        super.init()
        
        updateScreenFrameMap()
        NotificationCenter.default.addObserver(self, selector: #selector(onChangeScreenParametersNotification), name: NSApplication.didChangeScreenParametersNotification, object: nil)
    }
    
    private func updateScreenFrameMap() {
        NSScreen.screens.forEach {
            if let uuid = $0.uuid() {
                screenFrameMap[uuid] = $0.frame
            }
        }
    }
    
    @objc private func onChangeScreenParametersNotification() {
        var screenMap = [String: NSScreen]()
        NSScreen.screens.forEach {
            if let uuid = $0.uuid() {
                screenMap[uuid] = $0
            }
        }
        
        var addedScreen = [NSScreen]()
        var removedScreen = Array(screenFrameMap.keys)
        var updatedScreen = [NSScreen]()
        
        for (uuid, screen) in screenMap {
            if let frame = screenFrameMap[uuid] {
                removedScreen.removeAll{ $0 == uuid }
                if screen.frame != frame {
                    updatedScreen.append(screen)
                }
            } else {
                addedScreen.append(screen)
            }
        }
        
        updateScreenFrameMap()
        
        if !addedScreen.isEmpty || !removedScreen.isEmpty {
            let userInfo:[String: Any] = [ScreenChangeHelper.userInfoKeyAddedScreen: addedScreen,
                            ScreenChangeHelper.userInfoKeyRemovedScreen: removedScreen]
            NotificationCenter.default.post(name: ScreenChangeHelper.screenCountChangedFromScreenHelper, object: self, userInfo: userInfo)
        }
        
        if !updatedScreen.isEmpty {
            let userInfo:[String: Any] = [ScreenChangeHelper.userInfoKeyUpdatedScreen: updatedScreen]
            NotificationCenter.default.post(name: ScreenChangeHelper.screenFrameChangedFromScreenHelper, object: self, userInfo: userInfo)
        }
    }

}
