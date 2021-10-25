//
//  ShareContext.swift
//  WebexTeams
//
//  Created by Archie You on 2021/2/10.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa
import CommonHead

protocol ShareContextProtocol: AnyObject {
    var callId: String { get }
    var shareSourceType: CHSourceType { get }
    var screen: NSScreen? { get }
    var applicationList: [String]? { get }
    var windowNumberList: [CGWindowID]? { get }
    var sharingWindowNumberList: [CGWindowID] { get }
    var screenToDraw: NSScreen { get }
    var lastStartShareInfo: StartShareInfo? { get }
    func isSharing(source: ShareSource) -> Bool
    func isEqual(to theOther: ShareContextProtocol?) -> Bool
}

class StartShareInfo: NSObject {
    var shareSourceList: [CHShareSource]
    var shareType: CHShareType
    init(shareSourceList: [CHShareSource], shareType: CHShareType) {
        self.shareSourceList = shareSourceList
        self.shareType = shareType
    }
}

class ShareContext: NSObject, ShareContextProtocol {
    var callId: String
    var shareSourceType = CHSourceType.unknown
    var screen: NSScreen?
    var applicationList: [String]?
    var windowNumberList: [CGWindowID]?
    var sharingWindowNumberList = [CGWindowID]()
    var screenToDraw = NSScreen.main ?? NSScreen()
    var lastStartShareInfo: StartShareInfo?
    var isLocalSharing = false
    
    init(callId: String) {
        self.callId = callId
        super.init()
        update(shareSourceType: .unknown)
    }
    
    func update(shareSourceType: CHSourceType, captureRect: CHRect? = nil, screenId: ScreenId? = nil, applicationList: [String]? = nil, windowNumberList: [CGWindowID]? = nil, sharingWindowNumberList: [CGWindowID]? = nil) {
        self.shareSourceType = shareSourceType
        self.screen = NSScreen.aScreen(uuid: screenId)
        self.applicationList = applicationList
        self.windowNumberList = windowNumberList
        if let sharingWindowNumberList = sharingWindowNumberList {
            self.sharingWindowNumberList = sharingWindowNumberList
        }
        
        if let screen = screen {
            screenToDraw = screen
        } else if let captureRect = captureRect {
            if let screen = getSharedScreen(rect: captureRect) {
                screenToDraw = screen
            }
        }
        
        SPARK_LOG_DEBUG("{ shareSourceType:\(self.shareSourceType), screen:\(self.screen?.uuid() ?? "nil"), application: \(self.applicationList?.count ?? 0), window: \(self.windowNumberList?.count ?? 0), sharingWindow: \(self.sharingWindowNumberList.count), callId: \(callId) }")
        SPARK_LOG_DEBUG("screenToDraw:\(screenToDraw.frame)")
    }
    
    func isSharing(source: ShareSource) -> Bool {
        switch source.shareType{
        case .iosViaCable:
            return lastStartShareInfo?.shareType == .iosViaCable && isLocalSharing
        default:
            switch source.sourceType {
            case .desktop:
                return screen?.uuid() == source.id
            case .window:
                if let windowId = source.windowIdList.first {
                    return windowNumberList?.contains(windowId) == true
                }
            case .application:
                return applicationList?.contains(source.id) == true
            default:
                return false
            }
        }
        return false
    }
    
    private func getSharedScreen(rect: CHRect) -> NSScreen? {
        for screen in NSScreen.screens {
            let screenFrame = screen.getFlippedCoordinateFrame()
            if screenFrame.minX == CGFloat(rect.x.floatValue), screenFrame.minY == CGFloat(rect.y.floatValue), screenFrame.width == CGFloat(rect.width.floatValue), screenFrame.height == CGFloat(rect.height.floatValue) {
                return screen
            }
        }
        
        SPARK_LOG_ERROR("Can't find matched screen")
        return nil
    }
    
    func isEqual(to theOther: ShareContextProtocol?) -> Bool {
        guard let theOther = theOther else { return false }
        return callId == theOther.callId
            && shareSourceType == theOther.shareSourceType
            && screen == theOther.screen
            && applicationList == theOther.applicationList
            && windowNumberList == theOther.windowNumberList
            && sharingWindowNumberList == theOther.sharingWindowNumberList
            && screenToDraw == theOther.screenToDraw
    }
}
