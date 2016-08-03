//
//  GYHHeader.h
//  GongYouHui
//
//  Created by 陈伟荣 on 16/4/12.
//  Copyright © 2016年 GYH. All rights reserved.
//

#ifndef GYHHeader_h
#define GYHHeader_h

//rest服务器地址

//#define REST_SERVICE_URL @"http://121.40.69.128:8080"//老的ip地址
//#define REST_SERVICE_URL @"http://120.24.174.61:8081"
//#define REST_SERVICE_URL @"http://192.168.1.127:8081"
//#define REST_SERVICE_URL @"http://192.168.1.100:8080/mobile"
#define REST_SERVICE_URL @"http://www.iclouduv.com:8080"
//测试
//#define REST_SERVICE_URL @"http://192.168.1.127:8080"

#define IOS_VERSION_8_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)? (YES):(NO))
#define IOS_VERSION_7_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)? (YES):(NO))
#define IOS_VERSION_6_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)? (YES):(NO))

//颜色

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define APP_BG_COLOR [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue &0xFF00) >>8))/255.0 blue:((float)(rgbValue &0xFF))/255.0 alpha:1.0]


//程序调试颜色
#if 1

#define APP_DEBUG_COLOR [UIColor colorWithRed:arc4random() %256 / 255.0 green:arc4random() %256/255.0 blue:arc4random()%256 /255.0 alpha:1.0]

#else

#endif

#define APP_BASE_COLOR [UIColor colorWithRed:11 / 255.0 green:179/255.0 blue:239 /255.0 alpha:1.0]

#define APP_green_COLOR [UIColor colorWithRed:44 / 255.0 green:248/255.0 blue:arc4random()%152 /255.0 alpha:1.0]

#define RGBCOLORV(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]


#define RGBCOLORVA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif



#define  Is_Remember_Password  @"Is_Remember_Password"

#define UserName    @"UserName"
#define Password    @"Passwrod"
#define UserID    @"userId"

#define nUpdateHeaderImage @"updateHeaderImage"
#define nUpdateDeviceHeaderImage @"updateDeviceHeaderImage"


#define HZProgressBarHeight  2.5
#define HZProgresstagId  222122323


#define LIST_PERPAGE 20

#define KNotificationCreateGroupSuccessful @"CreateGroupSuccessful"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kNotificationFirendsListDict @"FirendsListDictNotifitication"

#define kNotificationAddFirendToChatList @"AddFirendToChatListNotification"
#define kNotificationDeleteFirendFromChatList @"DeleteFirendFromChatListNotification"

#define kNotificationOnlyMyInspection @"OnlyMyInspection"
#define kNotificationAllInspection @"AllInspection"

#define kNotificationAddPanGestrue @"AddPanGestrue"
#define kNotificationRemovePanGestrue @"RemovePanGestrue"

#define kNewUnloadChatMessageNotification @"NewUnloadChatMessageNotification"
#define kTaskNewMessageNotification @"TaskNewMessageNotification"


//枚举isafe界面的传入类型

typedef enum DeviceType {
    
    hats = 0 ,
    clothes,
    shoes,
    
}DeviceType;

#define DefaultBluetoothDeviceUUID  @"defaultBluetoothDeviceUUID"
#define KTaskListSetSwitchOn @"TaskListSetSwitchOn"

#define KSortLastUpDate @"按回复时间排序"
#define KSortTaskOrderTime @"按创建时间排序"

#define kShowNormalTypeTask @"显示常规任务"
#define KShowCycleTypeTask @"显示周期任务"

#define kShowNormalStatusTask @"显示可执行任务"
#define KShowOverStatusTask @"显示已结束任务"

#define KSortTimeAscendingOrder @"按时间升序排序"
#define KSortTimeDescendingOrder @"按时间降序排序"



//公告
#define GYHNOTICEURL @"/api/news/%@/%ld/%ld"
//新闻
#define GYHNewListURL @"/api/news/%ld/%ld"
#define NEWLISTNUM 15
//注册
#define GYHREGIST @"/api/account/register/code/%@"
#define KWIDTH self.view.bounds.size.width
#define KHEIGHT self.view.bounds.size.height

#endif /* GYHHeader_h */
