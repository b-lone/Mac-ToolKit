//
//  NotificationEventNames.m
//  SparkMacDesktop
//
//  Created by jimmcoyn on 18/08/2015.
//  Copyright © 2015 Cisco Systems. All rights reserved.
//

#import "NotificationEventNames.h"

@implementation NotificationEventNames

//

NSString * const OnSparkMainWindowDidMiniaturizeKey = @"OnSparkMainWindowDidMiniaturizeKey";
NSString * const OnSparkMainWindowWillClose = @"OnSparkMainWindowWillClose";
NSString * const OnSparkMainWindowBecomeFullWindow = @"OnSparkMainWindowBecomeFullWindow";
NSString * const OnSparkMainWindowBecomeCompactWindow = @"OnSparkMainWindowBecomeCompactWindow";

NSString * const OnSparkMediaWindowDidMiniaturizeKey = @"OnSparkMediaWindowDidMiniaturizeKey";
NSString * const OnSparkMediaWindowDidDeminiaturizeKey = @"OnSparkMediaWindowDidDeminiaturizeKey";

NSString * const OnLoginSuccessful = @"OnLoginSuccessful";
NSString * const OnLoginInProgress = @"OnLoginInProgress";

NSString* const DialogueTitleKey = @"DialogueTitleKey";
NSString* const DialogueMessageKey = @"DialogueMessageKey";
NSString* const OnCallingSelectedDeviceChanged = @"OnCallingSelectedDeviceChanged";

// common head events
NSString * const OnCommonHeadError = @"OnCommonHeadError";
NSString * const AlertKey = @"AlertKey";
NSString * const OnCommonHeadAvatarsChanged = @"OnCommonHeadAvatarsChanged";
NSString * const AvatarIdsKey = @"AvatarIdsKey";
NSString * const OnAvatarCacheChanged = @"OnAvatarCacheChanged";

// common head conversation


NSString * const OnViewModelConversationsArrived = @"OnViewModelConversationsArrived";
NSString * const OnViewModelConversationsChanged = @"OnViewModelConversationsChanged";
NSString * const OnViewModelConversationsRemoved = @"OnViewModelConversationsRemoved";
NSString * const OnViewModelConversationIdChanged = @"OnViewModelConversationIdChanged";
NSString * const OnViewModelTeamsArrived = @"OnViewModelTeamsArrived";
NSString * const OnViewModelMessagesChanged = @"OnViewModelMessagesChanged";
NSString * const OnViewModelMessagesArrived = @"OnViewModelMessagesArrived";

// conversation
NSString * const OnConversationsArrived = @"OnConversationsArrived";
NSString * const OnConversationsRemoved = @"OnConversationsRemoved";
NSString * const OnConversationsChanged = @"OnConversationsChanged";
NSString * const OnConversationIdChanged = @"OnConversationIdChanged";
NSString * const OnOneOnOneFoundWithDeletedUser = @"OnOneOnOneFoundWithDeletedUser";
NSString * const OnConversationCreationFailed = @"OnConversationCreationFailed";
NSString * const OnConversationErrorHappened = @"OnConversationErrorHappened";
NSString * const OnNotAllParticipantsAdded = @"OnNotAllParticipantsAdded";

NSString * const OnMessagesArrived = @"OnMessagesArrived";
NSString * const OnMessageIdChanged = @"OnMessageIdChanged";
NSString * const OnMessagesChanged = @"OnMessagesChanged";
NSString * const OnIntervalsCollapsed = @"OnIntervalsCollapsed";
NSString * const OnSelfMentionsAdded = @"OnSelfMentionsAdded";
NSString * const OnSyncingStatusChanged = @"OnSyncingStatusChanged";
NSString * const OnMercuryStateChanged = @"OnMercuryStateChanged";
NSString * const OnReAuthRequired = @"OnReAuthRequired";
NSString * const OnUnauthorisedDomain = @"OnUnauthorisedDomain";
NSString * const OnCoreFrameworkInitialisationFailed = @"OnCoreFrameworkInitialisationFailed";
NSString * const OnApplicationStartupCompleted = @"OnApplicationStartupCompleted";
NSString * const OnApplicationStartupFailed = @"OnApplicationStartupFailed";
NSString * const OnDatabaseResetCompleted = @"OnDatabaseResetCompleted";
NSString * const OnApplicationAboutToTerminate = @"OnApplicationAboutToTerminate";
NSString * const OnConfigReady = @"OnConfigReady";
NSString * const OnExportDiagnosticsData = @"OnExportDiagnosticsData";
NSString * const OnDataWarehouseInitialized = @"OnDataWarehouseInitialized";
NSString * const OnMediaEngineInitialized = @"OnMediaEngineInitialized";
NSString * const OnMediaProcessInitialized = @"OnMediaProcessInitialized";
NSString * const OnMediaEngineHanged = @"OnMediaEngineHanged";
NSString * const OnCertPinningFailed = @"OnCertPinningFailed";
NSString * const OnProxyAuthenticationRequired = @"OnProxyAuthenticationRequired";
NSString * const OnAudioSharePluginStatus = @"OnAudioSharePluginStatus";
NSString * const OnEcmLoggedIn = @"OnEcmLoggedIn";
NSString * const OnEcmReAuthRequired = @"OnEcmReAuthRequired";
NSString * const OnEcmReAuthenticated = @"OnEcmReAuthenticated";
NSString * const OnEcmLoggedOut = @"OnEcmLoggedOut";
NSString * const OnECMEasyShareResyncStatusChanged = @"OnECMEasyShareResyncStatusChanged";
NSString * const OnECMResyncButtonClicked = @"OnECMResyncButtonClicked";
NSString * const OnConfigUpdated = @"OnConfigUpdated";
NSString * const OnLaunchEcmAuthentication = @"OnLaunchEcmAuthentication";
NSString * const OnCompleteEcmAuthentication = @"OnCompleteEcmAuthentication";


NSString * const OnEmailVerificationSuccessful = @"OnEmailVerificationSuccessful";
NSString * const OnEmailVerificationFailed = @"OnEmailVerificationFailed";
NSString * const OnLoginAttempted = @"OnLoginAttempted";
NSString * const OnLoginComplete = @"OnLoginComplete";
NSString * const OnSelfUserAvailable = @"OnSelfUserAvailable";
NSString * const OnContactChanged = @"OnContactChanged";
NSString * const OnLoginFailed = @"OnLoginFailed";

NSString * const OnServerHealthRetrieved = @"OnServerHealthRetrieved";
NSString * const OnServerReachabilityCheckCompleted = @"OnServerReachabilityCheckCompleted";

NSString * const OnFeedbackFileUploadSuccesful = @"OnFeedbackFileUploadSuccesful";
NSString * const OnFeedbackFileUploadFailed = @"OnFeedbackFileUploadFailed";
NSString * const OnRequestUrlSuccesful = @"OnRequestUrlSuccesful";
NSString * const OnRequestUrlFailed = @"OnRequestUrlFailed";

