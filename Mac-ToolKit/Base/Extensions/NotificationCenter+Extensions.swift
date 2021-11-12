//
//  NotificationCenter+Extensions.swift
//  Mac-ToolKit
//
//  Created by Archie You on 2021/11/12.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Foundation

extension NotificationCenter {
    @objc public func postNotificationNameOnMainThread(_ aName: String, object anObject: AnyObject?, userInfo aUserInfo: [AnyHashable: Any]?){
         DispatchQueue.main.async(execute: {
            NotificationCenter.default.post(name: Notification.Name(rawValue: aName), object: anObject , userInfo: aUserInfo)
        });
        
    }
    
    @objc public func postNotificationNameOnMainThreadWhenModal(_ aName: String, object anObject: AnyObject?, userInfo aUserInfo: [AnyHashable: Any]?) {
        let notification = Notification.init(name: Notification.Name(rawValue: aName), object: anObject, userInfo: aUserInfo)
        self.performSelector(onMainThread: #selector(self.postNotificationSelector), with: notification, waitUntilDone: false, modes: ["NSModalPanelRunLoopMode", "NSDefaultRunLoopMode"])
    }
    
    @objc public func postNotificationSelector(_ notification: Notification) {
        NotificationCenter.default.post(notification)
    }
}
//( nonnull  NSString *)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo
