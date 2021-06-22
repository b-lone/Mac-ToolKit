//
//  TestWindow.m
//  Test-Mac
//
//  Created by Archie You on 2021/3/10.
//  Copyright © 2021 Cisco. All rights reserved.
//

#import "TestWindow.h"
#include <vector>
#include <string.h>
#include <algorithm>
#include <functional>

@implementation TestWindow

-(void)test {
    self.level = 5;
    
    std::vector<int> test1;
    test1.push_back(1);
    
    test1.erase(std::remove(test1.begin(), test1.end(), 2), test1.end());
    NSLog(@"%d", test1.size());
}

@end
