//
//  MyWebViewController.m
//  GongYouHui
//
//  Created by 陈伟荣 on 16/4/11.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import "MyWebViewController.h"
#define NAV_COLOR @"#515151"
@interface MyWebViewController ()<UIWebViewDelegate>

@end

@implementation MyWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createWebView];
}
- (void)createWebView
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, GYHScreenWidth, GYHScreenHeight-64)];
    webView.delegate = self;
    [webView loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    webView.scalesPageToFit=YES;
    [self.view addSubview:webView];
}
- (void)createNav
{
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title =  self.mTitle;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:22],NSForegroundColorAttributeName:[UIColor colorWithHexString:NAV_COLOR]}];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn addTarget:self action:@selector(leftBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"xi_fan_up.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"xi_fan_dow.png"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
-(void)leftBarButtonItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
