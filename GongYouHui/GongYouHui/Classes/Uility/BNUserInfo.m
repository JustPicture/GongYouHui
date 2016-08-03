//
//  BNUserInfo.m
//  crazyAlapama
//
//  Created by jpm on 14-7-24.
//  Copyright (c) 2014年 jpm. All rights reserved.
//

#import "BNUserInfo.h"

@implementation BNUserInfo
- (id)init
{
    if(self = [super init]){
        
        self.userName = @"";
        self.password = @"";
        self.email = @"";
        
    }
    return self;
}
@end
