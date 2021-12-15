//
//  CoreFramework.swift
//  Mac-ToolKit
//
//  Created by Archie You on 2021/10/28.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Foundation
class SparkFeatureFlagsProxy: NSObject {
    func isSharingControlBarDraggableEnabled() -> Bool {
        return true
    }
}

class TelephonyServiceProxy: NSObject {
    func updateViewHandle(forCallId: String, layer: SparkVideoLayer, byTrackType: Int) {
        SPARK_LOG_DEBUG("")
    }
    
    func removeViewHandle(forCallId: String, layer: SparkVideoLayer, byTrackType: Int) {
        SPARK_LOG_DEBUG("")
    }
}

class CoreFrameworkProxy: NSObject {
    var sparkFeatureFlagsProxy = SparkFeatureFlagsProxy()
    var telephonyServiceProxy = TelephonyServiceProxy()
    
    func getConfigValue(_ key: String) -> String? {
        return "true"
    }
}

@objc public enum TrackVMType:NSInteger {
    
    case unknown = 0
    case local
    
    // remote track types
    case remote
    case remoteAux1
    case remoteAux2
    case remoteAux3
    case remoteAux4
    case remoteAux5
    case remoteAux6
    case remoteAux7
    case remoteAux8
    case remoteAux9
    case remoteAux10
    case remoteAux11
    case remoteAux12
    case remoteAux13
    case remoteAux14
    case remoteAux15
    case remoteAux16
    case remoteAux17
    case remoteAux18
    case remoteAux19
    case remoteAux20
    case remoteAux21
    case remoteAux22
    case remoteAux23
    case remoteAux24
    
    // here more remote auxiliary track type can be added
    case localShare
    case remoteShare
    
    
    //for enumeration
    static let auxTracks = [remote, remoteAux1, remoteAux2, remoteAux3, remoteAux4]
    
    static let strings = [
        unknown:"Unknown",
        local:"Local",
        remote:"Remote",
        remoteAux1:"RemoteAux1",
        remoteAux2:"RemoteAux2",
        remoteAux3:"RemoteAux3",
        remoteAux4:"RemoteAux4",
        remoteAux5:"RemoteAux5",
        remoteAux6:"RemoteAux6",
        remoteAux7:"RemoteAux7",
        remoteAux8:"RemoteAux8",
        remoteAux9:"RemoteAux9",
        localShare:"LocalShare",
        remoteShare:"RemoteShare"]
    
 
    var description:String {
        get {
            return TrackVMType.strings[self] ?? "Default"
        }
    }
}


public class ConfigKeys: NSObject {
    

    @objc public static let resetTutorialFlag = "desktop-tutorial-reset"
    @objc public static let outOfProcMediaEngine = "desktop-mac-outofprocess-media"
    @objc public static let autoStartupConfigured = "autoStartupConfigured"
    public static let isMenuExpanded = "isMenuExpanded"
    public static let shownLookupServiceWarning = "shownLookupServiceWarning"
    public static let isMessagesSoundNotificationsEnabled = "MessagesSoundNotificationsEnabled"
    public static let isCallsNotificationsEnabled = "CallsNotificationsEnabled"
    public static let incomingCallAlertSound = "IncomingCallAlertSound"
    public static let callSoundNotificationsEnabled = "desktop-call-sound-notifications"
    public static let incomingCallAlertConfig = "incoming-call-alert-sound" // align with Windows, when set multiline ringtone, will set key like "incoming-call-alert-sound_1"
    public static let isCallsSoundNotificationsEnabled = "CallsSoundNotificationsEnabled"
    public static let isRoomsExpanded = "isRoomsExpanded"
    public static let isTeamsExpanded = "isTeamsExpanded"
    public static let localProximity = "local-proximity-enabled"
    public static let localAutoConnect = "local-auto-endpoint-connection-enabled"
    public static let localWifiProximity = "wifi-proximity-permitted-by-user"
    @objc public static let resetDatabaseFlag = "desktop-database-reset"
    

    @objc public static let directMessageNotifications = "direct-message-notifications"
    @objc public static let groupMessageNotifications = "group-message-notifications"
    @objc public static let mentionNotifications = "mention-notifications"
    @objc public static let desktopPairingOutOfProcess =  "desktop-client-pairing-out-process"
    

