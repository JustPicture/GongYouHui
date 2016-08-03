//
//  AuthCodeResponseVo.h
//  GongYouHui
//
//  Created by 陈伟荣 on 16/4/15.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthCodeResponseVo : NSObject

@property (nonatomic) BOOL isSuccess;
@property (nonatomic,strong) NSString *msg;

@property (nonatomic,strong) NSString *verificationCode;


- (id)initWithDic:(NSDictionary *)dic;

@end
