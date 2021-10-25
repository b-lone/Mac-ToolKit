//
//  CFURL+Extensions.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/8/18.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

extension URL {
    public static func getSysPrivateFrameWorkFolder() -> URL? {
        let shareFileManager = FileManager.default
        let possibleURLs = shareFileManager.urls(for: .libraryDirectory, in: .systemDomainMask)
        
        var sysLibraryURL: URL?
        var framworkURL: URL?
        
        if !possibleURLs.isEmpty {
            sysLibraryURL = possibleURLs[0]
        }
        
        if let sysLibraryURL = sysLibraryURL {
            framworkURL = sysLibraryURL.appendingPathComponent("PrivateFrameworks")
        }
        
        SPARK_LOG_DEBUG("\(framworkURL?.absoluteString ?? "")")
        if let framworkURL = framworkURL {
            return framworkURL
        }
        return nil
    }
}
