//
//  BSContainer.h
//  crazyAlapama
//
//  Created by jpm on 14-7-24.
//  Copyright (c) 2014年 jpm. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserInfo.h"


@interface BNContainer : NSObject

@property (nonatomic, strong) UserInfo *userInfo;

+ (BNContainer *)instance;
- (NSString *)findUniqueSavePath:(NSString *)name;

@end
