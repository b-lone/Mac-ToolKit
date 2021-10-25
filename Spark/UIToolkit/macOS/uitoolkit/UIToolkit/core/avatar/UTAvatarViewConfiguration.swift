//
//  UTAvatarViewConfiguration.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 16/06/2021.
//

import Foundation
import Cocoa


public enum AvatarType {
    case image
    case initialsWithBackground
    case lockedIconWithBackground
    case pair
    case defaultAvatar
    case messageSentBySelf
    case defaultExConferenceAvatar
    case meetingIcon
    case unknown
}


/**
 A protocol to specify the configuration of the `AvatarImageView`. A struct called `DefaultConfiguration` is provided and set on the `AvatarImageView` by default.
 */
public protocol AvatarImageViewDataSourceProtocol {

    
    /// The user's name. This will be used to generate the initials.
    var name: String { get }
    
    /// The user's profile picture. If this is nil, the user's initials will be set.
    var avatar: NSImage? { get set}
    
    /**
     The background color for the initials. This value DOES NOT set the background color of the image view.<br />
     If this is nil, the configuration's `bgColor` will be used. If that is also nil, a random color will be generated.
     */
    var bgColor: NSColor? { get }
    
    /// If you prefer to specify your own initials, implement this field.
    var initials: String { get }
   
    var avatarId: String { get set }
    
    var isTyping: Bool {get }
    
    var isBot: Bool { get }
    
    var avatarType: AvatarType { get }
    
    var size: UTAvatarView.Size { get }
    
    var presenceState: UTPresenceState { get set}
    
    var useSingleInitial: Bool { get }

}

public class AvatarImageViewDataSource : AvatarImageViewDataSourceProtocol {
    

    public var name:String
    public var avatarId:String
    public var avatar: NSImage?
    public var bgColor: NSColor?
    public var isBot: Bool = false
    public var isTyping: Bool = false
    public var avatarType: AvatarType = .unknown
    public var size:UTAvatarView.Size = .medium
    public var presenceState:UTPresenceState = .none
    public var useSingleInitial:Bool = false
    
    public convenience init(presenceState:UTPresenceState = .none, size:UTAvatarView.Size,  name:String, bgColor:NSColor?, useSingleInitial: Bool = false) {
        self.init(presenceState:presenceState, size:size, avatarType: .initialsWithBackground, avatarId: "", name:name, avatar:nil, bgColor:bgColor, useSingleInitial:useSingleInitial)
    }
    
    public convenience init(presenceState:UTPresenceState = .none, size:UTAvatarView.Size, avatar: NSImage) {
        self.init(presenceState:presenceState, size:size, avatarType: .image, avatarId: "", name:"", avatar:avatar, bgColor:nil)
    }
    
    public class func initLockAvatar(size:UTAvatarView.Size) -> AvatarImageViewDataSourceProtocol{
        return AvatarImageViewDataSource(presenceState: .none, size: size, avatarType: .lockedIconWithBackground, avatarId: "", name: "", avatar: nil, bgColor: nil)
    }
    
    public class func initSelfMessage(size:UTAvatarView.Size) -> AvatarImageViewDataSourceProtocol{
        return AvatarImageViewDataSource(presenceState: .none, size: size, avatarType: .messageSentBySelf, avatarId: "", name: "", avatar: nil, bgColor: nil)
    }
    
    public class func initPairAvatar(size:UTAvatarView.Size) -> AvatarImageViewDataSourceProtocol{
        return AvatarImageViewDataSource(presenceState: .none, size: size, avatarType: .pair, avatarId: "", name: "", avatar: nil, bgColor: nil)
    }
    
    public class func initDefaultExConferenceAvatar(size:UTAvatarView.Size) -> AvatarImageViewDataSourceProtocol{
        return AvatarImageViewDataSource(presenceState: .none, size: size, avatarType: .defaultExConferenceAvatar, avatarId: "", name: "", avatar: nil, bgColor: nil)
    }

    public class func initMeetingIconAvatar(size: UTAvatarView.Size) -> AvatarImageViewDataSourceProtocol{
        return AvatarImageViewDataSource(presenceState: .none, size: size, avatarType: .meetingIcon, avatarId: "", name: "", avatar: nil, bgColor: nil)
    }
    
    private init(presenceState:UTPresenceState, size:UTAvatarView.Size, avatarType:AvatarType, avatarId: String, name:String, avatar:NSImage?, bgColor:NSColor?, isBot:Bool = false, isTyping:Bool = false, useSingleInitial:Bool = false) {
        self.presenceState = presenceState
        self.size = size
        self.name = name
        self.avatar = avatar
        self.bgColor = bgColor
        self.isBot = isBot
        self.isTyping =  isTyping
        self.avatarType = avatarType
        self.avatarId = avatarId
        self.useSingleInitial = useSingleInitial
    }
}

public extension AvatarImageViewDataSourceProtocol {
    /// returns `""`
    var name: String {
        get {
            return ""
        }
    }
    
    /// returns `nil`
//    var avatar: NSImage? {
//        get {
//            return nil
//        }
//    }
    
    /// returns `nil`
    var bgColor: NSColor?{
        get {
            return nil
        }
    }
    
    /// returns `nil`
    var isTyping: Bool{
        get {
            return false
        }
    }
    
    var isBot: Bool{
        get {
            return false
        }
    }

     
    var initials: String {
        get {
            guard name.count > 0 else {
               // assert(false, "missing initals")
                return "?"
            }
            
            var initials = ""
            if useSingleInitial {
                if let firstName = name.first {
                    initials.append(firstName)
                }
            } else {
                var nameArray = name.components(separatedBy: " ")
                if let firstName = nameArray.first,
                    let lastName = nameArray.last
                    , nameArray.count > 2 {
                    nameArray = [firstName, lastName]
                }
                
                nameArray.forEach { element in
                    if let firstLetter = element.first {
                        initials.append(firstLetter)
                    }
                }
            }
            
            return initials.uppercased()
            
        }
    }
}
