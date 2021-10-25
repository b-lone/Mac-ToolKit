// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel_header.j2

#ifndef CHShareTelemetryManager_IMPORTED
#define CHShareTelemetryManager_IMPORTED
#import <Foundation/Foundation.h>
#include "CHShareTelemetryManagerProtocol.h"

enum CHShortcut: NSUInteger;


@class CommonHeadFrameworkProxy;

@interface CHShareTelemetryManager : NSObject<CHShareTelemetryManagerProtocol>

@property(nonatomic, weak) id<CHShareTelemetryManagerDelegate> _Nullable delegate;

-(void) addDelegate:(id<CHShareTelemetryManagerDelegate> _Nonnull)delegate;
-(void) removeDelegate:(id<CHShareTelemetryManagerDelegate> _Nonnull)delegate;

- (instancetype _Nonnull)initWithCommonHeadFramework:(CommonHeadFrameworkProxy * _Nonnull)commonHeadFramework;

- (void)recordShortcutKeyPressed:(NSString * _Nonnull)callId shortcut:(enum CHShortcut)shortcut;
- (void)recordSettingsButtonPressed:(NSString * _Nonnull)callId;


@end
#endif
