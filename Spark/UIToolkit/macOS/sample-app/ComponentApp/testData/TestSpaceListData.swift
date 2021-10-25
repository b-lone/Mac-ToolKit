//
//  TestSpaceListData.swift
//  ComponentApp
//
//  Created by James Nestor on 17/06/2021.
//

import Cocoa
import UIToolkit

enum UINotificationState : UInt32, CaseIterable {
    
    case defaultState
    case importantUnreadMessage
    case unreadMessage
    case unreadMention
    case unreadSelfAddedToSpace
    case mutedRoomWithUnreadMessage
    case mutedRoom
    case alertOnAllMessages
    
    func asIndicatorType() -> UTIndicatorBadgeType{
        switch self {
        case .defaultState:
            return .noBadge
        case .importantUnreadMessage:
            return .unread
        case .unreadMessage:
            return .unread
        case .unreadMention:
            return .mention
        case .unreadSelfAddedToSpace:
            return .newlyAdded
        case .mutedRoomWithUnreadMessage:
            return .muted
        case .mutedRoom:
            return .muted
        case .alertOnAllMessages:
            return .alert
        }
    }
    
    static func randomNotificationState() -> UINotificationState{
        let rand = arc4random_uniform(UInt32(self.allCases.count - 1))
        return UINotificationState(rawValue: rand)!
    }
}

class TestSpaceListDataBase : NSObject{
    var group:TestSpaceGroup = .normal
    init(group:TestSpaceGroup){
        self.group = group
    }
    
    func buildMenu(menu:NSMenu, sel:Selector) {}
}

class TestSpaceListData: TestSpaceListDataBase {
    
    private (set) var uniqueId:String
    var displayName:String
    var notificationState: UINotificationState
    
    var teamData:TestTeamData?
    var hasActiveCall:Bool
    var callStartTime:Date?
    var callParticipantCount: Int
    var presence:UTPresenceState
    
    var isTeamSpace:Bool {
        return teamData != nil
    }
    
    var avatarColor:CCColor {
        if let data = teamData {
            return data.color
        }
        
        return NSColor.gray
    }
    
    public init(uniqueId:String, displayName: String, notificationState: UINotificationState, teamData:TestTeamData?, hasActiveCall: Bool, callStartTime:Date? = nil, callParticipantCount:Int = 0, group:TestSpaceGroup, presence:UTPresenceState = .none){
        self.uniqueId             = uniqueId
        self.displayName          = displayName
        self.notificationState    = notificationState
        self.teamData             = teamData
        self.hasActiveCall        = hasActiveCall
        self.callStartTime        = callStartTime
        self.callParticipantCount = callParticipantCount
        self.presence             = presence
        super.init(group: group)
    }
    
    class func buildTestData(count:UInt) -> [TestSpaceListData] {
        
        var data:[TestSpaceListData] = []
        
        for i in 0..<count {
            
            data.append(TestSpaceListData(uniqueId: "\(i)",
                                      displayName: "Test Space Test Space \(i)",
                                notificationState: UINotificationState.randomNotificationState(),
                                teamData: TestTeamData.randomTeamOrNil(),
                                hasActiveCall: false,
                                group: i % 43 == 0 ? .favourite : .normal,
                                presence: TestSpaceListData.randomPresence()))
            
        }
        
        return data
    }
    
    class func buildTestSpaceWithCallData(count:UInt) -> [TestSpaceListData] {
        
        var data:[TestSpaceListData] = []
        
        for i in 0..<count {
            
            data.append(TestSpaceListData(uniqueId: "Call \(i)",
                                       displayName: "Call Test \(i)",
                                 notificationState: UINotificationState.randomNotificationState(),
                                          teamData: TestTeamData.randomTeamOrNil(),
                                     hasActiveCall: true,
                                     callStartTime: Date(timeIntervalSinceNow: TimeInterval(i * 1000)),
                                     callParticipantCount: Int(arc4random_uniform(102)),
                                     group: .call))
            
        }
        
