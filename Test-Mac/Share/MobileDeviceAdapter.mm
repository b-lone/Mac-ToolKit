//
//  MobileDeviceAdapter.m
//  WebexTeams
//
//  Created by Archie You on 2021/8/18.
//  Copyright © 2021 Cisco. All rights reserved.
//

#import "MobileDeviceAdapter.h"
#import "MobileDevice.h"
#import "../Log/SparkLogger.h"
#import <CoreMediaIO/CMIOHardwareObject.h>
#import <CoreMediaIO/CMIOHardwareDevice.h>
#import <CoreMediaIO/CMIOHardwareSystem.h>

void mydevicecallback(struct wbx_device_notification_callback_info * cb, void* arg);
@interface MobileDeviceAdapter()
{
    WBX_AMDeviceNotificationSubscribe wbx_AMDeviceNotificationSubscribe;
    WBX_AMDeviceNotificationUnsubscribe wbx_AMDeviceNotificationUnsubscribe;
    WBX_AMDeviceConnect wbx_AMDeviceConnect;
    WBX_AMDeviceDisconnect wbx_AMDeviceDisconnect;
    WBX_AMDeviceIsPaired wbx_AMDeviceIsPaired;
    WBX_AMDeviceValidatePairing wbx_AMDeviceValidatePairing;
    wbx_device_notification* deviceNotification;
}
@end

@implementation MobileDeviceAdapter

- (instancetype)initWithMobileDeviceBundle:(CFBundleRef) bundle
{
    self = [super init];
    if (self) {
        wbx_AMDeviceNotificationSubscribe = (WBX_AMDeviceNotificationSubscribe)CFBundleGetFunctionPointerForName(bundle, CFSTR("AMDeviceNotificationSubscribe"));
        wbx_AMDeviceNotificationUnsubscribe = (WBX_AMDeviceNotificationUnsubscribe)CFBundleGetFunctionPointerForName(bundle, CFSTR("AMDeviceNotificationUnsubscribe"));
        wbx_AMDeviceConnect = (WBX_AMDeviceConnect)CFBundleGetFunctionPointerForName(bundle, CFSTR("AMDeviceConnect"));
        wbx_AMDeviceDisconnect = (WBX_AMDeviceDisconnect)CFBundleGetFunctionPointerForName(bundle, CFSTR("AMDeviceDisconnect"));
        wbx_AMDeviceIsPaired = (WBX_AMDeviceIsPaired)CFBundleGetFunctionPointerForName(bundle, CFSTR("AMDeviceIsPaired"));
        wbx_AMDeviceValidatePairing = (WBX_AMDeviceValidatePairing)CFBundleGetFunctionPointerForName(bundle, CFSTR("AMDeviceValidatePairing"));
    }
    if (wbx_AMDeviceNotificationSubscribe && wbx_AMDeviceNotificationUnsubscribe && wbx_AMDeviceConnect && wbx_AMDeviceDisconnect && wbx_AMDeviceIsPaired && wbx_AMDeviceValidatePairing) {
        SPARK_LOG_DEBUG("Load successfully");
        return self;
    } else {
        SPARK_LOG_DEBUG("Load failed");
        return nil;
    }
}

- (void)deviceNotificationSubscribe {
    wbx_AMDeviceNotificationSubscribe(&mydevicecallback, 0, 0, (__bridge void*)(self), &deviceNotification);
}

- (void)deviceNotificationUnSubscribe {
    if (deviceNotification) {
        wbx_AMDeviceNotificationUnsubscribe(deviceNotification);
    }
}

- (void)enableHalDevice:(BOOL)bEnable {
    CMIOObjectPropertyAddress prop  = {
        kCMIOHardwarePropertyAllowScreenCaptureDevices,
        kCMIOObjectPropertyScopeGlobal,
        kCMIOObjectPropertyElementMaster
    };
    UInt32 allow = bEnable;
    
    CMIOObjectSetPropertyData(kCMIOObjectSystemObject, &prop, 0, NULL, 4, &allow);
//    2021-08-23 22:09:07.200677+0800 Test-Mac[67096:3020389] [] CMIOHardware.cpp:379:CMIOObjectGetPropertyData Error: 2003332927, failed
//    2003332927: kAudioCodecUnknownPropertyError
}

- (void)myDeviceCallback:(wbx_device_notification_callback_info*)info
{
    if(info == nil || info->dev == nil) return;
    
    SPARK_LOG_DEBUG("msg = " << info->msg);
    if(info->msg == 1)
    {
        int ret = wbx_AMDeviceConnect(info->dev);
        if(ret == 0)
        {
            ret = wbx_AMDeviceIsPaired(info->dev);
            if(ret == 1)
            {
                ret = wbx_AMDeviceValidatePairing(info->dev);
                if(ret == 0)
                {
                    SPARK_LOG_DEBUG("detect trust device");
                }
            }
        }
    }
    else if(info->msg == 2)
    {
        SPARK_LOG_DEBUG("detect device plug out");
    }
    else if(info->msg == 4)
    {
        SPARK_LOG_DEBUG("detect trust device");
    }
}

@end

void mydevicecallback(struct wbx_device_notification_callback_info * cb, void* arg)
{
    MobileDeviceAdapter* pThis = (__bridge MobileDeviceAdapter*)arg;
    [pThis myDeviceCallback: cb];
}
