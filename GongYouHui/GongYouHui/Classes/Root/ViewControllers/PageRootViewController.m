//
//  PageRootViewController1.m
//  GongYouHui
//
//  Created by 陈伟荣 on 16/4/14.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import "PageRootViewController.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
@interface PageRootViewController ()

@end

@implementation PageRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    self.scrollerView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, GYHScreenWidth, GYHScreenHeight)];
    [self.view addSubview:self.scrollerView];
    self.pageView=[[UIPageControl alloc]initWithFrame:CGRectMake(0, GYHScreenHeight-100, GYHScreenWidth, 37)];
    [self.view addSubview:self.pageView];
    self.scrollerView.delegate=self;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.scrollerView.bounces=YES;
    self.scrollerView.pagingEnabled=YES;
    self.scrollerView.scrollEnabled=YES;
    self.scrollerView.showsHorizontalScrollIndicator=NO;
    self.scrollerView.showsVerticalScrollIndicator=YES;
    self.scrollerView.contentSize=CGSizeMake(4*GYHScreenWidth, GYHScreenHeight);
    
    self.loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitle:@"登入" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithRed:0.44 green:0.35 blue:0.61 alpha:1] forState:UIControlStateNormal];
    self.loginButton.frame=CGRectMake((GYHScreenWidth-300)/3, GYHScreenHeight-60, 150, 40);
    self.loginButton.backgroundColor=[UIColor colorWithRed:0.59 green:0.76 blue:0.8 alpha:1];
    [self.loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 5;
    [self.view addSubview:self.loginButton];
    self.registButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.registButton.frame=CGRectMake(2*(GYHScreenWidth-300)/3 + 150, GYHScreenHeight-60, 150, 40);
    [self.registButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registButton setTitleColor:[UIColor colorWithRed:0.59 green:0.76 blue:0.8 alpha:1] forState:UIControlStateNormal];
    [self.registButton addTarget:self action:@selector(registButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.registButton.backgroundColor=[UIColor colorWithRed:0.44 green:0.35 blue:0.61 alpha:1];
    self.registButton.layer.masksToBounds = YES;
    self.registButton.layer.cornerRadius = 5;
    
    [self.view addSubview:self.registButton];
    NSArray *imageArr=@[@"page1",@"page2",@"page3",@"page4",@"page5",@"page6"];
    for ( int i=0; i<imageArr.count ;i++){
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*GYHScreenWidth, 0, GYHScreenWidth, GYHScreenHeight)];
        
        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArr[i]]];
        [self.scrollerView addSubview:imageView];
    }
    self.scrollerView.contentSize=CGSizeMake(imageArr.count*GYHScreenWidth, GYHScreenHeight);
    self.pageView.numberOfPages=imageArr.count;
    self.pageView.currentPage=0;
}
-(void)loginButtonClick{
    
    LoginViewController *login=[[LoginViewController alloc]init];
    [self presentViewController:login animated:YES completion:nil];
//    [self.navigationController pushViewController:login animated:YES];
    
    
    
}

-(void)registButtonClick{
    
    RegistViewController *regist=[[RegistViewController alloc]init];
    [self presentViewController:regist animated:YES completion:nil];
//    [self.navigationController pushViewController:regist animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int index=scrollView.contentOffset.x/GYHScreenWidth;
    self.pageView.currentPage=index;
    
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
