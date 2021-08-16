//
//  BonjourClient.swift
//  Test-Mac
//
//  Created by Archie You on 2021/7/16.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa
// Source: https://developer.apple.com/library/mac/qa/qa1312/_index.html
struct Services {
    // Used by Personal File Sharing in the Sharing preference panel starting in Mac OS X 10.2.
    // The Finder browses for AFP servers starting in Mac OS X 10.2.
    static let AppleTalk_Filing: String = "_afpovertcp._tcp."
    // The Finder browses for NFS servers starting in Mac OS X 10.2.
    static let Network_File_System: String = "_nfs._tcp."
    // The Finder browses for WebDAV servers but because of a bug (r. 3171023), double-clicking
    // a discovered server fails to connect.
    static let WebDAV_File_System: String = "_webdav._tcp."
    // Used by FTP Access in the Sharing preference panel starting in Mac OS X 10.2.2.
    // The Finder browses for FTP servers starting in Mac OS X 10.3.
    // The Terminal application also browses for FTP servers starting in Mac OS X 10.3.
    static let File_Transfer: String = "_ftp._tcp."
    // Used by Remote Login in the Sharing preference panel starting in Mac OS X 10.3.
    // The Terminal application browses for SSH servers starting in Mac OS X 10.3.
    static let Secure_Shell: String = "_ssh._tcp."
    // Used by Remote AppleEvents in the Sharing preference panel starting in Mac OS X 10.2.
    static let Remote_AppleEvents: String = "_eppc._tcp."
    // Used by Personal Web Sharing in the Sharing preference panel to advertise the User's
    // Sites folders starting in Mac OS X 10.2.4. Safari can be used to browse for web servers.
    static let Hypertext_Transfer: String = "_http._tcp."
    // If Telnet is enabled, xinetd will advertise it via Bonjour starting in Mac OS X 10.3.
    // The Terminal application browses for Telnet servers starting in Mac OS X 10.3.
    static let Remote_Login: String = "_telnet._tcp."
    // Print Center browses for LPR printers starting in Mac OS X 10.2.
    static let Line_Printer_Daemon: String = "_printer._tcp."
    // Print Center browses for IPP printers starting in Mac OS X 10.2.
    static let Internet_Printing: String = "_ipp._tcp."
    // Print Center browses for PDL Data Stream printers starting in Mac OS X 10.2.
    static let PDL_Data_Stream: String = "_pdl-datastream._tcp."
    // Used by the AirPort Extreme Base Station to share USB printers. Printer Setup Utility
    // browses for AirPort Extreme shared USB printers which use the Remote I/O USB Printer
    // Protocol starting in Mac OS X 10.3.
    static let Remote_IO_USB_Printer: String = "_riousbprint._tcp."
    // Also known as iTunes Music Sharing. iTunes advertises and browses for DAAP servers
    // starting in iTunes 4.0.
    static let Digital_Audio_Access: String = "_daap._tcp."
    // Also known as iPhoto Photo Sharing. iPhoto advertises and browses for DPAP servers
    // starting in iPhoto 4.0.
    static let Digital_Photo_Access: String = "_dpap._tcp."
    // Used by iChat 1.0 which shipped with Mac OS X 10.2. This service is now deprecated with
    // the introduction of the "presence" service in iChat AV. See below.
    static let iChat_Instant_Messaging_Deprecated: String = "_ichat._tcp."
    // Used by iChat AV which shipped with Mac OS X 10.3.
    static let iChat_Instant_Messaging: String = "_presence._tcp."
    // Used by the Image Capture application to share cameras in Mac OS X 10.3.
    static let Image_Capture_Sharing: String = "_ica-networking._tcp."
    // Used by the AirPort Admin Utility starting in Mac OS X 10.2 in order to locate and
    // configure the AirPort Base Station (Dual Ethernet) and the AirPort Extreme Base Station.
    static let AirPort_Base_Station: String = "_airport._tcp."
    // Used by the Xserve RAID Admin Utility to locate and configure Xserve RAID hardware.
    static let Xserve_RAID: String = "_xserveraid._tcp."
    // Used by Xcode in its Distributed Builds feature.
    static let Distributed_Compiler: String = "_distcc._tcp."
    // Used by Open Directory Password Server starting in Mac OS X Server 10.3.
    static let Apple_Password_Server: String = "_apple-sasl._tcp."
    // Open Directory advertises this service starting in Mac OS X 10.2. Workgroup Manager
    // browses for this service starting in Mac OS X Server 10.2.
    static let Workgroup_Manager: String = "_workstation._tcp."
    // Mac OS X Server machines advertise this service starting in Mac OS X 10.3. Server
    // Admin browses for this service starting in Mac OS X Server 10.3.
    static let Server_Admin: String = "_servermgr._tcp."
    // Also known as AirTunes. The AirPort Express Base Station advertises this service.
    // iTunes browses for this service starting in iTunes 4.6.
    static let Remote_Audio_Output: String = "_raop._tcp."
    // Used by the Xcode Service Service in the Apple Server App
    static let Xcode_Server: String = "_xcs2p._tcp."
    
    static let AirPlay_Station: String = "_airplay._tcp."
}

class BonjourClient: NSObject, NetServiceBrowserDelegate {
    let browser = NetServiceBrowser()
    
    override init() {
        super.init()
        browser.delegate = self
    }
    
    func start() {
//        browser.searchForRegistrationDomains()
        browser.searchForServices(ofType: Services.AirPlay_Station, inDomain: "local.")
//        browser.searchForServices(ofType: "_airplay._tcp.", inDomain: "local.")
    }
    
    func stop() {
        browser.stop()
    }
    
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        SPARK_LOG_DEBUG("")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFindDomain domainString: String, moreComing: Bool) {
        SPARK_LOG_DEBUG(domainString)
        browser.searchForServices(ofType: Services.AirPort_Base_Station, inDomain: domainString)
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        SPARK_LOG_DEBUG("")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        SPARK_LOG_DEBUG("\n{\n  domain:\(service.domain)\n  name:\(service.name)\n  type:\(service.type)\n}")
    }
}