    public static let meetingNotificationsEnabled = "meeting-notifications-enabled"
    public static let notifyMinutesBeforeMeeting = "scheduled-meeting-notifications-timer"
    public static let LocalRecordingPreferenceSetting = "desktop-local-recording-preference"
    public static let IsLocalRecordingPreferenceSet = "isLocalRecordingPreferenceSet"
    public static let multitaskingWindowEnabled = "multitasking-window-preference"
  
    public static let desktopWirelessShare   = "desktop-wireless-share"
    public static let desktopWifiSearch = "desktop-proximity-wifi"
    
    public static let cloudPairedVideoToggle = "desktop-paired-video-toggle"

    public static let spellCorrectionEnabled = "desktop-spell-correction-enabled"
    public static let grammarCheckingEnabled = "desktop-grammar-checking-enabled"
    public static let continuousSpellCheckingEnabled = "desktop-continuous-spell-checking-enabled"
    
    public static let meetingVideoBackgroundImage = "meeting-video-background-image"
    
    // new room filtering
    public static let startupRoomFilterSelection = "default-startup-rooms-filter-selection"
    public static let roomsAll = "Rooms-all"
    // Outlook integration
    public static let officeServiceEnabled = "desktop-office-integration"
    // themes
    public static let isDarkThemeEnabled = "desktop-ax-dark-mode"
    public static let isLightThemeEnabled = "desktop-ax-light-mode"
    // connect people - invite flow
    public static let connectPeopleEnabled = "desktop-ux-connect-pre-production"
    // tasks
    public static let isSparkNotesEnabled = "mac-notes-tasks"

    @objc public static let inviteToolbarButtonEnabled = "mac-invite-toolbar-button-enabled"

    //hang detection
    public static let hangDetectionSettingEnabled = "desktop-hang-detection-enabled"
    
    public static let desktopPstnEnabled = "desktop-pstn-enabled"
    public static let desktopInternalPstnEnabled = "desktop-internal-pstn-enabled"
    
    public static let desktopEnumeratedWhiteboardShareOption = "desktop-enumerated-whiteboard-share-option"
    
    // announcement spaces
    @objc public static let isAnnouncementSpacesEnabled = "desktop-announcement-spaces"
    
    @objc public static let isGroupMentionAllEnabled = "desktop-group-mention-all"
    //connectivity banner keys
    public static let isConnectivityBannerEnabled = "desktop-conban-enabled"
    
    public static let desktopRichtextEnabled = "desktop-compose-rich-text"
        
    //auto-connect device
    public static let disableAutoConnectAlert = "desktop-auto-connect-alert-disabled"
    
    //device only mode
    public static let desktopDeviceOnlyMode = "desktop-modular-client-devices-only"
    
    //meet only mode
    public  static let desktopMeetModeOnlyMode = "desktop-meet-only-mode-enabled"
    
    //mute from share border
    public static let muteInShareBorder = "desktop-mute-from-border"

    public static let chRosterVM = "desktop-ch-roster-vm"

    public static let isUnfurlEnabled = "desktop-preview-url-with-policy"
    
    public static let ishighContastSettingEnabled = "desktop-high-contrast-setting"

    public static let isNewSpaceIndicatorEnabled = "desktop-ia-new-space-indicator"
    
    @objc public static let conversationRefreshEnabled = "desktop-conversation-refresh-enabled"
     
    public static let isDesktopRightMenusEnabled = "desktop-right-menus"
    
    public static let isIncognitoFeatureEnabled = "desktop-incognito-menu"
    
    public static let isIncognitoSetting =  "incognito-mode-setting"
    
    public static let isIMOnlyMode = "desktop-im-only-mode"
    
    public static let isDesktopRichTextAllowPasteEnabled = "desktop-rich-text-allow-paste"
    
    public static let isDesktopAddMultiplePeopleSpaceEnabled = "desktop-add-multiple-people-space"
    
    public static let isPinFavoritesEnabled = "IsPinFavoritesEnabled"
    
