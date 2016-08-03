//
//  RemberPasswordViewController.m
//  GongYouHui

//  Created by 陈伟荣 on 16/4/13.
//  Copyright © 2016年 GYH. All rights reserved.

#import "RemberPasswordViewController.h"
#import "RegistViewController.h"
#import "AuthCodeResponseVo.h"
#import "LoginResponseVo.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
@interface RemberPasswordViewController ()<UITextFieldDelegate>
{
    int time;
    NSTimer *timer;
}
@end

@implementation RemberPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatUI];
}
- (void)creatUI{
    UIView *NavView = [[UIView alloc]init];
    NavView.frame = CGRectMake(0, 0, GYHScreenWidth, 64);
    NavView.backgroundColor = [UIColor colorWithHexString:@"#39beee"];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 10, 50, 50);
    [leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [NavView addSubview:leftBtn];
    
    self.doneBtn.layer.masksToBounds = YES;
    self.doneBtn.layer.cornerRadius = 5;
    
    self.yanZhengMaBtn.layer.masksToBounds = YES;
    self.yanZhengMaBtn.layer.cornerRadius = 5;
    
    _yanZhengMaTextfield.delegate = self;
    _TelTextfield.delegate = self;
    _passwordTextfield.delegate = self;
    
    //密码暗文
    [_passwordTextfield setSecureTextEntry:YES];
    
    [self.view addSubview:NavView];
}
- (void)leftBtnClick{
    RegistViewController *Regist = [[RegistViewController alloc]init];
    [self presentViewController:Regist animated:YES completion:nil];
}

//点击发送验证码
- (IBAction)getYanZhengMa:(id)sender {
    
    if ([self.TelTextfield.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:NSLocalizedStringFromTable(@"请输入手机号码", @"BaseStrings", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedStringFromTable(@"确认", @"BaseStrings", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        [self.TelTextfield becomeFirstResponder];
        return;
    }
    
    time = 60;
    [self.yanZhengMaBtn setEnabled:NO];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setButtonTime) userInfo:nil repeats:YES];
//    self.HUD.labelText = @"";
//    [self.HUD show:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/account/register/code/%@",REST_SERVICE_URL,self.TelTextfield.text];
    NSLog(@"%@",url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        //   NSLog(@"JSON: %@", resp);
        AuthCodeResponseVo *vo = [[AuthCodeResponseVo alloc] initWithDic:resp];
        
        if (vo.isSuccess) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"提示", @"BaseStrings", nil) message:NSLocalizedStringFromTable(vo.msg, @"BaseStrings", nil) preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                
            }];
            
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            
            //成功
        }else{
            //失败
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:vo.msg
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedStringFromTable(@"确认", @"BaseStrings", nil)
                                                  otherButtonTitles:nil];
            [alert show];
            time = 0;
            [self setButtonTime];
        }
        
        //[self.HUD hide:YES afterDelay:0.3];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"Error: %@", error);
        NSString *msg = NSLocalizedStringFromTable(@"获取验证码失败,请重试!", @"BaseStrings", nil);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedStringFromTable(@"确认", @"BaseStrings", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        //[self.HUD hide:YES afterDelay:0.3];
        time = 0;
        [self setButtonTime];
    }];
}
- (void)setButtonTime{
    
    if (time == 0) {
        [self.yanZhengMaBtn setEnabled:YES];
        if ([timer isValid]) {
            [timer invalidate];
        }
        [self.yanZhengMaBtn setTitle:NSLocalizedStringFromTable(@"重新获取", @"BaseStrings", nil) forState:UIControlStateNormal];
        [self.yanZhengMaBtn setTitle:NSLocalizedStringFromTable(@"重新获取", @"BaseStrings", nil) forState:UIControlStateDisabled];
    }else{
        [self.yanZhengMaBtn setEnabled:NO];
        [self.yanZhengMaBtn setTitle:[NSString stringWithFormat:@"%d %@",time,@"s"] forState:UIControlStateNormal];
        [self.yanZhengMaBtn setTitle:[NSString stringWithFormat:@"%d %@",time,@"s"] forState:UIControlStateDisabled];
    }
    time --;
    
}

