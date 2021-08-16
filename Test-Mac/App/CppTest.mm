//
//  CppTest.m
//  Test-Mac
//
//  Created by Archie You on 2021/7/15.
//  Copyright © 2021 Cisco. All rights reserved.
//

#import "CppTest.h"
#import <vector>
class A {
    
};

@implementation CppTest

+ (void)startTest {
    std::vector<A> av = { A() };
    auto result = std::make_shared<std::vector<A>>(av.begin(), av.end());
}

@end
