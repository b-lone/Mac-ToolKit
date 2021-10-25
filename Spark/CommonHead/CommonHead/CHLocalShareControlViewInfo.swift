// DO NOT EDIT - Auto generated
// Generated with swift_model.j2

import Foundation

@objcMembers
open class CHLocalShareControlViewInfo: NSObject {

    public private(set) var labelInfo: CHLocalShareControlViewLabelInfo
    public private(set) var recordingState: CHMeetingRecordingState
    public private(set) var recordingSvgLabel: CHLabel
    public private(set) var meetingLockedLabel: CHLabel
    public private(set) var shareTitleButton: CHButton
    public private(set) var rdcButton: CHButton
    public private(set) var annotateButton: CHButton
    public private(set) var pauseButton: CHButton
    public private(set) var stopButton: CHButton
    public private(set) var showPreviewView: Bool

    public init(
        labelInfo: CHLocalShareControlViewLabelInfo,
        recordingState: CHMeetingRecordingState,
        recordingSvgLabel: CHLabel,
        meetingLockedLabel: CHLabel,
        shareTitleButton: CHButton,
        rdcButton: CHButton,
        annotateButton: CHButton,
        pauseButton: CHButton,
        stopButton: CHButton,
        showPreviewView: Bool)
    {
        self.labelInfo = labelInfo
        self.recordingState = recordingState
        self.recordingSvgLabel = recordingSvgLabel
        self.meetingLockedLabel = meetingLockedLabel
        self.shareTitleButton = shareTitleButton
        self.rdcButton = rdcButton
        self.annotateButton = annotateButton
        self.pauseButton = pauseButton
        self.stopButton = stopButton
        self.showPreviewView = showPreviewView
        
    }
}
