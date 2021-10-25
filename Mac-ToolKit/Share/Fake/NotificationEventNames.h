//
//  NotificationEventNames.h
//  SparkMacDesktop
//
//  Created by jimmcoyn on 18/08/2015.
//  Copyright © 2015 Cisco Systems. All rights reserved.
//

#ifndef NotificationEventNames_h
#define NotificationEventNames_h

#import <Foundation/Foundation.h>

extern NSString *const OnLoginSuccessful;
extern NSString *const OnLoginInProgress;

extern NSString* const DialogueTitleKey;
extern NSString* const DialogueMessageKey;

//Global window trigger events
extern NSString *const OnSparkMainWindowDidMiniaturizeKey;
extern NSString *const OnSparkMainWindowWillClose;
extern NSString *const OnSparkMainWindowBecomeFullWindow;
extern NSString *const OnSparkMainWindowBecomeCompactWindow;

extern NSString *const OnSparkMediaWindowDidMiniaturizeKey;
extern NSString *const OnSparkMediaWindowDidDeminiaturizeKey;

// common head events
extern NSString *const OnCommonHeadError; // ICommonHeadFrameworkCallback::onError notification
extern NSString *const AlertKey;
extern NSString *const OnCommonHeadAvatarsChanged; // only to be used to listen to CH, as this will update the avatar cache so UI elements can then be notified
extern NSString *const AvatarIdsKey;
// UI layer avatar cache notifications
extern NSString *const OnAvatarCacheChanged; // should be used for UI layer listening for avatar changes to make sure the cache updates first

// common head conversation/teams
extern NSString *const OnBrickletsAdded;
extern NSString *const OnBrickletsChanged;
extern NSString *const OnBrickletsRemoved;

extern NSString *const OnViewModelConversationsArrived;
extern NSString *const OnViewModelConversationsChanged;
extern NSString *const OnViewModelConversationsRemoved;
extern NSString *const OnViewModelConversationIdChanged;
extern NSString *const OnViewModelTeamsArrived;
extern NSString *const OnViewModelMessagesChanged;
extern NSString *const OnViewModelMessagesArrived;

// conversation events
extern NSString *const OnConversationsChanged;
extern NSString *const OnConversationIdChanged;
extern NSString *const OnOneOnOneFoundWithDeletedUser;
extern NSString *const OnConversationsArrived;
extern NSString *const OnConversationsRemoved;
extern NSString *const OnMessagesArrived;
extern NSString *const OnMessagesChanged;
extern NSString *const OnMessageIdChanged;
extern NSString *const OnIntervalsCollapsed;
extern NSString *const OnSelfMentionsAdded;
extern NSString *const OnMissingMessagesChanged;
extern NSString *const OnConversationErrorHappened;
extern NSString *const OnConversationCreationFailed;
extern NSString *const OnNotAllParticipantsAdded;
extern NSString *const OnReactionsChanged;
extern NSString *const OnStageFileAction;
extern NSString *const OnContentDroppedAction;

extern NSString *const AvatarFrameKey;
extern NSString *const ToastFrameKey;
extern NSString *const ConfigIdKey;
extern NSString *const ConfigValueKey;
extern NSString *const CachedValuesKey;

//Connectivity Banner events
extern NSString *const OnShowConnectivityBanner;
extern NSString *const OnHideConnectivityBanner;

extern NSString *const ConnectivityBannerStringKey;
extern NSString *const ConnectivityBannerTypeKey;

// UCLogin Service events
extern NSString *const OnServiceReady;

