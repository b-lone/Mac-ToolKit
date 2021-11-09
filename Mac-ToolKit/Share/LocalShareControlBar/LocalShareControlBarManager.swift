//
//  LocalShareControlBarManager.swift
//  WebexTeams
//
//  Created by Archie You on 2021/10/12.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa

protocol LocalShareControlBarManagerProtocol: ShareManagerComponentSetup {
    func showShareControlBar()
    func hideShareControlBar()
}

class LocalShareControlBarManager: NSObject & LocalShareControlBarManagerProtocol {
    private weak var shareComponent: ShareManagerComponentProtocol?
    private let shareFactory: ShareFactoryProtocol
    
    private var shareControlBar: ILocalShareControlBarWindowController?
    
    init(shareFactory: ShareFactoryProtocol) {
        self.shareFactory = shareFactory
        super.init()
    }
    
    private func makeShareControlBar() -> ILocalShareControlBarWindowController {
        let windowController = shareFactory.makeLocalShareControlBarWindowController()
        if let shareComponent = shareComponent {
            windowController.setup(shareComponent: shareComponent)
        }
        return windowController
    }
    
    //MARK: ShareManagerComponentSetup
    func setup(shareComponent: ShareManagerComponentProtocol) {
        self.shareComponent = shareComponent
        shareControlBar?.setup(shareComponent: shareComponent)
    }
    
    //MARK: LocalShareControlBarManagerProtocol
    func showShareControlBar() {
        if shareControlBar == nil {
            shareControlBar = makeShareControlBar()
        }
        shareControlBar?.showWindow(self)
    }
    
    func hideShareControlBar() {
        shareControlBar?.close()
    }
}
