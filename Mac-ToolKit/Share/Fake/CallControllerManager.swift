//
//  CallControllerManager.swift
//  SparkMacDesktop
//
//  Created by jimmcoyn on 08/10/2015.
//  Copyright © 2015 Cisco Systems. All rights reserved.
//
import Cocoa
import CommonHead

class CallControllerManager: NSObject {
    private var appContext: AppContext!
    var shareManager: ShareManagerProtocol

    // MARK: Lifecycle
    init(appContext: AppContext) {
        self.appContext = appContext
        shareManager = ShareManager(appContext: appContext)
        super.init()
    }

    deinit {
    }
}

@objc public  enum CallStateEnum:Int {
    case callChanged // we should revisit this
    case callStarted
    case callConversationChanged
    case callTerminated
    case audioMutedEvent
    case videoMutedEvent
    case videoTrackPersonChangedEvent
    case videoStreamingChangedEvent
    case shareStartedEvent
    case shareFinishedEvent
    case challengeStarted
    
    static let strings = [
        callChanged:"CallChanged",
        callStarted:"CallStarted",
        callTerminated:"CallTerminated",
        audioMutedEvent:"AudioMutedEvent",
        videoMutedEvent:"VideoMutedEvent",
        videoTrackPersonChangedEvent:"VideoTrackPersonChangedEvent",
        videoStreamingChangedEvent:"VideoStreamingChangedEvent",
        shareStartedEvent:"ShareStartedEvent",
        shareFinishedEvent:"ShareFinishedEvent",
        challengeStarted:"ChallengeStarted"
    ]
    
    var description:String {
        get {
            return CallStateEnum.strings[self] ?? "Default"
        }
    }
}
