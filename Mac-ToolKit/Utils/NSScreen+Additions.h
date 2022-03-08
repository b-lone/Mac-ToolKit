#import <AppKit/NSScreen.h>
#import <AppKit/AppKitDefines.h>

@interface NSScreen ()

@property (readwrite) NSEdgeInsets safeAreaInsets API_AVAILABLE(macos(12.0));

@end
