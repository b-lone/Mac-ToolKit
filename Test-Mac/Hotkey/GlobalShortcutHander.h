//
//  GlobalShortCutHander.h
//  SparkMacDesktop
//
//  Created by jimmcoyn on 11/04/2016.
//  Copyright © 2016 Cisco Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSEvent;


@interface GlobalShortcutHander : NSObject


- (void)registerAnswerCallHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void) unregisterAnswerCallHotKey;

- (void)registerDumpServiceCatalogueHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void) unregisterDumpServiceCatalogueHotKey;

- (void)registerCaptureBorderHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void) unregisterCaptureBorderHotKey;

@end
