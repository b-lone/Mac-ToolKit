//
//  ShareModel.swift
//  SparkMacDesktop
//
//  Created by James Nestor on 11/08/2017.
//  Copyright © 2017 Cisco Systems. All rights reserved.
//

import Cocoa
//import CommonHead

class ShareModel: NSObject {
    var id: String
    var name: String
    var sourceType: CHSourceType
    var icon: NSImage?
    var image:NSImage?
    var windowIdList: [UInt32]
    var screen: NSScreen?
    
    var isSelected = false
    var canSelect = true
    
    init(id: String, name: String, sourceType: CHSourceType, icon:NSImage? = nil, windowIdList: [UInt32] = [], screen: NSScreen? = nil){
        self.id = id
        self.name = name
        self.sourceType = sourceType
        self.icon = icon
        self.windowIdList = windowIdList
        self.screen = screen
        super.init()
        isSelected = isSharing()
    }
    
    override var description:String{
        get{
            return "{id:\(id), name:\(name)}"
        }
    }

    func isSharing() -> Bool {
        return false
//        var wId:UInt32 = 0
//        if let w = windowIdList.first{
//            wId = w
//        }
//        return telephonyServiceProxy?.isSharingSource(forCallId: callId, winId: wId, sourceId: shareSourceId, share: sourceType) ?? false
        
    }
    
    func getImage(width:CGFloat, force: Bool = false, callback: @escaping (NSImage?, String?) -> Void){
//        if ProcessInfo.isRunningDevHarnessTests(){
//            return callback(nil, id)
//        }
        
        if !force, image != nil{
            return callback(image, id)
        }
        
        let getImageCallback: (NSImage?)->Void = { [weak self, width, callback] (img: NSImage?) in
            if let self = self {
                let image = img?.resizeImage(width)
                self.image = image
                callback(image, self.id)
            }
        }
        
        if sourceType == .desktop, let displayId = windowIdList.first {
            NSImage.getScreenshot(displayId: displayId, callback: getImageCallback)
        } else {
            if windowIdList.count == 0{
                image = icon
                icon = nil
                return callback(image, id)
            } else if windowIdList.count == 1, let wId = windowIdList.first {
                NSImage.getWindowImage(winId: wId, imageOptions: .boundsIgnoreFraming, callback: getImageCallback)
            }
            else if windowIdList.count > 1{
                NSImage.getMultiWindowsImage(windowIds: windowIdList, callback: getImageCallback)
            }
        }
    }
}

class ShareModelBuilder : NSObject{
    static func getDesktopWindowInfo() -> [ShareModel] {
        var screenInfoList:[ShareModel] = []
        
        SPARK_LOG_DEBUG("Screen count in NSScreen: \(NSScreen.screens.count)")
        for screen in NSScreen.screens{
            if let uuid = screen.uuid(){
                screenInfoList.append(ShareModel(id: uuid, name: screen.getScreenNumberName(), sourceType: .desktop, screen: screen))
            }
            else{
                SPARK_LOG_DEBUG("Unable to get uuid from screen with frame: \(screen.frame)")
            }
        }
        
        return screenInfoList
    }
    
    static func getIosScreenInfo() -> [ShareModel] {
        let iosShareModel = ShareModel(id: "iOS screen via cable", name: "iPhone or iPad screen", sourceType: .desktop)
        return [iosShareModel]
    }
    
    static func getRunningApplicationWindows(drawingManager: MagicDrawingBoardManagerProtocol) -> [ShareModel] {
        var windowInfoList: [ShareModel] = []
        var sparkWindowInfoList: [ShareModel] = []
        
        let lastActiveWindowInfoList = drawingManager.getWindowInfoList(exclude: true)
        var pidAppMap = [Int32:NSRunningApplication]()
        
        for app in NSWorkspace.shared.runningApplications {
            pidAppMap[app.processIdentifier] = app
        }
        
        for windowInfo in lastActiveWindowInfoList {
            let pid = Int32(windowInfo.pid) ?? 0
            let winId = UInt32(windowInfo.windowNumber)
            
            if let app = pidAppMap[pid] {
                let appInfo = ShareModel(id: windowInfo.pid, name: windowInfo.name.isEmpty ? windowInfo.pName : windowInfo.name, sourceType: .window, icon: app.icon, windowIdList: [winId])
                
                if Bundle.getSparkBundle()?.bundleIdentifier == app.bundleIdentifier {
                    sparkWindowInfoList.append(appInfo)
                } else {
                    windowInfoList.append(appInfo)
                }
            }
        }
            
        windowInfoList += sparkWindowInfoList
        
        return windowInfoList
    }
    
    static func getRunningApplicationsSync() -> [ShareModel] {
        var shareModel:[ShareModel] = []
        var sparkShareModel:[ShareModel] = []
    
        let processWindowMap = Process.getProcessWindowList()
        let runningApplications = NSWorkspace.shared.runningApplications
        let sortedProcesses = Process.getProcessListByLastActive()

        for p in sortedProcesses {
            for app in runningApplications {
                let pid = Int32(app.processIdentifier)
                if pid == p {
                    if app.activationPolicy == .regular && app.bundleIdentifier != "com.apple.finder" {
                        let windowList = processWindowMap[pid] ?? []
                        
                        let appInfo = ShareModel(id: String(pid), name: app.localizedName ?? "", sourceType: .application, icon: app.icon, windowIdList: windowList)
                        
                        
                        if Bundle.getSparkBundle()?.bundleIdentifier == app.bundleIdentifier {
                            sparkShareModel.append(appInfo)
                        } else {
                            shareModel.append(appInfo)
                        }
                    }
                    break
                }
            }
        }
        
        shareModel += sparkShareModel
        return shareModel
    }
    
    static func getRunningApplicationsAsync(telephonyServiceProxy:TelephonyServiceProxy, callId:String, callback: @escaping ([ShareModel]) -> Void) {
        telephonyServiceProxy.getShareSources(.application, callback: {(shareSources : NSMutableArray?) in
            guard let theShareSources = shareSources as? [ShareSourceVM] else { return }
            var shareModelList = getRunningApplicationsSync()
            shareModelList.removeAll { shareModel in
                !theShareSources.contains { $0.sourceId == shareModel.id }
            }
            callback(shareModelList)
        })
    }
}


