// DO NOT EDIT - Auto generated
// Generated with swift_model.j2

import Foundation

@objcMembers
open class CHResumeShareControlBarInfo: NSObject {

    public private(set) var show: Bool
    public private(set) var message: String
    public private(set) var stressedMessage: String
    public private(set) var okButton: CHButton
    public private(set) var resumeButton: CHButton

    public init(
        show: Bool,
        message: String,
        stressedMessage: String,
        okButton: CHButton,
        resumeButton: CHButton)
    {
        self.show = show
        self.message = message
        self.stressedMessage = stressedMessage
        self.okButton = okButton
        self.resumeButton = resumeButton
        
    }
}
