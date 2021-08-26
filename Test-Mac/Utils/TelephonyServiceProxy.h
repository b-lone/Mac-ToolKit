//
//  TelephonyServiceProxy.h
//  Test-Mac
//
//  Created by Archie You on 2021/8/26.
//  Copyright © 2021 Cisco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHSourceType.h"

NS_ASSUME_NONNULL_BEGIN
@class ShareSourceVM;
typedef void (^ShareSourcesCallback)(NSMutableArray<ShareSourceVM*>* shareSources);
@interface TelephonyServiceProxy : NSObject
-(void) getShareSources:(CHSourceType) shareType callback:(ShareSourcesCallback) callback;
@end

NS_ASSUME_NONNULL_END
