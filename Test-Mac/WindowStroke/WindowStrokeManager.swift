//
//  WindowStrokeManager.swift
//  Test-Mac
//
//  Created by Archie You on 2021/4/27.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

struct WindowInfo {
    var windowId: UInt32 = 0
    var pid: Int32 = 0
    var bounds: CGRect = .zero
    var name: String = ""
    var level: Int = 0
    
    var description: String {
        "{\nid: \(windowId)\nbounds: \(bounds)\nlevel:\(level)\n}"
    }
}

class WindowStrokeManager: NSObject {
    private var strokeLines = [StrokeLine]()
    
    override init() {
        super.init()
//        NotificationCenter.default.addObserver(self, selector: #selector(onWindowResize), name: NSWindow.didResizeNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(onWindowMove), name: NSWindow.didResizeNotification, object: nil)
    }
    
//    @objc func onWindowResize(_ notification: Notification) {
//        print("onWindowResize")
//    }
//
//    @objc func onWindowMove(_ notification: Notification) {
//        print("onWindowMove")
//    }
    
    func getTerminal() -> NSRunningApplication? {
        let runningApplications = NSWorkspace.shared.runningApplications
        let terminal = runningApplications.first{ $0.localizedName == "Terminal" }
        print("\(terminal?.localizedName ?? "")")
        return terminal
    }
    
    func getWindowsAbove() -> [WindowInfo] {
        var result = [WindowInfo]()
        let options = CGWindowListOption(arrayLiteral: [.optionOnScreenAboveWindow, .excludeDesktopElements])
        if let windowListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(SharedInstance.shared.window.windowNumber)) as? Array<[String: AnyObject]> {
            
            for windowInfo in windowListInfo{
                var info = WindowInfo()
                if let windowLevel = windowInfo[kCGWindowLayer as String] as? Int {
                    info.level = windowLevel
                }
                
                if( info.level == kCGMainMenuWindowLevel || info.level == kCGStatusWindowLevel || info.level == kCGDockWindowLevel || info.level == kCGUtilityWindowLevel || info.level == kCGPopUpMenuWindowLevel) {
                    continue
                }
                
                if let bounds = windowInfo[kCGWindowBounds as String] as! CFDictionary?{
                    if let b = CGRect(dictionaryRepresentation: bounds){
//                        if( b.width < 10 && b.height < 10) {
//                            continue
//                        }
//
                        info.bounds = b
                    }
                }
                
                let winId = windowInfo[kCGWindowNumber as String] as! UInt32
                info.windowId = winId
                
                let numPid = windowInfo[kCGWindowOwnerPID as String] as! NSNumber
                let pid = numPid.int32Value
                info.pid = pid
                
                print(info.description)
                
                result.append(info)
            }
        }
        print("getWindowsByLastActive \(result.count)")
        return result
    }
    
    func getWindowsByLastActive() -> [WindowInfo]{
        print("getWindowsByLastActive")
        var result = [WindowInfo]()
        
        let options = CGWindowListOption(arrayLiteral: [.optionOnScreenOnly, .excludeDesktopElements])
        if let windowListInfo = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? Array<[String: AnyObject]> {
            
            for windowInfo in windowListInfo{
                var info = WindowInfo()
                if let windowLevel = windowInfo[kCGWindowLayer as String] as? Int {
                    info.level = windowLevel
                }
                
                if let bounds = windowInfo[kCGWindowBounds as String] as! CFDictionary?{
                    if let b = CGRect(dictionaryRepresentation: bounds){
                        if( b.width < 10 && b.height < 10) {
                            continue
                        }
                        info.bounds = b
                    }
                }
                
//                if let windowName = windowInfo[kCGWindowName as String] as! CFString? {
//                    info.name = String(windowName)
//                }
                
                
                
                let winId = windowInfo[kCGWindowNumber as String] as! UInt32
                info.windowId = winId
                
                let numPid = windowInfo[kCGWindowOwnerPID as String] as! NSNumber
                let pid = numPid.int32Value
                info.pid = pid
                
                result.append(info)
            }
        }
        print("getWindowsByLastActive \(result.count)")
        return result
    }
    
    func getTerminalWindows() -> [WindowInfo] {
        guard let terminal = getTerminal()  else { return [] }

        let windowInfos = getWindowsByLastActive()
        
        var result = [WindowInfo]()
        
        for winInfo in windowInfos {
            print("\(winInfo.level) \(winInfo.bounds)")
            if winInfo.pid == terminal.processIdentifier {
                result.append(winInfo)
            }
        }
        
        print("getTerminalWindows \(result.count)")
        return result
    }
    
    func covertRectFromScreen(_ rect: NSRect) -> NSRect{
        guard let screenRect = NSScreen.main?.frame else { return .zero }
        print("\(screenRect)")
        return NSMakeRect(rect.minX, screenRect.maxY - rect.maxY, rect.width, rect.height)
    }
    
    func drawStroke() {
        for line in strokeLines {
            line.close()
        }
        strokeLines.removeAll()
        
        for windowInfo in getTerminalWindows() {
            print("\(windowInfo.bounds)")
            let orignRect = covertRectFromScreen(windowInfo.bounds)
            
            let line1 = StrokeLine()
            let line2 = StrokeLine()
            let line3 = StrokeLine()
            let line4 = StrokeLine()
            
//            line1.setFrameTopLeftPoint(NSMakePoint(orignRect.minX - 1, orignRect.minY - 1))
//            line2.setFrameTopLeftPoint(NSMakePoint(orignRect.minX - 1, orignRect.minY - 1))
//            line3.setFrameTopLeftPoint(NSMakePoint(orignRect.maxX, orignRect.minY - 1))
//            line4.setFrameTopLeftPoint(NSMakePoint(orignRect.minX - 1, orignRect.maxY))
//
//            line1.setContentSize(NSMakeSize(1, orignRect.height + 2))
//            line2.setContentSize(NSMakeSize(orignRect.width + 2, 1))
//            line3.setContentSize(NSMakeSize(1, orignRect.height + 2))
//            line4.setContentSize(NSMakeSize(orignRect.width + 2, 1))
            line1.setFrame(NSMakeRect(orignRect.minX - 1, orignRect.minY - 1, 1, orignRect.height + 2), display: true, animate: false)
            line2.setFrame(NSMakeRect(orignRect.minX - 1, orignRect.minY - 1, orignRect.width + 2, 1), display: true, animate: false)
            line3.setFrame(NSMakeRect(orignRect.minX - 1, orignRect.maxY + 1, orignRect.width + 2, 1), display: true, animate: false)
            line4.setFrame(NSMakeRect(orignRect.maxX + 1, orignRect.minY - 1, 1, orignRect.height + 2), display: true, animate: false)
            
            strokeLines.append(line1)
            strokeLines.append(line2)
            strokeLines.append(line3)
            strokeLines.append(line4)
            
            line1.makeKeyAndOrderFront(self)
            line2.makeKeyAndOrderFront(self)
            line3.makeKeyAndOrderFront(self)
            line4.makeKeyAndOrderFront(self)
        }
    }
}
