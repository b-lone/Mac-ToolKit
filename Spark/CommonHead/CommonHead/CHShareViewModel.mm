// DO NOT EDIT - Auto generated
// Generated with objc_viewmodel.j2

//#import "Frameworks.h"
//#import "SwiftInterfaceHeader.h"
//#import "AppleConversionFunctions.h"
//#import "CoreFrameworkProxy.h"
//#import "CommonHeadFrameworkProxy.h"
//#import "NotificationEventNames.h"
//#import "ConversionUtils.h"
//#import "common-head/Services/ICommonHeadFramework.h"
//#import "common-head/Services/ViewModelFactory.h"
//#import "spark-client-framework/SparkTypes.h"
//
////cpp includes
//#import "common-head/Services/ICommonHeadFramework.h"
//#import "common-head/ViewModels/ShareViewModel/ShareModel.h"
//#import "spark-client-framework/Services/ImageService/ImageModelTypes.h"
//#import "spark-client-framework/Utilities/GuidUtils.h"


#import "CHShareViewModel.h"
#import "CommonHead.h"
//#import "common-head/ViewModels/IShareViewModel.h"

@interface CHShareViewModel ()
@property (nonatomic) NSHashTable* _Nonnull delegates;
@end


//class CHShareViewModelCallback : public std::enable_shared_from_this<CHShareViewModelCallback>, public commonHead::viewModels::IShareViewModelCallback
//{
//
//public:
//CHShareViewModelCallback(CHShareViewModel * _viewModel):viewModel(_viewModel) {}
//
//private:
//__weak CHShareViewModel *viewModel ;
//
//    void onRemoteShareControlBarInfoChanged(const commonHead::viewModels::RemoteShareControlBarInfo& info) override
//    {
//        @autoreleasepool {
//            if(viewModel && (viewModel.delegate || [viewModel.delegates count] > 0))
//            {
//
//                CHRemoteShareControlBarInfo * infoObj = CHRemoteShareControlBarInfoFromCPP(info);
//
//
//                auto weakThis = weak_from_this();
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    RETURN_FROM_LAMBDA_IF_DEAD(weakThis);
//
//                    @autoreleasepool {
//                        NSArray* delegates = viewModel.delegates.allObjects;
//                        for (int i = 0; i < delegates.count; i++)
//                        {
//                            if ([delegates objectAtIndex:i])
//                            {
//                                [[delegates objectAtIndex:i] shareViewModel:viewModel onRemoteShareControlBarInfoChanged :infoObj ];
//                            }
//                        }
//                        if (viewModel.delegate)
//                        {
//                            [[viewModel delegate] shareViewModel:viewModel onRemoteShareControlBarInfoChanged :infoObj ];
//                        }
//                    }
//                });
//            }
//        }
//    }
//    void onHWAccelerationCheckReceived(bool isSupported) override
//    {
//        @autoreleasepool {
//            if(viewModel && (viewModel.delegate || [viewModel.delegates count] > 0))
//            {
//
//                bool isSupportedObj = isSupported;
//
//
//                auto weakThis = weak_from_this();
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    RETURN_FROM_LAMBDA_IF_DEAD(weakThis);
//
//                    @autoreleasepool {
//                        NSArray* delegates = viewModel.delegates.allObjects;
//                        for (int i = 0; i < delegates.count; i++)
//                        {
//                            if ([delegates objectAtIndex:i])
//                            {
//                                [[delegates objectAtIndex:i] shareViewModel:viewModel onHWAccelerationCheckReceived :isSupportedObj ];
//                            }
//                        }
//                        if (viewModel.delegate)
//                        {
//                            [[viewModel delegate] shareViewModel:viewModel onHWAccelerationCheckReceived :isSupportedObj ];
//                        }
//                    }
//                });
//            }
//        }
//    }
//    void onShareTabDataChanged(const commonHead::viewModels::ShareTabData& data) override
//    {
//        @autoreleasepool {
//            if(viewModel && (viewModel.delegate || [viewModel.delegates count] > 0))
//            {
//
//                CHShareTabData * dataObj = CHShareTabDataFromCPP(data);
//
//
//                auto weakThis = weak_from_this();
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    RETURN_FROM_LAMBDA_IF_DEAD(weakThis);
//
//                    @autoreleasepool {
//                        NSArray* delegates = viewModel.delegates.allObjects;
//                        for (int i = 0; i < delegates.count; i++)
//                        {
//                            if ([delegates objectAtIndex:i])
//                            {
//                                [[delegates objectAtIndex:i] shareViewModel:viewModel onShareTabDataChanged :dataObj ];
//                            }
//                        }
//                        if (viewModel.delegate)
//                        {
//                            [[viewModel delegate] shareViewModel:viewModel onShareTabDataChanged :dataObj ];
//                        }
//                    }
//                });
//            }
//        }
//    }
//    void onLocalShareControlBarInfoChanged(const commonHead::viewModels::LocalShareControlBarInfo& info) override
//    {
//        @autoreleasepool {
//            if(viewModel && (viewModel.delegate || [viewModel.delegates count] > 0))
//            {
//
//                CHLocalShareControlBarInfo * infoObj = CHLocalShareControlBarInfoFromCPP(info);
//
//
//                auto weakThis = weak_from_this();
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    RETURN_FROM_LAMBDA_IF_DEAD(weakThis);
//
//                    @autoreleasepool {
//                        NSArray* delegates = viewModel.delegates.allObjects;
//                        for (int i = 0; i < delegates.count; i++)
//                        {
//                            if ([delegates objectAtIndex:i])
//                            {
//                                [[delegates objectAtIndex:i] shareViewModel:viewModel onLocalShareControlBarInfoChanged :infoObj ];
//                            }
//                        }
//                        if (viewModel.delegate)
//                        {
//                            [[viewModel delegate] shareViewModel:viewModel onLocalShareControlBarInfoChanged :infoObj ];
//                        }
//                    }
//                });
//            }
//        }
//    }
//    void onResumeShareControlBarInfoChanged(const commonHead::viewModels::ResumeShareControlBarInfo& info) override
//    {
//        @autoreleasepool {
//            if(viewModel && (viewModel.delegate || [viewModel.delegates count] > 0))
//            {
//
//                CHResumeShareControlBarInfo * infoObj = CHResumeShareControlBarInfoFromCPP(info);
//
//
//                auto weakThis = weak_from_this();
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    RETURN_FROM_LAMBDA_IF_DEAD(weakThis);
//
//                    @autoreleasepool {
//                        NSArray* delegates = viewModel.delegates.allObjects;
//                        for (int i = 0; i < delegates.count; i++)
//                        {
//                            if ([delegates objectAtIndex:i])
//                            {
//                                [[delegates objectAtIndex:i] shareViewModel:viewModel onResumeShareControlBarInfoChanged :infoObj ];
//                            }
//                        }
//                        if (viewModel.delegate)
//                        {
//                            [[viewModel delegate] shareViewModel:viewModel onResumeShareControlBarInfoChanged :infoObj ];
//                        }
//                    }
//                });
//            }
//        }
//    }
//    void onLocalShareStateChanged(bool isActive) override
//    {
//        @autoreleasepool {
//            if(viewModel && (viewModel.delegate || [viewModel.delegates count] > 0))
//            {
//
//                bool isActiveObj = isActive;
//
//
//                auto weakThis = weak_from_this();
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    RETURN_FROM_LAMBDA_IF_DEAD(weakThis);
//
//                    @autoreleasepool {
//                        NSArray* delegates = viewModel.delegates.allObjects;
//                        for (int i = 0; i < delegates.count; i++)
//                        {
//                            if ([delegates objectAtIndex:i])
//                            {
//                                [[delegates objectAtIndex:i] shareViewModel:viewModel onLocalShareStateChanged :isActiveObj ];
//                            }
//                        }
//                        if (viewModel.delegate)
//                        {
//                            [[viewModel delegate] shareViewModel:viewModel onLocalShareStateChanged :isActiveObj ];
//                        }
//                    }
//                });
//            }
//        }
//    }
//    void onShareSourcesSelectionWindowInfoChanged(const commonHead::viewModels::ShareSourcesSelectionWindowInfo& info) override
//    {
//        @autoreleasepool {
//            if(viewModel && (viewModel.delegate || [viewModel.delegates count] > 0))
//            {
//
//                CHShareSourcesSelectionWindowInfo * infoObj = CHShareSourcesSelectionWindowInfoFromCPP(info);
//
//
//                auto weakThis = weak_from_this();
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    RETURN_FROM_LAMBDA_IF_DEAD(weakThis);
//
//                    @autoreleasepool {
//                        NSArray* delegates = viewModel.delegates.allObjects;
//                        for (int i = 0; i < delegates.count; i++)
//                        {
//                            if ([delegates objectAtIndex:i])
//                            {
//                                [[delegates objectAtIndex:i] shareViewModel:viewModel onShareSourcesSelectionWindowInfoChanged :infoObj ];
//                            }
//                        }
//                        if (viewModel.delegate)
//                        {
//                            [[viewModel delegate] shareViewModel:viewModel onShareSourcesSelectionWindowInfoChanged :infoObj ];
//                        }
//                    }
//                });
//            }
//        }
//    }
//    void onShareNotificationArrived(const commonHead::viewModels::ShareNotification& notification) override
//    {
//        @autoreleasepool {
//            if(viewModel && (viewModel.delegate || [viewModel.delegates count] > 0))
//            {
//
//                CHShareNotification * notificationObj = CHShareNotificationFromCPP(notification);
//
//
//                auto weakThis = weak_from_this();
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    RETURN_FROM_LAMBDA_IF_DEAD(weakThis);
//
//                    @autoreleasepool {
//                        NSArray* delegates = viewModel.delegates.allObjects;
//                        for (int i = 0; i < delegates.count; i++)
//                        {
//                            if ([delegates objectAtIndex:i])
//                            {
//                                [[delegates objectAtIndex:i] shareViewModel:viewModel onShareNotificationArrived :notificationObj ];
//                            }
//                        }
//                        if (viewModel.delegate)
//                        {
//                            [[viewModel delegate] shareViewModel:viewModel onShareNotificationArrived :notificationObj ];
//                        }
//                    }
//                });
//            }
//        }
//    }
//    void onSharingContentChanged(const commonHead::viewModels::SharingContent& sharingContent) override
//    {
//        @autoreleasepool {
//            if(viewModel && (viewModel.delegate || [viewModel.delegates count] > 0))
//            {
//
//                CHSharingContent * sharingContentObj = CHSharingContentFromCPP(sharingContent);
//
//
//                auto weakThis = weak_from_this();
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    RETURN_FROM_LAMBDA_IF_DEAD(weakThis);
//
//                    @autoreleasepool {
//                        NSArray* delegates = viewModel.delegates.allObjects;
//                        for (int i = 0; i < delegates.count; i++)
//                        {
//                            if ([delegates objectAtIndex:i])
//                            {
//                                [[delegates objectAtIndex:i] shareViewModel:viewModel onSharingContentChanged :sharingContentObj ];
//                            }
//                        }
//                        if (viewModel.delegate)
//                        {
//                            [[viewModel delegate] shareViewModel:viewModel onSharingContentChanged :sharingContentObj ];
//                        }
//                    }
//                });
//            }
//        }
//    }
//    void onSharingServiceStopped() override
//    {
//        @autoreleasepool {
//            if(viewModel && (viewModel.delegate || [viewModel.delegates count] > 0))
//            {
//
//                auto weakThis = weak_from_this();
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    RETURN_FROM_LAMBDA_IF_DEAD(weakThis);
//
//                    @autoreleasepool {
//                        NSArray* delegates = viewModel.delegates.allObjects;
//                        for (int i = 0; i < delegates.count; i++)
//                        {
//                            if ([delegates objectAtIndex:i])
//                            {
//                                [[delegates objectAtIndex:i] shareViewModelOnSharingServiceStopped:viewModel];
//                            }
//                        }
//                        if (viewModel.delegate)
//                        {
//                            [[viewModel delegate] shareViewModelOnSharingServiceStopped:viewModel];
//                        }
//                    }
//                });
//            }
//        }
//    }
//
//};



 @implementation  CHShareViewModel
 {
//   std::shared_ptr<const commonHead::ICommonHeadFramework> mCommonHeadFramework;
//   commonHead::viewModels::IShareViewModelPtr mViewModelCpp;
//   std::shared_ptr<CHShareViewModelCallback>  cHShareViewModelCallbackCpp;
 }

