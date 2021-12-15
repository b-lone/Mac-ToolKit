//
//  ShareFactory.swift
//  WebexTeams
//
//  Created by Archie You on 2021/9/2.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Foundation

typealias ShareFactoryProtocol = ShareViewFactory & ShareWindowFactory & ShareManagerFactory

protocol ShareViewFactory {
    func makeShareSelectionFteViewController() -> IShareSelectionFteViewController
    func makeLocalShareControlBarViewController(orientation: Orientation) -> ILocalShareControlBarViewController
    func makeLocalShareControlButtonsViewController(orientation: Orientation) -> ILocalShareControlButtonsViewController
    func makeLocalShareVideoViewController(callId: String) -> ILocalShareVideoViewController
    func makeImmersiveShareLocalVideoViewController(callId: String) -> IImmersiveShareLocalVideoViewController
}

protocol ShareWindowFactory {
    func makeMagicDrawingBoardWindowController(screen: SparkScreen, level: MagicDrawingBoardWindowController.Level) -> IMagicDrawingBoardWindowController
    func makeShareIosScreenWindowController() -> IShareIosScreenWindowController
    func makeShareIosScreenPromptWindowController() -> IShareIosScreenPromptWindowController
    func makeLocalShareControlBarWindowController() -> ILocalShareControlBarWindowController
    func makeImmersiveShareFlaotingVideoWindowController() -> IImmersiveShareFlaotingVideoWindowController
}

protocol ShareManagerFactory {
    func makeTimer() -> SparkTimerProtocol
    func makeLocalShareControlBarManager() -> LocalShareControlBarManagerProtocol
    func makeRemoteControleeManager(callId: String) -> RDCControleeHelperProtocol
    func makeFullScreenDetector() -> FullScreenDetectorProtocol
    func makeImmersiveShareManager() -> ImmersiveShareManagerProtocol
}

class ShareFactory: NSObject, ShareFactoryProtocol {
    let weakAppContext =  WeakWillBeSet<AppContext>()
    private var appContext: AppContext { weakAppContext.value }
    
    //MARK: ShareViewFactory
    func makeShareSelectionFteViewController()  -> IShareSelectionFteViewController {
        ShareSelectionFteViewController(appContext: appContext)
    }
    
    func makeLocalShareControlBarViewController(orientation: Orientation) -> ILocalShareControlBarViewController {
        switch orientation {
        case .horizontal:
            return LocalShareControlHorizontalBarViewController(shareFactory: self)
        case .vertical:
            return LocalShareControlVerticalBarViewController(shareFactory: self)
        }
    }
    
    func makeLocalShareControlButtonsViewController(orientation: Orientation) -> ILocalShareControlButtonsViewController {
        switch orientation {
        case .horizontal:
            return LocalShareControlButtonsHorizontalViewController(shareFactory: self, mainMenuHandlerHelper: appContext.mainMenuHandlerHelper, globalShortcutHanderHelper: appContext.globalShortcutHanderHelper)
        case .vertical:
            return LocalShareControlButtonsVerticalViewController(shareFactory: self, mainMenuHandlerHelper: appContext.mainMenuHandlerHelper, globalShortcutHanderHelper: appContext.globalShortcutHanderHelper)
        }
    }
    
    func makeLocalShareVideoViewController(callId: String) -> ILocalShareVideoViewController {
        LocalShareVideoViewController(appContext: appContext, callId: callId)
    }
    
    func makeImmersiveShareLocalVideoViewController(callId: String) -> IImmersiveShareLocalVideoViewController {
        ImmersiveShareLocalVideoViewController(appContext: appContext, callId: callId)
    }
    
    //MARK: ShareWindowFactory
    func makeMagicDrawingBoardWindowController(screen: SparkScreen, level: MagicDrawingBoardWindowController.Level) -> IMagicDrawingBoardWindowController {
        MagicDrawingBoardWindowController(screen: screen, level: level)
    }
    
    func makeShareIosScreenWindowController() -> IShareIosScreenWindowController {
        ShareIosScreenWindowController()
    }
    
    func makeShareIosScreenPromptWindowController() -> IShareIosScreenPromptWindowController {
        ShareIosScreenPromptWindowController(appContext: appContext)
    }
    
    func makeLocalShareControlBarWindowController() -> ILocalShareControlBarWindowController {
        LocalShareControlBarWindowController(shareFactory: self, screenAdapter: appContext.screenAdapter, telemetryManager: appContext.callControlerManager?.shareManager.telemetryManager ?? appContext.commonHeadFrameworkAdapter.makeShareTelemetryManager())
    }
    
    func makeImmersiveShareFlaotingVideoWindowController() -> IImmersiveShareFlaotingVideoWindowController {
        ImmersiveShareFlaotingVideoWindowController(appContext: appContext)
    }
    
    //MARK: ShareManagerFactory
    func makeTimer() -> SparkTimerProtocol {
        SparkTimer()
    }
    
    func makeLocalShareControlBarManager() -> LocalShareControlBarManagerProtocol {
        LocalShareControlBarManager(shareFactory: self)
    }
    
    func makeRemoteControleeManager(callId: String) -> RDCControleeHelperProtocol {
        RDCControleeHelper(appContext: appContext, callId: callId)
    }
    
    func makeFullScreenDetector() -> FullScreenDetectorProtocol {
        FullScreenDetector()
    }
    
    func makeImmersiveShareManager() -> ImmersiveShareManagerProtocol {
        ImmersiveShareManager(shareFactory: appContext.shareFactory)
    }
}
