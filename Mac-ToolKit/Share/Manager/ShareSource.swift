//
//  ShareSource.swift
//  SparkMacDesktop
//
//  Created by Archie You on 26/08/2021.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa
import CommonHead
import UIToolkit

extension CHShareSource {
    class func make( shareSourceType: CHSourceType, sourceId: String, name: String, windowHandle: NSNumber = 0) -> CHShareSource {
        return CHShareSource(
            shareSourceType: shareSourceType,
            sourceId: sourceId,
            uniqueName: "",
            name: name,
            x: 0,
            y: 0,
            width: 0,
            height: 0,
            windowHandle: windowHandle)
    }
    
    class func make(windowInfo: MagicWindowInfo) -> CHShareSource {
        return make(shareSourceType: .window, sourceId: windowInfo.pid, name: windowInfo.fullName, windowHandle: NSNumber(value: windowInfo.windowNumber))
    }
}

extension CHShareType {
    var iconType: MomentumRebrandIconType? {
        switch self {
        case .iosViaCable:
            return .phoneBold
        default:
            return nil
        }
    }
}

class ShareSource: NSObject {
    var id: String
    var name: String
    var sourceType: CHSourceType
    var icon: NSImage?
    var image:NSImage?
    var windowIdList: [CGWindowID]
    var screen: NSScreen?
    var shareType: CHShareType
    
    var isSharing = false
    var isSelected = false
    var canSelect = true
    
    init(id: String, name: String, sourceType: CHSourceType, shareType: CHShareType, icon:NSImage? = nil, windowIdList: [CGWindowID] = [], screen: NSScreen? = nil){
        self.id = id
        self.name = name
        self.sourceType = sourceType
        self.icon = icon
        self.windowIdList = windowIdList
        self.screen = screen
        self.shareType = shareType
        super.init()
    }
    
    override var description: String { "{id:\(id), name:\(name)}" }
    
    func getImage(width:CGFloat, force: Bool = false, callback: @escaping (NSImage?, String?) -> Void){
        if ProcessInfo.isRunningDevHarnessTests(){
            return callback(nil, id)
        }        
        
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
        
        if sourceType == .desktop, let displayId = screen?.displayID()?.int32Value {
            NSImage.getScreenshot(displayId: UInt32(displayId), callback: getImageCallback)
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

protocol ShareSourceBuilderProtocol: AnyObject {
    func generateDesktopShareSources() -> [ShareSource]
    func generateAdvancedScreenShareSources() -> [ShareSource]
    func generateWindowShareSources(drawingManager: MagicDrawingBoardManagerProtocol) -> [ShareSource]
    func generateApplicationShareSourcesSync() -> [ShareSource]
//    func generateApplicationShareSourcesAsync(telephonyServiceProxy:TelephonyServiceProxy, callId:String, callback: @escaping ([ShareSource]) -> Void)
}

class ShareSourceBuilder : NSObject, ShareSourceBuilderProtocol {
    private weak var shareComponent: ShareManagerComponentProtocol?
    
    init(shareComponent: ShareManagerComponentProtocol?) {
        self.shareComponent = shareComponent
    }
    
    private func updateShareSourceSharingState(shareSourceList: inout [ShareSource]) {
        guard let shareComponent = shareComponent else { return }
        shareSourceList.forEach {
            $0.isSharing = shareComponent.shareContext.isSharing(source: $0)
            $0.isSelected = $0.isSharing
        }
    }
    
    func generateDesktopShareSources() -> [ShareSource] {
        var shareSourceList = [ShareSource]()
        
        SPARK_LOG_DEBUG("Screen count in NSScreen: \(NSScreen.screens.count)")
        for screen in NSScreen.screens{
            if let uuid = screen.uuid() {
                shareSourceList.append(ShareSource(id: uuid, name: screen.getScreenNumberName(), sourceType: .desktop, shareType: .desktop, screen: screen))
            } else {
                SPARK_LOG_DEBUG("Unable to get uuid from screen with frame: \(screen.frame)")
            }
        }
        
        updateShareSourceSharingState(shareSourceList: &shareSourceList)
        return shareSourceList
    }
    
    func generateAdvancedScreenShareSources() -> [ShareSource] {
        let iosShareSource = ShareSource(id: "\(ProcessInfo.processInfo.processIdentifier)", name: LocalizationStrings.iphoneOrIpad, sourceType: .desktop, shareType: .iosViaCable)
        var shareSourceList = [iosShareSource]
        updateShareSourceSharingState(shareSourceList: &shareSourceList)
        return shareSourceList
    }
    
    func generateWindowShareSources(drawingManager: MagicDrawingBoardManagerProtocol) -> [ShareSource] {
        var windowShareSourceList = [ShareSource]()
        var sparShareSourceList = [ShareSource]()
        
        let lastActiveWindowInfoList = drawingManager.getWindowInfoList(exclude: true, onScreenOnly: true)
        let runningApplications =  NSWorkspace.shared.runningApplications
        
        for windowInfo in lastActiveWindowInfoList {
            if let app = runningApplications.first(where: { $0.processIdentifier == windowInfo.pid.intValue }) {
                let appInfo = ShareSource(id: windowInfo.pid, name: windowInfo.fullName, sourceType: .window, shareType: .window, icon: app.icon, windowIdList: [windowInfo.windowNumber])
                
                if app.processIdentifier == ProcessInfo().processIdentifier {
                    sparShareSourceList.append(appInfo)
                } else {
                    windowShareSourceList.append(appInfo)
                }
            }
        }
        
        windowShareSourceList += sparShareSourceList
        updateShareSourceSharingState(shareSourceList: &windowShareSourceList)
        return windowShareSourceList
    }
    
    func generateApplicationShareSourcesSync() -> [ShareSource] {
        var shareSourceList:[ShareSource] = []
        var sparkShareSourceList:[ShareSource] = []
    
        let processWindowMap = Process.getProcessWindowList()
        let runningApplications = NSWorkspace.shared.runningApplications
        let sortedProcesses = Process.getProcessListByLastActive()

        for p in sortedProcesses {
            for app in runningApplications {
                let pid = Int32(app.processIdentifier)
                if pid == p {
                    if app.activationPolicy == .regular && app.bundleIdentifier != "com.apple.finder" {
                        let windowList = processWindowMap[pid] ?? []
                        
                        let appInfo = ShareSource(id: String(pid), name: app.localizedName ?? "", sourceType: .application, shareType: .application, icon: app.icon, windowIdList: windowList)
                        
                        if app.processIdentifier == ProcessInfo().processIdentifier {
                            sparkShareSourceList.append(appInfo)
                        } else {
                            shareSourceList.append(appInfo)
                        }
                    }
                    break
                }
            }
        }
        
        shareSourceList += sparkShareSourceList
        updateShareSourceSharingState(shareSourceList: &shareSourceList)
        return shareSourceList
    }
    
//    func generateApplicationShareSourcesAsync(telephonyServiceProxy:TelephonyServiceProxy, callId:String, callback: @escaping ([ShareSource]) -> Void) {
//        telephonyServiceProxy.getShareSources(.application, callback: { [weak self] (shareSources : NSMutableArray?) in
//            guard let self = self, let theShareSources = shareSources as? [ShareSourceVM] else { return }
//            var shareSourceList = self.generateApplicationShareSourcesSync()
//            shareSourceList.removeAll { shareSource in
//                !theShareSources.contains { $0.sourceId == shareSource.id }
//            }
//            callback(shareSourceList)
//        })
//    }
}