// Head-to-head events
extern NSString *const OnTeamSelectedAction;
extern NSString *const OnTeamActivatedAction;
extern NSString *const OnConversationSelectedAction;
extern NSString *const OnContactCardPopoverCloseAction;
extern NSString *const OnHighlightMessageInConversation;
extern NSString *const OnStartOneToOneConversationAction;
extern NSString *const OnJoinConversationAction;
extern NSString *const OnUpdateCallTimer;
extern NSString *const OnContextChange;
extern NSString *const OnUnjoinedTeamSearchAction;
extern NSString *const OnPreviewAnnotationContentAction;
extern NSString *const OnPreviewContentAction;
extern NSString *const OnOpenFileContentAction;
extern NSString *const OnMarkdownEnabledChanged;
extern NSString *const OnWhiteboardSessionStarted;
extern NSString *const OnWhiteboardSessionEnded;
extern NSString *const OnWhiteboardSessionReadOnlyChanged;
extern NSString *const OnWhiteboardSessionFatalError;
extern NSString *const OnWhiteboardSessionInfo;
extern NSString *const OnWhiteboardAnnotationFailed;
extern NSString *const OnWhiteboardAnnotationCanClearAll;
extern NSString *const OnWhiteboardServiceDeinit;
extern NSString *const OnEditWhiteboardAndShareOnCall;
extern NSString *const OnNewWhiteboardAndShareOnCall;
extern NSString *const OnCallActivityChanged;
extern NSString *const OnSelectedEntityChanged;
extern NSString *const OnShareWhiteBoardLiveAction;
extern NSString *const OnToggleAddPeopleAction;
extern NSString *const OnOpenWebViewRequested;
extern NSString *const OnCallingSelectedDeviceChanged;
extern NSString *const OnWhiteboardInit;
extern NSString *const OnWhiteboardAddContents;
extern NSString *const OnWhiteboardSetBackgroundImage;
extern NSString *const OnWhiteboardRealtimeMessage;
extern NSString *const OnWhiteboardSaveContents;
extern NSString *const OnWhiteboardGetImageSnapshot;
extern NSString *const OnWhiteboardClearBoard;
extern NSString *const OnWhiteboardSetReadOnly;
extern NSString *const OnWhiteboardSwitchColor;
extern NSString *const OnWhiteboardSwitchToEraser;
extern NSString *const OnNativeMessagingViewToggled;
extern NSString *const OnCallNotificationArrivedFromParticipantList;

extern NSString *const OnEditWhiteboardAction;
extern NSString *const OnShowWirelessSectionAction;
extern NSString *const OnWhiteboardShareLoaded;
extern NSString *const OnShowCallControlsAfterWhiteboarding;
extern NSString *const OnNewWhiteboardAction;
extern NSString *const OnOpenCallingDevicesPreferences;
extern NSString *const OnOpenSearchWirelessDevices;
extern NSString *const OnOpenSearchAction;
extern NSString *const OnShowSearch;
extern NSString *const OnSocialRoomFilterUpdated;
extern NSString *const OnFourthColumnDidStartAnimating;
extern NSString *const OnFourthColumnDidFinishAnimating;
extern NSString *const OnFourthColumnDidClosed;
extern NSString *const OnMediaControlsVisbilityStateChanged;
extern NSString *const OnFourthColumnOpenChanged;
extern NSString *const OnFourthColumnActivityChanged;
extern NSString *const OnCloseSearchResults;
extern NSString *const OnForwardMessageAction;
extern NSString *const OnOpenSpaceButtonClicked;
extern NSString *const OnBindSpaceSelectedAction;
extern NSString *const OnConversationTabActivityChanged;
extern NSString *const OnShareBorderControlsChanged;
extern NSString *const OnCreateSpaceAction;
extern NSString *const OnDisplayConnectingChanged;

//
extern NSString *const OnSyncingStatusChanged;
extern NSString *const OnMercuryStateChanged;
extern NSString *const OnReAuthRequired;
extern NSString *const OnUnauthorisedDomain;
extern NSString *const OnCoreFrameworkInitialisationFailed;
extern NSString *const OnApplicationStartupCompleted;
extern NSString *const OnApplicationStartupFailed;
extern NSString *const OnDatabaseResetCompleted;
extern NSString *const OnApplicationAboutToTerminate;
extern NSString *const OnConfigReady;
extern NSString *const OnExportDiagnosticsData;
extern NSString *const OnCertPinningFailed;
extern NSString *const OnCreateConversation;
extern NSString *const OnParticipantStatusChanged;
extern NSString *const OnParticipantsStatusChanged;
extern NSString *const OnDataWarehouseInitialized;
extern NSString *const OnMediaEngineInitialized;
extern NSString *const OnMediaProcessInitialized;
extern NSString *const OnMediaEngineHanged;
extern NSString *const OnAudioSharePluginStatus;
extern NSString *const OnEcmLoggedIn;
extern NSString *const OnEcmLoggedOut;
extern NSString *const OnEcmReAuthRequired;
extern NSString *const OnEcmReAuthenticated;
extern NSString *const OnECMEasyShareResyncStatusChanged;
extern NSString *const OnECMResyncButtonClicked;
extern NSString *const OnConfigUpdated;
extern NSString *const OnBeginBackgroundTask;
extern NSString *const OnEndBackgroundTask;
extern NSString *const OnLaunchEcmAuthentication;
extern NSString *const OnCompleteEcmAuthentication;

//proxy server
extern NSString *const OnProxyAuthenticationRequired;

// login events
extern NSString *const OnEmailVerificationSuccessful;
extern NSString *const OnEmailVerificationFailed;
extern NSString *const OnLoginAttempted;
extern NSString *const OnLoginComplete;
extern NSString *const OnLoginFailed;

// server health
extern NSString *const OnServerHealthRetrieved;
extern NSString *const OnServerReachabilityCheckCompleted;

