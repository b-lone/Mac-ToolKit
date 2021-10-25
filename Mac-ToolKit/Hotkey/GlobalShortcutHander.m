//
//  GlobalShortCutHander.m
//  SparkMacDesktop
//
//  Created by jimmcoyn on 11/04/2016.
//  Copyright © 2016 Cisco Systems. All rights reserved.
//

#import "GlobalShortcutHander.h"
#import "DDHotKeyCenter.h"
#import <Carbon/Carbon.h>

@implementation GlobalShortcutHander


- (void)registerAnswerCallHotKey:(NSObject*)target  selectorName:(NSString*)selectorName
{
    [self registerSelector:selectorName ofTarget:target forKeyCode:kVK_ANSI_C  andModifiersFlags:(NSEventModifierFlagControl|NSEventModifierFlagShift)];
}

- (void)unregisterAnswerCallHotKey
{
    [self unregisterHotKeyWithKeyCode:kVK_ANSI_K modifierFlags:(NSEventModifierFlagCommand)];
}

- (void)registerDumpServiceCatalogueHotKey:(NSObject*)target  selectorName:(NSString*)selectorName
{
    
    [self registerSelector:selectorName ofTarget:target forKeyCode:kVK_ANSI_S  andModifiersFlags:(NSEventModifierFlagControl|NSEventModifierFlagShift)];
}

- (void)unregisterDumpServiceCatalogueHotKey
{
    [self unregisterHotKeyWithKeyCode:kVK_ANSI_S modifierFlags:(NSEventModifierFlagControl|NSEventModifierFlagShift)];
}

- (void)registerMakeLocalShareControlBarKeyWindowHotKey:(NSObject*)target  selectorName:(NSString*)selectorName
{
    [self registerSelector:selectorName ofTarget:target forKeyCode:kVK_ANSI_K  andModifiersFlags:(NSEventModifierFlagControl|NSEventModifierFlagCommand)];
}

- (void)unregisterMakeLocalShareControlBarKeyWindowHotKey
{
    [self unregisterHotKeyWithKeyCode:kVK_ANSI_K modifierFlags:(NSEventModifierFlagControl|NSEventModifierFlagCommand)];
}

- (void)registerOpenShareSelectionWindowHotKey:(NSObject*)target  selectorName:(NSString*)selectorName
{
    [self registerSelector:selectorName ofTarget:target forKeyCode:kVK_ANSI_D  andModifiersFlags:(NSEventModifierFlagControl|NSEventModifierFlagShift)];
}

- (void)unregisterOpenShareSelectionWindowHotKey
{
    [self unregisterHotKeyWithKeyCode:kVK_ANSI_D modifierFlags:(NSEventModifierFlagControl|NSEventModifierFlagShift)];
}

- (void)registerStopShareHotKey:(NSObject*)target  selectorName:(NSString*)selectorName
{
    [self registerSelector:selectorName ofTarget:target forKeyCode:kVK_ANSI_Z  andModifiersFlags:(NSEventModifierFlagControl|NSEventModifierFlagShift)];
}

- (void)unregisterStopShareHotKey
{
    [self unregisterHotKeyWithKeyCode:kVK_ANSI_Z modifierFlags:(NSEventModifierFlagControl|NSEventModifierFlagShift)];
}

- (void)registerrPauseOrResumeShareHotKey:(NSObject*)target  selectorName:(NSString*)selectorName
{
    [self registerSelector:selectorName ofTarget:target forKeyCode:kVK_ANSI_S  andModifiersFlags:(NSEventModifierFlagControl|NSEventModifierFlagShift)];
}

- (void)unregisterPauseOrResumeShareHotKey
{
    [self unregisterHotKeyWithKeyCode:kVK_ANSI_S modifierFlags:(NSEventModifierFlagControl|NSEventModifierFlagShift)];
}

- (void)registerrStartRDCHotKey:(NSObject*)target  selectorName:(NSString*)selectorName
{
    [self registerSelector:selectorName ofTarget:target forKeyCode:kVK_ANSI_R  andModifiersFlags:(NSEventModifierFlagCommand|NSEventModifierFlagOption)];
}
- (void)unregisterStartRDCHotKey
{
    [self unregisterHotKeyWithKeyCode:kVK_ANSI_R modifierFlags:(NSEventModifierFlagCommand|NSEventModifierFlagOption)];
}

- (void)registerrStopRDCHotKey:(NSObject*)target  selectorName:(NSString*)selectorName
{
    [self registerSelector:selectorName ofTarget:target forKeyCode:kVK_ANSI_V  andModifiersFlags:(NSEventModifierFlagCommand|NSEventModifierFlagOption)];
}

- (void)unregisterStopRDCHotKey
{
    [self unregisterHotKeyWithKeyCode:kVK_ANSI_V modifierFlags:(NSEventModifierFlagCommand|NSEventModifierFlagOption)];
}


-(void) registerSelector:(NSString*)selectorName ofTarget:(NSObject*)target forKeyCode:(unsigned short)keyCode andModifiersFlags:(NSUInteger)flags
{
    SEL sel = NSSelectorFromString(selectorName);
       DDHotKeyCenter *c = [DDHotKeyCenter sharedHotKeyCenter];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    bool result = true;
    if (![c registerHotKeyWithKeyCode:keyCode modifierFlags:flags target:target action:sel object:nil])
    {
        result = false;
    }
#pragma clang diagnostic pop#pragma clang diagnostic pop
    
//    SPARK_LOG_DEBUG(" [register] selector:" << selectorName << " keyCode:" << keyCode << " modifierFlags:" << flags << " result:" << result);
}

-(void) unregisterHotKeyWithKeyCode:(unsigned short)keyCode modifierFlags:(NSUInteger)flags
{
//    SPARK_LOG_DEBUG(" [unregister] keyCode:" << keyCode << " modifierFlags:" << flags);
    DDHotKeyCenter *c = [DDHotKeyCenter sharedHotKeyCenter];
    [c unregisterHotKeyWithKeyCode:keyCode modifierFlags:flags];
}

@end
