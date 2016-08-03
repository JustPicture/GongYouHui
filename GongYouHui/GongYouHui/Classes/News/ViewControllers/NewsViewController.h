//
//  NewsViewController.h
//  GongYouHui
//
//  Created by wendf on 16/3/8.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController

//是否刷新
@property (nonatomic,assign) BOOL isRefreshing;
@property (nonatomic,assign) BOOL isLoadMore;



//刷新视图
- (void)createRefreshView ;
//结束刷新
- (void)endRefreshing;

@end
