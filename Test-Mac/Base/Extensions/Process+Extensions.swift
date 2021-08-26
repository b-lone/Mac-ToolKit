//
//  Process+Extensions.swift
//  SparkMacDesktop
//
//  Created by Jimmy Coyne on 30/06/2017.
//  Copyright © 2017 Cisco Systems. All rights reserved.
//

import Cocoa

extension Process {
    
    //https://developer.apple.com/documentation/apple_silicon/about_the_rosetta_translation_environment
    /* To programmatically determine when a process is running under Rosetta translation, call the sysctlbyname function with the sysctl.proc_translated flag, as shown in the following example. The example function returns the value 0 for a native process, 1 for a translated process, and -1 when an error occurs. */
    static func isProcessTranslated() -> Bool {
        var ret = Int32(0)
        var size = MemoryLayout.size(ofValue: ret)
        let result = sysctlbyname("sysctl.proc_translated", &ret, &size, nil, 0)
        if result == -1 {
            if (errno == ENOENT){
                return false
            }
            return false
        }
        
        if ret == 1 {
            return true
        } else {
            return false
        }
    }
    
    
    //Blocking call, dont run on main thread
    func shell(_ input: String, shouldForce: Bool = false) -> (output: String, exitCode: Int32) {
        
        if !shouldForce && Thread.isMainThread {
          abort()
        }
        
        let arguments = input.split { $0 == " " }.map(String.init)
        
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = arguments
        task.environment = [
            "LC_ALL" : "en_US.UTF-8",
            "HOME" : NSHomeDirectory(),
            "PATH" : (ProcessInfo.processInfo.environment["PATH"]! as String) + ":."
        ]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        
        task.waitUntilExit()
        
        return (output, task.terminationStatus)
    }
    
    static func getProcessWindowList(pid:Int32) -> [UInt32]{
        
        var processWindowList:[UInt32] = []
        
        let allProcessWindowList = Process.getProcessWindowList()
        if let pwl = allProcessWindowList[pid]{
            processWindowList = pwl
        }
        
        return processWindowList
    }
    
    static func getProcessWindowList() -> [Int32:[UInt32]]{
        
        var processWindowList = [Int32:[UInt32]]()
        
        let options = CGWindowListOption(arrayLiteral: [.optionOnScreenOnly, .excludeDesktopElements])
        if let windowListInfo = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? Array<[String: AnyObject]>{
            
            for windowInfo in windowListInfo{
                
                if let bounds = windowInfo[kCGWindowBounds as String] as! CFDictionary?{
                    if let b = CGRect(dictionaryRepresentation: bounds){
                        if( b.width < 10 || b.height < 10) {
                            continue
                        }
                    }
                }
                let windowLevel = windowInfo[kCGWindowLayer as String] as! Int64
                if windowLevel != 0{
                    continue
                }
                let pid = windowInfo[kCGWindowOwnerPID as String] as! NSNumber
                let winId = windowInfo[kCGWindowNumber as String] as! UInt32
                if processWindowList[pid.int32Value] == nil{
                    processWindowList[pid.int32Value] = []
                    
                }
                
                processWindowList[pid.int32Value]?.append(winId)
            }
        }
        
        return processWindowList
    }
    
    static func getProcessListByLastActive(ignoreHighLevelWindows : Bool = true) -> [Int32]{
        
        var orderedProcessList = getProcessListForWindowsWith(options: CGWindowListOption(arrayLiteral: [.optionOnScreenOnly, .excludeDesktopElements]), ignoreHighLevelWindows: ignoreHighLevelWindows)
        let processIncludingOffscreen = getProcessListForWindowsWith(options: CGWindowListOption(arrayLiteral: [.optionAll, .excludeDesktopElements]), ignoreHighLevelWindows: ignoreHighLevelWindows)
       
        for processId in processIncludingOffscreen{
            if orderedProcessList.contains(where: {$0 == processId}) == false{
                orderedProcessList.append(processId)
            }
        }
       
        return orderedProcessList
    }
    
