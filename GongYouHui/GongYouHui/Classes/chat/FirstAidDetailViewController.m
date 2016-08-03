////
////  FirstAidDetailViewController.m
////  GongYouHui
////
////  Created by tianqiwang on 15/4/5.
////  Copyright (c) 2015年 tianqiwang. All rights reserved.
////
//
#import "FirstAidDetailViewController.h"
#import "PerMessageViewController.h"
@interface FirstAidDetailViewController ()

@property (nonatomic,strong)UIView      *headerBgView;
@property (nonatomic,strong)UIView      *NFCBgView;
@property (nonatomic,strong)UIButton    *headerButton;
@property (nonatomic,strong)UITextField *NFCTextField;
@property (nonatomic,strong)UIButton    *searchButton;

@end
@implementation FirstAidDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"急救查询";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI1];
}

- (void)createUI1{
    _headerBgView = [[UIView alloc]init];
    _headerBgView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
    _headerBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"急救查询-背景"]];
    
    _headerButton = [[UIButton alloc]init];
    _headerButton.frame = CGRectMake(self.view.bounds.size.width/2-50, 60, 100, 100);
    _headerButton.layer.masksToBounds = YES;
    _headerButton.layer.cornerRadius = 50;
    NSURL *imageUrl = [NSURL URLWithString:_dataDict[@"headUrl"]];
   UIImageView  *historyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    historyImageView.layer.cornerRadius = 10;
    historyImageView.layer.masksToBounds = YES;
    historyImageView.userInteractionEnabled = YES;
    [historyImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"默认"]];
    [_headerButton addSubview:historyImageView];
    [_headerBgView addSubview:_headerButton];
    
    UILabel *usernameLabel = [[UILabel alloc]init];
    usernameLabel.frame = CGRectMake(0, 160, self.view.bounds.size.width, 40);
    usernameLabel.text = _dataDict[@"name"];
    usernameLabel.textColor =[UIColor whiteColor];
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *headLabel = [[UILabel alloc]init];
    headLabel.frame = CGRectMake(0, 10, self.view.bounds.size.width, 40);
    headLabel.text = @"工友惠";
    headLabel.textColor =[UIColor whiteColor];
    headLabel.textAlignment = NSTextAlignmentCenter;
    NSArray *ary1 = @[@"电话 :",@"血型 :",@"部门主管 :",@"主管电话 :"];
    NSArray *ary2 = @[_dataDict[@"mobilePhone"],_dataDict[@"bloodType"],_dataDict[@"directlyLeaderName"],_dataDict[@"directlyLeaderPhone"]];
    for (int i = 0; i < 4; i ++) {
        UILabel *lbl1 = [[UILabel alloc]init];
        lbl1.frame = CGRectMake(20, 220 + 60*i,100 ,30 );
        lbl1.text = ary1[i];
        [self.view addSubview:lbl1];
        
        UILabel *lbl = [[UILabel alloc]init];
        lbl.frame = CGRectMake(0, 265 + 60*i,KWIDTH ,1 );
        lbl.backgroundColor = RGBACOLOR(226, 226, 226, 1);
        [self.view addSubview:lbl];
        
        UILabel *lbl2 = [[UILabel alloc]init];
        lbl2.frame = CGRectMake(140, 220 + 60*i,200 ,30 );
        lbl2.text = ary2[i];
        [self.view addSubview:lbl2];
    }
    
    _searchButton = [[UIButton alloc]init];
    _searchButton.frame = CGRectMake(20, 470, self.view.bounds.size.width -40, 50);
    [_searchButton setTitle:@"查看详情" forState:UIControlStateNormal];
    _searchButton.backgroundColor = RGBACOLOR(230, 140, 130, 1);
    [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _searchButton.layer.masksToBounds = YES;
    _searchButton.layer.cornerRadius = 5;
    [_searchButton addTarget:self action:@selector(searchbtn) forControlEvents:UIControlEventTouchUpInside];
    
    [_headerBgView addSubview:headLabel];
    [_headerBgView addSubview:usernameLabel];
    [self.view addSubview:_searchButton];
    [self.view addSubview:_headerBgView];
}
- (void)searchbtn{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:UserID];
    NSString *url = [NSString stringWithFormat:@"%@/api/firstAid/details/%@/%@",REST_SERVICE_URL,userid,self.datastr];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSError *error;
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
       // NSLog(@"JSON: %@", resp);
        NSInteger ret = [[resp objectForKey:@"code"] integerValue];
        if (ret == 200) {
            NSDictionary *dict = resp[@"data"];
            NSLog(@"%@",dict);
            //成功  跳转到下一个界面
            PerMessageViewController *personMessage = [[PerMessageViewController alloc]init];
            self.tabBarController.tabBar.hidden=YES;
            personMessage.datasouceAry = dict;
            personMessage.title =  NSLocalizedStringFromTable(@"个人信息详情", @"BaseStrings", nil);
            [self.navigationController pushViewController:personMessage animated:YES];
        }else if(ret == 519){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"权限不足", @"BaseStrings", nil) message:[resp objectForKey:@"message"] delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"确定", @"BaseStrings", nil) otherButtonTitles:nil];
            [alert show];
        }
        else{
            //失败
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"查询失败", @"BaseStrings", nil) message:[resp objectForKey:@"message"] delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"确定", @"BaseStrings", nil) otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSString *msg = NSLocalizedStringFromTable(@"查询失败,请重试!", @"BaseStrings", nil);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedStringFromTable(@"确定", @"BaseStrings", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}
//
//- (void)callPhone:(NSString *)phoneNumber
//{
//    //phoneNumber = "18369......"
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
//    UIWebView * callWebview = [[UIWebView alloc] init];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//    [self.view addSubview:callWebview];
//}

@end