NSString * const OnAvatarChanged = @"OnAvatarChanged";
NSString * const OnThumbnailChanged = @"OnThumbnailChanged";
NSString * const OnThumbnailDownloadFailed = @"OnThumbnailDownloadFailed";
NSString * const OnRoomAvatarChanged = @"OnRoomAvatarChanged";
NSString * const OnThumbnailPreviewChanged = @"OnThumbnailPreviewChanged";
NSString * const OnReadersChanged = @"OnReadersChanged";
NSString * const OnAdaptiveCardSubmitStatusReturn = @"OnAdaptiveCardSubmitStatusReturn";
NSString * const OnDownloadProgress = @"OnDownloadProgress";
NSString * const OnDownloadComplete = @"OnDownloadComplete";
NSString * const OnDownloadFailed = @"OnDownloadFailed";
NSString * const OnDownloadBlocked = @"OnDownloadBlocked";
NSString * const OnUploadProgress = @"OnUploadProgress";
NSString * const OnCreateConversation = @"OnCreateConversation";
NSString * const OnParticipantStatusChanged = @"OnParticipantStatusChanged";
NSString * const OnParticipantsStatusChanged = @"OnParticipantsStatusChanged";
NSString * const OnDeleteMessageAction = @"OnDeleteMessageAction";
NSString * const OnDownloadBlockedAction = @"OnDownloadBlockedAction";
NSString * const OnContextMenuAction = @"OnContextMenuAction";
NSString * const OnUnreadCountersChanged = @"OnUnreadCountersChanged";
NSString * const OnMissingMessagesChanged = @"OnMissingMessagesChanged";
NSString * const OnStartSpaceRequested = @"OnStartSpaceRequested";
NSString * const OnStartOneToOneConversationRequested = @"OnStartOneToOneConversationRequested";
NSString * const OnConversationsFetchComplete = @"OnConversationsFetchComplete";
NSString * const OnReactionsChanged = @"OnReactionsChanged";
NSString * const OnOneToOneEncryptionHealRequired = @"OnOneToOneEncryptionHealRequired";
NSString * const OnOneToOneEncryptionHealResult = @"OnOneToOneEncryptionHealResult";
NSString * const OnCustomAppsRefreshed = @"OnCustomAppsRefreshed";
NSString * const OnConversationRefreshed = @"OnConversationRefreshed";
NSString * const OnStartThread = @"OnStartThread";
NSString * const OnStageFileAction = @"OnStageFileAction";
NSString * const OnContentDroppedAction = @"OnContentDroppedAction";

NSString * const AvatarFrameKey = @"AvatarFrameKey";
NSString * const ToastFrameKey = @"ToastFrameKey";
NSString * const ConfigIdKey = @"ConfigIdKey";
NSString * const ConfigValueKey = @"ConfigValueKey";
NSString * const CachedValuesKey = @"CachedValuesKey";

// Connectivity Banner events
NSString *const OnShowConnectivityBanner = @"OnShowConnectivityBanner";
NSString *const OnHideConnectivityBanner = @"OnHideConnectivityBanner";

NSString *const ConnectivityBannerStringKey = @"ConnectivityBannerStringKey";
NSString *const ConnectivityBannerTypeKey = @"ConnectivityBannerTypeKey";

// UCLogin Service events
NSString *const OnServiceReady = @"OnServiceReady";

// Head-to-head events
NSString *const OnTeamSelectedAction = @"OnTeamSelectedAction";
NSString *const OnTeamActivatedAction = @"OnTeamUnArchivedAction";
NSString *const OnConversationSelectedAction = @"OnConversationSelectedAction";
NSString *const OnContactCardPopoverCloseAction = @"OnContactCardPopoverCloseAction";
NSString *const OnHighlightMessageInConversation = @"OnHighlightMessageInConversation";
NSString *const OnJoinConversationAction = @"OnJoinConversationAction";
NSString *const OnStartOneToOneConversationAction = @"OnStartOneToOneConversationAction";
NSString *const OnUpdateCallTimer = @"OnUpdateCallTimer";
NSString *const OnContextChange = @"OnContextChange";
NSString *const OnUnjoinedTeamSearchAction = @"OnUnjoinedTeamSearchAction";
NSString *const OnPreviewAnnotationContentAction = @"OnPreviewAnnotationContentAction";
NSString *const OnPreviewContentAction = @"OnPreviewContentAction";
NSString *const OnOpenFileContentAction = @"OnOpenFileContentAction";
NSString *const OnMarkdownEnabledChanged = @"OnMarkdownEnabledChanged";
NSString *const OnEditWhiteboardAction = @"OnEditWhiteboardAction";
NSString *const OnShowWirelessSectionAction = @"OnShowWirelessSectionAction";
NSString *const OnWhiteboardSessionStarted = @"OnWhiteboardSessionStarted";
NSString *const OnWhiteboardSessionReadOnlyChanged = @"OnWhiteboardSessionReadOnlyChanged";
NSString *const OnWhiteboardSessionFatalError = @"OnWhiteboardSessionFatalError";
NSString *const OnWhiteboardSessionEnded = @"OnWhiteboardSessionEnded";
NSString *const OnWhiteboardSessionInfo = @"OnWhiteboardSessionInfo";
NSString *const OnWhiteboardAnnotationFailed = @"OnWhiteboardAnnotationFailed";
NSString *const OnWhiteboardAnnotationCanClearAll = @"onWhiteboardAnnotationCanClearAll";
NSString *const OnWhiteboardServiceDeinit = @"onWhiteboardServiceDeinit";
NSString *const OnEditWhiteboardAndShareOnCall = @"OnEditWhiteboardAndShareOnCall";
NSString *const OnNewWhiteboardAndShareOnCall = @"OnNewWhiteboardAndShareOnCall";
NSString *const OnCallActivityChanged = @"OnCallActivityChanged";
NSString *const OnSelectedEntityChanged = @"OnSelectedEntityChanged";
NSString *const OnShareWhiteBoardLiveAction = @"OnShareWhiteboardLiveAction";
NSString *const OnToggleAddPeopleAction = @"OnToggleAddPeopleAction";
NSString *const OnOpenWebViewRequested = @"OnOpenWebViewRequested";
NSString *const OnNativeMessagingViewToggled = @"OnNativeMessagingViewToggled";
NSString *const OnCallNotificationArrivedFromParticipantList = @"OnCallNotificationArrivedFromParticipantList";

NSString *const OnWhiteboardInit = @"OnWhiteboardInit";
NSString *const OnWhiteboardAddContents = @"OnWhiteboardAddContents";
NSString *const OnWhiteboardSetBackgroundImage = @"OnWhiteboardSetBackgroundImage";
NSString *const OnWhiteboardRealtimeMessage = @"OnWhiteboardRealtimeMessage";
NSString *const OnWhiteboardSaveContents = @"OnWhiteboardSaveContents";
NSString *const OnWhiteboardGetImageSnapshot = @"OnWhiteboardGetImageSnapshot";
NSString *const OnWhiteboardClearBoard = @"OnWhiteboardClearBoard";
NSString *const OnWhiteboardSetReadOnly = @"OnWhiteboardSetReadOnly";
NSString *const OnWhiteboardSwitchColor = @"OnWhiteboardSwitchColor";
NSString *const OnWhiteboardSwitchToEraser = @"OnWhiteboardSwitchToEraser";

NSString *const OnNewWhiteboardAction = @"OnNewWhiteboardAction";
NSString *const OnWhiteboardShareLoaded = @"OnWhiteboardShareLoaded";
NSString *const OnShowCallControlsAfterWhiteboarding = @"OnShowCallControlsAfterWhiteboarding";
NSString *const OnOpenCallingDevicesPreferences = @"OnOpenCallingDevicesPreferences";
NSString *const OnOpenSearchWirelessDevices = @"OnOpenWirelessDevices";