    public static let ProtocolHandlerKey = "ProtocolHandlerKey"
    
    public static let customUpgradeChannelName = "desktop-custom-upgrade-channel-name"
    
    public static let selectSpaceToBind = "select-space-to-bind"
    
    public static let hideSpacesEnabled = "desktop-ignore-spaces-enabled"
    
    public static let persistDraftsEnabled = "persist-drafts"
    
    public static let desktopLocalCalendarEnabled = "desktop-local-calendar"
    
    public static let macLocalCalendarForce = "mac-local-calendar-force"

    public static let hasSeenAddCalendarsView = "has-seen-add-calendars-view"

    public static let sendCallLogToMailer = "send-call-log-to-mailer"
    
    public static let traceLevelLogEnabled = "desktop-tracelevel-log-enabled"
    
    public static let showCrossLaunchMenuItemToggle = "desktop-show-cross-launch-meeting-enabled"
    public static let showDebugWebexCenterMenuItemToggle = "desktop-show-debug-cross-launch-meeting-enabled"
    
    public static let crossLaunchMeetingToggle = "dev-mode-desktop-webex-cross-launch"
    public static let debugMeetingCenterToggle = "dev-mode-debug-webex-cross-launch"
    public static let shareWindowFteReaded = "share-window-fte-readed"
    public static let excludeWindowFromShareEnabled = "exclude-window-from-share-enabled-dev"
    public static let excludeWindowFromShareToggle = "exclude-window-from-share-toggle-dev"
    public static let toggler = "mac-toggler-dev"
    public static let localShareControlBarMoveDown = "mac-local-share-control-bar-move-down"
    public static let sharingCaptureBorderRefactor = "mac-sharing-capture-border-refactor-dev"
    public static let macWebExCrossLaunchToggle = "desktop-mac-optional-webex-meetings-ga"
    
    public static let spaceTabsEnabled = "mac-space-tabs-enabled"
    
    public static let voicemailEnabled = "mobile-cucm-visual-voicemail-enabled-ga"
        
    public static let voicemailTrashEnabled = "mobile-cucm-voicemail-trash-enabled"

    public static let showDetailedErrorMessages = "desktop-show-detailed-errors"

    public static let callPickupNotificationMuted = "call_pickup_notification_muted"
    
    public static let userPresenceEnabled = "user-presence-enabled"
    public static let chooseRenderControllerTypeEnabled = "mac-choose-render-controller-type-enabled"
    
    public static let shouldContinueMigration = "ShouldContinueMigration"
    public static let WebexRestartedByMigration = "WebexRestartedByMigration"
    
    public static let supportUCLoginBySafariVC = "mobile-cucm-support-external-browser-enabled-ga"

    public static let callParkExpiredNotificationMuted = "call_park_expired_notification_muted"
    
    // Layout
    public static let macMediaAdaptiveLayoutForStageEnabled = "mac-media-adaptive-layout-for-stage-enabled-dev"
    public static let macMediaDraggableStageEnabled = "mac-media-draggable-stage-enabled-dev"
    public static let macParticipantStreamUpdateType = "mac-pariticipant-stream-update-type-dev"
    public static let macMediaPaginationEnabled = "mac-media-pagination-enabled-dev"
    public static let macMediaUnifySubscribeManagerEnabled = "mac-media-unify-subscribe-manager-enabled-dev"
    public static let macMediaViewModelPaginationEnabled = "mac-media-view-model-pagination-enabled-dev"
    public static let macMediaDragEnabled = "mac-media-drag-enabled-dev"
    public static let macMediaDoubleClickEnabled = "mac-media-double-click-enabled-dev"
    public static let macMediaLocalStageEnabled = "mac-media-local-stage-enabled-dev"
    public static let macMediaEnhancedFilmstripEnabled = "mac-media-enhanced-filmstrip-enabled-dev"
    public static let macMediaPaginationCount = "mac-media-pagination-count-dev"
    public static let macMediaCollectionViewAnimationEnabled = "mac-media-collection-view-animation-enabled-dev"
    public static let enhancedMeetingQualityIndicatorEnabled = "desktop-meeting-enhanced-quality-indicator-enabled"

