//
//  AppContext.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/7/11.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class AppContext: NSObject {
    static let shared = AppContext()
    
    let coreFramework = CoreFrameworkProxy()
    let commonHeadFrameworkAdapter = CommonHeadFrameworkAdapter()
    
    var globalShortcutHander: GlobalShortcutHanderProtocol = GlobalShortcutHander()
    lazy var globalShortcutHanderHelper: GlobalShortcutHandlerHelperProtocol = GlobalShortcutHandlerHelper(globalShortcutHandler: globalShortcutHander)
    
    let quartzWindowServicesAdapter: QuartzWindowServicesAdapterProtocol
    let screenAdapter: SparkScreenAdapterProtocol
    let shareFactory: ShareFactoryProtocol
    let drawingBoardManager: MagicDrawingBoardManagerProtocol
    var callControlerManager: CallControllerManager?
    
    override init() {
        quartzWindowServicesAdapter = QuartzWindowServicesAdapter()
        screenAdapter = SparkScreenAdapter()
        shareFactory = ShareFactory()
        drawingBoardManager = MagicDrawingBoardManager(factory: shareFactory, screenAdapter: screenAdapter, quartzWindowServicesAdapter: quartzWindowServicesAdapter)
        super.init()
        callControlerManager = CallControllerManager(appContext: self)
        (shareFactory as! ShareFactory).weakAppContext.value = self
    }
}
