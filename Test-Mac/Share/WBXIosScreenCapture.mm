//
//  WBXIosScreenCapture.m
//  videotest
//
//  Created by mac on 8/5/16.
//
//

#import "WBXIosScreenCapture.h"
#import <CoreMediaIO/CMIOHardwareObject.h>
#import <CoreMediaIO/CMIOHardwareDevice.h>
#import <CoreMediaIO/CMIOHardwareSystem.h>
#import "IOSScreenShareCtrl.h"
#import "safe_mem_lib.h"
#import "atmactra2.h"
#import "CCocoaUtil.h"
#import <uilib/UILibThemeDynamicColor.h>
#import "NSColor+Wbx.h"

#define DEFAULT_WIDTH 640
#define DEFAULT_HEIGHT 480

#define ENABLE_LAYERPREVIEW 1
#define QUICK_CAPTURE 1

#define NEWFITWIN_BASEHEIGHT	52
#define NEWFITWIN_EXTHEIGHT		23
#define PREVIEW_FIT_OFFSET      10

#define MASK_EDGE_WIDTH         6

#define INTERVAL1   5
#define INTERVAL2   10

NSString* kIOShareInfo1 = @"Connect your iPhone or iPad to this Mac computer.";
NSString* kIOShareInfo2 = @"On the connected iPhone or iPad, when asked if you trust this computer, select <b>Trust</b>.";
NSString* kIOShareInfo3 = @"Sharing will start automatically in a few seconds.";
NSString* kIOSShareTitle = @"Share iPhone or iPad Screen";

NSString* kIOSDeviceTrused = @"kIOSDeviceTrused";
NSString* kIOSDeviceCableConnect = @"kIOSDeviceCableConnect";
NSString* kIOSDeviceCableDisonnect = @"kIOSDeviceCableDisonnect";

#define INSTRUCTION_TOP_OFFSET 41
#define INSTRUCTION_BOTTOM_OFFSET 90

BOOL gbHalDeviceEnabled = 0;

@implementation IOShareMaskWindowContentView

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect rect = [self bounds];
    
    [[UILibThemeDynamicColor themeDynamicColorWithLightColor:[NSColor colorWithDeviceRed:0x4*1.0/0xFF green:0x9f*1.0/0xFF blue:0xd9*1.0/0xff alpha:1.0] darkColor:[NSColor colorWithRGB:0x545454 alpha:1.0]] set];
    NSBezierPath* path = [NSBezierPath bezierPath];
    [path appendBezierPathWithRoundedRect:rect xRadius:7 yRadius:7];
    [path appendBezierPathWithRoundedRect:NSInsetRect(rect, 10, 10) xRadius:10 yRadius:10];
    [path setWindingRule:NSEvenOddWindingRule];
    [path fill];
}

@end

@implementation IOShareMaskWindow

- (id)init
{
    self = [super initWithContentRect:NSZeroRect styleMask:0 backing:NSBackingStoreBuffered  defer:NO];
    if(self)
    {
        IOShareMaskWindowContentView* content = [[IOShareMaskWindowContentView alloc] initWithFrame:NSZeroRect];
        [self setContentView:content];
        [content release];
        [self setIgnoresMouseEvents:YES];
        [self setOpaque:NO];
        [self setBackgroundColor:[UILibThemeDynamicColor themeDynamicColorWithLightColor:[NSColor clearColor] darkColor:[NSColor colorWithRGB:0x1c1c1c alpha:1.0]]];
        [self setReleasedWhenClosed:YES];
    }
    
    return self;
}

@end

@implementation IOSInstructionView

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if(self)
    {
        mProgressView = [[DeloreanSpinImageView alloc] initWithFrame:NSMakeRect((frameRect.size.width - 80)/2,(frameRect.size.height - 80)/2, 80, 80)];
        [self addSubview:mProgressView];
        [mProgressView setHidden:YES];
        [mProgressView release];
    }
    
    return self;
}

- (NSAttributedString*)getAttributedString:(NSString*)str
{
    NSMutableString* mutableMainStr = [NSMutableString stringWithString:str];
    NSArray *boldArray = [self getBoldRanges:mutableMainStr];
    
    NSDictionary *mainAttr = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Lucida Grande" size:15],NSFontAttributeName,[UILibThemeDynamicColor themeDynamicColorWithLightColor:[NSColor colorWithDeviceRed:0x6a*1.0/255.0 green:0x6b*1.0/255.0 blue:0x6c*1.0/255.0 alpha:1.0] darkColor:[NSColor colorWithRGB:0xf7f7f7 alpha:1.0]],NSForegroundColorAttributeName,nil];
    
    NSMutableAttributedString *mainAttrStr = [[NSMutableAttributedString alloc] initWithString:mutableMainStr attributes:mainAttr];
    for(NSValue *boldRange in boldArray)
    {
        [mainAttrStr applyFontTraits:NSBoldFontMask range:[boldRange rangeValue]];
    }
    
    return [mainAttrStr autorelease];
}

-(NSArray *)getBoldRanges:(NSMutableString *)aString
{
    if(aString == nil)
        return nil;
    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:0];
    NSUInteger loc = 0;
    NSRange boldRange = NSMakeRange(NSNotFound, 0);
    while(loc<[aString length])
    {
        NSRange searchRange = NSMakeRange(loc, [aString length]-loc);
        NSRange flagRange = [aString rangeOfString:@"<b>" options:NSCaseInsensitiveSearch range:searchRange];
        if(NSEqualRanges(flagRange,NSMakeRange(NSNotFound, 0)))
            break;
        
        [aString deleteCharactersInRange:flagRange];
        loc = flagRange.location;
        searchRange = NSMakeRange(flagRange.location, [aString length]-flagRange.location);
        flagRange = [aString rangeOfString:@"</b>" options:NSCaseInsensitiveSearch range:searchRange];
        if(!NSEqualRanges(flagRange,NSMakeRange(NSNotFound, 0)))
        {
            [aString deleteCharactersInRange:flagRange];
            boldRange = NSMakeRange(loc, flagRange.location - loc);
        }
        else
        {
            boldRange = NSMakeRange(loc, [aString length]-flagRange.location);
        }
        [retArray addObject:[NSValue valueWithRange:boldRange]];
        loc = NSMaxRange(boldRange);
    }
    
    return retArray;
}

- (void)showProgressView:(BOOL)bShow
{
    if(bShow)
        [mProgressView startSpin];
    else
        [mProgressView stopSpin];
    
    [mProgressView setHidden:!bShow];

    [self setNeedsDisplay:YES];
}

- (void)resizeSubviewsWithOldSize:(NSSize)oldSize
{
    NSRect rect = [self bounds];
    NSRect progressRect = [mProgressView bounds];
    
    NSPoint origin = NSMakePoint((rect.size.width - progressRect.size.width)/2.0, (rect.size.height - progressRect.size.height)/2.0);
    [mProgressView setFrameOrigin:origin];
}