    // New meeting plist
    public static let newMeetingParticipantListEnabled = "desktop-new-meeting-participant-list-enabled-ga"
    public static let newMeetingParticipantListToggleEnabled = "mac-new-meeting-participant-list-toggle-enabled"
    
    // render multiple videos in one view
    public static let renderMultiVideosInOneViewEnabled = "desktop-render-multi-videos-in-one-view-enabled"
    
    // Call audio player
    public static let callAudioPlayerEnabled = "desktop-call-audio-player-enabled"
    
    // unified meeting
    public static let useUnifiedMeetingEnabled = "desktop-meeting-wbxappapi-meetinginfo-enabled-ga"
    public static let useUnifiedMeetingToggleEnabled = "mac-meeting-wbxappapi-meetinginfo-toggle-enabled"
    
    //Switch audio
    public static let switchAudioEnabled = "desktop-switch-audio-enabled-ga"
    public static let newCallMeControlEnabled = "desktop-new-callme-control-enabled-ga"
    
    // native messaging
    public static let macNativeMessageCacheThumbnailsEnabled = "mac-native-message-cache-thumbnails-enabled"
    
    public static let removeDuplicatedInterstitialVMInit = "desktop-mac-remove-duplicated-isvm-dev"
    
    public static let press1Enabled = "desktop-press-one-enabled"

    @objc public static let resetWebviewAfterSleep = "desktop-mac-reset-webview-after-sleep"
    @objc public static let heapUsageCheck = "desktop-client-feedback-heap-usage"
    @objc public static let periodicHeapUsageCheck = "periodic-desktop-client-heap-usage"
}

public class Constants : NSObject {
    
    public static let defaultAvatar80 = "DefaultAvatar80"
    public static let defaultAvatar240 = "DefaultAvatar240"
    // TBD: temporarilly use the existing ones
    public static let defaultPhysicalRoomAvatar80 = "MeetingRoomAvatar80"
    public static let defaultPhysicalRoomAvatar240 = "MeetingRoomAvatar240"
    public static let defaultTPAvatar80 = "TPEndpointAvatar80"
    public static let defaultTPAvatar240 = "TPEndpointAvatar240"
    public static let defaultTelephoneAvatar80 = "HeadsetAvatar80"
    public static let defaultTelephoneAvatar240 = "HeadsetAvatar240"
    
    @objc public static let defaultImageIcon = "icn-file-jpg"
    
    public static let maxWindowSizeWidth:CGFloat = 7680
    public static let maxWindowSizeHeight:CGFloat = 4800
    public static let minWindowSizeWidth:CGFloat = 800
    public static let minWindowSizeHeight:CGFloat = 450
    
    public static let loginWindowWidth:CGFloat = 1200
    public static let loginWindowHeight:CGFloat = 720

    public static let compactMainWindowWidth: CGFloat = 464
    public static let compactMainWindowNoHubWidth: CGFloat = 396
    public static let compactMainWindowHeight: CGFloat = 683

    public static let boundaryWidthSizeOfCompactStyle: CGFloat = 1000
    
    // Health Checker
    public static let resetCoachmarks = NSLocalizedStringHelper("Reset Coachmarks", comment: "Reset Coachmarks")
    public static let statusLink = "https://status.ciscospark.com"
    
    public static let applicationLifecycle =  "applicationLifecycle"
 
    public static let atlanticFont = "atlantic-neo-icons"
    public static let atlanticIllustrations = "atlantic-illustrations"
    public static let momentumIconFont = "momentum-ui-icons"
    public static let momentumRebrandIconFont = "momentum-ui-icons-rebrand"
    
    public static let ciscoSansRegular = "CiscoSansTT"
    public static let ciscoSansLight   = "CiscoSansTTLight"
    public static let ciscoSansMedium  = "CiscoSansTT-Medium"
    public static let CiscoSansBold    = "CiscoSansTT-Bold"
    
    // Remote Work Popover
    public static let remoteWorkStringURL = "https://www.webex.com/best-practices/teams.html"
    
