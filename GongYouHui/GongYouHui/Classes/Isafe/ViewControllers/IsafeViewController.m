//
//  IsafeViewController.m
//  GongYouHui
//
//  Created by wendf on 16/3/8.
//  Copyright © 2016年 GYH. All rights reserved.
//
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>



#import "IsafeViewController.h"
#import "AboutTableViewController.h"
#import "LoginViewController.h"
#import "QRCodeViewController.h"
@interface IsafeViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic)NSArray *sectionTitleArray;
@property (nonatomic)NSArray *sectionImageNameArray;
@property (nonatomic)UITableView *myTableView;
@property (nonatomic)NSDictionary *dic;
@end

@implementation IsafeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self createDataSource];
    [self loadData];
    [self createTableView];
}
//数据源
- (void)createDataSource{
    self.sectionTitleArray = [NSMutableArray arrayWithCapacity:1];
    self.sectionImageNameArray = [NSMutableArray arrayWithCapacity:1];

    _sectionTitleArray = [[NSArray alloc]initWithObjects:@"与好友分享",@"关注我们",@"关于我们",@"退出登录", nil];
    _sectionImageNameArray = [NSArray arrayWithObjects:@"icon_share.png",@"icon_weixin.png",@"icon_share.png",@"icon_weixin.png", nil];
}
//创建
-(void)createTableView{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 49) style:UITableViewStylePlain];
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    NSString *cellId = @"cellID";
    [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    [self.view addSubview:_myTableView];
}

#pragma mark UITableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sectionTitleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.textLabel.text = [_sectionTitleArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[_sectionImageNameArray objectAtIndex:indexPath.row ]];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 140;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];
    
    NSURL *imageUrl = [NSURL URLWithString:_dic[@"headUrl"]];
    UIImageView *historyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    historyImageView.layer.cornerRadius = 10;
    historyImageView.layer.masksToBounds = YES;
    historyImageView.userInteractionEnabled = YES;
    [historyImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"默认"]];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 50;
    [btn addSubview:historyImageView];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, 100, 30)];
    lbl.text = _dic[@"name"];
    
    UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(130, 50, 150, 30)];
    lbl1.text = _dic[@"phone"];
    
    UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(130, 90, 100, 30)];
    lbl2.text = _dic[@"departmentName"];
    
    UILabel *lbl3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, KWIDTH, 10)];
    lbl3.backgroundColor = RGBACOLOR(236, 236, 236, 1);
    
    for (int i = 0; i < 3; i ++) {
        UILabel *lbl5 = [[UILabel alloc]initWithFrame:CGRectMake(128, 45 + i *40, KWIDTH-130, 1)];
        lbl5.backgroundColor = RGBACOLOR(226, 226, 226, 1);
        [headView addSubview:lbl5];
    }
    
    [headView addSubview:btn];
    [headView addSubview:lbl];
    [headView addSubview:lbl1];
    [headView addSubview:lbl2];
    [headView addSubview:lbl3];
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //1、创建分享参数
        NSArray* imageArray = @[[UIImage imageNamed:@"工友惠.png"]];
        // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
        if (imageArray) {
            
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                             images:imageArray
                                                url:[NSURL URLWithString:@"http://www.iclouduv.com:8080"]
                                              title:@"分享标题"
                                               type:SSDKContentTypeAuto];
            //2、分享（可以弹出我们的分享菜单和编辑界面）
            [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                     items:nil
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                           
                           switch (state) {
                               case SSDKResponseStateSuccess:
                               {
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
                       }
             ];
        }
        

    }
    if (indexPath.row == 1) {
        QRCodeViewController *qrcode = [[QRCodeViewController alloc]init];
        [self.navigationController pushViewController:qrcode animated:YES];
    }

    if (indexPath.row == 2) {
        AboutTableViewController *about = [[AboutTableViewController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }
    if (indexPath.row == 3) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"您确认要退出登录吗?", @"BaseStrings", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"取消", @"BaseStrings", nil) otherButtonTitles:NSLocalizedStringFromTable(@"确认", @"BaseStrings", nil), nil];
        alert.tag = 10000;
        [alert show];
    }
}
- (void)loadData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //记住用户名密码
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:UserName];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:Password];
    NSString *url = [NSString stringWithFormat:@"%@/api/account/login/%@/%@",REST_SERVICE_URL,name,password];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        _dic = resp[@"data"];
        
        [self.myTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10000) {
        if (buttonIndex == 1) {
            LoginViewController * login = [[LoginViewController alloc]init];
            [self presentViewController:login animated:YES completion:nil];
        }
    }
}

@end
