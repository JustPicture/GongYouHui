//
//  NSDictionary+(BNDictionary).m
//  CarPoolForIOS
//
//  Created by tianqiwang on 15/1/24.
//  Copyright (c) 2015年 tianqiwang. All rights reserved.
//

#import "NSDictionary+BNDictionary.h"

@implementation NSDictionary (BNDictionary)
- (NSString *)strNotNullObjectForKey:(NSString *)key{
    NSString *str = [self objectForKey:key];
    if (str == nil || [str isKindOfClass:[NSNull class]]) {
        return @"";
    }else{
        return str;
    }
}
@end
