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
            return LocalShareControlHorizontalBarViewController(shareFactory: appContext.shareFactory)
        case .vertical:
            return LocalShareControlVerticalBarViewController(shareFactory: appContext.shareFactory)
        }
    }
    
    func makeLocalShareControlButtonsViewController(orientation: Orientation) -> ILocalShareControlButtonsViewController {
        switch orientation {
        case .horizontal:
            return LocalShareControlButtonsHorizontalViewController()
        case .vertical:
            return LocalShareControlButtonsVerticalViewController()
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
        LocalShareControlBarWindowController(shareFactory: appContext.shareFactory, screenAdapter: appContext.screenAdapter)
    }
    
    //MARK: ShareManagerFactory
    func makeTimer() -> SparkTimerProtocol {
        SparkTimer()
    }
    
    func makeLocalShareControlBarManager() -> LocalShareControlBarManagerProtocol {
        LocalShareControlBarManager(shareFactory: self)
    }
}
