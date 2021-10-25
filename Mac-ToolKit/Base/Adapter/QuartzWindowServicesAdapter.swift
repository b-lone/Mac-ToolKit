//
//  QuartzWindowServicesAdapter.swift
//  WebexTeams
//
//  Created by Archie You on 2021/9/8.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa

protocol QuartzWindowServicesAdapterProtocol: AnyObject {
    func windowListCopyWindowInfo(_ option: CGWindowListOption, _ relativeToWindow: CGWindowID) -> CFArray?
}

class QuartzWindowServicesAdapter: NSObject & QuartzWindowServicesAdapterProtocol {
    func windowListCopyWindowInfo(_ option: CGWindowListOption, _ relativeToWindow: CGWindowID) -> CFArray? {
        return CGWindowListCopyWindowInfo(option, relativeToWindow)
    }
}