- (void)setRunning:(BOOL)bRunning
{
    mbRunning = bRunning;
    [self setNeedsDisplay:YES];
}

- (void)setDeviceAttached:(BOOL)bAttached
{
    mbDeviceAttached = bAttached;
}

- (void)setImage:(NSImage*)img
{
    
}

- (BOOL)isOpaque
{
    return NO;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    NSRect rect = [self bounds];
    
    if(mbRunning)
    {
        [[UILibThemeDynamicColor themeDynamicColorWithLightColorRGB:0xffffff andAlpha:1.0 darkColorRGB:0x1c1c1c andAlpha:1.0] set];
        NSRectFill(rect);
    }
    else if(mProgressView && ![mProgressView isHidden])
    {
        [[UILibThemeDynamicColor themeDynamicColorWithLightColorRGB:0xffffff andAlpha:1.0 darkColorRGB:0x1c1c1c andAlpha:1.0] set];
        NSRectFill(rect);
    }
    else
    {
        [[UILibThemeDynamicColor themeDynamicColorWithLightColorRGB:0xffffff andAlpha:1.0 darkColorRGB:0x1c1c1c andAlpha:1.0] set];
        NSRectFill(rect);
        
        NSBundle* curBundle = [NSBundle bundleForClass:[self class]];
        NSString* tempstr = [curBundle localizedStringForKey:kIOShareInfo1 value:kIOShareInfo1 table:@"appshare"];
        NSAttributedString* info1 = [self getAttributedString:tempstr];
        tempstr = [curBundle localizedStringForKey:kIOShareInfo2 value:kIOShareInfo2 table:@"appshare"];
        NSAttributedString* info2 = [self getAttributedString:tempstr];
        tempstr = [curBundle localizedStringForKey:kIOShareInfo3 value:kIOShareInfo3 table:@"appshare"];
        NSAttributedString* info3 = [self getAttributedString:tempstr];
        
        NSAttributedString* sym1 = [self getAttributedString:@"1. "];
        NSAttributedString* sym2 = [self getAttributedString:@"2. "];
        
        NSSize size1 = [info1 size];
        NSSize size2 = [info2 size];
        NSSize size3 = [info3 size];
        
        NSSize sym1Size = [sym1 size];
        NSSize sym2Size = [sym2 size];
        int maxSymWidth = sym1Size.width > sym2Size.width ? sym1Size.width : sym2Size.width;
        
        int maxwidth = size1.width > size2.width ? size1.width : size2.width;
        maxwidth = size3.width > maxwidth ? size3.width : maxwidth;
        if(maxwidth > rect.size.width - 40*2 - maxSymWidth)
            maxwidth = rect.size.width - 40*2 - maxSymWidth;
        
        int leftOffset = (rect.size.width - maxwidth)/2;
        int yOffset = rect.size.height - INSTRUCTION_TOP_OFFSET;
	//	int symmOffset = yOffset;
        int symmOffset = yOffset - sym1Size.height;
        NSRect fitSize = [info1 boundingRectWithSize:NSMakeSize(maxwidth, 256) options:NSStringDrawingUsesLineFragmentOrigin];
        yOffset -= fitSize.size.height;
        [sym1 drawAtPoint:NSMakePoint(leftOffset, symmOffset)];
        [info1 drawInRect:NSMakeRect(leftOffset + maxSymWidth,yOffset,maxwidth,fitSize.size.height)];
       
        
        symmOffset = yOffset - sym2Size.height - INTERVAL1;
        fitSize = [info2 boundingRectWithSize:NSMakeSize(maxwidth, 256) options:NSStringDrawingUsesLineFragmentOrigin];
        yOffset -= (fitSize.size.height + INTERVAL1);
        [sym2 drawAtPoint:NSMakePoint(leftOffset, symmOffset)];
        [info2 drawInRect:NSMakeRect(leftOffset + maxSymWidth,yOffset,maxwidth,fitSize.size.height)];
        
        fitSize = [info3 boundingRectWithSize:NSMakeSize(maxwidth, 256) options:NSStringDrawingUsesLineFragmentOrigin];
        yOffset -= (fitSize.size.height + INTERVAL2);
        [info3 drawInRect:NSMakeRect(leftOffset,yOffset,maxwidth,fitSize.size.height)];
        
        NSImage* img = [NSImage imageNamed:@"share_diagram_2.png"];
        if(img == nil)
        {
            NSBundle* bundle = [NSBundle bundleForClass:[self class]];
            NSURL* url = [bundle URLForResource:@"share_diagram_2" withExtension:@"png"];
            if(url)
            {
                img = [[NSImage alloc] initByReferencingURL:url];
                [img autorelease];
            }
        }
        NSSize imgSize = [img size];
        
        leftOffset = (rect.size.width - imgSize.width)/2;
        [img drawAtPoint:NSMakePoint(leftOffset, INSTRUCTION_BOTTOM_OFFSET) fromRect:NSZeroRect operation:(NSCompositeSourceOver) fraction:1.0];
        
        img = [NSImage imageNamed:@"share_lightning.png"];
        if(img == nil)
        {
            NSBundle* bundle = [NSBundle bundleForClass:[self class]];
            NSURL* url = [bundle URLForResource:@"share_lightning" withExtension:@"png"];
            if(url)
            {
                img = [[NSImage alloc] initByReferencingURL:url];
                [img autorelease];
            }
        }
        imgSize = [img size];
        
        if(mbDeviceAttached)
        {
            yOffset = INSTRUCTION_BOTTOM_OFFSET - imgSize.height;
        }
        else
        {
            const int maxDistanceBetweenConnectorAndDevice = 26;
            const int stepForAnimation = 2;
            yOffset = INSTRUCTION_BOTTOM_OFFSET - imgSize.height - maxDistanceBetweenConnectorAndDevice + mCount*stepForAnimation;
        }
        
        mCount++;
        
        const int maxStepCount = 8;
        if(mCount > maxStepCount)
            mCount = 0;

        leftOffset = (rect.size.width - imgSize.width)/2;
        [img drawAtPoint:NSMakePoint(leftOffset, yOffset) fromRect:NSZeroRect operation:(NSCompositeSourceOver) fraction:1.0];
    }
}

@end

void mydevicecallback(struct am_device_notification_callback_info * cb, void* arg)
{
    WBXIosScreenCapture* pThis = (WBXIosScreenCapture*)arg;
    [pThis MyDeviceCallback:cb];
}

@implementation WBXIosScreenCapture

