//
//  PageRootViewController1.h
//  GongYouHui
//
//  Created by 陈伟荣 on 16/4/14.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import "RootViewController.h"

@interface PageRootViewController : RootViewController<UIScrollViewDelegate>
@property (nonatomic, strong)  UIScrollView *scrollerView;
@property (nonatomic, strong)  UIPageControl *pageView;
@property (nonatomic, strong)  UIButton *loginButton;
@property (nonatomic, strong)  UIButton *registButton;


@end
