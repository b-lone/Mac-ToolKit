// DO NOT EDIT - Auto generated
// Generated with swift_model.j2

import Foundation

@objcMembers
@objc open class CHShareNotification: NSObject {

    public private(set) var action: CHNotificationActionType
    public private(set) var notificationType: CHShareNotificationType
    public private(set) var message: String
    public private(set) var stressedMessage: String
    public private(set) var actions: [CHButton]

    public init(
        action: CHNotificationActionType,
        notificationType: CHShareNotificationType,
        message: String,
        stressedMessage: String,
        actions: [CHButton])
    {
        self.action = action
        self.notificationType = notificationType
        self.message = message
        self.stressedMessage = stressedMessage
        self.actions = actions
        
    }
}