// feedback events
extern NSString *const OnFeedbackFileUploadSuccesful;
extern NSString *const OnFeedbackFileUploadFailed;
extern NSString *const OnRequestUrlSuccesful;
extern NSString *const OnRequestUrlFailed;

// call events
extern NSString *const OnShowIncomingCallAlert;
extern NSString *const OnCallParkExpireAlert;
extern NSString *const OnDismissIncomingCallAlert;
extern NSString *const OnCallConnected;
extern NSString *const OnCallJoined;
extern NSString *const OnCallDisconnected;
extern NSString *const OnCallStateChanged;
extern NSString *const OnRemoteAuxVideoReady;
extern NSString *const OnRemoteAuxVideoInUse;
extern NSString *const OnActiveSpeakerChanged;
extern NSString *const OnParkStateChanged;
extern NSString *const OnRemoteParticipantCountChanged;
extern NSString *const OnRemoteVideoStateChanged;
extern NSString *const OnRemoteShareStreamingChanged;
extern NSString *const OnRemoteVideoStreamingChanged;
extern NSString *const OnLocalVideoStateChanged;
extern NSString *const OnLocalVideoStreamingChanged;
extern NSString *const OnLocalVideoStreamSizeChanged;
extern NSString *const OnShareStateChanged;
extern NSString *const OnSharedCapturedWindowsChanged;
extern NSString *const OnSharePositionChanged;
extern NSString *const OnMeetingInfoChanged;
extern NSString *const OnWhiteboardShareStateChanged;
extern NSString *const OnAnnotateDesktopShare;
extern NSString *const OnDeviceSelectionChanged;
extern NSString *const OnCallParticipantsChanged;
extern NSString *const OnJoinedParticipantCountChanged;
extern NSString *const OnCallFailed;
extern NSString *const OnLocalShareIsReady;
extern NSString *const OnMediaDisconnected;
extern NSString *const OnCallConnecting;
extern NSString *const OnCallConversationChanged;
extern NSString *const OnMeetingHostChanged;
extern NSString *const OnAudioStreamingChanged;
extern NSString *const OnShowCallRating;
extern NSString *const OnCallNetworkCongestionChanged;
extern NSString *const OnCallWaitForMeetingPin;
extern NSString *const OnCallWaiting;
extern NSString *const OnCallWakeUp;
extern NSString *const OnMediaConnectionFailedToRecover;
extern NSString *const OnEccFailedToRecover;
extern NSString *const OnXApiRequestFailed;
extern NSString *const OnDevcieNotReachableToDirectShare;
extern NSString *const OnStartRinger;
extern NSString *const OnStopRinger;
extern NSString *const OnStartCallWaiting;
extern NSString *const OnStartTone;
extern NSString *const OnStopTone;
extern NSString *const OnStartPickupRinger;
extern NSString *const OnStartParkExpiredRinger;
extern NSString *const OnStartRingback;
extern NSString *const OnStopRingback;
extern NSString *const OnStartBusyTone;
extern NSString *const OnStopBusyTone;
extern NSString *const OnStartReconnectTone;
extern NSString *const OnStopReconnectTone;
extern NSString *const OnStartNotFoundTone;
extern NSString *const OnStopNotFoundTone;
extern NSString *const OnStartDtmfTone;
extern NSString *const OnStopDtmfTone;
extern NSString *const OnCallSleepScreenSaverChanged;
extern NSString *const OnCallRequested;
extern NSString *const OnSearchStringCallAction;
extern NSString *const OnCallWithEditAction;
extern NSString *const OnCallWithEditDialPadAction;
extern NSString *const OnCallAudioActiveSpeakerChanged;
extern NSString *const OnShowRemoteAvatarChanged;
extern NSString *const OnShowOnlyPersonInRoomChanged;
extern NSString *const OnResourceRoomStateChanged;
extern NSString *const OnResourceRoomError;
extern NSString *const OnShareWillMiniaturizeWindow;
extern NSString *const OnShareShouldExcludeWindow;
extern NSString *const OnWindowCoverStateChanged;
extern NSString *const OnMoveCallStarted;
extern NSString *const OnCallHoldStateChanged;
extern NSString *const OnExConferenceStateChanged;
extern NSString *const OnActiveCallChanged;
extern NSString *const OnCallCapsChanged;
extern NSString *const OnCallJoinedByRemote;
extern NSString *const OnAdaptiveCardSubmitStatusReturn;
//Network event
extern NSString *const OnNetworkStatusChanged;
extern NSString *const NetworkStatusKey;

//PSTN
extern NSString *const OnPSTNProvisionalDeviceJoined;
extern NSString *const OnPSTNDialinComplete;
extern NSString *const OnPSTNDialinFailed;

