//
//  PersonCenterViewController.m
//  GongYouHui
//
//  Created by wendf on 16/3/8.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "MyViewController.h"
#import "LoginViewController.h"
#import "AboutTableViewController.h"
@interface PersonCenterViewController ()<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) NSArray *array;

@end

@implementation PersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatTableView];
    _array = @[@"icon_feedback",@"icon_confirm",@"icon_about_us",@"icon_modify_password",@"icon_quit"];
//    UIView *view = [[UIView alloc]init];
//    view.frame = CGRectMake(0, 0, 375,self.view.bounds.size.height/4);
////    self.tableView.tableHeaderView = view;
//    view.backgroundColor = [UIColor whiteColor];
//    [self.tableView.tableHeaderView addSubview:view];
    self.tableView.tableHeaderView.backgroundColor = [UIColor redColor];
}
- (void)creatTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -33, self.view.frame.size.width, self.view.frame.size.height+33) style:UITableViewStyleGrouped];
    _dataSource = @[@"修改个人密码",@"确认个人详细信息",@"联系我们",@"关于我们",@"退出登录"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    UIImage *bgImage = [UIImage imageNamed:@"登录bg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
}
// UITableView的Delegate和DataSource代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.view.bounds.size.height/4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    cell.textLabel.text = _dataSource[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:_array[indexPath.row]];
    
    //cell的背景色
    cell.backgroundColor = [UIColor clearColor];
    //去掉分割线
    tableView.separatorStyle = NO;
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        AboutTableViewController * aboutUs = [[AboutTableViewController alloc]init];
        [self presentViewController:aboutUs animated:YES completion:nil];
    }
    if (indexPath.row == 4) {
        LoginViewController * login = [[LoginViewController alloc]init];
        [self presentViewController:login animated:YES completion:nil];
    }
}


@end