- (id)initWithShareCtrl:(IosScreenCaptureEvent*)pCtrl
{
    self = [super init];
    if(self)
    {
		WARNINGTRACE("[APPSHARE] WBXIosScreenCapture init");
		
		mbEnableRetinaCapture = FALSE;
		
        mLock = [[NSLock alloc] init];
		
		mState = CaptureState_NONE;
		
        mScreenShareCtrl = pCtrl;
        
        mMaskWindow = [[IOShareMaskWindow alloc] init];
        mDeviceList = [[NSMutableArray alloc] init];
        
        mVideoQueue = dispatch_queue_create("myVideoQueue", NULL);
        
#if QUICK_CAPTURE
        mTimerQueue = dispatch_queue_create("myTimerQueue", NULL);
        mTimerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, DISPATCH_TIMER_STRICT, mTimerQueue);
        if(mTimerSource)
        {
            dispatch_source_set_timer(mTimerSource, dispatch_time(DISPATCH_TIME_NOW, 0.15 * NSEC_PER_SEC), 0.15 * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
    
            dispatch_source_set_event_handler(mTimerSource, ^{
                [self OnCaptureWindowTimer];
            });
            
            dispatch_resume(mTimerSource);
        }
#endif
        
        mCaptureSession = [[AVCaptureSession alloc] init];
        mCaptureSession.sessionPreset = AVCaptureSessionPresetMedium;
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        mDeviceConnectObserver = [notificationCenter addObserverForName:AVCaptureDeviceWasConnectedNotification
                                                                        object:nil
                                                                         queue:[NSOperationQueue mainQueue]
                                                                    usingBlock:^(NSNotification *note) {
                                                                        AVCaptureDevice *device = note.object;
                                                                        [self deviceConnected:device];
                                                                    }];
        
        mDeviceDisonnectObserver = [notificationCenter addObserverForName:AVCaptureDeviceWasDisconnectedNotification
                                        object:nil
                                         queue:[NSOperationQueue mainQueue]
                                    usingBlock:^(NSNotification *note) {
                                        AVCaptureDevice *device = note.object;
                                        [self deviceDisconnected:device];
                                    }];
		
		
		[notificationCenter addObserver:self selector:@selector(OnCaptureSessionDidStart:) name:AVCaptureSessionDidStartRunningNotification object:mCaptureSession];
		[notificationCenter addObserver:self selector:@selector(OnCaptureSessionDidStop:) name:AVCaptureSessionDidStopRunningNotification object:mCaptureSession];
		
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(avCaptureInputPortFormatDescriptionDidChangeNotification:)
                                                     name:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appWillHide:)
                                                     name:NSApplicationWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidUnhide:)
                                                     name:NSApplicationDidUnhideNotification object:nil];
        
        
        BOOL bNeedLoadMobileDeviceFramework = TRUE;
        if(![[NSProcessInfo processInfo] respondsToSelector:@selector(operatingSystemVersion)])
        {
            bNeedLoadMobileDeviceFramework = FALSE;
        }
        else
        {
            NSOperatingSystemVersion ver = [[NSProcessInfo processInfo] operatingSystemVersion];
            if(ver.majorVersion < 10)
                bNeedLoadMobileDeviceFramework = FALSE;
        }
        
        mbEnableMobileDeviceFramework = 0;
        if(bNeedLoadMobileDeviceFramework)
        {
            OSStatus err = [self LoadPrivateFrameworkBundle:CFSTR("MobileDevice.framework") :&m_mobileDeviceBundleRef];
            if(err == noErr && m_mobileDeviceBundleRef)
            {
                pfnAMDeviceNotificationSubscribe = (LP_AMDeviceNotificationSubscribe)CFBundleGetFunctionPointerForName(m_mobileDeviceBundleRef, CFSTR("AMDeviceNotificationSubscribe"));
                pfnAMDeviceNotificationUnsubscribe = (LP_AMDeviceNotificationUnsubscribe)CFBundleGetFunctionPointerForName(m_mobileDeviceBundleRef, CFSTR("AMDeviceNotificationUnsubscribe"));
                pfnAMDeviceConnect = (LP_AMDeviceConnect)CFBundleGetFunctionPointerForName(m_mobileDeviceBundleRef, CFSTR("AMDeviceConnect"));
                pfnAMDeviceDisconnect = (LP_AMDeviceDisconnect)CFBundleGetFunctionPointerForName(m_mobileDeviceBundleRef, CFSTR("AMDeviceDisconnect"));
                pfnAMDeviceIsPaired = (LP_AMDeviceIsPaired)CFBundleGetFunctionPointerForName(m_mobileDeviceBundleRef, CFSTR("AMDeviceIsPaired"));
                pfnAMDeviceValidatePairing = (LP_AMDeviceValidatePairing)CFBundleGetFunctionPointerForName(m_mobileDeviceBundleRef, CFSTR("AMDeviceValidatePairing"));
                
                if(pfnAMDeviceNotificationSubscribe && pfnAMDeviceNotificationUnsubscribe && pfnAMDeviceConnect && pfnAMDeviceDisconnect && pfnAMDeviceIsPaired && pfnAMDeviceValidatePairing)
                {
                    mbEnableMobileDeviceFramework = 1;
                }
            }
        }
            
        if(!mbEnableMobileDeviceFramework)
        {
            [self EnableHalDevice:1];
        }
        else
        {
            pfnAMDeviceNotificationSubscribe(&mydevicecallback,0,0,self,&mDeviceNotification);
        }
        
        mLoadingImageData = new UInt8[640*480*4];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        mLoadingImageBmpContext = CGBitmapContextCreate(mLoadingImageData,DEFAULT_WIDTH,DEFAULT_HEIGHT,8,DEFAULT_WIDTH*4, colorSpace, kCGImageAlphaNoneSkipFirst);
        CGColorSpaceRelease(colorSpace);
        
        mPreviewWindow = [[NSPanel alloc] initWithContentRect:NSMakeRect(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT) styleMask:NSTitledWindowMask|NSMiniaturizableWindowMask backing:NSBackingStoreBuffered defer:NO];
        [[mPreviewWindow contentView] setAutoresizesSubviews:YES];
        
        NSBundle* curBundle = [NSBundle bundleForClass:[self class]];
        NSString* title = [curBundle localizedStringForKey:kIOSShareTitle value:kIOSShareTitle table:@"appshare"];
        [mPreviewWindow setTitle:title];
        
        mInstructionView = [[IOSInstructionView alloc] initWithFrame:NSMakeRect(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT)];
        [mInstructionView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [[mPreviewWindow contentView] addSubview:mInstructionView];
        [mPreviewWindow setHidesOnDeactivate:NO];
        [mInstructionView release];
        
        mPreviewView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT)];
        [mPreviewView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [mPreviewView setWantsLayer:YES];
        [mPreviewView setHidden:YES];
        [[mPreviewWindow contentView] addSubview:mPreviewView];
        [self centerPreviewWindow];
        [mPreviewWindow makeKeyAndOrderFront:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(previewWindowDidMove:)
                                                     name:NSWindowDidMoveNotification object:mPreviewWindow];
        
		if(ENABLE_LAYERPREVIEW)
		{
			mPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:mCaptureSession];
			[mPreviewLayer setAutoresizingMask:kCALayerWidthSizable | kCALayerHeightSizable];
            CGColorRef colorRef = CGColorCreateGenericRGB(0, 0, 0, 1);
            [mPreviewLayer setBackgroundColor:colorRef];
            [mPreviewLayer setFrame:CGRectMake(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT)];
            CGColorRelease(colorRef);
			[[mPreviewView layer] addSublayer:mPreviewLayer];
			[mPreviewLayer release];
		}
		
		mCaptureTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(OnCaptureTimer:) userInfo:nil repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:mCaptureTimer forMode:NSModalPanelRunLoopMode];
		[[NSRunLoop currentRunLoop] addTimer:mCaptureTimer forMode: NSEventTrackingRunLoopMode];
		
        mPlugAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(OnPlugAnimationTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:mPlugAnimationTimer forMode:NSModalPanelRunLoopMode];
        [[NSRunLoop currentRunLoop] addTimer:mPlugAnimationTimer forMode: NSEventTrackingRunLoopMode];
        
		dispatch_async(dispatch_get_main_queue(),^{
			[self SelectDevice];
		});
    }
	
    return self;
}

