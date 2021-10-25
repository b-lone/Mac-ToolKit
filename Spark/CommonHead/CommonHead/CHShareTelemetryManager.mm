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
//#import "common-head/ViewModels/ShareViewModel/ShareTelemetryFlags.h"
//
//
#import "CHShareTelemetryManager.h"
//#import "common-head/ViewModels/IShareTelemetryManager.h"

@interface CHShareTelemetryManager ()
@property (nonatomic) NSHashTable* _Nonnull delegates;
@end



 @implementation  CHShareTelemetryManager
 {
//   std::shared_ptr<const commonHead::ICommonHeadFramework> mCommonHeadFramework;
//   commonHead::viewModels::IShareTelemetryManagerPtr mViewModelCpp;
 }

-(id) initWithCommonHeadFramework:(CommonHeadFrameworkProxy* _Nonnull)commonHeadFramework;
{
    if (self = [super init])
    {
//        SPARK_LOG_DEBUG("");
//        mCommonHeadFramework = commonHeadFramework.commonHeadFramework;
//        mViewModelCpp =  mCommonHeadFramework->getViewModelFactory()->createViewModel<commonHead::viewModels::IShareTelemetryManager>();
//        _delegates = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

-(void) addDelegate:(id<CHShareTelemetryManagerDelegate> _Nonnull)delegate
{
//    @autoreleasepool {
//        [self.delegates addObject:delegate];
//        const auto count = [self.delegates.allObjects count];
//        SPARK_LOG_DEBUG("Adding delegate. Count after removal: " << count);
//        sparkAssert(count <= 15); // Ensure that too many delegates are not getting added (particularly items in a list)
//    }
}

-(void) removeDelegate:(id<CHShareTelemetryManagerDelegate> _Nonnull)delegate
{
//    @autoreleasepool {
//        [self.delegates removeObject:delegate];
//        SPARK_LOG_DEBUG("Removing delegate. Count after removal: " << [self.delegates.allObjects count]);
//    }
}

- (void)recordShortcutKeyPressed:(NSString * _Nonnull)callId shortcut:(enum CHShortcut)shortcut
{
//  @autoreleasepool {
//
//    auto callIdCpp = std::string([callId UTF8String]);
//
//    auto shortcutCpp = CHShortcutToCPP(shortcut);
//
//    mViewModelCpp->recordShortcutKeyPressed(callIdCpp,shortcutCpp);
//
//  }
}

- (void)recordSettingsButtonPressed:(NSString * _Nonnull)callId
{
//  @autoreleasepool {
//
//    auto callIdCpp = std::string([callId UTF8String]);
//
//    mViewModelCpp->recordSettingsButtonPressed(callIdCpp);
//
//  }
}


-(void) dealloc
{
//    SPARK_LOG_DEBUG("");
}

@end
