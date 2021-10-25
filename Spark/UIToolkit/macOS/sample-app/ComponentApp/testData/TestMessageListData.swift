//
//  TestMessageListData.swift
//  ComponentApp
//
//  Created by James Nestor on 22/06/2021.
//

import Cocoa
import UIToolkit

class TestMessageListData {
    
    var uniqueId:String
    var senderId:String
    var senderName: String
    var message:String
    var messageSendTime:Date
    var messageHitPositions:[UTHitPosition]
    var avatarImage:NSImage?
    
    var messageWithSenderAndHitPositions:  [UTStringProperties] {
        return [UTStringProperties(str: senderName + String.separatorString),
                UTStringProperties(str:message, hitPositions: messageHitPositions)]
    }
    
    var avatarColor:CCColor {
        if let i = Int(uniqueId) {
            let colorPair = TestMessageListData.MessageColors[i % 4]
            return UIToolkit.shared.getThemeManager().isDarkTheme() ? colorPair.1 : colorPair.0
        }
        
        
        return .gray
    }
    
    init(uniqueId:String, senderId:String, senderName:String, message:String, messageSendTime:Date, messageHitPositions:[UTHitPosition], avatarImage:NSImage? = nil){
        self.uniqueId        = uniqueId
        self.senderId        = senderId
        self.senderName      = senderName
        self.message         = message
        self.messageSendTime = messageSendTime
        self.messageHitPositions = messageHitPositions
        self.avatarImage     = avatarImage
    }
    
    class func buildTestMessageData(count:UInt) -> [TestMessageListData] {
        
        var data:[TestMessageListData] = []
        
        for i in 0..<count {
            
            let message = buildMessageData(i: i)
            
            data.append(TestMessageListData(uniqueId: "\(i)",
                                            senderId: "sender \(i)",
                                            senderName: "Test user \(i)",
                                            message: message,
                                            messageSendTime: Date(timeIntervalSinceNow: TimeInterval(i * 1000)),
                                            messageHitPositions: getMessageHitPositions(message: message),
                                            avatarImage: i % 40 == 0 ? testImage : nil))
            
        }
        
        return data
    }
    
    class func buildMessageData(i:UInt) -> String {
        
        if i % 4 == 0 {
            return "Test 🧐 extra small message"
        }
        else if i % 4 == 1 {
            return "Test small message test small message"
        }
        else if i % 4 == 2 {
            return "Test medium message test medium message test medium message test medium message"
        }
        else {
            return "Test 🧐 large message test large message test large message test large message test large message test large message test large message test large message test large message test large message test large message test large message test large message test large message test large message test large message test large message"
        }
    }
    
    class func getMessageHitPositions(message:String) -> [UTHitPosition] {
        
        let words = message.components(separatedBy: " ")
        let randomNum = Int(arc4random_uniform(UInt32(32)))
        
        if randomNum >= words.count {
            return []
        }
        
        let ranges = message.ranges(of: words[randomNum], options: .caseInsensitive)
        var hitPositions:[UTHitPosition] = []
        for range in ranges {
            let nsRange = NSRange(range, in: message)
            hitPositions.append(UTHitPosition(range: nsRange, type: .mentionMe))
        }
        
        return hitPositions
    }
    
    static var testImage = NSImage(named: "maya")
    
    static var MessageColors = [(CCColor.getColorFromHexString(hexString: "066070"), CCColor.getColorFromHexString(hexString: "22C7D6")),
                                (CCColor.getColorFromHexString(hexString: "735107"), CCColor.getColorFromHexString(hexString: "D6B220")),
                                (CCColor.getColorFromHexString(hexString: "416116"), CCColor.getColorFromHexString(hexString: "93C437")),
                                (CCColor.getColorFromHexString(hexString: "12615A"), CCColor.getColorFromHexString(hexString: "30C9B0"))]

}