-(id) initWithCommonHeadFramework:(CommonHeadFrameworkProxy* _Nonnull)commonHeadFramework;
{
    if (self = [super init])
    {
//        SPARK_LOG_DEBUG("");
//        mCommonHeadFramework = commonHeadFramework.commonHeadFramework;
//        mViewModelCpp =  mCommonHeadFramework->getViewModelFactory()->createViewModel<commonHead::viewModels::IShareViewModel>();
//
//        cHShareViewModelCallbackCpp = std::make_shared<CHShareViewModelCallback>(self);
//        mViewModelCpp->registerCallback(cHShareViewModelCallbackCpp);
//        _delegates = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

-(void) addDelegate:(id<CHShareViewModelDelegate> _Nonnull)delegate
{
//    @autoreleasepool {
//        [self.delegates addObject:delegate];
//        const auto count = [self.delegates.allObjects count];
//        SPARK_LOG_DEBUG("Adding delegate. Count after removal: " << count);
//        sparkAssert(count <= 15); // Ensure that too many delegates are not getting added (particularly items in a list)
//    }
}

-(void) removeDelegate:(id<CHShareViewModelDelegate> _Nonnull)delegate
{
//    @autoreleasepool {
//        [self.delegates removeObject:delegate];
//        SPARK_LOG_DEBUG("Removing delegate. Count after removal: " << [self.delegates.allObjects count]);
//    }
}

- (void)initialize:(NSString * _Nonnull)callId
{
//  @autoreleasepool {
//
//    auto callIdCpp = spark::guid([callId UTF8String]);
//
//    mViewModelCpp->initialize(callIdCpp);
//
//  }
}

- (void)initialize:(enum CHShareCallType)type conversationId:(NSString * _Nonnull)conversationId
{
//  @autoreleasepool {
//
//    auto typeCpp = CHShareCallTypeToCPP(type);
//
//    auto conversationIdCpp = spark::guid([conversationId UTF8String]);
//
//    mViewModelCpp->initialize(typeCpp,conversationIdCpp);
//
//  }
}

- (NSString * _Nullable)getCallId
{
    return @"";
//  @autoreleasepool {
//
//    auto callIdCpp = mViewModelCpp->getCallId();
//    return [ConversionUtils convertIdToNSString:callIdCpp];
//
//  }
}

- (bool)checkValid
{
    return true;
//  @autoreleasepool {
//
//    auto checkValidCpp = mViewModelCpp->checkValid();
//    return checkValidCpp;
//
//  }
}

- (CHShareSourcesSelectionWindowInfo * _Nullable)getShareSourcesSelectionWindowInfo
{
    return nil;
//  @autoreleasepool {
//
//    auto shareSourcesSelectionWindowInfoCpp = mViewModelCpp->getShareSourcesSelectionWindowInfo();
//    return CHShareSourcesSelectionWindowInfoFromCPP(shareSourcesSelectionWindowInfoCpp);
//
//  }
}

- (void)setShareConfig:(CHShareConfig * _Nonnull)shareConfig
{
//  @autoreleasepool {
//
//    auto shareConfigCpp = CHShareConfigToCPP(shareConfig);
//
//    mViewModelCpp->setShareConfig(shareConfigCpp);
//
//  }
}

- (void)startShare:(NSArray<CHShareSource *>* _Nonnull)sourceList shareType:(enum CHShareType)shareType
{
//  @autoreleasepool {
//    		    std::vector<commonHead::viewModels::ShareSource> sourceListVector;
//    for (id sourceListObj in sourceList)
//    {
//        sourceListVector.push_back(CHShareSourceToCPP(sourceListObj));
//    }
//
//
//    auto shareTypeCpp = CHShareTypeToCPP(shareType);
//
//    mViewModelCpp->startShare(sourceListVector,shareTypeCpp);
//
//  }
}

- (void)stopShare
{
//  @autoreleasepool {
//
//    mViewModelCpp->stopShare();
//
//  }
}

- (NSString * _Nullable)generateIMOnlyShareCall:(NSString * _Nonnull)conversationId
{
    return nil;
//  @autoreleasepool {
//
//    auto conversationIdCpp = spark::guid([conversationId UTF8String]);
//
//    auto generateIMOnlyShareCallCpp = mViewModelCpp->generateIMOnlyShareCall(conversationIdCpp);
//    return [ConversionUtils convertIdToNSString:generateIMOnlyShareCallCpp];
//
//  }
}

- (void)endShareOnlyCallIfNotStart
{
//  @autoreleasepool {
//
//    mViewModelCpp->endShareOnlyCallIfNotStart();
//
//  }
}

- (CHLocalShareControlBarInfo * _Nullable)getLocalShareControlBarInfo
{
    return nil;
//  @autoreleasepool {
//
//    auto localShareControlBarInfoCpp = mViewModelCpp->getLocalShareControlBarInfo();
//    return CHLocalShareControlBarInfoFromCPP(localShareControlBarInfoCpp);
//
//  }
}

- (void)setScreenList:(NSArray<NSString *>* _Nonnull)screenList
{
//  @autoreleasepool {
//    		    std::vector<std::string> screenListVector;
//    for (id screenListObj in screenList)
//    {
//        screenListVector.push_back(std::string([screenListObj UTF8String]));
//    }
//
//
//    mViewModelCpp->setScreenList(screenListVector);
//
//  }
}

- (void)setScreenInfoList:(NSArray<CHScreenInfo *>* _Nonnull)screenList
{
//  @autoreleasepool {
//    		    std::vector<commonHead::viewModels::ScreenInfo> screenListVector;
//    for (id screenListObj in screenList)
//    {
//        screenListVector.push_back(CHScreenInfoToCPP(screenListObj));
//    }
//
//
//    mViewModelCpp->setScreenInfoList(screenListVector);
//
//  }
}

- (void)toggleSharePauseState:(bool)bPause
{
//  @autoreleasepool {
//
//    auto bPauseCpp = bPause;
//
//    mViewModelCpp->toggleSharePauseState(bPauseCpp);
//
//  }
}

- (void)resumeShare
{
//  @autoreleasepool {
//
//    mViewModelCpp->resumeShare();
//
//  }
}

- (bool)isSharingShortcutKeysEnabled
{
    return true;
//  @autoreleasepool {
//
//    auto isSharingShortcutKeysEnabledCpp = mViewModelCpp->isSharingShortcutKeysEnabled();
//    return isSharingShortcutKeysEnabledCpp;
//
//  }
}

- (void)excludeWindowFromShare:(void * _Nonnull)windowHandle
{
//  @autoreleasepool {
//
//    auto windowHandleCpp = windowHandle;
//
//    mViewModelCpp->excludeWindowFromShare(windowHandleCpp);
//
//  }
}

- (bool)isSharingMultipleApplicationsEnabled
{
    return true;
//  @autoreleasepool {
//
//    auto isSharingMultipleApplicationsEnabledCpp = mViewModelCpp->isSharingMultipleApplicationsEnabled();
//    return isSharingMultipleApplicationsEnabledCpp;
//
//  }
}

- (bool)isSharingPreviewEnabled
{
    return true;
//  @autoreleasepool {
//
//    auto isSharingPreviewEnabledCpp = mViewModelCpp->isSharingPreviewEnabled();
//    return isSharingPreviewEnabledCpp;
//
//  }
}

- (bool)isSharingControlBarDraggableEnabled
{
    return true;
//  @autoreleasepool {
//
//    auto isSharingControlBarDraggableEnabledCpp = mViewModelCpp->isSharingControlBarDraggableEnabled();
//    return isSharingControlBarDraggableEnabledCpp;
//
//  }
}

- (bool)isSharingIndividualWindowEnabled
{
    return true;
//  @autoreleasepool {
//
//    auto isSharingIndividualWindowEnabledCpp = mViewModelCpp->isSharingIndividualWindowEnabled();
//    return isSharingIndividualWindowEnabledCpp;
//
//  }
}

- (CHSharingContent * _Nullable)getSharingContent
{
    return nil;
//  @autoreleasepool {
//
//    auto sharingContentCpp = mViewModelCpp->getSharingContent();
//    return CHSharingContentFromCPP(sharingContentCpp);
//
//  }
}

- (NSString * _Nullable)getValidSharingWindowsTooltips:(NSArray<CHShareSource *>* _Nonnull)validSources
{
    return @"";
//  @autoreleasepool {
//    		    std::vector<commonHead::viewModels::ShareSource> validSourcesVector;
//    for (id validSourcesObj in validSources)
//    {
//        validSourcesVector.push_back(CHShareSourceToCPP(validSourcesObj));
//    }
//
//
//    auto validSharingWindowsTooltipsCpp = mViewModelCpp->getValidSharingWindowsTooltips(validSourcesVector);
//    return [NSString stringWithUTF8String:validSharingWindowsTooltipsCpp.c_str()];
//
//  }
}

- (CHRemoteShareControlBarInfo * _Nullable)getRemoteShareControlBarInfo
{
    return nil;
//  @autoreleasepool {
//
//    auto remoteShareControlBarInfoCpp = mViewModelCpp->getRemoteShareControlBarInfo();
//    return CHRemoteShareControlBarInfoFromCPP(remoteShareControlBarInfoCpp);
//
//  }
}

- (void)checkHWAcceleration
{
//  @autoreleasepool {
//
//    mViewModelCpp->checkHWAcceleration();
//
//  }
}

- (bool)isVideoHWAccelerationEnabled
{
    return true;
//  @autoreleasepool {
//
//    auto isVideoHWAccelerationEnabledCpp = mViewModelCpp->isVideoHWAccelerationEnabled();
//    return isVideoHWAccelerationEnabledCpp;
//
//  }
}

- (void)enableHWAcceleration:(NSNumber * _Nonnull)hwAccelerationType
{
//  @autoreleasepool {
//
//    auto hwAccelerationTypeCpp = [hwAccelerationType intValue];
//
//    mViewModelCpp->enableHWAcceleration(hwAccelerationTypeCpp);
//
//  }
}

- (void)revertToClassicShare:(bool)isReverted
{
//  @autoreleasepool {
//
//    auto isRevertedCpp = isReverted;
//
//    mViewModelCpp->revertToClassicShare(isRevertedCpp);
//
//  }
}

- (bool)isRemoteControlSessionEstablished
{
    return true;
//  @autoreleasepool {
//
//    auto isRemoteControlSessionEstablishedCpp = mViewModelCpp->isRemoteControlSessionEstablished();
//    return isRemoteControlSessionEstablishedCpp;
//
//  }
}

- (bool)isRemoteControlSessionPaused
{
    return true;
//  @autoreleasepool {
//
//    auto isRemoteControlSessionPausedCpp = mViewModelCpp->isRemoteControlSessionPaused();
//    return isRemoteControlSessionPausedCpp;
//
//  }
}

- (CHImage * _Nullable)getLastScreenShareForAnnotate:(NSString * _Nonnull)callId
{
    return nil;
//  @autoreleasepool {
//
//    auto callIdCpp = spark::guid([callId UTF8String]);
//
//    auto lastScreenShareForAnnotateCpp = mViewModelCpp->getLastScreenShareForAnnotate(callIdCpp);
//    return CHImageFromCPP(lastScreenShareForAnnotateCpp);
//
//  }
}

- (void)setOptimizeForShare:(enum CHShareOptimizeType)type
{
//  @autoreleasepool {
//
//    auto typeCpp = CHShareOptimizeTypeToCPP(type);
//
//    mViewModelCpp->setOptimizeForShare(typeCpp);
//
//  }
}

- (void)setEnableShareAudio:(bool)isEnabled
{
//  @autoreleasepool {
//
//    auto isEnabledCpp = isEnabled;
//
//    mViewModelCpp->setEnableShareAudio(isEnabledCpp);
//
//  }
}

- (void)checkAudioSharePluginStatus
{
//  @autoreleasepool {
//
//    mViewModelCpp->checkAudioSharePluginStatus();
//
//  }
}

- (void)installAudioSharePlugin
{
//  @autoreleasepool {
//
//    mViewModelCpp->installAudioSharePlugin();
//
//  }
}

- (void)setIsUserAdmin:(bool)isUserAdmin
{
//  @autoreleasepool {
//
//    auto isUserAdminCpp = isUserAdmin;
//
//    mViewModelCpp->setIsUserAdmin(isUserAdminCpp);
//
//  }
}

- (void)applicationDidTerminate:(NSString * _Nonnull)processId
{
//  @autoreleasepool {
//
//    auto processIdCpp = std::string([processId UTF8String]);
//
//    mViewModelCpp->applicationDidTerminate(processIdCpp);
//
//  }
}

- (CHShareStateInfo * _Nullable)getShareStateInfo
{
    return nil;
//  @autoreleasepool {
//
//    auto shareStateInfoCpp = mViewModelCpp->getShareStateInfo();
//    return CHShareStateInfoFromCPP(shareStateInfoCpp);
//
//  }
}

- (CHScreenShareExport * _Nullable)determineScreenShareExport:(NSString * _Nonnull)conversationId
{
    return nil;
//  @autoreleasepool {
//
//    auto conversationIdCpp = spark::guid([conversationId UTF8String]);
//
//    auto determineScreenShareExportCpp = mViewModelCpp->determineScreenShareExport(conversationIdCpp);
//    return CHScreenShareExportFromCPP(determineScreenShareExportCpp);
//
//  }
}

- (void)startIMOnlyShare:(NSString * _Nonnull)callId
{
//  @autoreleasepool {
//
//    auto callIdCpp = spark::guid([callId UTF8String]);
//
//    mViewModelCpp->startIMOnlyShare(callIdCpp);
//
//  }
}


-(void) dealloc
{
//    SPARK_LOG_DEBUG("");
}

@end