//tutorial
extern NSString *const OnCoachmarksResetAction;
extern NSString *const OnWebexMigrationProfileCoachMarkAction;
extern NSString *const OnWebexMigrationProfileCoachMarkKey;

//call history events
extern NSString *const OnCallHistoryEvent;
extern NSString *const OnUnreadMissedCallCountChange;

//Voicemail
extern NSString *const OnVoicemailInfoEvent;

//media device events
extern NSString *const OnCameraVideoReadyEvent;
extern NSString *const OnMediaDeviceListChangedEvent;
extern NSString *const OnMediaDeviceChangedEvent;
extern NSString *const OnSelectedDeviceChangedEvent;
extern NSString *const OnRenderSizeChangedEvent;
extern NSString *const OnInputPeak;
extern NSString *const OnMediaDeviceHeadDetectedChange;
extern NSString *const OnMediaDeviceError;

// contact events
extern NSString *const OnSelfUserAvailable;
extern NSString *const OnContactChanged;

//calls ui triggered
extern NSString *const OnJoinCallAction;
extern NSString *const OnShareAction;
extern NSString *const OnStartCallAction;
extern NSString *const OnShowCallStatsAction;
extern NSString *const OnFileShareReceived;
extern NSString *const OnStopFileSharing;
extern NSString *const OnSpaceHeaderCallDropDownRequested;
extern NSString *const OnAddPeopleFTERequested			;

//ExCalling Notifications
extern NSString *const OnExCallingRegistrationChanged;
extern NSString *const OnExCallingAuthenticationChanged;

//ExCalling Keys
extern NSString *const ExRegistrationKey;
extern NSString *const ExAuthenticationKey;
extern NSString *const ExAuthenticationReasonKey;

extern NSString *const OnRoomAvatarChanged;//OnRoomAvatarChanged
extern NSString *const OnAvatarChanged;//OnRoomAvatarChanged
extern NSString *const OnThumbnailChanged;
extern NSString *const OnThumbnailPreviewChanged;
extern NSString *const OnThumbnailDownloadFailed;
extern NSString *const OnReadersChanged;
extern NSString *const OnDownloadProgress;
extern NSString *const OnDownloadComplete;
extern NSString *const OnDownloadFailed;
extern NSString *const OnDownloadBlocked;
extern NSString *const OnDownloadProgress;
extern NSString *const OnUploadProgress;
extern NSString *const OnDeleteMessageAction;
extern NSString *const OnDownloadBlockedAction;
extern NSString *const OnContextMenuAction;
extern NSString *const OnUnreadCountersChanged;
extern NSString *const OnStartSpaceRequested;
extern NSString *const OnStartOneToOneConversationRequested;
extern NSString *const OnConversationsFetchComplete;
extern NSString *const OnOneToOneEncryptionHealRequired;
extern NSString *const OnOneToOneEncryptionHealResult;
extern NSString *const OnCustomAppsRefreshed;
extern NSString *const OnConversationRefreshed;
extern NSString *const OnStartThread;