- (void)CleanUp
{
	WARNINGTRACE("[APPSHARE] WBXIosScreenCapture CleanUp enter");

    if(mPlugAnimationTimer)
    {
        [mPlugAnimationTimer invalidate];
        mPlugAnimationTimer = nil;
    }
    
    if(mReselectTimer)
    {
        [mReselectTimer invalidate];
        mReselectTimer = nil;
    }
    
    if(mReEnablHalTimer)
    {
        [mReEnablHalTimer invalidate];
        mReEnablHalTimer = nil;
    }
    
    if(mDeviceNotification)
    {
        pfnAMDeviceNotificationUnsubscribe(mDeviceNotification);
        mDeviceNotification = nil;
    }
    
	if(mAbnormalDisconnectTimer)
	{
		[mAbnormalDisconnectTimer invalidate];
		mAbnormalDisconnectTimer = NULL;
	}
	
	if(mCaptureTimer)
	{
		[mCaptureTimer invalidate];
		mCaptureTimer = NULL;
	}
	
    if(mTimerSource)
    {
        dispatch_source_cancel(mTimerSource);
        dispatch_release(mTimerSource);
        mTimerSource = NULL;
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_async(mTimerQueue, ^() {
            dispatch_semaphore_signal(semaphore);
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
	
    if([mMaskWindow parentWindow])
        [mPreviewWindow removeChildWindow:mMaskWindow];
    
    [mMaskWindow orderOut:nil];
    [mPreviewWindow orderOut:nil];
    
    [self stopCapture];
    
    if(mVideoQueue)
    {
        dispatch_release(mVideoQueue);
        mVideoQueue = nil;
    }

    if(mTimerQueue)
    {
        dispatch_release(mTimerQueue);
        mTimerQueue = nil;
    }
    
    if(mDeviceConnectObserver)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:mDeviceConnectObserver];
        mDeviceConnectObserver = nil;
    }
    
    if(mDeviceDisonnectObserver)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:mDeviceDisonnectObserver];
        mDeviceDisonnectObserver = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [mMaskWindow close];
    mMaskWindow = nil;
    
    mInstructionView = nil;
    mPreviewView = nil;
    
    [mPreviewWindow release];
    mPreviewWindow = nil;
    
    mScreenShareCtrl = nil;
	
	WARNINGTRACE("[APPSHARE] WBXIosScreenCapture CleanUp exit");
}

- (void)dealloc
{
	WARNINGTRACE("[APPSHARE] WBXIosScreenCapture dealloc");
    
    [mCaptureSession release];
    [mLock release];
    [mDeviceList release];

    if(mImageSwapBuffer)
    {
        delete[] mImageSwapBuffer;
        mImageSwapBuffer = NULL;
    }
    
    if(mLoadingImageBmpContext)
        CGContextRelease(mLoadingImageBmpContext);
    if(mLoadingImageData)
        delete[] mLoadingImageData;
    
    [super dealloc];
}

- (OSStatus)LoadPrivateFrameworkBundle:(CFStringRef)framework :(CFBundleRef*)bundlePtr
{
    OSStatus 	err = noErr;
    CFURLRef	baseURL = nil;
    CFURLRef	bundleURL = nil;
    
    *bundlePtr = nil;
    baseURL = GetSysPrivateFrameWorkFolder();
    
    if (baseURL != nil) {
        bundleURL = CFURLCreateCopyAppendingPathComponent(kCFAllocatorSystemDefault,
                                                          baseURL, framework, false);
        if (bundleURL == nil) {
            err = coreFoundationUnknownErr;
        }
    }
    
    if (err == noErr) {
        *bundlePtr = CFBundleCreate(kCFAllocatorSystemDefault, bundleURL);
        if (*bundlePtr == nil) {
            err = coreFoundationUnknownErr;
        }
    }
    if (err == noErr) {
        if ( ! CFBundleLoadExecutable( *bundlePtr ) ) {
            err = coreFoundationUnknownErr;
        }
    }
    
    if (err != noErr && *bundlePtr != nil) {
        CFRelease(*bundlePtr);
        *bundlePtr = nil;
    }
    if (bundleURL != nil) {
        CFRelease(bundleURL);
    }	
    
    
    return err;
}

- (void)setEnableRetinaCapture:(BOOL)bEnableRetina
{
	mbEnableRetinaCapture = bEnableRetina;
}

- (NSPanel*)GetPreviewWindow
{
	return mPreviewWindow;
}

- (void)centerPreviewWindow
{
    NSRect previewWinRect = [mPreviewWindow frame];
    NSScreen* currentScreen = [mPreviewWindow screen];
    if(currentScreen)
    {
        NSRect visibleRect = [currentScreen visibleFrame];
        
        previewWinRect.origin.x = visibleRect.origin.x + (visibleRect.size.width - previewWinRect.size.width)/2;
        previewWinRect.origin.y = visibleRect.origin.y + (visibleRect.size.height - previewWinRect.size.height)/2;
        
        int topEdge = visibleRect.origin.y + visibleRect.size.height;
        if(previewWinRect.origin.y  + previewWinRect.size.height > topEdge)
        {
            previewWinRect.origin.y = topEdge - previewWinRect.size.height;
        }
        
        [mPreviewWindow setFrame:previewWinRect display:YES];
    }
}

- (void)appWillHide:(id)sender
{
    mPreviewLayer.connection.enabled = NO;
}

- (void)appDidUnhide:(id)sender
{
    mPreviewLayer.connection.enabled = YES;
}

- (void)previewWindowDidMove:(id)sender
{
    [self updateMaskWindow];
}

