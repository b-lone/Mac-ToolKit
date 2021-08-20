//
//  MobileDeviceAdapter.m
//  Test-Mac
//
//  Created by Archie You on 2021/8/18.
//  Copyright © 2021 Cisco. All rights reserved.
//

#import "MobileDeviceAdapter.h"
#import "MobileDevice.h"
#import "../Log/SparkLogger.h"

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

//connect a already trust device, msg = 1
//connect a not trust device, then trust, msg =4
- (void)myDeviceCallback:(wbx_device_notification_callback_info*)info
{
    if(info == nil || info->dev == nil)
        return;
    
    SPARK_LOG_DEBUG("MyDeviceCallback,msg = " << info->msg);
    if(info->msg == 1)
    {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSValue valueWithPointer:info->dev] forKey:@"device"];
        
        //marked,after sync with wendy,[mInstructionView setDeviceAttached:YES];
        
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
//                    if(mReselectTimer)
//                    {
//                        [mReselectTimer invalidate];
//                        mReselectTimer = nil;
//                    }
                    
//                    if(gbHalDeviceEnabled)
//                    {
//                        mReselectTimer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(reselectTimer:) userInfo:nil repeats:NO];
//                        [[NSRunLoop currentRunLoop] addTimer:mReselectTimer forMode:NSModalPanelRunLoopMode];
//                        [[NSRunLoop currentRunLoop] addTimer:mReselectTimer forMode: NSEventTrackingRunLoopMode];
//                    }
                    
                    status = 1;
//                    if(mReEnablHalTimer == nil)
//                        [self EnableHalDevice:1];
                }
            }
            
            wbx_AMDeviceDisconnect(info->dev);
        }
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kIOSDeviceCableConnect object:nil];
        
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
        
//        if([mDeviceList count] == 0)
//            [mInstructionView setDeviceAttached:NO];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kIOSDeviceCableDisonnect object:nil];
    }
    else if(info->msg == 4)
    {
        SPARK_LOG_DEBUG("MyDeviceCallback, detect trust computer");
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kIOSDeviceTrused object:nil];
        
        for(int k = 0; k < [mDeviceList count]; k++)
        {
            NSMutableDictionary* dict = [mDeviceList objectAtIndex:k];
            if([[dict objectForKey:@"device"] pointerValue] == info->dev)
            {
                [dict setObject:[NSNumber numberWithInt:1] forKey:@"status"];
                break;
            }
        }
        
//        [self ReEnableHalDevice];
    }
}

@end

void mydevicecallback(struct wbx_device_notification_callback_info * cb, void* arg)
{
    MobileDeviceAdapter* pThis = (__bridge MobileDeviceAdapter*)arg;
    [pThis myDeviceCallback:cb];
}
