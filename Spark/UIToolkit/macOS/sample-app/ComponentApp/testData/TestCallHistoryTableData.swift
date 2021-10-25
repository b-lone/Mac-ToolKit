//
//  TestCallHistoryTableData.swift
//  ComponentApp
//
//  Created by James Nestor on 11/06/2021.
//

import Cocoa

class TestCallHistoryTableData: NSObject {

    private (set) var uniqueId:String
    var displayName:String
    var number:String
    var callStartDate:Date
    
    var canCall:Bool
    var canMeet:Bool
    var canMessage:Bool
    var hasActiveCall:Bool
    
    var isSecure:Bool
    var hasInfo:Bool
    var isPrivate:Bool
    
    var isOutGoing:Bool
    var isUnread:Bool
    var isMissed:Bool
    
    var dateCallString : String{
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        return dateformatter.string(from: callStartDate)
    }
    
    var timeCallString:String{
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"
        return timeformatter.string(from: callStartDate)
    }
    
    init(uniqueId:String, displayName:String, number:String = "", callStartDate:Date = Date(), canCall:Bool = true, canMeet:Bool = false, canMessage:Bool = true, isSecure:Bool = true, hasInfo:Bool = true, isPrivate:Bool = true, isOutGoing:Bool = true, isUnread:Bool = true, hasActiveCall:Bool = false, isMissed:Bool = false) {
        
        self.uniqueId = uniqueId
        self.displayName = displayName
        self.number = number
        self.callStartDate = callStartDate
        
        self.canCall = canCall
        self.canMeet = canMeet
        self.canMessage = canMessage
        self.hasActiveCall = hasActiveCall
        
        self.isSecure = isSecure
        self.hasInfo = hasInfo
        self.isPrivate = isPrivate
        
        self.isOutGoing = isOutGoing
        self.isUnread = isUnread
        self.isMissed = isMissed
    }
    
    class func buildTestData(count:UInt) -> [TestCallHistoryTableData] {
        
        var data:[TestCallHistoryTableData] = []
        
        for i in 0..<count {
            
            data.append(TestCallHistoryTableData(uniqueId: "\(i)",
                                                 displayName: "Test User \(i)",
                                                 number: "12345 \(i)",
                                                 callStartDate: Date.init(timeIntervalSinceNow: TimeInterval(i * 1000)),
                                                 canCall: true,
                                                 canMeet: false,
                                                 canMessage: i % 2 == 0 ? true : false,
                                                 isSecure: true,
                                                 hasInfo: true,
                                                 isPrivate: true,
                                                 isOutGoing: i % 3 == 0 ? true : false,
                                                 isUnread: false,
                                                 isMissed: i % 7 == 0 ? true : false))
            
        }
        
        return data
    }
    
    class func buildTestActiveCallData(count:UInt) -> [TestCallHistoryTableData] {
        
        var data:[TestCallHistoryTableData] = []
        
        for i in 0..<count {
            
            data.append(TestCallHistoryTableData(uniqueId: "CallBricklet\(i)",
                                                 displayName: "Call Test User \(i)",
                                                 number: "",
                                                 callStartDate: Date.init(timeIntervalSinceNow: TimeInterval(i * 1000)),
                                                 canCall: false,
                                                 canMeet: false,
                                                 canMessage: false,
                                                 isSecure: false,
                                                 hasInfo: false,
                                                 isPrivate: false,
                                                 isOutGoing: false,
                                                 isUnread: false,
                                                 hasActiveCall: true))
            
        }
        
        return data
    }
}
