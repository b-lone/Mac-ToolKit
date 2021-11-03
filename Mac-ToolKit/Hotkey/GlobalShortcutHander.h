//
//  GlobalShortCutHander.h
//  SparkMacDesktop
//
//  Created by jimmcoyn on 11/04/2016.
//  Copyright © 2016 Cisco Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSEvent;

@protocol GlobalShortcutHanderProtocol <NSObject>

- (void)registerAnswerCallHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void)unregisterAnswerCallHotKey;

- (void)registerDumpServiceCatalogueHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void)unregisterDumpServiceCatalogueHotKey;

- (void)registerMakeLocalShareControlBarKeyWindowHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void)unregisterMakeLocalShareControlBarKeyWindowHotKey;

- (void)registerOpenShareSelectionWindowHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void)unregisterOpenShareSelectionWindowHotKey;

- (void)registerStopShareHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void)unregisterStopShareHotKey;

- (void)registerrPauseOrResumeShareHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void)unregisterPauseOrResumeShareHotKey;

- (void)registerrStartRDCHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void)unregisterStartRDCHotKey;

- (void)registerrStopRDCHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void)unregisterStopRDCHotKey;

@end


@interface GlobalShortcutHander : NSObject<GlobalShortcutHanderProtocol>


- (void)registerAnswerCallHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void)unregisterAnswerCallHotKey;

- (void)registerDumpServiceCatalogueHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void)unregisterDumpServiceCatalogueHotKey;

- (void)registerMakeLocalShareControlBarKeyWindowHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void)unregisterMakeLocalShareControlBarKeyWindowHotKey;

- (void)registerOpenShareSelectionWindowHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void)unregisterOpenShareSelectionWindowHotKey;

- (void)registerStopShareHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void)unregisterStopShareHotKey;

- (void)registerrPauseOrResumeShareHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void)unregisterPauseOrResumeShareHotKey;

- (void)registerrStartRDCHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void)unregisterStartRDCHotKey;

- (void)registerrStopRDCHotKey:(NSObject*)target  selectorName:(NSString*)selectorName;
- (void)unregisterStopRDCHotKey;

@end