        return data
    }
    
    static func randomPresence() -> UTPresenceState{
        let rand = Int(arc4random_uniform(UInt32(12)))
        
        if rand == 0 {
            return .active
        }
        else if rand == 1 {
            return .call
        }
        else if rand == 2 {
            return .dnd
        }
        else if rand == 3 {
            return .meeting
        }
        else if rand == 4 {
            return .none
        }
        else if rand == 5 {
            return .pto
        }
        else if rand == 6 {
            return .quiet
        }
        else if rand == 7 {
            return .recents
        }
        else if rand == 8 {
            return.screenShare
        }
        else if rand == 9 {
            return .scheduleMeeting
        }
        
        return .none
    }
    
    override func buildMenu(menu:NSMenu, sel:Selector) {
        if group == .favourite {
            menu.addItem(NSMenuItem(title: "Unfavourite", action: sel, keyEquivalent: ""))
        }
        else {
            menu.addItem(NSMenuItem(title: "Favourite", action: sel, keyEquivalent: ""))
        }
        
        menu.addItem(NSMenuItem(title: "Peek", action: sel, keyEquivalent: ""))
    }

}

class TestTeamData {
    
    var teamId:String
    var teamName:String
    var lightColor:CCColor
    var darkColor:CCColor
    
    var color:CCColor {
        return UIToolkit.shared.getThemeManager().isDarkTheme() ? darkColor : lightColor
    }
    
    public init(teamId:String, teamName:String, lightColor:CCColor, darkColor:CCColor){
        self.teamId     = teamId
        self.teamName   = teamName
        self.lightColor = lightColor
        self.darkColor  = darkColor
    }
    
    static var teams:[TestTeamData] = [
        TestTeamData(teamId: "Team1", teamName: "AppTastic Feature Delivery Discussion Spaces", lightColor: CCColor.getColorFromHexString(hexString: "A12A3A"), darkColor: CCColor.getColorFromHexString(hexString: "FC97AA")),
        TestTeamData(teamId: "Team2", teamName: "Team name 2", lightColor: CCColor.getColorFromHexString(hexString: "066070"), darkColor: CCColor.getColorFromHexString(hexString: "22C7D6")),
        TestTeamData(teamId: "Team3", teamName: "Team name 3", lightColor: CCColor.getColorFromHexString(hexString: "735107"), darkColor: CCColor.getColorFromHexString(hexString: "D6B220")),
        TestTeamData(teamId: "Team4", teamName: "Team name 4", lightColor: CCColor.getColorFromHexString(hexString: "416116"), darkColor: CCColor.getColorFromHexString(hexString: "93C437")),
        TestTeamData(teamId: "Team5", teamName: "Team name 5", lightColor: CCColor.getColorFromHexString(hexString: "12615A"), darkColor: CCColor.getColorFromHexString(hexString: "30C9B0"))
    ]
    
    static func randomTeamData() -> TestTeamData{
        let rand = Int(arc4random_uniform(UInt32(self.teams.count - 1)))
        return teams[rand]
    }
    
    static func randomTeamOrNil() -> TestTeamData?{
        let rand = Int(arc4random_uniform(UInt32(self.teams.count + 4)))
        
        if rand >= teams.count{
            return nil
        }
        
        return teams[rand]
    }
}

class TestSpaceHeader : TestSpaceListDataBase{
    var title:String
    var isExpanded:Bool
    
    init(expanded:Bool, group:TestSpaceGroup) {
        self.isExpanded = expanded        
        
        if group == .call {
            title = "Calls"
        }
        else if group == .favourite {
            title = "Favourites"
        }
        else {
            title = "Other spaces"
        }
        
        super.init(group: group)
    }
}

enum TestSpaceGroup : UInt{
    
    case call
    case favourite
    case normal
}