NSString *const OnShowSearch = @"OnShowSearch";
NSString *const OnOpenSearchAction = @"OnOpenSearchAction";
NSString *const OnSocialRoomFilterUpdated = @"OnSocialRoomFilterUpdated";
NSString *const OnFourthColumnDidStartAnimating = @"OnFourthColumnDidStartAnimating";
NSString *const OnFourthColumnDidFinishAnimating = @"OnFourthColumnDidFinishAnimating";
NSString *const OnFourthColumnDidClosed = @"OnFourthColumnDidClosed";
NSString *const OnMediaControlsVisbilityStateChanged = @"OnMediaControlsVisbilityStateChanged";
NSString *const OnFourthColumnOpenChanged = @"OnFourthColumnOpenChanged";
NSString *const OnFourthColumnActivityChanged = @"OnFourthColumnOpenChanged";
NSString *const OnCloseSearchResults = @"OnCloseSearchResults";
NSString *const OnForwardMessageAction = @"OnForwardMessageAction";
NSString *const OnOpenSpaceButtonClicked = @"OnOpenSpaceButtonClicked";
NSString *const OnBindSpaceSelectedAction = @"OnBindSpaceSelectedAction";
NSString *const OnConversationTabActivityChanged = @"OnConversationTabActivityChanged";
NSString *const OnShareBorderControlsChanged = @"OnShareBorderControlsChanged";
NSString *const OnCreateSpaceAction = @"OnCreateSpaceAction";
NSString *const OnDisplayConnectingChanged = @"OnDisplayConnectingChanged";
// call
NSString *const OnShowIncomingCallAlert = @"OnShowIncomingCallAlert";
NSString *const OnCallParkExpireAlert = @"OnCallParkExpireAlert";
NSString *const OnDismissIncomingCallAlert = @"OnDismissIncomingCallAlert";
NSString *const OnCallConnected = @"OnCallConnected";
NSString *const OnCallDisconnected = @"OnCallDisconnected";
NSString *const OnCallJoined = @"OnCallJoined";
NSString *const OnCallStateChanged = @"OnCallStateChanged";
NSString *const OnRemoteAuxVideoReady = @"OnRemoteAuxVideoReady";
NSString *const OnRemoteAuxVideoInUse = @"OnRemoteAuxVideoInUse";
NSString *const OnRemoteVideoStateChanged = @"OnRemoteVideoStateChanged";
NSString *const OnRemoteVideoStreamingChanged = @"OnRemoteVideoStreamingChanged";
NSString *const OnRemoteShareStreamingChanged = @"OnRemoteShareStreamingChanged";
NSString *const OnLocalVideoStateChanged = @"OnLocalVideoStateChanged";
NSString *const OnLocalVideoStreamingChanged = @"OnLocalVideoStreamingChanged";
NSString *const OnLocalVideoStreamSizeChanged = @"OnLocalVideoStreamSizeChanged";
NSString *const OnActiveSpeakerChanged = @"OnActiveSpeakerChanged";
NSString *const OnParkStateChanged = @"OnParkStateChanged";
NSString *const OnRemoteParticipantCountChanged = @"OnRemoteParticipantCountChanged";
NSString *const OnShareStateChanged = @"OnShareStateChanged";
NSString *const OnSharedCapturedWindowsChanged = @"OnSharedCapturedWindowsChanged";
NSString *const OnSharePositionChanged = @"OnSharePositionChanged";
NSString *const OnWhiteboardShareStateChanged = @"OnWhiteboardShareStateChanged";
NSString *const OnAnnotateDesktopShare = @"OnAnnotateDesktopShare";
NSString *const OnMeetingInfoChanged = @"OnMeetingInfoChanged";
NSString *const OnDeviceSelectionChanged = @"OnDeviceSelectionChanged";
NSString *const OnCallParticipantsChanged = @"OnCallParticipantsChanged";
NSString *const OnJoinedParticipantCountChanged = @"OnJoinedParticipantCountChanged";
NSString *const OnCallFailed = @"OnCallFailed";
NSString *const OnLocalShareIsReady = @"OnLocalShareIsReady";
NSString *const OnMediaDisconnected = @"OnMediaDisconnected";
NSString *const OnCallConnecting = @"OnCallConnecting";
NSString *const OnCallConversationChanged = @"OnCallConversationChanged";
NSString *const OnMeetingHostChanged = @"OnMeetingHostChanged";
NSString *const OnAudioStreamingChanged = @"OnAudioStreamingChanged";
NSString *const OnShowCallRating = @"OnShowCallRating";
NSString *const OnCallNetworkCongestionChanged = @"OnCallNetworkCongestionChanged";
NSString *const OnCallWaitForMeetingPin = @"OnCallWaitForMeetingPin";
NSString *const OnCallWaiting = @"OnCallWaiting";
NSString *const OnCallWakeUp = @"OnCallWakeUp";
NSString *const OnMediaConnectionFailedToRecover = @"OnMediaConnectionFailedToRecover";
NSString *const OnEccFailedToRecover = @"OnEccFailedToRecover";
NSString *const OnXApiRequestFailed = @"OnXApiRequestFailed";
NSString *const OnDevcieNotReachableToDirectShare = @"OnDevcieNotReachableToDirectShare";
NSString *const OnStartRinger = @"OnStartRinger";
NSString *const OnStopRinger = @"OnStopRinger";
NSString *const OnStartCallWaiting = @"OnStartCallWaiting";
NSString *const OnStartTone = @"OnStartTone";
NSString *const OnStopTone = @"OnStopTone";
NSString *const OnStartPickupRinger = @"OnStartPickupRinger";
NSString *const OnStartParkExpiredRinger = @"OnStartParkExpiredRinger";
NSString *const OnStartRingback = @"OnStartRingback";
NSString *const OnStopRingback = @"OnStopRingback";
NSString *const OnStartBusyTone = @"OnStartBusyTone";
NSString *const OnStopBusyTone = @"OnStopBusyTone";
NSString *const OnStartReconnectTone = @"OnStartReconnectTone";
NSString *const OnStopReconnectTone = @"OnStopReconnectTone";
NSString *const OnStartNotFoundTone = @"OnStartNotFoundTone";
NSString *const OnStopNotFoundTone = @"OnStopNotFoundTone";
NSString *const OnStartDtmfTone = @"OnStartDtmfTone";
NSString *const OnStopDtmfTone = @"OnStopDtmfTone";
NSString *const OnCallSleepScreenSaverChanged = @"OnCallSleepScreenSaverChanged";
NSString *const OnCallRequested = @"OnCallRequested";
NSString *const OnSearchStringCallAction = @"OnSearchStringCallAction";
NSString *const OnCallWithEditAction = @"OnCallWithEditAction";
NSString *const OnCallWithEditDialPadAction = @"OnCallWithEditDialPadAction";
NSString *const OnCallAudioActiveSpeakerChanged = @"OnCallAudioActiveSpeakerChanged";
NSString *const OnShowRemoteAvatarChanged = @"OnShowRemoteAvatarChanged";
NSString *const OnShowOnlyPersonInRoomChanged = @"OnShowOnlyPersonInRoomChanged";
NSString *const OnResourceRoomStateChanged = @"OnResourceRoomStateChanged";
NSString *const OnResourceRoomError = @"OnResourceRoomError";
NSString *const OnShareWillMiniaturizeWindow = @"OnShareWillMiniaturizeWindow";
NSString *const OnShareShouldExcludeWindow = @"OnShareShouldExcludeWindow";
NSString *const OnWindowCoverStateChanged = @"OnWindowCoverStateChanged";
NSString *const OnMoveCallStarted = @"OnMoveCallStarted";
NSString *const OnCallHoldStateChanged = @"OnCallHoldStateChanged";
NSString *const OnExConferenceStateChanged = @"OnExConferenceStateChanged";
NSString *const OnActiveCallChanged = @"OnActiveCallChanged";
NSString *const OnCallCapsChanged = @"OnCallCapsChanged";
NSString *const OnCallJoinedByRemote = @"OnCallJoinedByRemote";

