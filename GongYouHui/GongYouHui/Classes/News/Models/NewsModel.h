//
//  NewsModel.h
//  GongYouHui
//
//  Created by 陈伟荣 on 16/4/10.
//  Copyright © 2016年 GYH. All rights reserved.

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
@property (nonatomic,copy)NSString *Id;
@property (nonatomic,copy)NSString *newsIntro;
@property (nonatomic,copy)NSString *newsTitle;
@property (nonatomic,copy)NSString *newsTime;
@property (nonatomic,copy)NSString *imageUrl;
@property (nonatomic) BOOL isSuccess;
@property (nonatomic,strong) NSString *msg;
@property (nonatomic,strong) NSMutableArray *newsArray;

- (id)initWithDic:(NSDictionary *)dic;

+(NSMutableArray*)parsePesponsData:(NSDictionary*)respondata;


@end
