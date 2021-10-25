#ifndef CHShareViewModelProtocol_IMPORTED
#define CHShareViewModelProtocol_IMPORTED
// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_protocol.j2
@class CHImage;
@class CHLocalShareControlBarInfo;
@class CHRemoteShareControlBarInfo;
@class CHResumeShareControlBarInfo;
@class CHScreenInfo;
@class CHScreenShareExport;
@class CHShareConfig;
@class CHShareNotification;
@class CHShareSource;
@class CHShareSourcesSelectionWindowInfo;
@class CHShareStateInfo;
@class CHShareTabData;
@class CHSharingContent;

enum CHShareCallType: NSUInteger;
enum CHShareOptimizeType: NSUInteger;
enum CHShareType: NSUInteger;



//forward declare the protocol
@protocol CHShareViewModelProtocol;

@protocol CHShareViewModelDelegate
- (void)shareViewModel:(id<CHShareViewModelProtocol> _Nonnull)shareViewModel onRemoteShareControlBarInfoChanged:(CHRemoteShareControlBarInfo * _Nonnull)info;
- (void)shareViewModel:(id<CHShareViewModelProtocol> _Nonnull)shareViewModel onHWAccelerationCheckReceived:(bool)isSupported;
- (void)shareViewModel:(id<CHShareViewModelProtocol> _Nonnull)shareViewModel onShareTabDataChanged:(CHShareTabData * _Nonnull)data;
- (void)shareViewModel:(id<CHShareViewModelProtocol> _Nonnull)shareViewModel onLocalShareControlBarInfoChanged:(CHLocalShareControlBarInfo * _Nonnull)info;
- (void)shareViewModel:(id<CHShareViewModelProtocol> _Nonnull)shareViewModel onResumeShareControlBarInfoChanged:(CHResumeShareControlBarInfo * _Nonnull)info;
- (void)shareViewModel:(id<CHShareViewModelProtocol> _Nonnull)shareViewModel onLocalShareStateChanged:(bool)isActive;
- (void)shareViewModel:(id<CHShareViewModelProtocol> _Nonnull)shareViewModel onShareSourcesSelectionWindowInfoChanged:(CHShareSourcesSelectionWindowInfo * _Nonnull)info;
- (void)shareViewModel:(id<CHShareViewModelProtocol> _Nonnull)shareViewModel onShareNotificationArrived:(CHShareNotification * _Nonnull)notification;
- (void)shareViewModel:(id<CHShareViewModelProtocol> _Nonnull)shareViewModel onSharingContentChanged:(CHSharingContent * _Nonnull)sharingContent;
- (void)shareViewModelOnSharingServiceStopped:(id<CHShareViewModelProtocol> _Nonnull) shareViewModel;
@end

@protocol CHShareViewModelProtocol

@property(nonatomic, weak) id<CHShareViewModelDelegate> _Nullable delegate; // DEPRECATED, use add/removeDelegate instead
-(void) addDelegate:(id<CHShareViewModelDelegate> _Nonnull)delegate NS_SWIFT_NAME(addDelegate(_:));
-(void) removeDelegate:(id<CHShareViewModelDelegate> _Nonnull)delegate NS_SWIFT_NAME(removeDelegate(_:));


- (void)initialize:(NSString * _Nonnull)callId NS_SWIFT_NAME(initialize(callId:));
- (void)initialize:(enum CHShareCallType)type conversationId:(NSString * _Nonnull)conversationId NS_SWIFT_NAME(initialize(type:conversationId:));
- (NSString * _Nullable)getCallId;
- (bool)checkValid;
- (CHShareSourcesSelectionWindowInfo * _Nullable)getShareSourcesSelectionWindowInfo;
- (void)setShareConfig:(CHShareConfig * _Nonnull)shareConfig NS_SWIFT_NAME(setShareConfig(shareConfig:));
- (void)startShare:(NSArray<CHShareSource *>* _Nonnull)sourceList shareType:(enum CHShareType)shareType NS_SWIFT_NAME(startShare(sourceList:shareType:));
- (void)stopShare;
- (NSString * _Nullable)generateIMOnlyShareCall:(NSString * _Nonnull)conversationId NS_SWIFT_NAME(generateIMOnlyShareCall(conversationId:));
- (void)endShareOnlyCallIfNotStart;
- (CHLocalShareControlBarInfo * _Nullable)getLocalShareControlBarInfo;
- (void)setScreenList:(NSArray<NSString *>* _Nonnull)screenList NS_SWIFT_NAME(setScreenList(screenList:));
- (void)setScreenInfoList:(NSArray<CHScreenInfo *>* _Nonnull)screenList NS_SWIFT_NAME(setScreenInfoList(screenList:));
- (void)toggleSharePauseState:(bool)bPause NS_SWIFT_NAME(toggleSharePauseState(bPause:));
- (void)resumeShare;
- (bool)isSharingShortcutKeysEnabled;
- (void)excludeWindowFromShare:(void * _Nonnull)windowHandle NS_SWIFT_NAME(excludeWindowFromShare(windowHandle:));
- (bool)isSharingMultipleApplicationsEnabled;
- (bool)isSharingPreviewEnabled;
- (bool)isSharingControlBarDraggableEnabled;
- (bool)isSharingIndividualWindowEnabled;
- (CHSharingContent * _Nullable)getSharingContent;
- (NSString * _Nullable)getValidSharingWindowsTooltips:(NSArray<CHShareSource *>* _Nonnull)validSources NS_SWIFT_NAME(getValidSharingWindowsTooltips(validSources:));
- (CHRemoteShareControlBarInfo * _Nullable)getRemoteShareControlBarInfo;
- (void)checkHWAcceleration;
- (bool)isVideoHWAccelerationEnabled;
- (void)enableHWAcceleration:(NSNumber * _Nonnull)hwAccelerationType NS_SWIFT_NAME(enableHWAcceleration(hwAccelerationType:));
- (void)revertToClassicShare:(bool)isReverted NS_SWIFT_NAME(revertToClassicShare(isReverted:));
- (bool)isRemoteControlSessionEstablished;
- (bool)isRemoteControlSessionPaused;
- (CHImage * _Nullable)getLastScreenShareForAnnotate:(NSString * _Nonnull)callId NS_SWIFT_NAME(getLastScreenShareForAnnotate(callId:));
- (void)setOptimizeForShare:(enum CHShareOptimizeType)type NS_SWIFT_NAME(setOptimizeForShare(type:));
- (void)setEnableShareAudio:(bool)isEnabled NS_SWIFT_NAME(setEnableShareAudio(isEnabled:));
- (void)checkAudioSharePluginStatus;
- (void)installAudioSharePlugin;
- (void)setIsUserAdmin:(bool)isUserAdmin NS_SWIFT_NAME(setIsUserAdmin(isUserAdmin:));
- (void)applicationDidTerminate:(NSString * _Nonnull)processId NS_SWIFT_NAME(applicationDidTerminate(processId:));
- (CHShareStateInfo * _Nullable)getShareStateInfo;
- (CHScreenShareExport * _Nullable)determineScreenShareExport:(NSString * _Nonnull)conversationId NS_SWIFT_NAME(determineScreenShareExport(conversationId:));
- (void)startIMOnlyShare:(NSString * _Nonnull)callId NS_SWIFT_NAME(startIMOnlyShare(callId:));


@end

#endif
