//
//  BSContainer.m
//  crazyAlapama
//
//  Created by jpm on 14-7-24.
//  Copyright (c) 2014年 jpm. All rights reserved.
//

#import "BNContainer.h"
#import "BNCommon.h"

@implementation BNContainer

- (id)init
{
    if(self = [super init]){
        _userInfo = [[UserInfo alloc] init];
    }
    return self;
}

+ (BNContainer *)instance{
    static BNContainer *instance;
    @synchronized(self) {
        if (!instance) {
            instance = [[BNContainer alloc] init];
        }
    }
    return instance;
}

- (NSString *)findUniqueSavePath:(NSString *)name{
    
    NSString *path = [NSString stringWithFormat:@"%@/Documents/iphone_IMAGE_%@.PNG", NSHomeDirectory(), name];
    return path;
}
@end
