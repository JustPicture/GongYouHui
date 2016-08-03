//
//  UIViewController+TabBarItem.h
//  GongYouHui
//
//  Created by wendf on 16/3/8.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TabBarItem)

//定义一个方法，生成viewControleller
//生成UITabBarItem ，对各个项进行赋值
//返回生成的viewController
+ (instancetype)viewContrllerTitle:(NSString*)title normalImage:(NSString*)normalImageName selectImageName:(NSString*)selectImageName;

@end
