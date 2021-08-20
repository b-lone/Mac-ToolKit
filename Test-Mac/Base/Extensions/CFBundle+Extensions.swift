//
//  CFBundle+Extensions.swift
//  Test-Mac
//
//  Created by Archie You on 2021/8/18.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

extension CFBundle {    
    class func loadPrivateFrameworkBundle(frameworkName: String, bundle: inout CFBundle?) -> Bool {
        var result = false
        var bundleURL: CFURL?
        bundle = nil
        
        if let baseURL = CFURL.getSysPrivateFrameWorkFolder() {
            bundleURL = CFURLCreateCopyAppendingPathComponent(kCFAllocatorSystemDefault, baseURL, frameworkName as CFString, false)
        }
        
        if let bundleURL = bundleURL {
            bundle = CFBundleCreate(kCFAllocatorSystemDefault, bundleURL)
        }
        
        if let bundle = bundle {
            result = CFBundleLoadExecutable(bundle)
        }
        
        if !result {
            bundle = nil
        }
        
        SPARK_LOG_DEBUG("result:\(result)")

        return result
    }
}
