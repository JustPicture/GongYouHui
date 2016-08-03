//
//  MessageVo.h
//  KingWeatherForIOS
//
//  Created by tianqiwang on 15/1/14.
//  Copyright (c) 2015年 tianqiwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *headUrl;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *username;//
@property (strong, nonatomic) NSString *companyCode;//
@property (strong, nonatomic) NSString *chatToken;//融云聊天的token
@property (strong, nonatomic) NSString *hatUseDate;//安全帽启用日期
@property (strong, nonatomic) NSString *hatEndDate;//安全帽过期日期
@property (strong, nonatomic) NSString *companyId; //公司id
@property (strong, nonatomic) NSString *companyName; //公司id
@property (nonatomic, strong) NSString * departmentId;//部门id
@property (nonatomic, strong) NSString * departmentName;//部门名字

@property (nonatomic,strong)NSString * nickName;

@property (nonatomic,strong)NSString * accidentRecord;
@property (nonatomic,strong)NSString * accredited;

@property (nonatomic,strong)NSString * allergyDrug;
@property (nonatomic,strong)NSString * bloodType;
@property (nonatomic,strong)NSString * breakTheRulesRecord;

@property (nonatomic,strong)NSString * emergencyContactMobilePhone;
@property (nonatomic,strong)NSString * emergencyContactName;
@property (nonatomic,strong)NSString * emergencyContactRelation;
@property (nonatomic,strong)NSString * loginName;
@property (nonatomic,strong)NSString * medicalHistory;
@property (nonatomic,strong)NSString * parentDealerId;
@property (nonatomic,strong)NSString * receiveHelmet;
@property (nonatomic,strong)NSString * uniqueCode;
@property (nonatomic,strong)NSNumber * isConfirm;

@property (nonatomic,strong)NSNumber * hatNum;
@property (nonatomic,strong)NSNumber * hatTip;
@property (nonatomic,strong)NSNumber * clothesNum;
@property (nonatomic,strong)NSNumber * clothesTip;
@property (nonatomic,strong)NSNumber * shoesNum;
@property (nonatomic,strong)NSNumber * shoesTip;

@property (nonatomic,strong)NSNumber * role;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
