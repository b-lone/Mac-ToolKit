//
//  LocalShareControlBarManager.swift
//  WebexTeams
//
//  Created by Archie You on 2021/10/12.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa

protocol LocalShareControlBarManagerProtocol: AnyObject {
    func setup(shareComponent: ShareManagerComponentProtocol)
    func showShareControlBar()
    func hideShareControlBar()
}

class LocalShareControlBarManager: NSObject {
    private weak var shareComponent: ShareManagerComponentProtocol?
    private var shareFactory: ShareFactoryProtocol
    
    private lazy var shareControlBar = shareFactory.makeLocalShareControlBarWindowController()
    
    init(shareFactory: ShareFactoryProtocol) {
        self.shareFactory = shareFactory
        super.init()
    }
    
    deinit {
        shareComponent?.unregisterListener(self)
    }
}

extension LocalShareControlBarManager: LocalShareControlBarManagerProtocol {
    func setup(shareComponent: ShareManagerComponentProtocol) {
        self.shareComponent?.unregisterListener(self)
        self.shareComponent = shareComponent
        shareComponent.registerListener(self)
        self.shareControlBar.setup(shareComponent: shareComponent)
    }
    
    func showShareControlBar() {
        shareControlBar.showWindow(self)
    }
    
    func hideShareControlBar() {
        shareControlBar.close()
    }
}

extension LocalShareControlBarManager: ShareManagerComponentListener {
}
