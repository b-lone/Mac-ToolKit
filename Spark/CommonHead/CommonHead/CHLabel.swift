// DO NOT EDIT - Auto generated
// Generated with swift_model.j2

import Foundation

@objcMembers
open class CHLabel: CHControl {

    public private(set) var text: String

    public init(
        text: String,
        isHidden: Bool,
        isEnabled: Bool,
        tooltip: String)
    {
        self.text = text
        super.init(isHidden: isHidden, isEnabled: isEnabled, tooltip: tooltip)
    }
}
