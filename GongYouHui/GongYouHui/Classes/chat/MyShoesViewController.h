//
//  MyShoesViewController.h
//  GongYouHui
//
//  Created by 陈伟荣 on 15/12/31.
//  Copyright © 2015年 tianqiwang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreBluetooth/CoreBluetooth.h>

#import <JumaBluetoothSDK/JumaBluetoothSDK.h>

@interface MyShoesViewController : UIViewController<JumaDeviceDelegate,JumaManagerDelegate>

@property (strong, nonatomic) UILabel *myHeight;
//视图的背景图片
@property (strong, nonatomic) UIView *bgImage;
@property (strong, nonatomic) UILabel *myWidthKg;
//BMI 的值 体质指数
@property (strong, nonatomic) UILabel *myBMI;
@property (strong, nonatomic) UILabel *rowContentLabel;
@property (strong, nonatomic) UILabel *stepNumLabel;
@property (strong, nonatomic) UILabel *caloricValueLabel;
@property(nonatomic,assign)int precent;
@end