- (void)updateMaskWindow
{
    if(mbRealRunning)
    {
        NSRect frame = [mPreviewWindow frame];
        [mMaskWindow setFrame:NSInsetRect(frame,-MASK_EDGE_WIDTH,-MASK_EDGE_WIDTH) display:YES];
        
        if(![mMaskWindow parentWindow])
        {
            [mPreviewWindow addChildWindow:mMaskWindow ordered:NSWindowBelow];
            [mMaskWindow orderFront:nil];
        }
    }
    else
    {
        if([mMaskWindow parentWindow])
        {
            [mPreviewWindow removeChildWindow:mMaskWindow];
            [mMaskWindow orderOut:nil];
        }
    }
}

- (void)ShowInstructionView
{
	[self ChangePreviewSize:NSMakeSize(DEFAULT_WIDTH, DEFAULT_HEIGHT)];
	mContentSize = NSMakeSize(DEFAULT_WIDTH*2, DEFAULT_HEIGHT*2);
		
	if(ENABLE_LAYERPREVIEW)
	{
        [mPreviewView setHidden:YES];
        [mInstructionView showProgressView:NO];
		[mInstructionView setHidden:NO];
	}
	
	[self centerPreviewWindow];
    [self updateMaskWindow];
}

- (void)ShowPreviewView
{
    [mInstructionView showProgressView:NO];
    [mInstructionView setHidden:YES];
    [mPreviewView setHidden:NO];
}

- (void)OnReEnableHalDeviceTimer:(id)sender
{
    mReEnablHalTimer = nil;
    [self EnableHalDevice:1];
}

- (void)ReEnableHalDevice
{
    if(mCurrentScreenCaptureDevice)
        return;
    
    WARNINGTRACE("[APPSHARE] ReEnableHalDevice");
    [self EnableHalDevice:0];
    
    if(mReEnablHalTimer)
        [mReEnablHalTimer invalidate];
    
    mReEnablHalTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(OnReEnableHalDeviceTimer:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:mReEnablHalTimer forMode:NSModalPanelRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer:mReEnablHalTimer forMode: NSEventTrackingRunLoopMode];
}

- (void)EnableHalDevice:(int)bEnable
{
    if(gbHalDeviceEnabled == bEnable)
        return;
    
    WARNINGTRACE("[APPSHARE] EnableHalDevice " << bEnable);
    
    gbHalDeviceEnabled = bEnable;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue,^() {
        CMIOObjectPropertyAddress   prop    = {
            kCMIOHardwarePropertyAllowScreenCaptureDevices,
            kCMIOObjectPropertyScopeGlobal,
            kCMIOObjectPropertyElementMaster
        };
        UInt32  allow   = gbHalDeviceEnabled;
        
        NSString* uniqueID = nil;
        CMIOObjectSetPropertyData(kCMIOObjectSystemObject, &prop, 0, NULL, sizeof(allow), &allow);
    });
}

- (void)MyDeviceCallback:(am_device_notification_callback_info*)info
{
    if(info == nil || info->dev == nil)
        return;
    
    WARNINGTRACE("[APPSHARE] MyDeviceCallback,msg = " << info->msg);
    if(info->msg == 1)
    {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSValue valueWithPointer:info->dev] forKey:@"device"];
        
        //marked,after sync with wendy,[mInstructionView setDeviceAttached:YES];
        
        int status = 0;
        int ret = pfnAMDeviceConnect(info->dev);
        if(ret == 0)
        {
            ret = pfnAMDeviceIsPaired(info->dev);
            if(ret == 1)
            {
                ret = pfnAMDeviceValidatePairing(info->dev);
                if(ret == 0)
                {
                    WARNINGTRACE("[APPSHARE] MyDeviceCallback,detect trust computer");
                    if(mReselectTimer)
                    {
                        [mReselectTimer invalidate];
                        mReselectTimer = nil;
                    }
                    
                    if(gbHalDeviceEnabled)
                    {
                        mReselectTimer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(reselectTimer:) userInfo:nil repeats:NO];
                        [[NSRunLoop currentRunLoop] addTimer:mReselectTimer forMode:NSModalPanelRunLoopMode];
                        [[NSRunLoop currentRunLoop] addTimer:mReselectTimer forMode: NSEventTrackingRunLoopMode];
                    }
                    
                    status = 1;
                    if(mReEnablHalTimer == nil)
                        [self EnableHalDevice:1];
                }
            }
            
            pfnAMDeviceDisconnect(info->dev);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kIOSDeviceCableConnect object:nil];
        
        [dict setObject:[NSNumber numberWithInt:status] forKey:@"status"];
        [mDeviceList addObject:[dict autorelease]];
    }
    else if(info->msg == 2)
    {
        WARNINGTRACE("[APPSHARE] MyDeviceCallback,detect device plug out");
        for(int k = 0; k < [mDeviceList count]; k++)
        {
            NSDictionary* dict = [mDeviceList objectAtIndex:k];
            if([[dict objectForKey:@"device"] pointerValue] == info->dev)
            {
                [mDeviceList removeObjectAtIndex:k];
                break;
            }
        }
        
        if([mDeviceList count] == 0)
            [mInstructionView setDeviceAttached:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kIOSDeviceCableDisonnect object:nil];
    }
    else if(info->msg == 4)
    {
        WARNINGTRACE("[APPSHARE] MyDeviceCallback,detect trust computer");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kIOSDeviceTrused object:nil];
        
        for(int k = 0; k < [mDeviceList count]; k++)
        {
            NSDictionary* dict = [mDeviceList objectAtIndex:k];
            if([[dict objectForKey:@"device"] pointerValue] == info->dev)
            {
                [dict setObject:[NSNumber numberWithInt:1] forKey:@"status"];
                break;
            }
        }
        
        [self ReEnableHalDevice];
    }
}

- (void)reselectTimer:(id)sender
{
    mReselectTimer = nil;
    
    if(mCurrentScreenCaptureDevice == nil && gbHalDeviceEnabled)
    {
        [self SelectDevice];
    }
}

- (void)PauseShare:(BOOL)bPause
{
	mbPaused = bPause;
}

