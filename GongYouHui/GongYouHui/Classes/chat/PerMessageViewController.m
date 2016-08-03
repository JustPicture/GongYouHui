//
//  PerMessageViewController.m
//  GongYouHui
//
//  Created by 陈伟荣 on 16/7/20.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import "PerMessageViewController.h"

@interface PerMessageViewController (){
    UIScrollView *myScrolleView;
}
@property (nonatomic,strong)UIView      *headerBgView;
@property (nonatomic,strong)UIView      *NFCBgView;
@property (nonatomic,strong)UIButton    *headerButton;

@end

@implementation PerMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(226, 226, 226, 1);
    [self creatUI];
}
- (void)creatUI{
    myScrolleView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    myScrolleView.contentSize= CGSizeMake(KWIDTH, 1250);
    [self.view addSubview:myScrolleView];

    [self upView];
    [self downView];
}
- (void)upView{
    _headerBgView = [[UIView alloc]init];
    _headerBgView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
    _headerBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"急救查询-背景"]];
    
    _headerButton = [[UIButton alloc]init];
    _headerButton.frame = CGRectMake(self.view.bounds.size.width/2-50, 60, 100, 100);
    _headerButton.layer.masksToBounds = YES;
    _headerButton.layer.cornerRadius = 50;
    NSURL *imageUrl = [NSURL URLWithString:_datasouceAry[@"headUrl"]];
    UIImageView  *historyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    historyImageView.layer.cornerRadius = 10;
    historyImageView.layer.masksToBounds = YES;
    historyImageView.userInteractionEnabled = YES;
    [historyImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"默认"]];
    [_headerButton addSubview:historyImageView];
    [_headerBgView addSubview:_headerButton];
    
    UILabel *usernameLabel = [[UILabel alloc]init];
    usernameLabel.frame = CGRectMake(0, 160, self.view.bounds.size.width, 40);
    usernameLabel.text = _datasouceAry[@"name"];
    usernameLabel.textColor =[UIColor whiteColor];
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *headLabel = [[UILabel alloc]init];
    headLabel.frame = CGRectMake(0, 10, self.view.bounds.size.width, 40);
    headLabel.text = @"工友惠";
    headLabel.textColor =[UIColor whiteColor];
    headLabel.textAlignment = NSTextAlignmentCenter;
    
    [_headerBgView addSubview:headLabel];
    [_headerBgView addSubview:usernameLabel];
    [myScrolleView addSubview:_headerBgView];
}
- (void)downView{
    NSArray *imageAry = @[@"icon_personal.png",@"icon_emergency.png",@"icon_company.png"];
    NSArray *nameAry = @[@"个人信息",@"急救信息",@"公司信息"];
    
    
    NSArray *ary0 = @[@"姓名:",@"性别:",@"电话:",@"血型:",@"地址:"];
    NSArray *ary1 = @[@"过敏药物:",@"疾病史:",@"紧急联系人:",@"联系人电话:",@"工号"];
    NSArray *ary2 = @[@"公司名称:",@"部门名称:",@"职位:",@"部门主管:",@"主管电话:"];
    NSArray *ARY = @[ary0,ary1,ary2];
    NSString *str = [[NSString alloc]init];
    if (_datasouceAry[@"sex"] == 0) {
        str = @"女";
    }else{
        str = @"男";
    }
    NSArray *ary3 = @[_datasouceAry[@"name"],str,_datasouceAry[@"mobilePhone"],_datasouceAry[@"bloodType"],_datasouceAry[@"address"]];
    NSArray *ary4 = @[_datasouceAry[@"hasAllergyDrug"],_datasouceAry[@"hasMedicalHistory"],_datasouceAry[@"emergencyContactName"],_datasouceAry[@"emergencyContactMobilePhone"],_datasouceAry[@"userCode"]];
    NSArray *ary5 = @[_datasouceAry[@"company"][@"companyName"],_datasouceAry[@"department"][@"departmentName"],_datasouceAry[@"position"],_datasouceAry[@"directlyLeaderName"],_datasouceAry[@"directlyLeaderPhone"]];
    NSArray *ARY1 = @[ary3,ary4,ary5];
    for (int i = 0; i < 3; i ++) {
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 220 + i *320, KWIDTH - 40, 300)];
        view1.backgroundColor = [UIColor whiteColor];
        
        UIView *nameView1 = [[UIView alloc]initWithFrame:CGRectMake(5, 5, view1.bounds.size.width - 10, 60)];
        nameView1.backgroundColor = RGBACOLOR(236, 236, 236, 1);
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        imageView.image = [UIImage imageNamed:imageAry[i]];
        
        UILabel *LBL = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, view1.bounds.size.width - 120, 50)];
        LBL.textAlignment = NSTextAlignmentCenter;
        LBL.text = nameAry[i];
        
        for (int j = 0 ; j < 5; j ++) {
           UILabel *LBL1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 70 + 45 *j, 120, 40)];
           LBL1.textAlignment = NSTextAlignmentLeft;
           LBL1.text = ARY[i][j];
           [view1 addSubview:LBL1];
            
            UILabel *LB = [[UILabel alloc]initWithFrame:CGRectMake(10, 115 + 45 *j, view1.bounds.size.width - 20, 1)];
            LB.backgroundColor = RGBACOLOR(236, 236, 236, 1);
            [view1 addSubview:LB];
            
            UILabel *LBL2 = [[UILabel alloc]initWithFrame:CGRectMake( view1.bounds.size.width - 200,70 + 45 *j, 180, 40)];
            LBL2.textAlignment = NSTextAlignmentRight;
            LBL2.text = ARY1[i][j];
            [view1 addSubview:LBL2];
        }
        [nameView1 addSubview:LBL];
        [nameView1 addSubview:imageView];
        [view1 addSubview:nameView1];
        [myScrolleView addSubview:view1];
    }
}
@end