// keys
extern NSString *const ReloadRoomList;
extern NSString *const IncognitoKey;
extern NSString *const DropImageListKey;
extern NSString *const DropFilePathListKey;
extern NSString *const DropTextKey;
extern NSString *const CallActivityKey;
extern NSString *const CallOriginKey;
extern NSString *const DeviceIdKey;
extern NSString *const ConversationIdsKey;
extern NSString *const ConversationIdKey;
extern NSString *const MessageAlertSound;
extern NSString *const RecordingIdKey;
extern NSString *const CallIdKey;
extern NSString *const LineIdKey;
extern NSString *const PcmRawsKey;
extern NSString *const UcmToneTypeKey;
extern NSString *const ActivityTypeKey;
extern NSString *const ActivityIdKey;
extern NSString *const ActivityTabTypeKey;
extern NSString *const ActivityKey;
extern NSString *const UpdateConversationKey;
extern NSString *const WindowKey;
extern NSString *const OldActivityIdKey;
extern NSString *const NewActivityIdKey;
extern NSString *const ConversationContextKey;
extern NSString *const UserInitiatedKey;
extern NSString *const AlertTypeKey;
extern NSString *const ConversationInputBoxFocusKey;
extern NSString *const MessageScrollReasonKey;
extern NSString *const MessageIdKey;
extern NSString *const MessageIdsKey;
extern NSString *const NewMessageIdKey;
extern NSString *const OldMessageIdKey;
extern NSString *const ParticipantKey;
extern NSString *const ParticipantIdKey;
extern NSString *const ParticipantIdsKey;
extern NSString *const ContactIdsKey;
extern NSString *const IsSyncingKey;
extern NSString *const MercuryStateKey;
extern NSString *const VideoActiveKey;
extern NSString *const NewConversationIdKey;
extern NSString *const OldConversationIdKey;
extern NSString *const NewHostIdKey;
extern NSString *const OldHostIdKey;
extern NSString *const ContentIndexKey;
extern NSString *const DownloadPathKey;
extern NSString *const PreviewPageNumberKey;
extern NSString *const PreviewPageImageRawDataKey;
extern NSString *const PreviewPageImageDownloadSuccessKey;
extern NSString *const ProgressKey;
extern NSString *const ErrorCodeKey;
extern NSString *const ParticipantListKey;
extern NSString *const CallStateKey;
extern NSString *const AddedKey;
extern NSString *const ModeratorKey;
extern NSString *const ScrollToItemKey;
extern NSString *const SearchHighlightItemKey;
extern NSString *const LeaveSearchOpenKey;
extern NSString *const SwitchToRoomViewKey;
extern NSString *const ShouldCloseChildWindowsKey;
extern NSString *const CallHistoryIdsKey;
extern NSString *const MediaDeviceTypeKey;
extern NSString *const OldMediaDeviceKey;
extern NSString *const NewMediaDeviceKey;
extern NSString *const MediaDeviceEventTypeKey;
extern NSString *const MediaErrorReasonKey;
extern NSString *const DownloadFileNameKey;
extern NSString *const CallFailureReasonKey;
extern NSString *const IsExistingEmailKey;
extern NSString *const IsResendKey;
extern NSString *const IsSignUpKey;
extern NSString *const IsDirectorySyncEnabledKey;
extern NSString *const SSOKey;
extern NSString *const VerificationEmailTriggeredKey;
extern NSString *const UserCreatedKey;
extern NSString *const HasPasswordKey;
extern NSString *const ConversationsWithCallsKey;
extern NSString *const DiagnosticsKey;
extern NSString *const CallCongestionKey;
extern NSString *const CurrentSparkContextKey;
extern NSString *const ServiceNameKey;
extern NSString *const ServiceStateKey;
extern NSString *const ContentSelectionKey;
extern NSString *const ConversationErrorKey;
extern NSString *const ConversationTypeKey;
extern NSString *const PrimaryIdKey;
extern NSString *const SecondaryIdKey;
extern NSString *const AudioDeviceIdKey;
extern NSString *const AppStartupFailure;
extern NSString *const EmailFailure;
extern NSString *const LoginFailure;
extern NSString *const MercuryState;
extern NSString *const StopRinger;
extern NSString *const IsMissingMessagesKey;
extern NSString *const ChannelUrlKey;
extern NSString *const FromAnnotationPreview;
extern NSString *const AnnotationFileNameKey;
extern NSString *const AnnotationSharedDateKey;
extern NSString *const AnnotationSharedNameKey;
extern NSString *const MediaControlsVisbilityKey;
extern NSString *const ContactCardSenderKey;
extern NSString *const ContactCardPopoverBoundsKey;
extern NSString *const ContactCardPopoverPreferredEdgeKey;
extern NSString *const ContactCardPopoverShouldAnimateKey;
extern NSString *const ContactCardPopoverBehaviorKey;
extern NSString *const ContactCardDelegateKey;
extern NSString *const SearchStringKey;
extern NSString *const CallWithEditStringKey;
extern NSString *const CallWithEditDialPadStringKey;
extern NSString *const MouseEventTypeKey;
extern NSString *const MouseEnterEvent;
extern NSString *const MouseLeaveEvent;
extern NSString *const OnConversationScrollEvent;
extern NSString *const OnAvatarMouseEvent;
extern NSString *const WhiteboardSessionIdKey;
extern NSString *const WhiteboardBackgroundImageKey;
extern NSString *const WhiteboardBackgroundImageWidthKey;
extern NSString *const WhiteboardBackgroundImageHeightKey;
extern NSString *const WhiteboardBackgroundImageTypeKey;
extern NSString *const WhiteboardChannelUrlKey;
extern NSString *const WhiteboardIsAnnotationKey;
extern NSString *const WhiteboardInitDisplayNameKey;
extern NSString *const WhiteboardInitUserIdKey;
extern NSString *const WhiteboardAddContentsKey;
extern NSString *const WhiteboardSetBackgroundImageDataKey;
extern NSString *const WhiteboardSetBackgroundImageWidthKey;
extern NSString *const WhiteboardSetBackgroundImageHeightKey;
extern NSString *const WhiteboardSetBackgroundImageMimeTypeKey;
extern NSString *const WhiteboardRealtimeMessageJsonKey;
extern NSString *const WhiteboardSaveContentsIdKey;
extern NSString *const WhiteboardSaveContentsSuccessKey;
extern NSString *const WhiteboardSetReadOnlyKey;
extern NSString *const WhiteboardSwitchColorHexColorKey;
extern NSString *const WhiteboardGetImageSnapshotMessageIdKey;
extern NSString *const MoveCallDirectionKey;
extern NSString *const AudioSharePluginStatusKey;
extern NSString *const ConversationHealSuccessKey;
extern NSString *const CloseFourthColumnKey;
extern NSString *const FourthColumnOpenKey;
extern NSString *const SearchTypeStingKey;
extern NSString *const ActiveCallIdKey;
extern NSString *const EcmProviderKey;
extern NSString *const EcmLoginStatusKey;
extern NSString *const ECMEasyShareResyncCompletedKey;
extern NSString *const QuoteMessageKey;
extern NSString *const ParticipantsKey;
extern NSString *const BindSpaceKey;
extern NSString *const CallNotificationKey;

