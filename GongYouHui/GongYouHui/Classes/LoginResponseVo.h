//
//  LoginResponseVo.h
//  GongYouHui
//
//  Created by tianqiwang on 15/4/4.
//  Copyright (c) 2015年 tianqiwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface LoginResponseVo : NSObject

@property (nonatomic) BOOL isSuccess;
@property (nonatomic,strong) NSString *msg;

//@property (nonatomic, strong) UserInfo *userInfo;

- (id)initWithDic:(NSDictionary *)dic;
@end
