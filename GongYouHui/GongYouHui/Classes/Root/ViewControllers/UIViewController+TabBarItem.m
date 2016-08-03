//
//  UIViewController+TabBarItem.m
//  GongYouHui
//
//  Created by wendf on 16/3/8.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import "UIViewController+TabBarItem.h"

@implementation UIViewController (TabBarItem)

+ (instancetype)viewContrllerTitle:(NSString*)title normalImage:(NSString*)normalImageName selectImageName:(NSString*)selectImageName
{
    //在类的方法中通过[self class]得到调用该法的类型
    UIViewController * viewContrller = [[[self class] alloc]init];
    
    //生成tabBarItem
    UIImage *selectImage = [UIImage imageNamed:selectImageName];
    selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:normalImageName] selectedImage:selectImage];
    
    //设置tabBar上文字的颜色
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#007aff"]} forState:UIControlStateSelected];
    
    //设置tabBarItem
    viewContrller.tabBarItem = tabBarItem;
    
    return viewContrller;
}
@end
