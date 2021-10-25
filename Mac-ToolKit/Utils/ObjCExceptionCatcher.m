//
//  ObjCExceptionCatcher.m
//  SparkMacDesktop
//
//  Created by James Nestor on 09/05/2016.
//  Copyright © 2016 Cisco Systems. All rights reserved.
//

#import "ObjCExceptionCatcher.h"

@implementation ObjCExceptionCatcher

+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error {
    @try {
        tryBlock();
        return YES;
    }
    @catch (NSException *exception) {
        *error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:exception.userInfo];
    }
}

@end