- (void)startCapture
{
	if(mbRunning)
		return;
	
    WARNINGTRACE("[APPSHARE] startCapture");
    
	mbRunning = TRUE;
	mbGotFormatChange = 0;
	
    [mInstructionView showProgressView:YES];
    
    [mCaptureSession beginConfiguration];
    
    NSError *error;
    mInput = [AVCaptureDeviceInput deviceInputWithDevice:mCurrentScreenCaptureDevice error:&error];
    if(!mInput)
    {
        [mCaptureSession commitConfiguration];
        WARNINGTRACE("[APPSHARE] deviceInputWithDevice error");
        return;
    }
    [mInput retain];
    [mCaptureSession addInput:mInput];

 
#if QUICK_CAPTURE
    mMovieOutput = [[AVCaptureMovieFileOutput alloc] init];
    [mCaptureSession addOutput:mMovieOutput];
    [mMovieOutput release];
    
    NSArray* conns = [mMovieOutput connections];
    if([conns count] > 0)
    {
        AVCaptureConnection* outConnection = [conns objectAtIndex:0];
        [mMovieOutput setOutputSettings:[NSDictionary dictionary] forConnection:outConnection];
    }
#else
    mStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA],kCVPixelBufferPixelFormatTypeKey, nil];
    [mStillImageOutput setOutputSettings:outputSettings];
    [outputSettings release];
    [mCaptureSession addOutput:mStillImageOutput];
    [mStillImageOutput release];
#endif
    
    [mCaptureSession commitConfiguration];
	
	dispatch_async(mVideoQueue, ^{
		[mCaptureSession startRunning];
	});
}

- (void)stopCapture
{
	if(mAbnormalDisconnectTimer)
	{
		[mAbnormalDisconnectTimer invalidate];
		mAbnormalDisconnectTimer = nil;
	}
	
    mCurrentScreenCaptureDevice = nil;
	
	mbGotFormatChange = 0;
	
	if(!mbRunning)
		return;
	
    WARNINGTRACE("[APPSHARE] stopCapture");

	mbRunning = FALSE;
    mbRealRunning = FALSE;
    
    [self ShowInstructionView];
    [mInstructionView setRunning:NO];
    [self updateMaskWindow];
    
	dispatch_sync(mVideoQueue, ^ {
		
		[mCaptureSession stopRunning];
		
		if(mInput)
		{
			[mCaptureSession removeInput:mInput];
            [mInput release];
			mInput = nil;
		}
		
		if(mStillImageOutput)
		{
			[mCaptureSession removeOutput:mStillImageOutput];
			mStillImageOutput = nil;
		}
		
        if(mMovieOutput)
        {
            [mCaptureSession removeOutput:mMovieOutput];
            mMovieOutput = nil;
        }
	});
				  
    [mLock lock];
    if(m_cachedSampleBufferRef)
    {
        CFRelease(m_cachedSampleBufferRef);
        m_cachedSampleBufferRef = NULL;
    }
    
    if(m_cachedCGImage)
    {
        CGImageRelease(m_cachedCGImage);
        m_cachedCGImage = nil;
    }
    [mLock unlock];
}

- (void)ChangePreviewSize:(NSSize)size
{
    NSPoint oldWindowCenter = NSMakePoint(0,0);
    if([mPreviewWindow isVisible])
    {
        NSRect previewWinRect = [mPreviewWindow frame];
        oldWindowCenter.x = previewWinRect.origin.x + previewWinRect.size.width/2;
        oldWindowCenter.y = previewWinRect.origin.y + previewWinRect.size.height/2;
    }

    [mPreviewWindow setContentSize:size];
    [mInstructionView setFrame:NSMakeRect(0,0,size.width, size.height)];
    [mPreviewView setFrame:NSMakeRect(0,0,size.width, size.height)];
    
    if([mPreviewWindow isVisible])
    {
        NSRect previewWinRect = [mPreviewWindow frame];
        previewWinRect.origin.x = oldWindowCenter.x - previewWinRect.size.width/2;
        previewWinRect.origin.y = oldWindowCenter.y - previewWinRect.size.height/2;
        
        NSScreen* currentScreen = [mPreviewWindow screen];
        if(currentScreen)
        {
            NSRect visibleRect = [currentScreen visibleFrame];
            int topEdge = visibleRect.origin.y + visibleRect.size.height;// - NEWFITWIN_BASEHEIGHT;
            if(previewWinRect.origin.y  + previewWinRect.size.height > topEdge)
                previewWinRect.origin.y = topEdge - previewWinRect.size.height;
        }
        
        [mPreviewWindow setFrame:previewWinRect display:YES];
    }

}

- (void)OnPlugAnimationTimer:(id)sender
{
    if(![mInstructionView isHidden])
        [mInstructionView setNeedsDisplay:YES];
}

- (void)OnCaptureWindowTimer
{
    if(mbPaused)
        return;
    
    if(!mbRealRunning)
    {
        NSImage* img = [NSImage imageNamed:@"blue_spinner"];
        if(img == nil)
        {
            NSBundle* bundle = [NSBundle bundleForClass:[self class]];
            NSURL* url = [bundle URLForResource:@"blue_spinner" withExtension:@"png"];
            if(url)
            {
                img = [[NSImage alloc] initByReferencingURL:url];
                [img autorelease];
            }
        }
        
        if(img)
        {
            NSSize imgSize = [img size];
            NSGraphicsContext* context = [NSGraphicsContext graphicsContextWithGraphicsPort:mLoadingImageBmpContext flipped:NO];
            [NSGraphicsContext saveGraphicsState];
            [NSGraphicsContext setCurrentContext:context];
            
            mRotateDegree -= 10;
            if(mRotateDegree <= 0)
                mRotateDegree = 360;
            
            NSAffineTransform* transform = [NSAffineTransform transform];
            [transform translateXBy:DEFAULT_WIDTH/2 yBy:DEFAULT_HEIGHT/2];
            [transform rotateByDegrees:mRotateDegree];
            [transform set];
 
            [[NSColor whiteColor] set];
            NSRectFill(NSMakeRect(-DEFAULT_WIDTH, -DEFAULT_HEIGHT, DEFAULT_WIDTH*2, DEFAULT_HEIGHT*2));
            [img drawInRect:NSMakeRect(-imgSize.width/2, -imgSize.height/2, imgSize.width, imgSize.height)];
            [NSGraphicsContext restoreGraphicsState];
            
            CGImageRef loadingImage = CGBitmapContextCreateImage(mLoadingImageBmpContext);
            
            [mLock lock];
            if(m_cachedCGImage)
            {
                CGImageRelease(m_cachedCGImage);
                m_cachedCGImage = nil;
            }
            m_cachedCGImage = loadingImage;
            [mLock unlock];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self ProcessCachedCGImage];
            });
        }
                                       
        return;
    }

    int winNum = [mPreviewWindow windowNumber];
    void* winList = (void*)winNum;
	
	CGWindowImageOption option = kCGWindowImageNominalResolution | kCGWindowImageBoundsIgnoreFraming | kCGWindowImageShouldBeOpaque;
	if(mbEnableRetinaCapture)
		option = kCGWindowImageBoundsIgnoreFraming | kCGWindowImageShouldBeOpaque;
	
    CFArrayRef windowIDsArray = CFArrayCreate(kCFAllocatorDefault, (const void**)&winList, 1, NULL);
    CGImageRef captureImageRef = CGWindowListCreateImageFromArray(CGRectNull,windowIDsArray,option);
    CFRelease (windowIDsArray);
    
    if(captureImageRef == nil)
        return;
    
    int width = CGImageGetWidth(captureImageRef);
    int height = CGImageGetHeight(captureImageRef);
    
    NSView* contentView = [mPreviewWindow contentView];
    NSRect contentRect =  [contentView convertRect:[contentView bounds] toView:nil];
    NSSize winSize = [mPreviewWindow frame].size;
    
    float xScale = winSize.width/width;
    float yScale = winSize.height/height;
    
    CGRect srcRect = CGRectMake(contentRect.origin.x,winSize.height - contentRect.origin.y - contentRect.size.height,
                                contentRect.size.width,contentRect.size.height);
    
    srcRect.origin.x /= xScale;
    srcRect.origin.y /= yScale;
    srcRect.size.width/= xScale;
    srcRect.size.height /= yScale;
    
    CGImageRef subImage = CGImageCreateWithImageInRect(captureImageRef,srcRect);
    CGImageRelease(captureImageRef);
	
	if(!subImage)
		return;
	
	if(CGImageGetWidth(subImage) <= 1 || CGImageGetHeight(subImage) <= 1)
	{
		CGImageRelease(subImage);
		return;
	}
	
    [mLock lock];
    if(m_cachedCGImage)
    {
        CGImageRelease(m_cachedCGImage);
        m_cachedCGImage = nil;
    }
    m_cachedCGImage = subImage;
    [mLock unlock];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self ProcessCachedCGImage];
    });
    
}