    // Help
    public static let helpCenterUrl = "https://help.webex.com/ld-n0bl93g-CiscoWebexTeams/Webex-Teams-App?omiReferProduct=WebexTeams"
    public static let webexOnlineUrl = "https://web.webex.com"
    public static let helpCenterShortcutsUrl = "https://help.webex.com/en-us/7wr87q/Webex-Keyboard-Navigation-and-Shortcuts"
    
    // Blockers Identifiers (the reason that a component can block an auto update)
    public static let blockForActiveWindow     = "activeWindow"
    public static let blockForScreenCapture    = "screenCapture"
    public static let blockForCall             = "call"
    public static let blockForFileUpload       = "fileUpload"
    public static let blockForInputBoxText     = "inputBoxHasText"
        
    public static func isWhiteSpace(_ ch: unichar) ->Bool {
        // characters outside this range may crash the conversion to UnicodeScalar - and this can happen for Emojis
        if (ch < 0 || ch > 0xD7FF) {
            return false
        }
        
        return (UnicodeScalar(ch) == UnicodeScalar(" ")) || (UnicodeScalar(ch) == UnicodeScalar("\n")) || (UnicodeScalar(ch) == UnicodeScalar("\r")) || (UnicodeScalar(ch) == UnicodeScalar("\t"))
    }
  
    //meeting capacity section
    public static let maximumDefaultMeetingCapacity: Int = 200
 
    // Richtext font sizes
    public static let defaultFontSize:CGFloat = 14.0
    public static let h1FontSize:CGFloat = 24.0
    public static let h2FontSize:CGFloat = 20.0
    public static let h3FontSize:CGFloat = 16.0
    public static let AppleEmojiFont:String = ".AppleColorEmojiUI"
    
    public static let messsageInputButtonSize:CGFloat = 22.0
    public static let richTextButtonHeight:CGFloat = 22.0
    public static let richTextButtonWidth:CGFloat = 34.0
    
    public static let rotationKeyPath = "transform.rotation"
    
    public static let forceFeatureUpgradeEnabled = "ForceFeatureUpgradeEnabled"
    public static let featureUpgradeEnabled = "FeatureUpgradeEnabled"
    public static let desktopMigrationFromJabberEnabled = "DesktopMigrationFromJabberEnabled"
    public static let browserLaunchMeetingEnabled = "BrowserLaunchMeetingEnabled"
    public static let momentumThemeIsEnabled = "MomentumThemeIsEnabled"
    public static let momentumThemeFeatureFlagEnabled = "MomentumThemeFeatureFlagEnabled"
    
    public static let ciscoSansEnabled = "CiscoSansEnabled"
    public static let highlightsIconName = "Highlights_120"
    public static let highlightsCoverGraphicDarkModeName = "HighlightsCoverGraphicDM_2x"
    
    @objc public static let groupMentionParticipantCountWarningSize:Int = 5
    
    // Send space feedback component constants
    public static let messaging = "Messaging"
    public static let meetings = "Meetings"
    public static let callingLocusUCM = "Calling (Locus & UCM)"
    public static let pairingAndDevices = "Pairing and Devices"
    public static let webexCallingBroadCloud = "Webex Calling (BroadCloud)"
    
    // choose render controller type
    public static let openGL = "openGL"
    public static let metal = "metal"
    public static let newMetal = "newMetal"
    
    public static let loginBGImageLight = "login_background_light"
    public static let loginBGImageDark  = "login_background_dark"
    public static let loginRebrandImage = "webex-logo-color"
    public static let rebrandFeatureSetVersion = 7
    public static let ringerVolume = "ringerVolume"
    public static let AllRingerDevicesVolume = "AllRingerDevicesVolume"
    
    public static let reactionGifAnimationDuration: Double = 1.8
}

@objc protocol AppMenuCallsProtocol {
    func appMenuStartCall()
    func appMenuStartVideoCall()
    func appMenuEndCall()
    func appMenuToggleAudioMute()
    func appMenuToggleVideoMute()
    func appMenuStartShare()
    func appMenuStopShare()
    func appMenuStartAnnotation()
    func appMenuStopAnnotation()
    func appMenuToggleMeetingControls()
    func appMenuAnswerCall()
    func appMenuDeclineCall()
}
