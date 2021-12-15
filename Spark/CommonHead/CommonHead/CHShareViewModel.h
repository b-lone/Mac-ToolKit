// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2

#ifndef CHShareViewModel_IMPORTED
#define CHShareViewModel_IMPORTED
#import <Foundation/Foundation.h>
#include "CHShareViewModelProtocol.h"
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


@class CommonHeadFrameworkProxy;

@interface CHShareViewModel : NSObject<CHShareViewModelProtocol>

@property(nonatomic, weak) id<CHShareViewModelDelegate> _Nullable delegate;

-(void) addDelegate:(id<CHShareViewModelDelegate> _Nonnull)delegate;
-(void) removeDelegate:(id<CHShareViewModelDelegate> _Nonnull)delegate;

- (instancetype _Nonnull)initWithCommonHeadFramework:(CommonHeadFrameworkProxy * _Nonnull)commonHeadFramework;

- (void)initialize:(NSString * _Nonnull)callId;
- (void)initialize:(enum CHShareCallType)type conversationId:(NSString * _Nonnull)conversationId;
- (NSString * _Nullable)getCallId;
- (bool)checkValid;
- (CHShareSourcesSelectionWindowInfo * _Nullable)getShareSourcesSelectionWindowInfo;
- (void)setShareConfig:(CHShareConfig * _Nonnull)shareConfig;
- (void)startShare:(NSArray<CHShareSource *>* _Nonnull)sourceList shareType:(enum CHShareType)shareType;
- (void)stopShare;
- (NSString * _Nullable)generateIMOnlyShareCall:(NSString * _Nonnull)conversationId;
- (void)endShareOnlyCall;
- (void)endShareOnlyCallIfNotStart;
- (CHShareCallType)getShareCallType;
- (bool)isImmersiveShare;
- (CHLocalShareControlBarInfo * _Nullable)getLocalShareControlBarInfo;
- (void)setScreenList:(NSArray<NSString *>* _Nonnull)screenList;
- (void)setScreenInfoList:(NSArray<CHScreenInfo *>* _Nonnull)screenList;
- (void)toggleSharePauseState:(bool)bPause;
- (void)resumeShare;
- (bool)isSharingShortcutKeysEnabled;
- (void)excludeWindowFromShare:(void * _Nonnull)windowHandle;
- (bool)isSharingMultipleApplicationsEnabled;
- (bool)isSharingPreviewEnabled;
- (bool)isSharingControlBarDraggableEnabled;
- (bool)isSharingIndividualWindowEnabled;
- (CHSharingContent * _Nullable)getSharingContent;
- (NSString * _Nullable)getValidSharingWindowsTooltips:(NSArray<CHShareSource *>* _Nonnull)validSources;
- (CHRemoteShareControlBarInfo * _Nullable)getRemoteShareControlBarInfo;
- (void)checkHWAcceleration;
- (bool)isVideoHWAccelerationEnabled;
- (void)enableHWAcceleration:(NSNumber * _Nonnull)hwAccelerationType;
- (void)revertToClassicShare:(bool)isReverted;
- (bool)isRemoteControlSessionEstablished;
- (bool)isRemoteControlSessionPaused;
- (CHImage * _Nullable)getLastScreenShareForAnnotate:(NSString * _Nonnull)callId;
- (void)setOptimizeForShare:(enum CHShareOptimizeType)type;
- (void)setEnableShareAudio:(bool)isEnabled;
- (void)checkAudioSharePluginStatus;
- (void)installAudioSharePlugin;
- (void)setIsUserAdmin:(bool)isUserAdmin;
- (void)applicationDidTerminate:(NSString * _Nonnull)processId;
- (CHShareStateInfo * _Nullable)getShareStateInfo;
- (CHScreenShareExport * _Nullable)determineScreenShareExport:(NSString * _Nonnull)conversationId;
- (void)startIMOnlyShare:(NSString * _Nonnull)callId;


@end
#endif