    static func getProcessListForWindowsWith(options: CGWindowListOption, ignoreHighLevelWindows : Bool = true) -> [Int32]{
        var processList = [Int32]()
        var highLevelProcessList = [Int32]()
        
        if let windowListInfo = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? Array<[String: AnyObject]>{
            
            for windowInfo in windowListInfo{
                
                if let bounds = windowInfo[kCGWindowBounds as String] as! CFDictionary?{
                    if let b = CGRect(dictionaryRepresentation: bounds){
                        if( b.width < 10 || b.height < 10) {
                            continue
                        }
                    }
                }
                
                let windowLevel = windowInfo[kCGWindowLayer as String] as! Int64
                let numPid = windowInfo[kCGWindowOwnerPID as String] as! NSNumber
                let pid = numPid.int32Value
                
                if windowLevel == 0 {
                    if processList.contains(where: {$0 == pid}) == false{
                        processList.append(pid)
                    }
                }
                else if ignoreHighLevelWindows == false{
                    highLevelProcessList.append(pid)
                }
            }
        }
        
        for pid in highLevelProcessList{
            if processList.contains(where: {$0 == pid}) == false{
                processList.append(pid)
            }
        }
        
        return processList
    }
    
    static func activateProcess(pid : Int32){
        
        let runningApplications = NSWorkspace.shared.runningApplications
        for app in runningApplications{
            if app.processIdentifier == pid{
                var iPid = pid
                
                let targetDescriptor = NSAppleEventDescriptor(descriptorType: typeKernelProcessID, bytes: &iPid, length: MemoryLayout<Int32>.size)
                let reopenDescriptor = NSAppleEventDescriptor(eventClass: kCoreEventClass, eventID: kAEReopenApplication, targetDescriptor: targetDescriptor, returnID: AEReturnID(kAutoGenerateReturnID), transactionID: AETransactionID(kAnyTransactionID))
                let activateDescriptor = NSAppleEventDescriptor(eventClass: kAEMiscStandards, eventID: kAEActivate, targetDescriptor: targetDescriptor, returnID: AEReturnID(kAutoGenerateReturnID), transactionID: AETransactionID(kAnyTransactionID))

                AESendMessage(activateDescriptor.aeDesc, nil, AESendMode(kAENoReply), kAEDefaultTimeout)
                AESendMessage(reopenDescriptor.aeDesc, nil, AESendMode(kAENoReply), kAEDefaultTimeout)
                return
            }
        }
    }
    
    static func getScreenForProcess(pid : Int32) -> NSScreen?{
        
        var biggestRect:CGRect?
        
        let options = CGWindowListOption(arrayLiteral: [.optionOnScreenOnly, .excludeDesktopElements])
        
        if let windowListInfo = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? Array<[String: AnyObject]>{
            for windowInfo in windowListInfo{
                
                let windowLevel = windowInfo[kCGWindowLayer as String] as! Int64
                if windowLevel > 0{
                    continue
                }
                
                let winPid = windowInfo[kCGWindowOwnerPID as String] as! NSNumber
                if winPid.int32Value == pid{
                    if let boundsDict = windowInfo[kCGWindowBounds as String] as! CFDictionary?{
                        if let bounds = CGRect(dictionaryRepresentation: boundsDict){
                            if( bounds.width < 10 || bounds.height < 10) {
                                continue
                            }
                            let windowSize = bounds.width * bounds.height
                            let bw = biggestRect?.width ?? 0
                            let bh = biggestRect?.height ?? 0
                            let biggestSize = bw * bh
                            
                            if(windowSize > biggestSize){
                                biggestRect = bounds
                            }
                            
                            
                        }
                    }
                }
            }
        }
        
        if let r = biggestRect{
            for s in NSScreen.screens{
                if s.frame.intersects(r){
                    return s
                }
            }
        }

        
        return NSScreen.main
    }
}

