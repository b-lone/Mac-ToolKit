//
//  ImmersiveShareManager.swift
//  WebexTeams
//
//  Created by Archie You on 2021/12/13.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa

protocol ImmersiveShareManagerProtocol: ShareManagerComponentSetup {
    func showFlaotingVideoWindow()
    func hideFlaotingVideoWindow()
    func reset()
}

class ImmersiveShareManager: NSObject & ImmersiveShareManagerProtocol {
    private weak var shareComponent: ShareManagerComponentProtocol?
    private let shareFactory: ShareFactoryProtocol
    private var floatingVideoWindowController: IImmersiveShareFlaotingVideoWindowController?
    
    init(shareFactory: ShareFactoryProtocol) {
        self.shareFactory = shareFactory
        super.init()
    }
    
    private func makeFloatingVideoWindowController() -> IImmersiveShareFlaotingVideoWindowController {
        let windowController = shareFactory.makeImmersiveShareFlaotingVideoWindowController()
        if let shareComponent = shareComponent {
            windowController.setup(shareComponent: shareComponent)
        }
        return windowController
    }
    
    //MARK: ShareManagerComponentSetup
    func setup(shareComponent: ShareManagerComponentProtocol) {
        self.shareComponent = shareComponent
        floatingVideoWindowController?.setup(shareComponent: shareComponent)
    }
    
    //MARK: LocalShareControlBarManagerProtocol
    func showFlaotingVideoWindow() {
        SPARK_LOG_DEBUG("")
        if floatingVideoWindowController == nil {
            floatingVideoWindowController = makeFloatingVideoWindowController()
        }
        floatingVideoWindowController?.showWindow(self)
        if let windowNumber = floatingVideoWindowController?.window?.windowNumber {
            NotificationCenter.default.post(name: Notification.Name(rawValue: OnShareShouldExcludeWindow), object: self, userInfo: ["windowNumber": windowNumber])
            NotificationCenter.default.post(name: Notification.Name(rawValue: OnDrawShouldExcludeWindow), object: self, userInfo: ["windowNumber": windowNumber])
        }
    }
    
    func hideFlaotingVideoWindow() {
        SPARK_LOG_DEBUG("")
        floatingVideoWindowController?.close()
    }
    
    func reset() {
        hideFlaotingVideoWindow()
        floatingVideoWindowController = nil
    }
}