extern NSString *const IsPmrKey;
extern NSString *const MeetingLockedErrorCodeKey;
extern NSString *const MeetingNameKey;
extern NSString *const GuestPinRequiredKey;
extern NSString *const CallChangedContactsKey;
extern NSString *const EmailKey;
extern NSString *const WindowListHandleKey;
extern NSString *const ShareRectKey;
extern NSString *const MinimizeKey;

extern NSString *const CopyLinkErrorMessageTitleKey;
extern NSString *const CopyLinkErrorMessageBodyKey;

extern NSString *const ShowConnecting;

extern NSString *const SharingStatusKey;

//Adaptive Cards
extern NSString *const OnAdaptiveCardSubmitStatusReturnKey;

//Network response keys
extern NSString *const FailureCodeKey;
extern NSString *const FailureReasonKey;
extern NSString *const WasSuccessfulKey;

//User Preferences Keys
extern NSString *const SelectedSpeakerKey;
extern NSString *const SelectedMicrophoneKey;
extern NSString *const SelectedCameraKey;
extern NSString *const SelectedRingerKey;
extern NSString *const PlayRingerOnAllDevicesKey;

extern NSString *const TrackTypeKey;

extern NSString *const CallStateKey;
extern NSString *const MuteStateKey;
extern NSString *const AudioStatesKey;
extern NSString *const RemoteMuteStatesKey;
extern NSString *const LocalMuteStatesKey;
extern NSString *const CallLockedKey;
extern NSString *const CallRecordingStateKey;
extern NSString *const SleepScreenSaverKey;
extern NSString *const CallRequestedKey;
extern NSString *const AudioActiveSpeakerStatesKey;
extern NSString *const MediaDirectionKey;
extern NSString *const CanBeMutedKey;
extern NSString *const MediaConversionStateKey;
extern NSString *const ConverterIdKey;
extern NSString *const FilepathKey;

extern NSString *const FeedbackIdKey;
extern NSString *const UrlKey;
extern NSString *const UrlTypeKey;

extern NSString *const ProxyUrlKey;


extern NSString *const OnPreferencesActionShortcut;
extern NSString *const PreferencesIdenitfierKey;
extern NSString *const OnAccountActionSource;
extern NSString *const PickerLauncher;
extern NSString *const EcmFolderFilesFetcher;


//dev harness
extern NSString *const OnDevHarnessBringToFront;

extern NSString *const OnUpgradeAvailable;

extern NSString *const OnPersonalInsightsLoginComplete;

extern NSString *const OnTeamsArrived;
extern NSString *const OnTeamsChanged;
extern NSString *const OnTeamRoomsChanged;
extern NSString *const TeamIdsKey;
extern NSString *const TeamIdKey;
extern NSString *const OnTeamRoomsAdded;
extern NSString *const OnTeamRoomCreated;
extern NSString *const OnTeamRoomsRemoved;
extern NSString *const NewTeamRoomIdKey;
extern NSString *const OldTeamRoomIdKey;
extern NSString *const NewTeamIdKey;
extern NSString *const OldTeamIdKey;
extern NSString *const TeamRoomIdsKey;
extern NSString *const TeamRoomIdKey;
extern NSString *const OnTeamIdChanged;
extern NSString *const OnTeamRoomIdChanged;
extern NSString *const OnTeamRoomJoinStateChange;
extern NSString *const OnTeamsRemoved;

// Auxiliary Device

extern NSString *const OnAuxiliaryDevicesAddedEvent;
extern NSString *const OnAuxiliaryDeviceIdsKey;

