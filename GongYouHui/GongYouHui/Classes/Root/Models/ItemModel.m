//
//  ItemModel.m
//  GongYouHui
//
//  Created by wendf on 16/3/8.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

- (id)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)itemModelWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}

+ (NSArray *)itemModelList {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GYHItems" ofType:@"plist"];
    NSArray *items = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *newList = [NSMutableArray array];
    for (NSDictionary *dic in items) {
        ItemModel *itemModel = [ItemModel itemModelWithDic:dic];
        [newList addObject:itemModel];
    }
    return newList;
    
}

@end