- (void)OnCaptureTimer:(id)sender
{
	if(!mbRealRunning)
		return;
	
#if !QUICK_CAPTURE
	AVCaptureConnection *videoConnection = nil;
	NSArray* connections = [mStillImageOutput connections];
	videoConnection = [connections objectAtIndex:0];
	
	if(videoConnection)
	{
		[mStillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
			if(!error)
			{
				[self captureOutput:mStillImageOutput didOutputSampleBuffer:imageSampleBuffer fromConnection:videoConnection];
			}
		}];
	}
#endif
}

- (void)OnResolutionChanged:(int)width :(int)height
{
    if(mContentSize.width != width || mContentSize.height != height)
    {
        int scaledWidth = width/2;
        int scaledHeight = height/2;
        
        [self ChangePreviewSize:NSMakeSize(scaledWidth, scaledHeight)];
        mContentSize = NSMakeSize(width, height);
  
        [self updateMaskWindow];
    }

}
- (void)avCaptureInputPortFormatDescriptionDidChangeNotification:(NSNotification *)notification
{
    WARNINGTRACE("[APPSHARE] format change");
    
#if QUICK_CAPTURE
    AVCaptureInputPort* port = [notification object];
    if([port input] != mInput)
        return;

    if(mAbnormalDisconnectTimer)
    {
        [mAbnormalDisconnectTimer invalidate];
        mAbnormalDisconnectTimer = nil;
    }
    
    AVCaptureInputPort *usePort = port;
    if(!usePort)
        return;
    
    CMFormatDescriptionRef formatDescription = usePort.formatDescription;
    if (formatDescription) {
        CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription);
        if (dimensions.width > 0 && dimensions.height > 0 && dimensions.height < 4096)
        {
			WARNINGTRACE("[APPSHARE] format change," << dimensions.width << "," << dimensions.height);
			
			mbGotFormatChange = 1;
            [self ShowPreviewView];
            [self OnResolutionChanged:dimensions.width :dimensions.height];
			
			if(dimensions.width * dimensions.height < 1920*1200)
				[self setEnableRetinaCapture:TRUE];
			else
				[self setEnableRetinaCapture:FALSE];
        }
    }
#endif
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
	[mLock lock];
	if(m_cachedSampleBufferRef)
	{
		CFRelease(m_cachedSampleBufferRef);
		m_cachedSampleBufferRef = NULL;
	}
	CMSampleBufferCreateCopy(NULL, sampleBuffer, &m_cachedSampleBufferRef);
	[mLock unlock];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[self ProcessCachedImage];
	});
 }


- (void)ProcessCachedCGImage
{
    if(mbPaused || mTimerSource == nil)
    {
        [mLock lock];
        if(m_cachedCGImage)
        {
            CGImageRelease(m_cachedCGImage);
            m_cachedCGImage = nil;;
        }
        [mLock unlock];
        
        return;
    }
    
    [mLock lock];
    if(m_cachedCGImage == NULL)
    {
        [mLock unlock];
        return;
    }
    CGImageRef cachedImage = m_cachedCGImage;
    m_cachedCGImage = NULL;
    [mLock unlock];
    
    if(mbRealRunning)
    {
        if(![mInstructionView isHidden])
        {
            [mInstructionView showProgressView:NO];
            [mInstructionView setHidden:YES];
        }
        
        if([mPreviewView isHidden])
        {
            [mPreviewView setHidden:NO];
        }
    }
    
    if(mState != CaptureState_Connected)
        mState = CaptureState_Connected;
    
    if(mScreenShareCtrl)
        mScreenShareCtrl->OnNewImageArrive(cachedImage);

    if(cachedImage)
        CGImageRelease(cachedImage);
}

