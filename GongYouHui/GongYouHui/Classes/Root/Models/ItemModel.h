//
//  ItemModel.h
//  GongYouHui
//
//  Created by wendf on 16/3/8.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *className;
@property (nonatomic,copy) NSString *normalImage;
@property (nonatomic,copy) NSString *selectedImage;

- (id)initWithDic:(NSDictionary *)dic;

+ (instancetype)itemModelWithDic:(NSDictionary *)dic;

+ (NSArray *)itemModelList;

@end
