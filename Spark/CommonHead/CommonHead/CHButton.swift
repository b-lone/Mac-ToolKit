// DO NOT EDIT - Auto generated
// Generated with swift_model.j2

import Foundation

@objcMembers
@objc open class CHButton: CHControl {

    public private(set) var buttonState: CHButtonState
    public private(set) var text: String

    public init(
        buttonState: CHButtonState,
        text: String,
        isHidden: Bool,
        isEnabled: Bool,
        tooltip: String)
    {
        self.buttonState = buttonState
        self.text = text
        super.init(isHidden: isHidden, isEnabled: isEnabled, tooltip: tooltip)
    }
}