extern NSString *const OnAuxiliaryDeviceSomeEventHappened;
extern NSString *const OnAuxiliaryDeviceListChangedEvent;
extern NSString *const OnSelectedAuxiliaryDeviceChangedEvent;
extern NSString *const OnAuxiliaryDeviceUpdatedEvent;
extern NSString *const OnAuxiliaryDeviceRegisteredEvent;
extern NSString *const OnAuxiliaryDeviceUnregisteredEvent;
extern NSString *const OnAuxiliaryDeviceProvisionedEvent;
extern NSString *const OnAuxiliaryDeviceUnprovisionedEvent;
extern NSString *const OnAuxiliaryDeviceRenameSuccessEvent;
extern NSString* const OnStartAudioRecorderEvent;
extern NSString* const OnStopAudioRecorderEvent;
extern NSString* const OnShutDownAudioRecorderEvent;
extern NSString* const OnRecordingEvent;
extern NSString* const OnStartProximityRecordingEvent;
extern NSString* const OnStopProximityRecordingEvent;
extern NSString* const OnWakeProximityRecordingEvent;
extern NSString* const OnSleepProximityRecordingEvent;
extern NSString* const OnAuxiliaryDeviceAvailabilityChanged;
extern NSString* const OnAuxiliaryDeviceStartShareEvent;
extern NSString* const OnAuxiliaryDeviceStopShareEvent;
extern NSString* const OnAuxiliaryDeviceShareFailEvent;
extern NSString* const OnAuxiliaryDeviceBindSucceededEvent;
extern NSString* const OnAuxiliaryDeviceBindFailedEvent;
extern NSString* const OnAuxiliaryDeviceUnbindSucceededEvent;
extern NSString* const OnAuxiliaryDeviceUnbindFailedEvent;
extern NSString* const OnPinChallengePairingWithNonPairingDeviceEvent;
extern NSString* const OnAuxiliaryDeviceBindingStatusChangedEvent;
extern NSString* const OnAuxiliaryDevicePairedEvent;
extern NSString* const OnAuxiliaryDeviceUnpairedEvent;
extern NSString* const OnAuxiliaryDeviceMuteChangedEvent;
extern NSString* const OnAuxiliaryDeviceBindResponseEventSuccess;
extern NSString* const OnAuxiliaryDeviceBindResponseEventFailureInvalidData;
extern NSString* const OnAuxiliaryDeviceBindResponseEventFailureNoAuthentication;
extern NSString* const OnAuxiliaryDeviceBindResponseEventFailureNoProximity;
extern NSString* const OnAuxiliaryDeviceBindResponseEventFailureSpaceDoesNotExist;
extern NSString* const OnAuxiliaryDeviceBindResponseEventFailureBindNotCurrentlyAvailable;
extern NSString* const OnAuxiliaryDeviceBindResponseEventFailureOther;
extern NSString* const OnAuxiliaryDeviceOfflineEvent;
extern NSString* const OnPinChallengeRequested;
extern NSString* const OnPinChallengeValidPin;
extern NSString* const OnPinChallengeInvalidPin;
extern NSString* const OnPinChallengeExpiredEvent;
extern NSString* const OnAuxiliaryDevicePairingAndSelectionEvent;
extern NSString* const OnPinChallengeRequestDeniedEvent;
extern NSString* const OnProximityToggleEvent;
extern NSString* const OnAuxiliaryDeviceWifiListChangedEvent;
extern NSString* const OnMoveCallOptionAvailableEvent;
extern NSString* const DisplayNameKey;
extern NSString *const AddedCallParticipantsKey;
extern NSString *const RemovedCallParticipantsKey;
extern NSString *const InvitedCallParticipantsKey;
extern NSString *const OnSearchedDeviceSelected;
extern NSString *const OnAuxiliaryDeviceErrorEventUpdate;

extern NSString *const OnShowPairingDevicePopover;

//Flags
extern NSString *const OnMessageFlagsAdded;
extern NSString *const OnMessageFlagsRemoved;
extern NSString *const NewFlagIdKey;
extern NSString *const OldFlagIdKey;
extern NSString *const OnFlagIdChanged;

//Meeting controls
extern NSString *const OnMeetingStateMuteChanged;
extern NSString *const MutePrivilegeChangeKey;
extern NSString *const OnMeetingStateLockChanged;
extern NSString *const OnMeetingStateLocalMuteChanged;
extern NSString *const OnMeetingRecordingStateChanged;
extern NSString *const OnMediaConversionStateChanged;
extern NSString *const OnChangeMenuSelection;
extern NSString *const MenuItemKey;
extern NSString *const ReadonlyKey;


// Calendar
extern NSString * const OnMeetingsArrived;
extern NSString * const OnMeetingsChanged;
extern NSString * const OnMeetingsRemoved;
extern NSString * const OnCalendarParticipantInfoChanged;
extern NSString * const OnUpcomingMeetingCounterChanged;
extern NSString * const MeetingIdsKey;
extern NSString * const MeetingIdKey;
extern NSString * const StartTimeKey;
extern NSString *const OnNotesArrived;
extern NSString *const OnNotesChanged;
extern NSString *const OnNotesRemoved;
extern NSString *const OnNoteIdChanged;
extern NSString *const NoteIdKey;
extern NSString *const NoteIdsKey;
extern NSString *const NoteOldIdKey;
extern NSString *const MeetingCounterKey;
extern NSString *const MeetingCounterTypeKey;
extern NSString *const OnMeetingPreferenceChanged;

