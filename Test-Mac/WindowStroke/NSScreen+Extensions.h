//
//  NSScreen+Extensions.h
//  SparkMacDesktop
//
//  Created by jimmcoyn on 03/11/2015.
//  Copyright © 2015 Cisco Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Cocoa/Cocoa.h>

@interface NSScreen (Extensions)

-(nullable NSString*) displayName;
-(nullable NSNumber*) displayID;
-(nullable NSString*) uuid;
-(NSRect) getFlippedCoordinateFrame;

@end
