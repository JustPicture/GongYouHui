//
//  DetailViewController.m
//  GongYouHui
//
//  Created by 陈伟荣 on 16/7/18.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(100, 100, 200, 50);
    label.backgroundColor = [UIColor purpleColor];
    label.text = @"你点击了Btn";
    [self.view addSubview:label];
    // Do any additional setup after loading the view.
}
@end