- (void)ProcessCachedImage
{
	if(!mbRunning || mbPaused)
		return;
	
	[mLock lock];
	
	if(m_cachedSampleBufferRef == NULL)
	{
		[mLock unlock];
		return;
	}
	
	CMSampleBufferRef cachedSampleBufferRef = m_cachedSampleBufferRef;
	m_cachedSampleBufferRef = NULL;
	
	[mLock unlock];
	
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(cachedSampleBufferRef);
	/*CVReturn ret = */CVPixelBufferLockBaseAddress(imageBuffer,0);        // Lock the image buffer
	
	uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);   // Get information of the image
	size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
	size_t width = CVPixelBufferGetWidth(imageBuffer);
	size_t height = CVPixelBufferGetHeight(imageBuffer);
	
	if(mImageSwapBufferSize < bytesPerRow*height)
	{
		if(mImageSwapBuffer)
		{
			delete[] mImageSwapBuffer;
			mImageSwapBuffer = NULL;
		}
		
		mImageSwapBufferSize = bytesPerRow*height;
		mImageSwapBuffer = new UInt8[mImageSwapBufferSize];
	}
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGDataProviderRef dp = CGDataProviderCreateWithData(nil, baseAddress, bytesPerRow*height, nil);
	CGImageRef srcImage = CGImageCreate(width, height, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaNoneSkipLast, dp, NULL, NO, kCGRenderingIntentDefault);
	
	CGContextRef newContext = nil;
	if(srcImage)
	{
		int scaledWidth = width/2;
		int scaledHeight = height/2;
		
		newContext = CGBitmapContextCreate(mImageSwapBuffer, scaledWidth, scaledHeight, 8, scaledWidth*4, colorSpace, kCGImageAlphaNoneSkipLast);
		CGContextSetInterpolationQuality(newContext, kCGInterpolationHigh);
		CGContextDrawImage(newContext, CGRectMake(0, 0, scaledWidth, scaledHeight), srcImage);
		CGContextFlush(newContext);
		
		for(int k = 0; k < scaledHeight; k++)
		{
			UInt8* startLine = mImageSwapBuffer + k*scaledWidth*4;
			for(int j =0; j < scaledWidth;j++)
			{
				UInt8 temp = *(startLine + 0);
				*(startLine + 0) = *(startLine + 2);
				*(startLine + 2) = temp;
				
				startLine += 4;
			}
		}
		
		CGImageRelease(srcImage);
	}
	
	CGDataProviderRelease(dp);
	CGColorSpaceRelease(colorSpace);
	
	if(ENABLE_LAYERPREVIEW)
	{
        if(![mInstructionView isHidden])
        {
            [mInstructionView setHidden:YES];
        }
        
		if([mPreviewView isHidden])
		{
			[mPreviewView setHidden:NO];
		}
	}
	
	if(mContentSize.width != width || mContentSize.height != height)
	{
		[self ChangePreviewSize:NSMakeSize(width/2, height/2)];
		mContentSize = NSMakeSize(width, height);
	}
	
    if(![mPreviewWindow isMiniaturized])
    {
        if(![mPreviewWindow isVisible] || mState != CaptureState_Connected)
        {
            [self centerPreviewWindow];
            //[mPreviewWindow orderFront:nil];
        }
    }
	
	if(mState != CaptureState_Connected)
		mState = CaptureState_Connected;
	
	CGImageRef scaledImageRef = NULL;
	if(newContext)
		scaledImageRef = CGBitmapContextCreateImage(newContext);
	
	if(scaledImageRef && !ENABLE_LAYERPREVIEW)
	{
		NSImage* nsimg = [[NSImage alloc] initWithCGImage:scaledImageRef size:NSZeroSize];
		[mInstructionView setImage:nsimg];
		[mInstructionView setNeedsDisplay:YES];
		[nsimg release];
	}
	
	if(mScreenShareCtrl && scaledImageRef)
		mScreenShareCtrl->OnNewImageArrive(scaledImageRef);
	
	if(scaledImageRef)
		CGImageRelease(scaledImageRef);
	if(newContext)
		CGContextRelease(newContext);
	
	CVPixelBufferUnlockBaseAddress(imageBuffer,0);
	
	CFRelease(cachedSampleBufferRef);
	
	[pool drain];
}

- (BOOL)SelectDevice
{
    if(mReselectTimer)
    {
        [mReselectTimer invalidate];
        mReselectTimer = nil;
    }
    
    if(mCurrentScreenCaptureDevice)
        return YES;
    
    WARNINGTRACE("[APPSHARE] SelectDevice");
    
	BOOL bDeviceConnected = FALSE;
	NSArray *devices = [AVCaptureDevice devices];
	for(int k = 0; k < [devices count]; k++)
	{
		id temp = [devices objectAtIndex:k];
		NSString* modelID = [temp modelID];
//		NSString* uniqueId = [temp uniqueID];

		BOOL bAbnomalDevice = FALSE;
		if([modelID isEqualToString:@"iOS Device"] && !bAbnomalDevice)
		{
			[self deviceConnected:temp];
			bDeviceConnected = TRUE;
			break;
		}
	}
	
    if(mCurrentScreenCaptureDevice == nil)
        [self ShowInstructionView];
    
	return bDeviceConnected;
}

- (void) deviceConnected:(AVCaptureDevice *)device
{
    NSString* modelID = [device modelID];
	
    if(![modelID isEqualToString:@"iOS Device"])
        return;
	
	WARNINGTRACE("[APPSHARE] deviceConnected " << (long)device);
	
	if(mCurrentScreenCaptureDevice)
		return;
	
	mState = CaptureState_Connecting;

	if(ENABLE_LAYERPREVIEW)
	{
		[mInstructionView setHidden:NO];
		[mPreviewView setHidden:YES];
	}
	
    if(![mPreviewWindow isVisible])
    {
        [self centerPreviewWindow];
        [mPreviewWindow orderFront:nil];
    }
    
    if(!mCurrentScreenCaptureDevice)
    {
        mCurrentScreenCaptureDevice = device;
        [self startCapture];
    }
}

- (void) deviceDisconnected:(AVCaptureDevice *)device
{
	WARNINGTRACE("[APPSHARE] deviceDisconnected " << (long)device);
	
    if(mCurrentScreenCaptureDevice == device)
    {
        [self stopCapture];
        mCurrentScreenCaptureDevice = nil;
		
		mState = CaptureState_NONE;
    }
	
    if(mCurrentScreenCaptureDevice == nil)
        [self SelectDevice];
}

- (void)abnormalDisconnectTimer:(NSTimer*)sender
{
	mAbnormalDisconnectTimer = nil;
	
	if(mbRunning && mbRealRunning && mCurrentScreenCaptureDevice)
	{
		WARNINGTRACE("[APPSHARE] abnormalDisconnectTimer detect device abnomal disconnect");

		[self stopCapture];
		mCurrentScreenCaptureDevice = nil;
        
        if(gbHalDeviceEnabled && mReselectTimer == nil)
        {
            mReselectTimer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(reselectTimer:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:mReselectTimer forMode:NSModalPanelRunLoopMode];
            [[NSRunLoop currentRunLoop] addTimer:mReselectTimer forMode: NSEventTrackingRunLoopMode];
        }
	}
}

- (void)OnCaptureSessionDidStart:(NSNotification*)sender
{
	WARNINGTRACE("[APPSHARE] OnCaptureSessionDidStart");
    if(mAbnormalDisconnectTimer)
    {
        [mAbnormalDisconnectTimer invalidate];
        mAbnormalDisconnectTimer = nil;
    }
    
    if(mCurrentScreenCaptureDevice == nil || !mbRunning)
        return;
    
    mbRealRunning = TRUE;
    
    [mInstructionView setRunning:YES];
    [self updateMaskWindow];

    /*if(!mbGotFormatChange)
	{
		mAbnormalDisconnectTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(abnormalDisconnectTimer:) userInfo:nil repeats:NO];
		[[NSRunLoop currentRunLoop] addTimer:mAbnormalDisconnectTimer forMode:NSModalPanelRunLoopMode];
		[[NSRunLoop currentRunLoop] addTimer:mAbnormalDisconnectTimer forMode: NSEventTrackingRunLoopMode];
	}*/
}

- (void)OnCaptureSessionDidStop:(NSNotification*)sender
{
	WARNINGTRACE("[APPSHARE] OnCaptureSessionDidStop");
    
    mbRealRunning = FALSE;
    [mInstructionView setRunning:NO];
    [self updateMaskWindow];
}


@end
