//
//  AboutTableViewController.m
//  GongYouHui
//
//  Created by tianqiwang on 15/4/5.
//  Copyright (c) 2015年 tianqiwang. All rights reserved.
//

#import "AboutTableViewController.h"

@interface AboutTableViewController ()

@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";

    self.view.backgroundColor = RGBACOLOR(236, 236, 236, 1);
    [self creatUI];
}
- (void)creatUI{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KWIDTH/2-60, 50, 120, 120)];
    imageView.image = [UIImage imageNamed:@"默认"];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 20;
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.frame = CGRectMake(KWIDTH/2 - 40 , 170, 80, 40);
    nameLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"工友惠", @"BaseStrings", nil)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *versionLabel = [[UILabel alloc]init];
    versionLabel.frame = CGRectMake(KWIDTH/2 - 50, 215, 100, 50);
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.text = [NSString stringWithFormat:@"%@ 3.3.1",NSLocalizedStringFromTable(@"版本", @"BaseStrings", nil)];
    
    UIButton *BTN = [UIButton buttonWithType:UIButtonTypeCustom];

    BTN.frame = CGRectMake(0, 300, KWIDTH, 50);
    BTN.backgroundColor = [UIColor whiteColor];
    [BTN setTitle:@"联系我们  021-61636229" forState:UIControlStateNormal];
    [BTN setTitleColor:RGBACOLOR(130, 200, 230, 1) forState:UIControlStateNormal];
    [BTN addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:BTN];
    [self.view addSubview:imageView];
    [self.view addSubview:nameLabel];
    [self.view addSubview:versionLabel];
}
- (void)callPhone
{
    [self callPhone:@"021-61636229"];
}
- (void)callPhone:(NSString *)phoneNumber
{
    //phoneNumber = "18369......"
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
@end
