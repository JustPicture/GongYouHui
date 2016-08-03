//
//  AuthCodeResponseVo.m
//  GongYouHui
//
//  Created by 陈伟荣 on 16/4/15.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import "AuthCodeResponseVo.h"
#import "NSDictionary+BNDictionary.h"


@implementation AuthCodeResponseVo
- (id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        // Initialization code here.
        NSInteger ret = [[dic objectForKey:@"code"] integerValue];
        if (ret == 200) {
            
            self.isSuccess = YES;
            NSDictionary *userInfoDic = [dic objectForKey:@"data"];
            self.verificationCode = [userInfoDic strNotNullObjectForKey:@"verificationCode"];
            self.msg = @"验证码已发送";
            
        }else{
            
            self.isSuccess = NO;
            self.msg = [NSString stringWithFormat:@"%ld",(long)ret];
            
        }
        
    }
    return self;
}

@end
