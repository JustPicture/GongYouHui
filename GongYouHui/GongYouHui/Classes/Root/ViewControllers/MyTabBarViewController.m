//
//  MyTabBarViewController.m
//  GongYouHui
//
//  Created by wendf on 16/3/8.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import "MyTabBarViewController.h"
#import "ItemModel.h"
#import "UIViewController+TabBarItem.h"

@interface MyTabBarViewController ()

@property (nonatomic) NSArray *items;

@end

@implementation MyTabBarViewController

- (NSArray *)items{
    if (!_items) {
        _items = [ItemModel itemModelList];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createContentViewControllers];
}
- (void)createContentViewControllers{
    for (ItemModel *model in self.items) {
        UIViewController *viewController = [NSClassFromString(model.className) viewContrllerTitle:model.title normalImage:model.normalImage selectImageName:model.selectedImage];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
        [self addChildViewController:nav]; 
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
