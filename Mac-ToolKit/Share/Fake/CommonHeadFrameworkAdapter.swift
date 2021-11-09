//
//  CommonHeadFrameworkAdapter.swift
//  Mac-ToolKit
//
//  Created by Archie You on 2021/10/28.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa
import CommonHead

func sparkAssert(_ assert: Bool, _ comment: String? = nil) {}

class MacOSUtilsHelper: NSObject {
    static func isUserAdmin() -> Bool {
        return true
    }
}

class FakeShareVM: CHShareViewModel {
    var sharingContent: CHSharingContent?
    override func getSharingContent() -> CHSharingContent? {
        sharingContent
    }
    
    var localShareControlBarInfo: CHLocalShareControlBarInfo?
    override func getLocalShareControlBarInfo() -> CHLocalShareControlBarInfo? {
        return localShareControlBarInfo
    }
}

class CommonHeadFrameworkAdapter: NSObject {
    func makeShareTelemetryManager() -> CHShareTelemetryManagerProtocol {
        return CHShareTelemetryManager()
    }
    
    let shareVM = FakeShareVM()
    func makeShareViewModel() -> CHShareViewModelProtocol {
        return shareVM
    }
}
