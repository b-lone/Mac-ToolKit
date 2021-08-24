//
//  CFBundle+Extensions.swift
//  Test-Mac
//
//  Created by Archie You on 2021/8/18.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

extension CFBundle {    
    class func loadPrivateFrameworkBundle(frameworkName: String) -> CFBundle? {
        var bundleURL: CFURL?
        var bundle: CFBundle?
        
        if let baseURL = CFURL.getSysPrivateFrameWorkFolder() {
            bundleURL = CFURLCreateCopyAppendingPathComponent(kCFAllocatorSystemDefault, baseURL, frameworkName as CFString, false)
        }
        
        if let bundleURL = bundleURL {
            bundle = CFBundleCreate(kCFAllocatorSystemDefault, bundleURL)
        }
        
        if let bundle = bundle, CFBundleLoadExecutable(bundle) {
            SPARK_LOG_DEBUG("load success!")
            return bundle
        } else {
            SPARK_LOG_ERROR("load failed!")
            return nil
        }
    }
}