//PSTN
NSString *const OnPSTNProvisionalDeviceJoined = @"OnPSTNProvisionalDeviceJoined";
NSString *const OnPSTNDialinComplete = @"OnPSTNDialinComplete";
NSString *const OnPSTNDialinFailed = @"OnPSTNDialinFailed";

//call history
NSString *const OnCallHistoryEvent = @"OnCallHistoryEvent";
NSString *const OnUnreadMissedCallCountChange = @"OnUnreadMissedCallCountChange";

//Voicemail
NSString *const OnVoicemailInfoEvent = @"OnVoicemailInfoEvent";

//Media Device events
NSString *const OnCameraVideoReadyEvent = @"OnCameraVideoReadyEvent";
NSString *const OnMediaDeviceListChangedEvent = @"OnMediaDeviceListChangedEvent";
NSString *const OnMediaDeviceChangedEvent = @"OnMediaDeviceChangedEvent";
NSString *const OnMediaDeviceError = @"OnMediaDeviceError";
NSString *const OnSelectedDeviceChangedEvent = @"OnSelectedDeviceChangedEvent";
NSString *const OnRenderSizeChangedEvent = @"OnRenderSizeChangedEvent";
NSString *const OnInputPeak = @"OnInputPeak";
NSString *const OnMediaDeviceHeadDetectedChange = @"OnMediaDeviceHeadDetectedChange";

//call UI triggered

NSString *const OnJoinCallAction = @"OnJoinCallAction";
NSString *const OnShareAction = @"OnShareAction";
NSString *const OnStartCallAction = @"OnStartCallAction";
NSString *const OnShowCallStatsAction = @"OnShowCallStatsAction";
NSString *const OnFileShareReceived = @"OnFileShareReceived";
NSString *const OnStopFileSharing = @"OnStopFileSharing";
NSString *const OnBeginBackgroundTask = @"onBeginBackgroundTask";
NSString *const OnEndBackgroundTask = @"onEndBackgroundTask";
NSString *const OnSpaceHeaderCallDropDownRequested = @"OnSpaceHeaderCallDropDownRequested";
NSString *const OnAddPeopleFTERequested=@"OnAddPeopleFTERequested";

NSString *const OnNetworkStatusChanged = @"OnNetworkStatusChanged";
NSString *const NetworkStatusKey = @"NetworkStatusKey";

