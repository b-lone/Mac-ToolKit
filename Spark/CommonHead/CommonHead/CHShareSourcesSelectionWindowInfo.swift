// DO NOT EDIT - Auto generated
// Generated with swift_model.j2

import Foundation

@objcMembers
@objc open class CHShareSourcesSelectionWindowInfo: NSObject {

    public private(set) var shareOptionsButton: CHButton
    public private(set) var showOptimizeForShare: Bool
    public private(set) var optimizeForShareInfo: [CHMenuItem]
    public private(set) var showShareAudio: Bool
    public private(set) var shareAudioInfo: CHMenuItem
    public private(set) var isShareIndividualWindowEnabled: Bool

    public init(
        shareOptionsButton: CHButton,
        showOptimizeForShare: Bool,
        optimizeForShareInfo: [CHMenuItem],
        showShareAudio: Bool,
        shareAudioInfo: CHMenuItem,
        isShareIndividualWindowEnabled: Bool)
    {
        self.shareOptionsButton = shareOptionsButton
        self.showOptimizeForShare = showOptimizeForShare
        self.optimizeForShareInfo = optimizeForShareInfo
        self.showShareAudio = showShareAudio
        self.shareAudioInfo = shareAudioInfo
        self.isShareIndividualWindowEnabled = isShareIndividualWindowEnabled
        
    }
}
