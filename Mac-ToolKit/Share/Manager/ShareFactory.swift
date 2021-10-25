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
//    func makeShareSelectionFteViewController() -> IShareSelectionFteViewController
    func makeLocalShareControlHorizontalBarViewController() -> ILocalShareControlHorizontalBarViewController
    func makeLocalShareControlVerticalBarViewController() -> ILocalShareControlVerticalBarViewController
    func makeLocalShareControlButtonsHorizontalViewController() -> ILocalShareControlButtonsHorizontalViewController
    func makeLocalShareControlButtonsVerticalViewContrller() -> ILocalShareControlButtonsVerticalViewContrller
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

class ShareFactory: NSObject {
    let weakAppContext =  WeakWillBeSet<AppContext>()
    private var appContext: AppContext { weakAppContext.value }
}

extension ShareFactory: ShareViewFactory {
//    func makeShareSelectionFteViewController()  -> IShareSelectionFteViewController {
//        ShareSelectionFteViewController(appContext: appContext)
//    }
    
    func makeLocalShareControlHorizontalBarViewController() -> ILocalShareControlHorizontalBarViewController {
        LocalShareControlHorizontalBarViewController(shareFactory: appContext.shareFactory)
    }
    func makeLocalShareControlVerticalBarViewController() -> ILocalShareControlVerticalBarViewController {
        LocalShareControlVerticalBarViewController(shareFactory: appContext.shareFactory)
    }
    func makeLocalShareControlButtonsHorizontalViewController() -> ILocalShareControlButtonsHorizontalViewController {
        LocalShareControlButtonsHorizontalViewController()
    }
    func makeLocalShareControlButtonsVerticalViewContrller() -> ILocalShareControlButtonsVerticalViewContrller {
        LocalShareControlButtonsVerticalViewContrller()
    }
}

extension ShareFactory: ShareWindowFactory {
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
        LocalShareControlBarWindowController(appContext: appContext)
    }
}

extension ShareFactory: ShareManagerFactory {
    func makeTimer() -> SparkTimerProtocol {
        SparkTimer()
    }
    
    func makeLocalShareControlBarManager() -> LocalShareControlBarManagerProtocol {
        LocalShareControlBarManager(shareFactory: self)
    }
}
