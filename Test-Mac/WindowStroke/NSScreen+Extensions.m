//
//  NSScreen+Extensions.m
//  SparkMacDesktop
//
//  Created by jimmcoyn on 03/11/2015.
//  Copyright © 2015 Cisco Systems. All rights reserved.
//

#import "NSScreen+Extensions.h"

@implementation NSScreen (Extensions)

//
-(NSString*) displayName
{
  NSString *screenName = nil;
    
    int displayId =  [[self displayID] intValue];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSDictionary *deviceInfo = (NSDictionary *)CFBridgingRelease(IODisplayCreateInfoDictionary(CGDisplayIOServicePort(displayId), kIODisplayOnlyPreferredName));
#pragma clang diagnostic pop
    NSDictionary *localizedNames = [deviceInfo objectForKey:[NSString stringWithUTF8String:kDisplayProductName]];
    
    if ([localizedNames count] > 0) {
        //TODO get localized name
        screenName = [localizedNames objectForKey:[[localizedNames allKeys] objectAtIndex:0]];
    }
    return screenName;
}

-(NSNumber*) displayID
{
    return [[self deviceDescription] valueForKey:@"NSScreenNumber"];
}

-(NSString*) uuid
{
    CGDirectDisplayID displayID = [self displayID].unsignedIntValue;
    CFUUIDRef cfUuid = CGDisplayCreateUUIDFromDisplayID(displayID);
    if (cfUuid == nil) {
        return nil;
    }
    CFStringRef cfUuidStr = CFUUIDCreateString(NULL, cfUuid);
    NSString *uuidStr = (__bridge NSString *)cfUuidStr;
    CFRelease(cfUuid);
    CFRelease(cfUuidStr);
    return uuidStr;
}

-(NSRect) getFlippedCoordinateFrame
{
    if (NSScreen.screens != nil && NSScreen.screens.count > 0)
    {
        NSScreen* mainScreen = NSScreen.screens[0];
        
        if(self != mainScreen)
        {
            NSRect flippedFrame = [self frame];
            flippedFrame.origin.y = NSMaxY(mainScreen.frame) - NSMaxY(flippedFrame);
            
            return flippedFrame;
        }
    }
    
    return [self frame];
}

-(NSString * _Nonnull) frameInfo
{
    return [[NSString alloc] initWithFormat:@"{screen: %@, frame: %@}", [self displayName], NSStringFromRect(self.frame)];
}

@end
