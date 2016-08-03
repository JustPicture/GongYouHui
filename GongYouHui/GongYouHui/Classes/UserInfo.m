//
//  MessageVo.m
//  KingWeatherForIOS
//
//  Created by tianqiwang on 15/1/14.
//  Copyright (c) 2015年 tianqiwang. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"name"]) {
        self.nickName = value;
    }
    
    if ([key isEqualToString:@"token"]) {
        self.chatToken = value;
    }
    
    if ([key isEqualToString:@"sex"]) {
        self.sex = value?@"男":@"女";
    }
    
    if ([key isEqualToString: @"id"]) {
        self.userId = [NSString stringWithFormat:@"%@",value];
    }
    
    
}


@end
