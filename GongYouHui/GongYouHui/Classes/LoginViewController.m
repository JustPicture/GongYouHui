//
//  LoginViewController.m
//  GongYouHui
//
//  Created by 陈伟荣 on 16/4/13.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import "LoginViewController.h"
#import "IsafeViewController.h"
#import "RegistViewController.h"
#import "RemberPasswordViewController.h"
#import "LoginResponseVo.h"
#import "AppDelegate.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    BOOL _isRemember;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"登录bg"]];
    self.bgimageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"登陆"]];    
    self.Login.backgroundColor = [UIColor colorWithIntegerRed:96 green:190 blue:241 alpha:0.95];

    self.bgimageView.layer.masksToBounds = YES;
    self.bgimageView.layer.cornerRadius = 6.0;
    self.bgimageView.backgroundColor = [UIColor colorWithIntegerRed:150 green:150 blue:150 alpha:0.2];
    
    //密码暗文
    [_password setSecureTextEntry:YES];
    _telephone.delegate = self;
    _password.delegate = self;
    _telephone.borderStyle = UITextBorderStyleNone;
    _password.borderStyle = UITextBorderStyleNone;
    self.Login.layer.masksToBounds = YES;
    self.Login.layer.cornerRadius = 5;
    self.telephoneview.layer.masksToBounds = YES;
    self.telephoneview.layer.cornerRadius = 5;
    self.passwordView.layer.masksToBounds = YES;
    self.passwordView.layer.cornerRadius = 5;
}

- (IBAction)loginin:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *url = [NSString stringWithFormat:@"%@/api/account/login/%@/%@",REST_SERVICE_URL,_telephone.text,_password.text];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
     
        NSError *error;
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"login JSON: %@", resp);
        LoginResponseVo *vo = [[LoginResponseVo alloc] initWithDic:resp];
        //记住用户名密码
        [[NSUserDefaults standardUserDefaults] setObject:_telephone.text forKey:UserName];
        [[NSUserDefaults standardUserDefaults] setObject:_password.text forKey:Password];
        
        if (vo.isSuccess) {
            //成功
            [[NSUserDefaults standardUserDefaults] setBool:_isRemember forKey:Is_Remember_Password];
            //跳转
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate startApp];
        }else{
            //失败
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(vo.msg, @"BaseStrings", nil)  message:nil delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"确认", @"BaseStrings", nil) otherButtonTitles:nil];
            [alert show];
        }
        //[self.HUD hide:YES afterDelay:0.3];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSString *msg = NSLocalizedStringFromTable(@"登录失败,请重试!", @"BaseStrings", nil);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedStringFromTable(@"确认", @"BaseStrings", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
       // [self.HUD hide:YES afterDelay:0.3];
    }];
}

//忘记密码
- (IBAction)rememberpassword:(id)sender {
    RemberPasswordViewController *rememberpassword = [[RemberPasswordViewController alloc]init];
    [self presentViewController:rememberpassword animated:YES completion:nil];
}
//注册
- (IBAction)regist:(id)sender {
    RegistViewController *regist = [[RegistViewController alloc]init];
    [self presentViewController:regist animated:YES completion:nil];
}
//是否记住密码
- (IBAction)remberBtn:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.isSelected) {
        button.selected = NO;
        //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:Is_Remember_Password];
    }else{
        button.selected = YES;
        //        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:Is_Remember_Password];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}
/*  x
 键盘收回事件，UITextField协议方法
 
 **/
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [textField resignFirstResponder];
    return NO;
    
}

@end
