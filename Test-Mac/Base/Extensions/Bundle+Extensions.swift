//
//  CFBundle+Extensions.swift
//  Test-Mac
//
//  Created by Archie You on 2021/8/18.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

extension Bundle {    
    public class func loadPrivateFrameworkBundle(frameworkName: String) -> CFBundle? {
        var bundleURL: CFURL?
        var bundle: CFBundle?
        
        if let baseURL = URL.getSysPrivateFrameWorkFolder() {
            bundleURL = CFURLCreateCopyAppendingPathComponent(kCFAllocatorSystemDefault, baseURL as CFURL, frameworkName as CFString, false)
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
    public class func getSparkBundle() -> Bundle? {
        #if os(iOS)
        return Bundle(identifier: "com.cisco.CommonHeadResources")
        #else
        let bundles = Bundle.allBundles
        for bundle in bundles {
            if bundle.bundleIdentifier == "Cisco-Systems.Spark.main" {
                return bundle
            }
        }
        return nil
        #endif
    }
}
