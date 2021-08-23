//
//  MobileDevice.h
//  WebexTeams
//
//  Created by Archie You on 2021/8/17.
//  Copyright © 2021 Cisco. All rights reserved.
//

#ifndef as_MobileDevice_h
#define as_MobileDevice_h

#ifdef __cplusplus
extern "C" {
#endif
//typedef unsigned int mach_error_t;

typedef void(*wbx_device_notification_callback)(struct wbx_device_notification_callback_info *, void* arg);


typedef struct wbx_device {
    unsigned char unknown0[16]; /* 0 - zero */
    unsigned int device_id;     /* 16 */
    unsigned int product_id;    /* 20 - set to AMD_IPHONE_PRODUCT_ID */
    char *serial;               /* 24 - set to AMD_IPHONE_SERIAL */
    unsigned int unknown1;      /* 28 */
    unsigned char unknown2[4];  /* 32 */
    unsigned int lockdown_conn; /* 36 */
    unsigned char unknown3[8];  /* 40 */
} __attribute__ ((packed)) wbx_device;

typedef struct wbx_device_notification_callback_info {
    struct wbx_device *dev;  /* 0    device */
    unsigned int msg;       /* 4    one of ADNCI_MSG_* */
} __attribute__ ((packed)) wbx_device_notification_callback_info;

typedef struct wbx_device_notification {
    unsigned int unknown0;                      /* 0 */
    unsigned int unknown1;                      /* 4 */
    unsigned int unknown2;                      /* 8 */
    wbx_device_notification_callback callback;   /* 12 */
    unsigned int unknown3;                      /* 16 */
} __attribute__ ((packed)) wbx_device_notification;

typedef mach_error_t (*WBX_AMDeviceNotificationSubscribe)(wbx_device_notification_callback callback, unsigned int unused0, unsigned int unused1, void* dn_unknown3, struct wbx_device_notification **notification) __attribute__(());
typedef void (*WBX_AMDeviceNotificationUnsubscribe)(wbx_device_notification* notification) __attribute__(());
    
typedef mach_error_t (*WBX_AMDeviceConnect)(struct wbx_device *device) __attribute__(());
typedef void (*WBX_AMDeviceDisconnect)(struct wbx_device *device) __attribute__(());
typedef int (*WBX_AMDeviceIsPaired)(struct wbx_device *device) __attribute__(());
typedef mach_error_t (*WBX_AMDeviceValidatePairing)(struct wbx_device *device) __attribute__(());

#ifdef __cplusplus
}
#endif
#endif
