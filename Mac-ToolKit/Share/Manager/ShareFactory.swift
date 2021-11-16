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
}

protocol ShareWindowFactory {
    func makeMagicDrawingBoardWindowController(screen: SparkScreen, level: MagicDrawingBoardWindowController.Level) -> IMagicDrawingBoardWindowController
    func makeShareIosScreenWindowController() -> IShareIosScreenWindowController
    func makeShareIosScreenPromptWindowController() -> IShareIosScreenPromptWindowController
    func makeLocalShareControlBarWindowController() -> ILocalShareControlBarWindowController
}

protocol ShareManagerFactory {
    func makeTimer() -> SparkTimerProtocol
    func makeLocalShareControlBarManager() -> LocalShareControlBarManagerProtocol
    func makeRemoteControleeManager(callId: String) -> RDCControleeHelperProtocol
    func makeFullScreenDetector() -> FullScreenDetectorProtocol
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
            return LocalShareControlButtonsHorizontalViewController(shareFactory: self)
        case .vertical:
            return LocalShareControlButtonsVerticalViewController(shareFactory: self)
        }
    }
    
    func makeLocalShareVideoViewController(callId: String) -> ILocalShareVideoViewController {
        LocalShareVideoViewController(appContext: appContext, callId: callId)
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
        LocalShareControlBarWindowController(shareFactory: self, screenAdapter: appContext.screenAdapter)
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
}
