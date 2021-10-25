//
//  ObjCExceptionCatcher.h
//  SparkMacDesktop
//
//  Created by James Nestor on 09/05/2016.
//  Copyright © 2016 Cisco Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjCExceptionCatcher : NSObject
+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;
@end
