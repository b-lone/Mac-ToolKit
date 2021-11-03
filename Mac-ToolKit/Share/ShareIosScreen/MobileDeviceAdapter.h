//
//  MobileDeviceAdapter.h
//  WebexTeams
//
//  Created by Archie You on 2021/8/18.
//  Copyright © 2021 Cisco. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MobileDeviceAdapter : NSObject

- (nullable instancetype)initWithMobileDeviceBundle:(CFBundleRef) bundle;
- (void)deviceNotificationSubscribe;
- (void)deviceNotificationUnSubscribe;
+ (void)enableHalDevice:(BOOL)bEnable;

@end

NS_ASSUME_NONNULL_END
