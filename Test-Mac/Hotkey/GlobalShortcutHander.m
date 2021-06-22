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
//#import "SparkLogger.h"

@implementation GlobalShortcutHander


- (void)registerAnswerCallHotKey:(NSObject*)target  selectorName:(NSString*)selectorName
{
//    [self registerSelector:selectorName ofTarget:target forKeyCode:kVK_ANSI_L  andModifiersFlags:(NSEventModifierFlagControl|NSEventModifierFlagCommand)];
    [self registerSelector:selectorName ofTarget:target forKeyCode:kVK_ANSI_Z  andModifiersFlags:(NSEventModifierFlagShift|NSEventModifierFlagControl)];
}

- (void)unregisterAnswerCallHotKey
{
    DDHotKeyCenter *c = [DDHotKeyCenter sharedHotKeyCenter];
    [c unregisterHotKeyWithKeyCode:kVK_ANSI_L modifierFlags:(NSEventModifierFlagControl|NSEventModifierFlagCommand)];
}

- (void)registerDumpServiceCatalogueHotKey:(NSObject*)target  selectorName:(NSString*)selectorName
{
    
    [self registerSelector:selectorName ofTarget:target forKeyCode:kVK_ANSI_S  andModifiersFlags:(NSEventModifierFlagControl|NSEventModifierFlagShift)];
}

- (void)unregisterDumpServiceCatalogueHotKey
{
    DDHotKeyCenter *c = [DDHotKeyCenter sharedHotKeyCenter];
    [c unregisterHotKeyWithKeyCode:kVK_ANSI_S modifierFlags:(NSEventModifierFlagControl|NSEventModifierFlagShift)];
}

- (void)registerCaptureBorderHotKey:(NSObject*)target  selectorName:(NSString*)selectorName
{
    [self registerSelector:selectorName ofTarget:target forKeyCode:kVK_ANSI_K  andModifiersFlags:(NSEventModifierFlagControl|NSEventModifierFlagCommand)];
}

- (void)unregisterCaptureBorderHotKey
{
    DDHotKeyCenter *c = [DDHotKeyCenter sharedHotKeyCenter];
    [c unregisterHotKeyWithKeyCode:kVK_ANSI_K modifierFlags:(NSEventModifierFlagControl|NSEventModifierFlagCommand)];
}


-(void) registerSelector:(NSString*)selectorName ofTarget:(NSObject*)target forKeyCode:(unsigned short)keyCode andModifiersFlags:(NSUInteger)flags
{
    
    SEL sel = NSSelectorFromString(selectorName);
   	DDHotKeyCenter *c = [DDHotKeyCenter sharedHotKeyCenter];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if (![c registerHotKeyWithKeyCode:keyCode modifierFlags:flags target:target action:sel object:nil])
    {
        NSLog(@"failed");
    } else {
        NSLog(@"succeed");
    }
#pragma clang diagnostic pop#pragma clang diagnostic pop
}

@end
