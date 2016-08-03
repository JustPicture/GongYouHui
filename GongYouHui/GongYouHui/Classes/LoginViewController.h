//
//  LoginViewController.h
//  GongYouHui
//
//  Created by 陈伟荣 on 16/4/13.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"

@interface LoginViewController : RootViewController
@property (strong, nonatomic) IBOutlet UITextField *telephone;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *Login;
@property (strong, nonatomic) IBOutlet UIButton *RememberPassword;
@property (strong, nonatomic) IBOutlet UIView *telephoneview;
@property (strong, nonatomic) IBOutlet UIView *passwordView;
@property (strong, nonatomic) IBOutlet UIView *bgimageView;
@property (strong, nonatomic) IBOutlet UIButton *remrmberbtn;

@end
