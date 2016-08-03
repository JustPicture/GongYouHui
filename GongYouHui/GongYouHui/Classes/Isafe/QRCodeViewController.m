//
//  QRCodeViewController.m
//  GongYouHui
//
//  Created by 陈伟荣 on 15/9/24.
//  Copyright (c) 2015年 tianqiwang. All rights reserved.
//

#import "QRCodeViewController.h"

@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadQRCodeImageView];
    // Do any additional setup after loading the view.
}

- (void)loadQRCodeImageView{
    
    UIImageView * qrCodeimageView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 6 , 100, [UIScreen mainScreen].bounds.size.width * 2 /3 , [UIScreen mainScreen].bounds.size.width * 2 /3 )];
    qrCodeimageView.image = [UIImage imageNamed:@"QRcode.png"];
    [self.view addSubview:qrCodeimageView];
    
    UIImageView * qrCodeTextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 30 + CGRectGetMaxY(qrCodeimageView.frame), [UIScreen mainScreen].bounds.size.width  , 70)];
    qrCodeTextImageView.image = [UIImage imageNamed:@"QRcodeText.png"];
    [self.view addSubview:qrCodeTextImageView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tabBarController.tabBar setHidden:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
