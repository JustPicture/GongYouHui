//
//  AppDelegate.h
//  GongYouHui
//
//  Created by wendf on 16/3/8.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTabBarViewController.h"
#import "LeftSlideViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) LeftSlideViewController *LeftSlideVC;
@property (nonatomic,strong) MyTabBarViewController *tabBarViewController;

//进入主界面
-(void)startApp;
@end

