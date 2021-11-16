#import <AppKit/NSScreen.h>
#import <AppKit/AppKitDefines.h>

@interface NSScreen ()

@property (readonly) NSEdgeInsets safeAreaInsets API_AVAILABLE(macos(12.0));

@end