- (IBAction)confirmBtn:(id)sender {
    if (!([self checkTextfield:self.TelTextfield] && [self checkTextfield:self.yanZhengMaTextfield]&&[self checkTextfield:self.passwordTextfield])) {
        return;
    }
    //self.HUD.labelText = NSLocalizedStringFromTable(@"注册中", @"BaseStrings", nil);
    //[self.HUD show:YES];
    
    NSMutableArray *  datasouceArray = [NSMutableArray arrayWithObjects:@"姓名 ",@"性别 ",@"血型 ",@"年龄 ",@"过敏药物 ",@"疾病史 ",@"紧急联系人 ",@"紧急联系人电话 ",@"紧急联系人关系 ", nil];
   
    NSString * sex = [[NSUserDefaults standardUserDefaults]objectForKey:NSLocalizedStringFromTable(@"性别 ", @"BaseStrings", nil)];
    NSString * newSex ;
    if ([sex isEqualToString:@"Male"]||[sex isEqualToString:@"男"]) {
        newSex = @"1";
    }else{
        newSex = @"0";
    }
    NSString * age = [[NSUserDefaults standardUserDefaults]objectForKey:NSLocalizedStringFromTable(datasouceArray[3], @"BaseStrings", nil)];
    NSString * newage ;
    if (age.length > 0) {
        newage = age;
    }else{
        newage = @"0";
    }
    
    NSDictionary * parametes = [NSDictionary dictionaryWithObjectsAndKeys:
                                NSLocalizedStringFromTable([[NSUserDefaults standardUserDefaults]objectForKey:NSLocalizedStringFromTable(datasouceArray[0], @"BaseStrings", nil)], @"BaseStrings", nil)
                                ,@"name",
                                newSex,@"sex",
                                newage,@"age",
                                NSLocalizedStringFromTable([[NSUserDefaults standardUserDefaults]objectForKey:NSLocalizedStringFromTable(datasouceArray[2], @"BaseStrings", nil)], @"BaseStrings", nil)
                                ,@"bloodType",
                                NSLocalizedStringFromTable([[NSUserDefaults standardUserDefaults]objectForKey:NSLocalizedStringFromTable(datasouceArray[4], @"BaseStrings", nil)], @"BaseStrings", nil)
                                ,@"allergyDrug",
                                NSLocalizedStringFromTable([[NSUserDefaults standardUserDefaults]objectForKey:NSLocalizedStringFromTable(datasouceArray[5], @"BaseStrings", nil)], @"BaseStrings", nil)
                                ,@"medicalHistory",
                                NSLocalizedStringFromTable([[NSUserDefaults standardUserDefaults]objectForKey:NSLocalizedStringFromTable(datasouceArray[6], @"BaseStrings", nil)], @"BaseStrings", nil)
                                ,@"emergencyContactName",
                                NSLocalizedStringFromTable([[NSUserDefaults standardUserDefaults]objectForKey:NSLocalizedStringFromTable(datasouceArray[7], @"BaseStrings", nil)], @"BaseStrings", nil)
                                ,@"emergencyContactMobilePhone",
                                NSLocalizedStringFromTable([[NSUserDefaults standardUserDefaults]objectForKey:NSLocalizedStringFromTable(datasouceArray[8], @"BaseStrings", nil)], @"BaseStrings", nil)
                                ,@"emergencyContactRelation",
                                self.TelTextfield.text,@"mobilePhone",
                                self.passwordTextfield.text,@"password",
                                self.yanZhengMaTextfield.text,@"code", nil];
    
    // NSLog(@"parametes = %@",parametes);
    //注册发送数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@/api/account/v2/register",REST_SERVICE_URL];
    NSLog(@"%@",url);
    [manager POST:url parameters:parametes success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString * string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        //  NSLog(@"string = %@",string);
        NSError *error;
        NSDictionary * resp = [NSJSONSerialization JSONObjectWithData:responseObject  options:NSJSONReadingMutableLeaves error:&error];
        //   NSLog(@"register JSON: %@", resp);
        LoginResponseVo *vo = [[LoginResponseVo alloc] initWithDic:resp];
        NSLog(@"error = %@",error);
        
        if (vo.isSuccess) {
            for (int i = 0; i< datasouceArray.count; i++) {
                [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:NSLocalizedStringFromTable(datasouceArray[i], @"BaseStrings", nil)];
            }
            //成功
            //进入主界面
            LoginViewController *loginMain = [[LoginViewController alloc]init];
            [self presentViewController:loginMain animated:YES completion:nil];
        }else{
            //失败
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:vo.msg message:nil delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"确认", @"BaseStrings", nil) otherButtonTitles:nil];
            [alert show];
            
        }
        //[self.HUD hide:YES afterDelay:0.3];
        //进入主界面
        LoginViewController *loginMain = [[LoginViewController alloc]init];
        [self presentViewController:loginMain animated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        NSString *msg = NSLocalizedStringFromTable(@"注册失败,请重试!", @"BaseStrings", nil);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedStringFromTable(@"确认", @"BaseStrings", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        //[self.HUD hide:YES afterDelay:0.3];
    }];
    

    
}
- (BOOL)checkTextfield:(UITextField *)textfield{
    
    if ([textfield.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:textfield.placeholder
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedStringFromTable(@"确认", @"BaseStrings", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        [textfield becomeFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 
 键盘收回事件，UITextField协议方法
 
 **/
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
    
}@end