//key
NSString *const ReloadRoomList = @"ReloadRoomList";
NSString *const IncognitoKey = @"IncognitoKey";
NSString *const DropImageListKey = @"DropImageListKey";
NSString *const DropFilePathListKey = @"DropFilePathListKey";
NSString *const DropTextKey = @"DropTextKey";
NSString *const CallActivityKey = @"CallActivityKey";
NSString *const CallOriginKey = @"CallOrigin";
NSString *const DeviceIdKey = @"DeviceId";
NSString *const ConversationIdsKey = @"ConversationIds";
NSString *const ConversationIdKey = @"ConversationId";
NSString *const RecordingIdKey = @"RecordingId";
NSString *const MessageAlertSound = @"MessageAlertSound";
NSString *const UserInitiatedKey = @"UserInitiated";
NSString *const AlertTypeKey = @"AlertType";
NSString *const ConversationInputBoxFocusKey = @"ConversationInputBoxFocusKey";
NSString *const CallIdKey = @"CallIdKey";
NSString *const LineIdKey = @"LineIdKey";
NSString *const PcmRawsKey = @"PcmRawsKey";
NSString *const UcmToneTypeKey = @"UcmToneTypeKey";
NSString *const ActivityTypeKey = @"ActivityTypeKey";
NSString *const ActivityIdKey = @"ActivityIdKey";
NSString *const ActivityTabTypeKey = @"ActivityTabTypeKey";
NSString *const ActivityKey = @"ActivityKey";
NSString *const UpdateConversationKey = @"UpdateConversationKey";
NSString *const WindowKey = @"WindowKey";
NSString *const OldActivityIdKey = @"OldActivityIdKey";
NSString *const NewActivityIdKey = @"NewActivityIdKey";
NSString *const ConversationContextKey = @"ConversationContextKey";
NSString *const MessageScrollReasonKey = @"MessageScrollReasonKey";
NSString *const MessageIdKey = @"MessageIdKey";
NSString *const MessageIdsKey = @"MessageIdsKey";
NSString *const NewMessageIdKey = @"NewMessageId";
NSString *const OldMessageIdKey = @"OldMessageId";
NSString *const ParticipantKey = @"Participant";
NSString *const ParticipantsKey = @"Participants";
NSString *const ParticipantIdKey = @"ParticipantId";
NSString *const ParticipantIdsKey = @"ParticipantIds";
NSString *const ContactIdsKey = @"ContactIds";
NSString *const IsSyncingKey = @"IsSyncingKey";
NSString *const MercuryStateKey = @"MercuryStateKey";
NSString *const VideoActiveKey = @"VideoActiveKey";
NSString *const NewConversationIdKey = @"NewConversationIdKey";
NSString *const OldConversationIdKey = @"OldConversationIdKey";
NSString *const NewHostIdKey = @"NewHostIdKey";
NSString *const OldHostIdKey = @"OldHostIdKey";
NSString *const ContentIndexKey = @"ContentIndex";
NSString *const PreviewPageNumberKey = @"PreviewPageNumberKey";
NSString *const PreviewPageImageRawDataKey = @"PreviewPageImageRawDataKey";
NSString *const PreviewPageImageDownloadSuccessKey = @"PreviewPageImageDownloadSuccessKey";
NSString *const ProgressKey = @"ProgressKey";
NSString *const ErrorCodeKey = @"ErrorCodeKey";
NSString *const ParticipantListKey = @"ParticipantListKey";
NSString *const ScrollToItemKey = @"ScrollToItemKey";
NSString *const SearchHighlightItemKey = @"SearchHighlightItemKey";
NSString *const LeaveSearchOpenKey = @"LeaveSearchOpenKey";
NSString *const SwitchToRoomViewKey = @"SwitchToRoomViewKey";
NSString *const ShouldCloseChildWindowsKey = @"ShouldCloseChildWindowsKey";
NSString *const CallHistoryIdsKey = @"CallHistoryIdsKey";
NSString *const MediaDeviceTypeKey = @"MediaDeviceTypeKey";
NSString *const MediaErrorReasonKey = @"MediaErrorReasonKey";
NSString *const OldMediaDeviceKey = @"OldMediaDeviceKey";
NSString *const NewMediaDeviceKey = @"NewMediaDeviceKey";
NSString *const MediaDeviceEventTypeKey = @"MediaDeviceEventTypeKey";
NSString *const TrackTypeKey = @"TrackTypeKey";
NSString *const DownloadFileNameKey = @"DownloadFileNameKey";
NSString *const DownloadPathKey = @"DownloadPathKey";
NSString *const CallFailureReasonKey = @"CallFailureReasonKey";
NSString *const ConversationsWithCallsKey = @"ConversationsWithCallsKey";
NSString *const DiagnosticsKey = @"DiagnosticsKey";
NSString *const ConversationTypeKey = @"ConversationTypeKey";
NSString *const ConversationErrorKey = @"ConversationErrorCode";
NSString *const PrimaryIdKey = @"PrimaryIdKey";
NSString *const SecondaryIdKey = @"SecondaryIdKey";
NSString *const AudioDeviceIdKey = @"AudioDeviceId";
NSString *const StopRinger = @"StopRinger";
NSString *const IsMissingMessagesKey = @"IsMissingMessages";
NSString *const ChannelUrlKey = @"ChannelUrlKey";
NSString *const FromAnnotationPreview = @"FromAnnotationPreview";
NSString *const AnnotationFileNameKey = @"AnnotationFileNameKey";
NSString *const AnnotationSharedDateKey = @"AnnotationSharedDateKey";
NSString *const AnnotationSharedNameKey = @"AnnotationSharedNameKey";
NSString *const MediaControlsVisbilityKey = @"MediaControlsVisbilityKey";
NSString *const ContactCardSenderKey = @"ContactCardSenderKey";
NSString *const ContactCardPopoverBoundsKey = @"ContactCardPopoverBoundsKey";
NSString *const ContactCardPopoverPreferredEdgeKey = @"ContactCardPopoverPreferredEdgeKey";
NSString *const ContactCardPopoverShouldAnimateKey = @"ContactCardPopoverShouldAnimateKey";
NSString *const ContactCardPopoverBehaviorKey = @"ContactCardPopoverBehaviorKey";
NSString *const ContactCardDelegateKey = @"ContactCardDelegateKey";
NSString *const SearchStringKey = @"SearchStringKey";
NSString *const CallWithEditStringKey = @"CallWithEditStringKey";
NSString *const CallWithEditDialPadStringKey = @"CallWithEditDialPadStringKey";
NSString *const MouseEventTypeKey = @"MouseEventKey";
NSString *const MouseEnterEvent = @"mouseenter"; // matches the JS value returned from web view
NSString *const MouseLeaveEvent = @"mouseleave"; // matches the JS value returned from web view
NSString *const OnConversationScrollEvent = @"OnConversationScrollEvent";
NSString *const OnAvatarMouseEvent = @"OnAvatarMouseEvent";
NSString *const WhiteboardSessionIdKey = @"WhiteboardSessionIdKey";
NSString *const WhiteboardBackgroundImageKey = @"WhiteboardBackgroundImageKey";
NSString *const WhiteboardBackgroundImageWidthKey = @"WhiteboardBackgroundImageWidthKey";
NSString *const WhiteboardBackgroundImageHeightKey = @"WhiteboardBackgroundImageHeightKey";
NSString *const WhiteboardBackgroundImageTypeKey = @"WhiteboardBackgroundImageTypeKey";
NSString *const WhiteboardChannelUrlKey = @"WhiteboardChannelUrlKey";
NSString *const WhiteboardIsAnnotationKey = @"WhiteboardIsAnnotationKey";
NSString *const WhiteboardInitDisplayNameKey = @"WhiteboardInitDisplayNameKey";
NSString *const WhiteboardInitUserIdKey = @"WhiteboardInitUserIdKey";
NSString *const WhiteboardAddContentsKey = @"WhiteboardAddContentsKey";
NSString *const WhiteboardSetBackgroundImageDataKey = @"WhiteboardSetBackgroundImageDataKey";
NSString *const WhiteboardSetBackgroundImageWidthKey = @"WhiteboardSetBackgroundImageWidthKey";
NSString *const WhiteboardSetBackgroundImageHeightKey = @"WhiteboardSetBackgroundImageHeightKey";
NSString *const WhiteboardSetBackgroundImageMimeTypeKey = @"WhiteboardSetBackgroundImageMimeTypeKey";
NSString *const WhiteboardRealtimeMessageJsonKey = @"WhiteboardRealtimeMessageKey";
NSString *const WhiteboardSaveContentsIdKey = @"WhiteboardSaveContentsIdKey";
NSString *const WhiteboardSaveContentsSuccessKey = @"WhiteboardSaveContentsSuccessKey";
NSString *const WhiteboardSetReadOnlyKey = @"WhiteboardSetReadOnlyKey";
NSString *const WhiteboardSwitchColorHexColorKey = @"WhiteboardSwitchColorHexColorKey";
NSString *const WhiteboardGetImageSnapshotMessageIdKey = @"WhiteboardGetImageSnapshotMessageIdKey";
NSString *const DisplayNameKey = @"DisplayNameKey";
NSString *const AddedCallParticipantsKey = @"AddedCallParticipantsKey";
NSString *const RemovedCallParticipantsKey = @"RemovedCallParticipantsKey";
NSString *const InvitedCallParticipantsKey = @"InvitedCallParticipantsKey";
NSString *const ConversationHealSuccessKey = @"ConversationHealSuccessKey";
NSString *const CloseFourthColumnKey = @"CloseFourthColumnKey";
NSString *const FourthColumnOpenKey = @"FourthColumnOpenKey";
NSString *const SearchTypeStingKey = @"SearchTypeStingKey";
NSString *const EcmProviderKey = @"EcmProviderKey";
NSString *const EcmLoginStatusKey = @"EcmLoginStatusKey";
NSString *const ECMEasyShareResyncCompletedKey = @"ECMEasyShareResyncCompletedKey";
NSString *const QuoteMessageKey = @"QuoteMessageKey";
NSString *const BindSpaceKey = @"BindSpaceKey";
NSString *const CallNotificationKey = @"CallNotificationKey";
NSString *const CopyLinkErrorMessageTitleKey = @"CopyLinkErrorMessageTitleKey";
NSString *const CopyLinkErrorMessageBodyKey = @"CopyLinkErrorMessageBodyKey";
NSString *const ShowConnecting = @"ShowConnecting";
NSString *const SharingStatusKey = @"SharingStatus";

//AdaptiveCards
NSString *const OnAdaptiveCardSubmitStatusReturnKey = @"OnAdaptiveCardSubmitStatusReturnKey";
//ExCalling
NSString *const OnExCallingRegistrationChanged = @"OnExCallingRegistrationChanged";
NSString *const OnExCallingAuthenticationChanged = @"OnExCallingAuthenticationChanged";

//ExCalling Keys
NSString *const ExRegistrationKey = @"ExRegistrationKey";
NSString *const ExAuthenticationKey = @"ExAuthenticationKey";
NSString *const ExAuthenticationReasonKey = @"ExAuthenticationReasonKey";

//Network Response Key
NSString *const FailureCodeKey = @"FailureCodeKey";
NSString *const FailureReasonKey = @"FailureReasonKey";
NSString *const WasSuccessfulKey = @"WasSuccessfulKey";