// Calendar CommonHead events
extern NSString * const OnMeetingsArrivedCommon;
extern NSString * const OnMeetingsChangedCommon;
extern NSString * const OnMeetingRemovedCommon;
extern NSString * const OnDayViewChangedCommon;
extern NSString * const MeetingListItemsKey;
extern NSString * const DateKey;

//User action
extern NSString *const onShowSpaceActivityForCallAction;
extern NSString *const SpaceActivityKey;
extern NSString *const SpaceActivityInfoShowAssignHostKey;
extern NSString *const OnToggleDisplayParticipantListForCall;
extern NSString *const OnForceDisplayParticipantListForCall;
extern NSString *const OnOpenInviteToMeetingParticipantListForCall;
extern NSString *const OnToggleDisplayMessagesForCall;
extern NSString *const PeopleTypeKey;

// PSTN
extern NSString *const TollFreeDialInKey;
extern NSString *const TollDialInKey;
extern NSString *const GlobalDialInKey;
extern NSString *const AttendeeIdKey;

//Wait-in-lobby
extern NSString *const OnWaitInLobbyIsEmpty;

// Common Head Participant List
extern NSString *const OnParticipantsAddedCommon;
extern NSString *const OnParticipantsUpdatedCommon;
extern NSString *const OnParticipantsRemovedCommon;
extern NSString *const OnParticipantListInvalidated;
extern NSString *const OnContactUpdatedCommon;
extern NSString *const ParticipantListItemsKey;

// Common Head Presence
extern NSString *const OnPresenceChanged;
extern NSString *const PresenceKey;

// Common Head Calling Interstitial
extern NSString *const OnCallingInterstitialCallJoined;
extern NSString *const OnCallingInterstitialDataArrived;
extern NSString *const OnCallingInterstitialLocalVideoStreamingChanged;
extern NSString *const ShowSelfPreviewKey;
extern NSString *const CallingInterstitialDataKey;

// Common Head Calling Devices
extern NSString *const OnCallingDevicesDataArrived;
extern NSString *const CallingDevicesDataKey;

// Common Head Personal Room View Model
extern NSString *const OnPersonalRoomMeetingDetails;
extern NSString *const PersonalRoomMeetingDetailsKey;
extern NSString *const TooManyAttemptsKey;

// Common Head Toast
extern NSString *const OnMeetingToastUpdated;
extern NSString *const ToastItemKey;
extern NSString *const OnToastAdded;
extern NSString *const OnToastRemoved;
extern NSString *const OnToastUpdated;
extern NSString *const OnLocalRecordingToastUpdated;
extern NSString *const ToastEventItemKey;

// Richtext
extern NSString *const OnHeadingShortcut;
extern NSString *const Identifier;

//My Profile Menu
extern NSString *const OnSignOutSelected;
extern NSString *const OnCloseProfileWindow;

extern NSString *const OnCloseParticipantList;

extern NSString *const UserId;

extern NSString *const OnClosePopover;

//code gen
extern NSString *const OnBrickletsChanged;
extern NSString *const OnBrickletsRemoved;
extern NSString *const OnBrickletsAdded;
extern NSString *const BrickletsKey;
extern NSString *const BrickletIdsKey;
extern NSString *const IsUserInitiatedKey;

// Help Portal
extern NSString *const OnLaunchCiscoHelpPage;

// open web view
extern NSString *const WebViewURLKey;
extern NSString *const WebViewTitleKey;
extern NSString *const WebViewWidthKey;
extern NSString *const WebViewHeightKey;
// Client compatability hint (force upgrade)
extern NSString *const OnClientUpgradeHint;
extern NSString *const ClientCompatabilityHintKey;

// Custom Status
extern NSString *const SetCustomStatus;
extern NSString *const SetCustomStatusValue;
extern NSString *const ClearCustomStatus;

// Voicemail
extern NSString *const OnVoicemailPlayerPlayed;
extern NSString *const VoicemailPlayerKey;

extern NSString *const ExpandChangeBackgroundUI;

// Escalation
extern NSString *const EscalateCallToMeetingDismissIncomingAlert;

//Migration
extern NSString *const OnStartMigration;

extern NSString *const OnSetCustomDND;
extern NSString *const DndDuration;

@interface NotificationEventNames : NSObject
@end

#endif // NotificationEventNames_h
