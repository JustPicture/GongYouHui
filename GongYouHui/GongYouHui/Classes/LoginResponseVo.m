//
//  LoginResponseVo.m
//  GongYouHui
//
//  Created by tianqiwang on 15/4/4.
//  Copyright (c) 2015年 tianqiwang. All rights reserved.
//

#import "LoginResponseVo.h"
#import "NSDictionary+BNDictionary.h"

@implementation LoginResponseVo
- (id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        
        // Initialization code here.
        
        NSInteger ret = [[dic objectForKey:@"code"] integerValue];
        if (ret == 200) {
            self.isSuccess = YES;
            
            NSDictionary *userInfoDic = [dic objectForKey:@"data"];
            
            UserInfo *userInfo = [[UserInfo alloc] init];
            userInfo.age = [userInfoDic strNotNullObjectForKey:@"age"];
            userInfo.userId = [NSString stringWithFormat:@"%@",[userInfoDic strNotNullObjectForKey:@"userId"]];
            userInfo.sex = [userInfoDic strNotNullObjectForKey:@"sex"];
            
            NSString *headUrl = [userInfoDic strNotNullObjectForKey:@"headUrl"];
            userInfo.headUrl = headUrl;
            userInfo.phone = [userInfoDic strNotNullObjectForKey:@"phone"];
            userInfo.username = [userInfoDic strNotNullObjectForKey:@"username"];
            userInfo.companyCode = [userInfoDic strNotNullObjectForKey:@"companyCode"];
            userInfo.chatToken = [userInfoDic strNotNullObjectForKey:@"token"];
            userInfo.hatUseDate = [userInfoDic strNotNullObjectForKey:@"hatUseDate"];
            userInfo.hatEndDate = [userInfoDic strNotNullObjectForKey:@"hatEndDate"];
            userInfo.companyId = [userInfoDic strNotNullObjectForKey:@"companyId"];
            userInfo.nickName = [userInfoDic strNotNullObjectForKey:@"name"];
            userInfo.isConfirm = [userInfoDic objectForKey:@"isConfirm"];
            userInfo.companyName = [userInfoDic strNotNullObjectForKey:@"companyName"];

            
            userInfo.hatNum = [userInfoDic objectForKey:@"hatNum"];
            userInfo.hatTip =[userInfoDic objectForKey:@"hatTip"];
            
            userInfo.clothesNum = [userInfoDic objectForKey:@"clothesNum"];
            userInfo.clothesTip =[userInfoDic objectForKey:@"clothesTip"];
            
            userInfo.shoesNum = [userInfoDic objectForKey:@"shoesNum"];
            userInfo.shoesTip =[userInfoDic objectForKey:@"shoesTip"];
            
            userInfo.departmentId = [NSString stringWithFormat:@"%@",[userInfoDic strNotNullObjectForKey:@"departmentId"]];
            userInfo.departmentName = [userInfoDic strNotNullObjectForKey:@"departmentName"];
            
            userInfo.role = [userInfoDic objectForKey:@"role"];
            
            [BNContainer instance].userInfo = userInfo;
            
        }else {
            
            self.isSuccess = NO;
            self.msg = [NSString stringWithFormat:@"%ld",(long)ret];

        }

    }
    return self;
}

@end