NSString *const AddedKey = @"AddedKey";
NSString *const ModeratorKey = @"ModeratorKey";
NSString *const IsExistingEmailKey = @"IsExistingEmailKey";
NSString *const IsDirectorySyncEnabledKey = @"IsDirectorySyncEnabledKey";
NSString *const SSOKey = @"SSOKey";
NSString *const VerificationEmailTriggeredKey = @"VerificationEmailTriggeredKey";
NSString *const UserCreatedKey = @"UserCreatedKey";
NSString *const HasPasswordKey = @"HasPasswordKey";
NSString *const IsResendKey = @"IsResend";
NSString *const IsSignUpKey = @"IsSignUp";

NSString *const AppStartupFailure = @"AppStartupFailure";

NSString *const ContentSelectionKey = @"ContentSelectionKey";
NSString *const CurrentSparkContextKey = @"CurrentSparkContextKey";
NSString *const EmailFailure = @"EmailFailure";
NSString *const LoginFailure = @"LoginFailure";
NSString *const MercuryState = @"MercuryState";

//User Preferences Keys
NSString *const SelectedSpeakerKey = @"SelectedSpeakerKey";
NSString *const SelectedMicrophoneKey = @"SelectedMicrophoneKey";
NSString *const SelectedCameraKey = @"SelectedCameraKey";
NSString *const SelectedRingerKey = @"SelectedRingerKey";
NSString *const PlayRingerOnAllDevicesKey = @"PlayRingerOnAllDevicesKey";

NSString *const PreferencesIdenitfierKey = @"PreferencesIdenitfierKey";

//tutorial
NSString *const OnCoachmarksResetAction = @"OnCoachmarksResetAction";
NSString *const OnWebexMigrationProfileCoachMarkAction = @"OnWebexMigrationProfileCoachMarkAction";
NSString *const OnWebexMigrationProfileCoachMarkKey = @"OnWebexMigrationProfileCoachMarkKey";

//Call keys
NSString *const CallStateKey = @"CallStateKey";
NSString *const MuteStateKey = @"MuteStateKey";
NSString *const AudioStatesKey = @"AudioStatesKey";
NSString *const RemoteMuteStatesKey = @"RemoteMuteStatesKey";
NSString *const LocalMuteStatesKey = @"LocalMuteStatesKey";
NSString *const CallCongestionKey = @"CallCongestionKey";
NSString *const CallLockedKey = @"CallLockedKey";
NSString *const CallRecordingStateKey = @"CallRecordingStateKey";
NSString *const SleepScreenSaverKey = @"SleepScreenSaverKey";
NSString *const CallRequestedKey = @"CallRequestedKey";
NSString *const AudioActiveSpeakerStatesKey = @"AudioActiveSpeakerStatesKey";
NSString *const IsPmrKey = @"IsPmrKey";
NSString *const MeetingNameKey = @"MeetingNameKey";
NSString *const MeetingLockedErrorCodeKey = @"MeetingLockedErrorCodeKey";
NSString *const GuestPinRequiredKey = @"GuestPinRequiredKey";
NSString *const CallChangedContactsKey = @"CallChangedContactsKey";
NSString *const EmailKey = @"EmailKey";
NSString *const WindowListHandleKey = @"WindowListHandleKey";
NSString *const ShareRectKey = @"ShareRectKey";
NSString *const MinimizeKey = @"MinimizeKey";
NSString *const MediaDirectionKey = @"MediaDirectionKey";
NSString *const CanBeMutedKey = @"CanBeMutedKey";
NSString *const MoveCallDirectionKey = @"MoveCallDirectionKey";
NSString *const AudioSharePluginStatusKey =@"AudioSharePluginStatusKey";
NSString *const ActiveCallIdKey = @"ActiveCallIdKey";
NSString *const MediaConversionStateKey = @"MediaConversionStateKey";
NSString *const ConverterIdKey = @"ConverterIdKey";
NSString *const FilepathKey = @"FilepathKey";

//Server Health Keys
NSString *const ServiceNameKey = @"ServiceNameKey";
NSString *const ServiceStateKey = @"ServiceStateKey";

//Feedback keys
NSString *const FeedbackIdKey = @"FeedbackIdKey";
NSString *const UrlKey = @"UrlKey";
NSString *const UrlTypeKey = @"UrlTypeKey";

//proxy settings keys
NSString *const ProxyUrlKey = @"ProxyUrlKey";

//Shortcut events
NSString *const OnPreferencesActionShortcut = @"OnPreferencesActionShortcut";

//Source events
NSString *const OnAccountActionSource = @"OnAccountActionSource";

// File picker launcher
NSString *const PickerLauncher = @"PickerLauncher";

// ECM linked folder files fetcher
NSString* const EcmFolderFilesFetcher = @"EcmFolderFilesFetcher";

//dev harness
NSString *const OnDevHarnessBringToFront = @"OnDevHarnessBringToFront";

//upgrades
NSString *const OnUpgradeAvailable = @"OnUpgradeAvailable";

// PersonalInsights
NSString *const OnPersonalInsightsLoginComplete = @"OnPersonalInsightsLoginComplete";

//teams
NSString *const OnTeamsArrived = @"OnTeamsArrived";
NSString *const OnTeamsChanged = @"OnTeamsChanged";
NSString *const OnTeamRoomsChanged = @"OnTeamRoomsChanged";
NSString *const TeamIdKey = @"TeamId";
NSString *const TeamIdsKey = @"TeamIds";
NSString *const OnTeamRoomsAdded = @"OnTeamRoomsAdded";
NSString *const OnTeamRoomCreated = @"OnTeamRoomCreated";
NSString *const OnTeamRoomsRemoved = @"OnTeamRoomsRemoved";
NSString *const NewTeamRoomIdKey = @"NewTeamRoomIdKey";
NSString *const OldTeamRoomIdKey = @"OldTeamRoomIdKey";
NSString *const NewTeamIdKey = @"NewTeamIdKey";
NSString *const OldTeamIdKey = @"OldTeamIdKey";
NSString *const TeamRoomIdsKey = @"TeamRoomIds";
NSString *const TeamRoomIdKey = @"TeamRoomId";
NSString *const OnTeamIdChanged = @"OnTeamIdChanged";
NSString *const OnTeamRoomIdChanged = @"OnTeamRoomIdChanged";
NSString *const OnTeamRoomJoinStateChange = @"onTeamRoomJoinStateChange";
NSString *const OnTeamsRemoved = @"OnTeamsRemoved";


NSString *const OnAuxiliaryDevicesAddedEvent = @"OnAuxiliaryDevicesAddedEvent";
NSString *const OnAuxiliaryDeviceIdsKey = @"OnAuxiliaryDeviceIdsKey";

