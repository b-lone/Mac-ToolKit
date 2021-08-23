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
    NSMutableArray* mDeviceList;
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
    wbx_AMDeviceNotificationSubscribe(&mydevicecallback, 0, 0, (void*)CFBridgingRetain(self), &deviceNotification);
}

- (void)deviceNotificationUnSubscribe {
    if (deviceNotification) {
        wbx_AMDeviceNotificationUnsubscribe(deviceNotification);
    }
}

- (void)enableHalDevice:(int)bEnable {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue,^() {
        CMIOObjectPropertyAddress prop  = {
            kCMIOHardwarePropertyAllowScreenCaptureDevices,
            kCMIOObjectPropertyScopeGlobal,
            kCMIOObjectPropertyElementMaster
        };
        UInt32 allow = bEnable;

        CMIOObjectSetPropertyData(kCMIOObjectSystemObject, &prop, 0, NULL, sizeof(allow), &allow);
    });
}

//connect a already trust device, msg = 1
//connect a not trust device, then trust, msg =4
- (void)myDeviceCallback:(wbx_device_notification_callback_info*)info
{
    if(info == nil || info->dev == nil) return;
    
    SPARK_LOG_DEBUG("MyDeviceCallback,msg = " << info->msg);
    if(info->msg == 1)
    {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSValue valueWithPointer:info->dev] forKey:@"device"];
        
        int status = 0;
        int ret = wbx_AMDeviceConnect(info->dev);
        if(ret == 0)
        {
            ret = wbx_AMDeviceIsPaired(info->dev);
            if(ret == 1)
            {
                ret = wbx_AMDeviceValidatePairing(info->dev);
                if(ret == 0)
                {
                    SPARK_LOG_DEBUG("MyDeviceCallback, detect trust computer");
                    [self.delegate mobileDeviceAdapter:self deviceCallback:1];
                    status = 1;
                }
            }
        }
        
        [dict setObject:[NSNumber numberWithInt:status] forKey:@"status"];
        [mDeviceList addObject:dict];
    }
    else if(info->msg == 2)
    {
        SPARK_LOG_DEBUG("MyDeviceCallback,detect device plug out");
        for(int k = 0; k < [mDeviceList count]; k++)
        {
            NSDictionary* dict = [mDeviceList objectAtIndex:k];
            if([[dict objectForKey:@"device"] pointerValue] == info->dev)
            {
                [mDeviceList removeObjectAtIndex:k];
                break;
            }
        }
        
        [self.delegate mobileDeviceAdapter:self deviceCallback:2];
    }
    else if(info->msg == 4)
    {
        SPARK_LOG_DEBUG("MyDeviceCallback, detect trust computer");
        
        for(int k = 0; k < [mDeviceList count]; k++)
        {
            NSMutableDictionary* dict = [mDeviceList objectAtIndex:k];
            if([[dict objectForKey:@"device"] pointerValue] == info->dev)
            {
                [dict setObject:[NSNumber numberWithInt:1] forKey:@"status"];
                break;
            }
        }
        [self.delegate mobileDeviceAdapter:self deviceCallback:4];
    }
    
    SPARK_LOG_DEBUG("mDeviceList size:" << mDeviceList.count);
}

- (void)onCaptureWindowTimer {
    [self.delegate mobileDeviceAdapterOnCaptureWindowTimer:self];
}

@end

void mydevicecallback(struct wbx_device_notification_callback_info * cb, void* arg)
{
    MobileDeviceAdapter* pThis = (__bridge MobileDeviceAdapter*)arg;
    [pThis myDeviceCallback:cb];
}
