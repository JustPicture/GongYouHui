//
//  NewsModel.m
//  GongYouHui
//
//  Created by 陈伟荣 on 16/4/10.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

+(NSMutableArray *)parsePesponsData:(NSDictionary *)respondata{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *data = respondata[@"data"];
    for (NSDictionary *dic in data) {
        NewsModel *model = [[NewsModel alloc]init];
        model.Id = dic[@"id"];
        model.newsIntro = dic[@"newIntro"];
        model.newsTime = dic[@"newsTime"];
        model.imageUrl = dic[@"imgUrl"];
        [array addObject:model];
    }
    return array;
}
- (NSMutableArray *)newsArray{
    if (!_newsArray) {
        _newsArray = [[NSMutableArray alloc] init];
    }
    return _newsArray;
}

- (id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSInteger ret = [[dic objectForKey:@"code"] integerValue];
        if (ret == 200) {
            self.isSuccess = YES;
            NSArray *newsArray = [dic objectForKey:@"data"];
            for (NSDictionary *newsDic  in newsArray) {
                NewsModel *model = [[NewsModel alloc]init];
                model.Id = newsDic[@"id"];
                model.newsIntro = newsDic[@"newIntro"];
                model.newsTime = newsDic[@"newsTime"];
                model.imageUrl = newsDic[@"imgUrl"];
                model.newsTitle = newsDic[@"newsTitle"];
                [self.newsArray addObject:model];
            }
            self.msg = @"加载成功";
        }else{
            self.isSuccess = NO;
            self.msg = [NSString stringWithFormat:@"%ld",(long)ret];
        }
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

