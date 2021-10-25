// DO NOT EDIT - Auto generated
// Generated with swift_model.j2

import Foundation

@objcMembers
open class CHLocalShareControlBarInfo: NSObject {

    public private(set) var windowInfo: CHLocalShareControlWindowInfo
    public private(set) var viewInfo: CHLocalShareControlViewInfo
    public private(set) var isSharePaused: Bool
    public private(set) var isImOnlyShareForAccept: Bool

    public init(
        windowInfo: CHLocalShareControlWindowInfo,
        viewInfo: CHLocalShareControlViewInfo,
        isSharePaused: Bool,
        isImOnlyShareForAccept: Bool)
    {
        self.windowInfo = windowInfo
        self.viewInfo = viewInfo
        self.isSharePaused = isSharePaused
        self.isImOnlyShareForAccept = isImOnlyShareForAccept
        
    }
}