NSString *const OnAuxiliaryDeviceSomeEventHappened = @"OnAuxiliaryDeviceSomeEventHappened";
NSString *const OnAuxiliaryDeviceListChangedEvent = @"OnAuxiliaryDeviceListChangedEvent";
NSString *const OnSelectedAuxiliaryDeviceChangedEvent = @"OnSelectedAuxiliaryDeviceChangedEvent";
NSString *const OnAuxiliaryDeviceUpdatedEvent = @"OnAuxiliaryDeviceUpdatedEvent";
NSString *const OnAuxiliaryDeviceRegisteredEvent = @"OnAuxiliaryDeviceRegisteredEvent";
NSString *const OnAuxiliaryDeviceUnregisteredEvent = @"OnAuxiliaryDeviceUnregisteredEvent";
NSString *const OnAuxiliaryDeviceProvisionedEvent = @"OnAuxiliaryDeviceProvisionedEvent";
NSString *const OnAuxiliaryDeviceUnprovisionedEvent = @"OnAuxiliaryDeviceUnprovisionedEvent";
NSString *const OnAuxiliaryDeviceRenameSuccessEvent = @"OnAuxiliaryDeviceRenameSuccessEvent";
NSString *const OnStartAudioRecorderEvent = @"OnStartAudioRecorderEvent";
NSString *const OnStopAudioRecorderEvent = @"OnStopAudioRecorderEvent";
NSString *const OnShutDownAudioRecorderEvent = @"OnShutDownAudioRecorderEvent";
NSString *const OnRecordingEvent = @"OnRecordingEvent";
NSString *const OnStartProximityRecordingEvent = @"OnStartProximityRecordingEvent";
NSString *const OnStopProximityRecordingEvent = @"OnStopProximityRecordingEvent";
NSString *const OnWakeProximityRecordingEvent = @"OnWakeProximityRecordingEvent";
NSString *const OnSleepProximityRecordingEvent = @"OnSleepProximityRecordingEvent";
NSString *const OnAuxiliaryDeviceAvailabilityChanged = @"OnAuxiliaryDeviceAvailabilityChanged";
NSString *const OnAuxiliaryDeviceStartShareEvent = @"OnAuxiliaryDeviceStartShareEvent";
NSString *const OnAuxiliaryDeviceShareFailEvent = @"OnAuxiliaryDeviceShareFailEvent";
NSString *const OnAuxiliaryDeviceStopShareEvent = @"OnAuxiliaryDeviceStopShareEvent";
NSString *const OnAuxiliaryDeviceBindSucceededEvent = @"OnAuxiliaryDeviceBindSucceededEvent";
NSString *const OnAuxiliaryDeviceBindFailedEvent = @"OnAuxiliaryDeviceBindFailedEvent";
NSString *const OnAuxiliaryDeviceUnbindSucceededEvent = @"OnAuxiliaryDeviceUnbindSucceededEvent";
NSString *const OnAuxiliaryDeviceUnbindFailedEvent = @"OnAuxiliaryDeviceUnbindFailedEvent";
NSString *const OnPinChallengePairingWithNonPairingDeviceEvent = @"OnPinChallengePairingWithNonPairingDeviceEvent";
NSString *const OnAuxiliaryDeviceBindingStatusChangedEvent = @"OnAuxiliaryDeviceBindingStatusChangedEvent";
NSString *const OnAuxiliaryDevicePairedEvent = @"OnAuxiliaryDevicePairedEvent";
NSString *const OnAuxiliaryDeviceUnpairedEvent = @"OnAuxiliaryDeviceUnpairedEvent";
NSString *const OnAuxiliaryDeviceMuteChangedEvent = @"OnAuxiliaryDeviceMuteChangedEvent";
NSString *const OnAuxiliaryDeviceBindResponseEventSuccess = @"OnAuxiliaryDeviceBindResponseEventSuccess";
NSString *const OnAuxiliaryDeviceBindResponseEventFailureInvalidData = @"OnAuxiliaryDeviceBindResponseEventFailureInvalidData";
NSString *const OnAuxiliaryDeviceBindResponseEventFailureNoAuthentication = @"OnAuxiliaryDeviceBindResponseEventFailureNoAuthentication";
NSString *const OnAuxiliaryDeviceBindResponseEventFailureNoProximity = @"OnAuxiliaryDeviceBindResponseEventFailureNoProximity";
NSString *const OnAuxiliaryDeviceBindResponseEventFailureSpaceDoesNotExist = @"OnAuxiliaryDeviceBindResponseEventFailureSpaceDoesNotExist";
NSString *const OnAuxiliaryDeviceBindResponseEventFailureBindNotCurrentlyAvailable = @"OnAuxiliaryDeviceBindResponseEventFailureBindNotCurrentlyAvailable";
NSString *const OnAuxiliaryDeviceBindResponseEventFailureOther = @"OnAuxiliaryDeviceBindResponseEventFailureOther";
NSString *const OnAuxiliaryDeviceOfflineEvent = @"OnAuxiliaryDeviceOfflineEvent";
NSString *const OnPinChallengeRequested = @"OnPinChallengeRequested";
NSString *const OnPinChallengeValidPin = @"OnPinChallengeValidPin";
NSString *const OnPinChallengeInvalidPin = @"OnPinChallengeInvalidPin";
NSString *const OnPinChallengeExpiredEvent = @"OnPinChallengeExpiredEvent";
NSString *const OnAuxiliaryDevicePairingAndSelectionEvent = @"OnAuxiliaryDevicePairingAndSelectionEvent";
NSString *const OnPinChallengeRequestDeniedEvent = @"OnPinChallengeRequestDeniedEvent";
NSString *const OnProximityToggleEvent = @"OnProximityToggleEvent";
NSString *const OnAuxiliaryDeviceWifiListChangedEvent = @"OnAuxiliaryDeviceWifiListChangedEvent";
NSString *const OnMoveCallOptionAvailableEvent = @"OnMoveCallOptionAvailableEvent";
NSString *const OnSearchedDeviceSelected = @"OnSearchedDeviceSelected";
NSString *const OnAuxiliaryDeviceErrorEventUpdate = @"OnAuxiliaryDeviceErrorEventUpdate";


//Flags
NSString * const OnFlagOrUnflagMessageAction = @"OnFlagMessageAction";
NSString * const OnMessageFlagsAdded = @"OnMessageFlagsAdded";
NSString * const OnMessageFlagsRemoved = @"OnMessageFlagsRemoved";
NSString * const NewFlagIdKey = @"NewFlagId";
NSString * const OldFlagIdKey = @"OldFlagId";
NSString * const OnFlagIdChanged = @"OnFlagIdChanged";

//Meeting controls
NSString * const OnMeetingStateMuteChanged = @"OnMeetingMuteStateChanged";
NSString * const OnMeetingStateLocalMuteChanged = @"OnMeetingStateLocalMuteChanged";
NSString * const MutePrivilegeChangeKey = @"MutePrivillegeChangeKey";
NSString * const OnMeetingStateLockChanged = @"OnMeetingStateLockChanged";
NSString * const OnMeetingRecordingStateChanged = @"OnMeetingRecordingStateChanged";
NSString * const OnMediaConversionStateChanged = @"OnMediaConversionStateChanged";

NSString * const ReadonlyKey = @"ReadonlyKey";
NSString * const OnChangeMenuSelection = @"OnChangeMenuSelection";
NSString * const MenuItemKey = @"MenuItemKey";

// Calendar
NSString * const OnMeetingsArrived = @"OnMeetingsArrived";
NSString * const OnMeetingsChanged = @"OnMeetingsChanged";
NSString * const OnMeetingsRemoved = @"OnMeetingsRemoved";
NSString * const OnCalendarParticipantInfoChanged = @"OnCalendarParticipantInfoChanged";
NSString * const OnUpcomingMeetingCounterChanged = @"OnUpcomingMeetingCounterChanged";
NSString * const MeetingIdsKey = @"MeetingIdsKey";
NSString * const MeetingIdKey = @"MeetingIdKey";
NSString * const StartTimeKey = @"StartTimeKey";
NSString * const MeetingCounterKey = @"MeetingCounterKey";
NSString * const MeetingCounterTypeKey = @"MeetingCounterTypeKey";
NSString * const OnMeetingPreferenceChanged = @"OnMeetingPreferenceChanged";

