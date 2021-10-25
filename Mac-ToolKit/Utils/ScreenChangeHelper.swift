//
//  ScreenHelper.swift
//  WebexTeams
//
//  Created by Archie You on 2021/8/26.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa

protocol ScreenChangeHelperObserver: AnyObject {
    func onScreenFrameChanged(screenId: ScreenId)
    func onScreenConnect(screenId: ScreenId)
    func onScreenDisconnect(screenId: ScreenId)
}

class ScreenChangeHelper: Subject<ScreenChangeHelperObserver> {
    private var screenMap = [ScreenId: SparkScreen]()
    private let screenAdapter: SparkScreenAdapterProtocol
    
    init(screenAdapter: SparkScreenAdapterProtocol) {
        self.screenAdapter = screenAdapter
        super.init()
        
        updateScreenMap()
        NotificationCenter.default.addObserver(self, selector: #selector(onChangeScreenParametersNotification), name: NSApplication.didChangeScreenParametersNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func updateScreenMap() {
        screenAdapter.screens.forEach {
            if let uuid = $0.uuid() {
                screenMap[uuid] = $0
            }
        }
    }
    
    @objc private func onChangeScreenParametersNotification() {
        var currentScreenMap = [String: SparkScreen]()
        screenAdapter.screens.forEach {
            if let uuid = $0.uuid() {
                currentScreenMap[uuid] = $0
            }
        }
        
        for (id, screen) in screenMap {
            if let currentScreen = currentScreenMap[id] {
                if screen.frame != currentScreen.frame {
                    observerList.forEach{ $0.onScreenFrameChanged(screenId: id) }
                }
                currentScreenMap[id] = nil
            } else {
                observerList.forEach{ $0.onScreenDisconnect(screenId: id) }
            }
        }
        
        for id in currentScreenMap.keys {
            observerList.forEach{ $0.onScreenConnect(screenId: id) }
        }
    }

}
