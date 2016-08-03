//
//  FirstAidViewController.m
//  GongYouHui
//
//  Created by wendf on 16/3/8.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import "FirstAidViewController.h"
#import "FirstAidDetailViewController.h"
#import "PerMessageViewController.h"
@interface FirstAidViewController ()<UITextFieldDelegate>
{
    NSDictionary *dic;
    UIImageView *historyImageView;
}
@property (nonatomic,strong)UIView      *headerBgView;
@property (nonatomic,strong)UIView      *NFCBgView;
@property (nonatomic,strong)UIButton    *headerButton;
@property (nonatomic,strong)UITextField *NFCTextField;
@property (nonatomic,strong)UIButton    *searchButton;
@end

@implementation FirstAidViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    self.navigationItem.title = @"急救查询";
    [super viewDidLoad];
    dic = [NSDictionary dictionary];
    self.view.backgroundColor = [UIColor colorWithIntegerRed:236 green:236 blue:236 alpha:1];
    [self loadData];
}

- (void)creatUI{
    _headerBgView = [[UIView alloc]init];
    _headerBgView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
    _headerBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"急救查询-背景"]];
    
    _headerButton = [[UIButton alloc]init];
    _headerButton.frame = CGRectMake(self.view.bounds.size.width/2-50, 60, 100, 100);
    _headerButton.layer.masksToBounds = YES;
    _headerButton.layer.cornerRadius = 50;
    [_headerButton addTarget:self action:@selector(personMessage) forControlEvents:UIControlEventTouchUpInside];
    NSURL *imageUrl = [NSURL URLWithString:dic[@"headUrl"]];
    historyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    historyImageView.layer.cornerRadius = 10;
    historyImageView.layer.masksToBounds = YES;
    historyImageView.userInteractionEnabled = YES;
    [historyImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"默认"]];
    [_headerButton addSubview:historyImageView];
    [_headerBgView addSubview:_headerButton];
    
    UILabel *usernameLabel = [[UILabel alloc]init];
    usernameLabel.frame = CGRectMake(0, 160, self.view.bounds.size.width, 40);
    usernameLabel.text = [dic objectForKey:@"name"];
    usernameLabel.textColor =[UIColor whiteColor];
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *headLabel = [[UILabel alloc]init];
    headLabel.frame = CGRectMake(0, 10, self.view.bounds.size.width, 40);
    headLabel.text = @"工友惠";
    headLabel.textColor =[UIColor whiteColor];
    headLabel.textAlignment = NSTextAlignmentCenter;
    
    _NFCBgView = [[UIView alloc]init];
    _NFCBgView.frame = CGRectMake(0, 220, self.view.bounds.size.width, 100);
    
    _NFCTextField = [[UITextField alloc]init];
    _NFCTextField.frame = CGRectMake(10, 20, self.view.bounds.size.width - 20, 50);
    _NFCTextField.placeholder = @"请输入唯一编码进行查询";
    _NFCTextField.textAlignment = NSTextAlignmentCenter;
    _NFCTextField.backgroundColor = [UIColor whiteColor];
    _NFCTextField.delegate = self;
    _NFCTextField.layer.masksToBounds = YES;
    _NFCTextField.layer.cornerRadius = 5;
    
    _searchButton = [[UIButton alloc]init];
    _searchButton.frame = CGRectMake(20, 340, self.view.bounds.size.width -40, 40);
    [_searchButton setTitle:@"查询" forState:UIControlStateNormal];
    _searchButton.backgroundColor = [UIColor colorWithHexString:@"#39beee"];
    [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _searchButton.layer.masksToBounds = YES;
    _searchButton.layer.cornerRadius = 5;
    [_searchButton addTarget:self action:@selector(searchbtn) forControlEvents:UIControlEventTouchUpInside];
    
    [_headerBgView addSubview:headLabel];
    [_headerBgView addSubview:usernameLabel];
    [_NFCBgView addSubview:_NFCTextField];
    [self.view addSubview:_NFCBgView];
    [self.view addSubview:_searchButton];
    [self.view addSubview:_headerBgView];
}
- (void)personMessage{
    PerMessageViewController *personmessage = [[PerMessageViewController alloc]init];
    [self.navigationController pushViewController:personmessage animated:YES];
}


/*
 键盘收回事件，UITextField协议方法
 
 **/
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [textField resignFirstResponder];
    return NO;
    
}
- (void)searchbtn{
    if (self.NFCTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"请输入查询码", @"BaseStrings", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"确认", @"BaseStrings", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSString *mystring = self.NFCTextField.text;
    NSString *regex = @"(^[A-Za-z0-9]*$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:mystring])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"查询码必须是字母或数字", @"BaseStrings", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"确认", @"BaseStrings", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    
  
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@/api/firstAid/%@/%@",REST_SERVICE_URL,dic[@"userId"],self.NFCTextField.text];
    NSLog(@"%@",url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
         NSLog(@"JSON: %@", resp);
        NSDictionary *dic1 = [NSDictionary dictionary];
        dic1 = resp[@"data"];
        if ([[resp objectForKey:@"code"] integerValue] == 200) {
            FirstAidDetailViewController * firstAid = [[FirstAidDetailViewController alloc]init];
            firstAid.tabBarController.tabBar.hidden=YES;
            firstAid.dataDict = dic1;
            firstAid.datastr = dic1[@"id"];
            NSLog(@"%@",firstAid.dataDict);
            [self.navigationController pushViewController:firstAid animated:YES];
        }else{
            NSString *msg = [[NSString alloc]init];
            if ([[resp objectForKey:@"code"] integerValue] == 519) {
                msg = @"权限不足";
            }
            if ([[resp objectForKey:@"code"] integerValue] == 520) {
                msg = @"查询人或被查询人不存在";
            }
            if ([[resp objectForKey:@"code"] integerValue] == 522) {
                msg = @"用户不属于任何部门（公司）";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"查询失败", @"BaseStrings", nil) message:msg delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"确认", @"BaseStrings", nil) otherButtonTitles:nil];
                    [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSString *msg = NSLocalizedStringFromTable(@"查询失败,请重试!", @"BaseStrings",nil);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedStringFromTable(@"确认", @"BaseStrings", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}
- (void)loadData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //记住用户名密码
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:UserName];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:Password];
    NSString *url = [NSString stringWithFormat:@"%@/api/account/login/%@/%@",REST_SERVICE_URL,name,password];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        dic = resp[@"data"];
        [[NSUserDefaults standardUserDefaults] setObject:dic[@"userId"] forKey:UserID];
        [self creatUI];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

@end