// Calendar CommonHead events
NSString * const OnMeetingsArrivedCommon = @"OnMeetingsArrivedCommon";
NSString * const OnMeetingsChangedCommon = @"OnMeetingsChangedCommon";
NSString * const OnMeetingRemovedCommon = @"OnMeetingRemovedCommon";
NSString * const OnDayViewChangedCommon = @"OnDayViewChangedCommon";
NSString * const MeetingListItemsKey = @"MeetingListItemsKey";
NSString * const DateKey = @"DateKey";


//notes
NSString *const OnNotesArrived = @"OnNotesArrived";
NSString *const OnNotesChanged = @"OnNotesChanged";
NSString *const OnNotesRemoved = @"OnNotesRemoved";
NSString *const OnNoteIdChanged = @"OnNoteIdChanged";
NSString *const NoteIdKey = @"NoteId";
NSString *const NoteIdsKey = @"NoteIds";
NSString *const NoteOldIdKey = @"NoteOldId";

//User actions
NSString *const onShowSpaceActivityForCallAction = @"onShowSpaceActivityForCallAction";
NSString *const SpaceActivityKey = @"SpaceActivityKey";
NSString *const SpaceActivityInfoShowAssignHostKey = @"SpaceActivityInfoShowAssignHostKey";
NSString *const OnToggleDisplayParticipantListForCall = @"OnToggleDisplayParticipantListForCall";
NSString *const OnForceDisplayParticipantListForCall = @"OnForceDisplayParticipantListForCall";
NSString *const OnOpenInviteToMeetingParticipantListForCall = @"OnOpenInviteToMeetingParticipantListForCall";
NSString *const OnToggleDisplayMessagesForCall = @"OnToggleDisplayMessagesForCall";
NSString *const PeopleTypeKey = @"PeopleTypeKey";

// PSTN
NSString *const TollFreeDialInKey = @"TollFreeDialInKey";
NSString *const TollDialInKey = @"TollDialInKey";
NSString *const GlobalDialInKey = @"GlobalDialInKey";
NSString *const AttendeeIdKey = @"AttendeeIdKey";

// Wait-in-lobby
NSString *const OnWaitInLobbyIsEmpty = @"OnWaitInLobbyIsEmpty";

// Common Head Participant List
NSString *const OnParticipantsAddedCommon = @"OnParticipantsAddedCommon";
NSString *const OnParticipantsUpdatedCommon = @"OnParticipantsUpdatedCommon";
NSString *const OnParticipantsRemovedCommon = @"OnParticipantsRemovedCommon";
NSString *const OnParticipantListInvalidated = @"OnParticipantListInvalidated";
NSString *const OnContactUpdatedCommon = @"OnContactUpdatedCommon";
NSString *const ParticipantListItemsKey = @"ParticipantListItemsKey";

// Common Head Presence
NSString *const OnPresenceChanged = @"OnPresenceChanged";
NSString *const PresenceKey = @"PresenceKey";

// Common Head Calling Interstitial
NSString *const OnCallingInterstitialCallJoined = @"OnCallingInterstitialCallJoined";
NSString *const OnCallingInterstitialDataArrived = @"OnCallingInterstitialDataArrived";
NSString *const OnCallingInterstitialLocalVideoStreamingChanged = @"OnCallingInterstitialLocalVideoStreamingChanged";
NSString *const ShowSelfPreviewKey = @"ShowSelfPreviewKey";
NSString *const CallingInterstitialDataKey = @"CallingInterstitialDataKey";

// Common Head Calling Devices
NSString *const OnCallingDevicesDataArrived = @"OnCallingDevicesDataArrived";
NSString *const CallingDevicesDataKey = @"CallingDevicesDataKey";

// Common Head Personal Room View Model
NSString *const OnPersonalRoomMeetingDetails = @"OnPersonalRoomMeetingDetails";
NSString *const OnPersonalRoomMeetingClaimed = @"OnPersonalRoomMeetingClaimed";
NSString *const PersonalRoomMeetingDetailsKey = @"PersonalRoomMeetingDetailsKey";
NSString *const TooManyAttemptsKey = @"TooManyAttempsKey";


// Common Head Toast
NSString *const OnMeetingToastUpdated = @"OnMeetingToastUpdate";
NSString *const ToastItemKey = @"ToastItemKey";
NSString *const OnToastAdded = @"OnToastAdded";
NSString *const OnToastRemoved = @"OnToastRemoved";
NSString *const OnToastUpdated = @"OnToastUpdated";
NSString *const OnLocalRecordingToastUpdated = @"OnLocalRecordingToastUpdated";
NSString *const ToastEventItemKey = @"ToastEventItemKey";

// Richtext
NSString *const OnHeadingShortcut = @"OnHeadingShortcut";
NSString *const Identifier = @"Identifier";

//User Profile menu
NSString *const OnSignOutSelected = @"OnSignOutSelected";
NSString *const OnCloseProfileWindow = @"OnCloseProfileWindow";

NSString *const OnCloseParticipantList = @"OnCloseParticipantList";

NSString *const UserId = @"UserId";

NSString *const OnClosePopover = @"OnClosePopover";

//code gen
NSString * const OnBrickletsAdded = @"OnBrickletsAdded";
NSString * const OnBrickletsChanged = @"OnBrickletsChanged";
NSString * const OnBrickletsRemoved = @"OnBrickletsRemoved";
NSString * const BrickletsKey  = @"BrickletsKey";
NSString * const BrickletIdsKey  = @"BrickletIdsKey";
NSString * const IsUserInitiatedKey  = @"IsUserInitiatedKey";

NSString * const OnLaunchCiscoHelpPage = @"OnLaunchCiscoHelpPage";

// open web view
NSString *const WebViewURLKey = @"WebViewURLKey";
NSString *const WebViewTitleKey = @"WebViewTitleKey";
NSString *const WebViewWidthKey = @"WebViewWidthKey";
NSString *const WebViewHeightKey = @"WebViewHeightKey";
// Client compatability hint (force upgrade)
NSString *const OnClientUpgradeHint = @"OnClientUpgradeHint";
NSString *const ClientCompatabilityHintKey = @"ClientCompatabilityHintKey";

NSString *const OnShowPairingDevicePopover = @"OnShowPairingDevicePopover";

// Custom Status
NSString *const SetCustomStatus = @"SetCustomStatus";
NSString *const SetCustomStatusValue = @"SetCustomStatusValue";
NSString *const ClearCustomStatus = @"ClearCustomStatus";

//Voicemail
NSString *const OnVoicemailPlayerPlayed = @"OnVoicemailPlayerPlayed";
NSString *const VoicemailPlayerKey = @"VoicemailPlayerKey";

NSString *const ExpandChangeBackgroundUI = @"ExpandChangeBackgroundUI";

//Escalation
NSString *const EscalateCallToMeetingDismissIncomingAlert = @"EscalateCallToMeetingDismissIncomingAlert";

//Migration
NSString *const OnStartMigration = @"OnStartMigration";

NSString *const OnSetCustomDND = @"OnSetCustomDND";
NSString *const DndDuration = @"DndDuration";

@end
