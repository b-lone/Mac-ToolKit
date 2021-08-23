//
//  WBXIosScreenCapture.h
//  videotest
//
//  Created by mac on 8/5/16.
//
//
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MobileDevice.h"
//#import "DeloreanSpinImageView.h"
//#include "ascommoninterface.h"

enum CaptureState
{
	CaptureState_NONE,
	CaptureState_Connecting,
	CaptureState_Connected,
};

@interface IOShareMaskWindowContentView : NSView
{
}
@end


@interface IOShareMaskWindow : NSWindow
{
}
@end

@interface IOSInstructionView : NSView
{
//    DeloreanSpinImageView* mProgressView;
    BOOL mbRunning;
    BOOL mbDeviceAttached;
    int mCount;
}

- (void)setDeviceAttached:(BOOL)bAttached;
- (void)showProgressView:(BOOL)bShow;
- (void)setRunning:(BOOL)bRunning;

@end

class IosScreenCaptureEvent;

@interface WBXIosScreenCapture : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession* mCaptureSession;
    AVCaptureDevice* mCurrentScreenCaptureDevice;
    AVCaptureInput* mInput;
    AVCaptureMovieFileOutput* mMovieOutput;
    
    id mDeviceConnectObserver;
    id mDeviceDisonnectObserver;
    
    dispatch_queue_t mVideoQueue;
    dispatch_queue_t mTimerQueue;
    
    IosScreenCaptureEvent* mScreenShareCtrl;
    
    CMSampleBufferRef m_cachedSampleBufferRef;
	NSTimer* mCaptureTimer;
    
    dispatch_source_t mTimerSource;
    CGImageRef m_cachedCGImage;
    
    NSLock* mLock;
    
    NSPanel* mPreviewWindow;
    IOSInstructionView* mInstructionView;
    NSSize mContentSize;
    
    UInt8* mImageSwapBuffer;
    int mImageSwapBufferSize;
	
    AVCaptureVideoPreviewLayer* mPreviewLayer;
    NSView* mPreviewView;
    
    AVCaptureStillImageOutput* mStillImageOutput;
	BOOL mbRunning;
    BOOL mbRealRunning;
	
	CaptureState mState;
	
	NSTimer* mAbnormalDisconnectTimer;
	
	BOOL mbPaused;
    
    wbx_device_notification* mDeviceNotification;
    
    NSMutableArray* mDeviceList;
    NSTimer* mReEnablHalTimer;
    NSTimer* mReselectTimer;
    
    IOShareMaskWindow* mMaskWindow;
    
    BOOL mbEnableMobileDeviceFramework;

    int mRotateDegree;
    
    CGContextRef mLoadingImageBmpContext;
    UInt8* mLoadingImageData;

	BOOL mbGotFormatChange;
    
    NSTimer* mPlugAnimationTimer;
    
    CFBundleRef m_mobileDeviceBundleRef;
    WBX_AMDeviceNotificationSubscribe pfnAMDeviceNotificationSubscribe;
    WBX_AMDeviceNotificationUnsubscribe pfnAMDeviceNotificationUnsubscribe;
    WBX_AMDeviceConnect pfnAMDeviceConnect;
    WBX_AMDeviceDisconnect pfnAMDeviceDisconnect;
    WBX_AMDeviceIsPaired pfnAMDeviceIsPaired;
    WBX_AMDeviceValidatePairing pfnAMDeviceValidatePairing;
	
	BOOL mbEnableRetinaCapture;
}

- (id)initWithShareCtrl:(IosScreenCaptureEvent*)pCtrl;
- (void)CleanUp;

- (void)MyDeviceCallback:(wbx_device_notification_callback_info*)info;

- (void)PauseShare:(BOOL)bPause;

- (void)startCapture;
- (void)stopCapture;

- (void)ShowDeviceNotDetect;
- (BOOL)SelectDevice;

- (NSPanel*)GetPreviewWindow;
- (void)HidePreviewWindow;

- (void)setEnableRetinaCapture:(BOOL)bEnableRetina;

@end
