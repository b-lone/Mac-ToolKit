// DO NOT EDIT - Auto generated
// Generated with swift_model.j2

import Foundation

@objcMembers
open class CHSharingContent: NSObject {

    public private(set) var sourceType: CHSourceType
    public private(set) var captureRect: CHRect
    public private(set) var shareSourceList: [CHShareSource]
    public private(set) var capturedWindows: [String]

    public init(
        sourceType: CHSourceType,
        captureRect: CHRect,
        shareSourceList: [CHShareSource],
        capturedWindows: [String])
    {
        self.sourceType = sourceType
        self.captureRect = captureRect
        self.shareSourceList = shareSourceList
        self.capturedWindows = capturedWindows
        
    }
}
