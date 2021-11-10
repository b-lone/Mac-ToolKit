//
//  LocalShareVideoViewController.swift
//  WebexTeams
//
//  Created by Archie You on 2020/12/14.
//  Copyright © 2020 Cisco Systems. All rights reserved.
//

import Cocoa

protocol VideoViewControllerProtocol {
    func updateVideoViewHandler(callId: String, register: Bool)
}


typealias ILocalShareVideoViewController = LocalShareVideoViewControllerProtocol & BaseViewController

protocol LocalShareVideoViewControllerProtocol: VideoViewControllerProtocol {
}

class LocalShareVideoViewController: ILocalShareVideoViewController {
    @IBOutlet weak var localShareVideoView: SparkVideoLayer!
    private var callId: String
    init(appContext: AppContext, callId: String) {
        self.callId = callId
        super.init(appContext: appContext)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        updateVideoViewHandler(callId: callId, register: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localShareVideoView.videoFrameType = .BGRA
        updateVideoViewHandler(callId: callId, register: true)
    }
    
    //MARK: VideoViewControllerProtocol
    func updateVideoViewHandler(callId: String, register: Bool) {
        if register {
//            appContext.coreFramework.telephonyServiceProxy.updateViewHandle(forCallId: callId, layer: selfShareVideoView, byTrackType: TrackVMType.localShare.rawValue)
        } else {
//            appContext.coreFramework.telephonyServiceProxy.removeViewHandle(forCallId: callId, layer: selfShareVideoView, byTrackType: TrackVMType.localShare.rawValue)
        }
    }
}
