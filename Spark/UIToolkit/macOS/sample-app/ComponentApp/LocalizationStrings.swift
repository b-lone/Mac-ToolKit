//
//  LocalizationStrings.swift
//  ComponentApp
//
//  Created by James Nestor on 17/06/2021.
//

import Foundation
import UIToolkit

func getAppDisplayName() -> String {
    return "Webex"
}

func NSLocalizedStringHelper(_ value: String,comment: String) -> String {
    return NSLocalizedString(value, bundle: UIToolkit.shared.localizationManager.getLanguageBundle(),  comment:comment)
}

func NSLocalizedStringWithArgsHelper(_ value: String,comment: String, args: CVarArg...) -> String {
    return String(format:  NSLocalizedStringHelper(value, comment: comment), arguments: args)
}

@objc public class LocalizationStrings: NSObject{
    
    public static var freeCallUserTitle:String { NSLocalizedStringHelper("Make a call or join a meeting",comment: "") }
    public static var freeCallUserCallDetail:String { NSLocalizedStringWithArgsHelper("To call another person who uses %@, type their name or email in the search bar.", comment: "", args: getAppDisplayName()) }
    public static var freeCallUserMeetingDetail:String { NSLocalizedStringHelper("To join a meeting, type or paste the address, such as conf_room123@example.com.",comment: "") }
    
    public static var alertTwoLineText:String { NSLocalizedStringHelper("Lorem ipsum dolor site aw aetns ctetuer adipiscing elit nullam amarte.",comment: "") }
    
    public static var error:String { NSLocalizedStringHelper("Error",comment: "") }
    public static var warning:String { return NSLocalizedStringHelper("Warning",comment: "") }
    public static var success:String { NSLocalizedStringHelper("Success",comment: "") }
    public static var generalInfo:String { NSLocalizedStringHelper("General announcement", comment: "") }
    public static var transientState:String { NSLocalizedStringHelper("Transient state...", comment: "") }
    public static var alertLabel:String { NSLocalizedStringHelper("Alert label", comment: "") }
    public static var errorPasswordMsg:String { NSLocalizedStringHelper("Enter a valid password",comment: "") }
    
    public static var yesterday:String { NSLocalizedStringHelper("Yesterday",comment: "") }
    
    public static var createToast:String { NSLocalizedStringHelper("Create toast",comment: "") }
    public static var createTextToast:String { NSLocalizedStringHelper("Create text toast",comment: "") }
    
    public static var meetingReminder:String { NSLocalizedStringHelper("Meeting Reminder",comment: "") }
    public static var meetingName:String { NSLocalizedStringHelper("Meeting name",comment: "") }
    public static var spaceName:String { NSLocalizedStringHelper("Space name",comment: "") }
    public static var now:String { NSLocalizedStringHelper("now",comment: "") }
    public static var incomingCall:String { NSLocalizedStringHelper("Incoming call",comment: "") }
    
    public static var createMeetingReminderToast:String { NSLocalizedStringHelper("Meeting reminder toast",comment: "") }
    public static var createMeetingInfoToast:String { NSLocalizedStringHelper("Meeting info toast",comment: "") }
    public static var callToast:String { NSLocalizedStringHelper("Call toast",comment: "") }
    
    public static var join:String { NSLocalizedStringHelper("Join",comment: "") }
    public static var answer:String { NSLocalizedStringHelper("Answer",comment: "") }
    public static var decline:String { NSLocalizedStringHelper("Decline",comment: "") }
    public static var message:String { NSLocalizedStringHelper("Message",comment: "") }
        
    public static var onePersonWaitingToJoin:String { NSLocalizedStringHelper("One person is waiting to join.",comment: "") }
}
