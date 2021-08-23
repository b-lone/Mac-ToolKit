//
//  MobileDeviceAdapter.h
//  WebexTeams
//
//  Created by Archie You on 2021/8/18.
//  Copyright © 2021 Cisco. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MobileDeviceAdapter;

@protocol MobileDeviceAdapterDelegate <NSObject>

- (void)mobileDeviceAdapter:(MobileDeviceAdapter *) adapter deviceCallback:(int)status;

@end

@interface MobileDeviceAdapter : NSObject

- (nullable instancetype)initWithMobileDeviceBundle:(CFBundleRef) bundle;
- (void)deviceNotificationSubscribe;
- (void)deviceNotificationUnSubscribe;
- (void)enableHalDevice:(int)bEnable;
@property(weak) _Nullable id<MobileDeviceAdapterDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
