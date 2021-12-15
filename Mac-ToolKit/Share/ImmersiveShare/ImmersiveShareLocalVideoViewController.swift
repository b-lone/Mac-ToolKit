//
//  ImmersiveShareLocalVideoViewController.swift
//  WebexTeams
//
//  Created by Archie You on 2021/12/13.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa

typealias IImmersiveShareLocalVideoViewController = ImmersiveShareLocalVideoViewControllerProtocol & BaseViewController

protocol ImmersiveShareLocalVideoViewControllerProtocol: VideoViewControllerProtocol {
}

class ImmersiveShareLocalVideoViewController: IImmersiveShareLocalVideoViewController {
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
        updateVideoViewHandler(callId: callId, register: true)
    }
    
    //MARK: VideoViewControllerProtocol
    func updateVideoViewHandler(callId: String, register: Bool) {
        if register {
            appContext.coreFramework.telephonyServiceProxy.updateViewHandle(forCallId: callId, layer: localShareVideoView, byTrackType: TrackVMType.local.rawValue)
        } else {
            appContext.coreFramework.telephonyServiceProxy.removeViewHandle(forCallId: callId, layer: localShareVideoView, byTrackType: TrackVMType.local.rawValue)
        }
    }
}
