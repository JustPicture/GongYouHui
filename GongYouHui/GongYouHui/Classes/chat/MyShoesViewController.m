//
//  MyShoesViewController.m
//  GongYouHui
//
//  Created by 陈伟荣 on 15/12/31.
//  Copyright © 2015年 tianqiwang. All rights reserved.
//

#import "MyShoesViewController.h"
#import "BNContainer.h"
#import "BluetoothViewController.h"

#import "MJRefresh.h"
//#import "ShoesCell.h"
#import "SXWaveView.h"  // -----步骤1 引入自定义view头文件
#import "SXHalfWaveView.h"
#import "ZFChart.h"
#import "UserInfo.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SIDES SCREEN_WIDTH/2
#define MARGIN SCREEN_WIDTH/28
#define COLOR(a,b,c,d) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d]

@interface MyShoesViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
//    一周的天数
    NSArray *_weekdays;
//    一个月的天数
    NSArray *_monthdays;
    //一年的月数
    NSArray *_yeardays;
}
@property(strong,nonatomic)ZFBarChart * barChart;
@property (strong, nonatomic) IBOutlet UIView *VIEW;
@property (strong, nonatomic) UIView *wenduView;

@property (strong, nonatomic) UIButton *getBluetoothDataButton;
@property (strong, nonatomic) UIButton *bindingDeviceButton;
@property (strong, nonatomic) UIScrollView *MyScrollView;
@property (strong,nonatomic)UIView *myDendrogram;

//控件的名字
@property (strong, nonatomic) UILabel *defaultDeviceLabel;
@property (strong, nonatomic) UILabel *defaultDeviceConnectStateTitleLabel;
@property (strong, nonatomic) UILabel *stepNumTtitleLabel;
@property (strong, nonatomic) UILabel *KLLTitleLabel;

@property (nonatomic,strong)JumaDevice * defaultDevice;
@property (nonatomic,strong)JumaManager * manager;
@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,strong)NSMutableArray *arrData;
//身高 体重
@property(nonatomic,assign)NSUInteger iHeight;
@property(nonatomic,assign)NSUInteger iWidth;
//创建弹出视图
@property(nonatomic,strong)UIPickerView *pickerViews;
@property(nonatomic,strong)UIView *myView;
//多定义几个数组 用来接收 每次返回的数据 1保存温度 2 保存湿度
@property(strong,nonatomic)NSMutableArray *arrWearthWind;
@property(nonatomic,strong)SXWaveView *animateView;
@property(nonatomic,strong)SXWaveView *animateView1;
@property(nonatomic,strong) UIButton  *cannle;
@property(nonatomic,strong) UIButton  *sures;
//计时器
@property(nonatomic,strong)NSTimer *myTimers;

//每月返回的数据源
@property(nonatomic,strong)NSDictionary *data;
//每年返回的数据源
@property(nonatomic,strong)NSDictionary *data1;
//存放月的values
@property(nonatomic,strong)NSArray *ary;
//存放年返回的values
@property(nonatomic,strong)NSArray *ary1;
@end

@implementation MyShoesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.VIEW bringSubviewToFront:self.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBarChart) name:@"shuzhuang" object:nil];
    
    //一周的天数
    _weekdays = [NSArray arrayWithObjects:@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六" ,nil];
 
    //一年的月数
    _yeardays = [NSArray arrayWithObjects: @"Jan",@"Feb",@"Mar",@"April",@"May",@"June",@"July",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
   
    
    //请求每月,每年的步数数据
    [self loadMonthAndYear];
    
    [self creatUI];
    //给laber 添加触摸事件
    [self laberTapEvent];
    
    //初始化  蓝牙返回的数据 二个数组
    self.arrData=[[NSMutableArray alloc]initWithCapacity:0];
    self.arrWearthWind=[[NSMutableArray alloc]initWithCapacity:0];
    
    
    //通过一个时间控制 返回请求回来的数据
    self.myTimers= [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
    
//    初始化JumaManager
  //      JumaManagerOptionShowPowerAlertKey   蓝牙关闭时回弹出警告框
    NSDictionary *options = @{ JumaManagerOptionShowPowerAlertKey    : @YES,
                               JumaManagerOptionRestoreIdentifierKey : @"io.juma.restoreID" };
    self.manager = [[JumaManager alloc]initWithDelegate:self queue:nil options:nil];

}
- (void)creatUI{
    //创建一个ScrolleView
    [self creatScrolleView];
    
    //创建日月年三个Button
    [self creatThreeButton];
    
    //创建身高体重体质指数步数卡路里温度等界面
    [self creatOhMyGod];
    
    //设置树状图的view
    [self setDendrogramView];
    
    //添加树状图
    [self showBarChart];

    //添加灌水动画
    [self guanshui];
    
    //pinckerView 初始化
    [self createPickerView];
    
    //创建 UIView 将确定 和取消都放在 UIView上面
    [self createViewAndBtn];
    
    //创建连接设备的btn
    [self creatLianJieBtn];
}
- (void)creatLianJieBtn{
    
    UIButton *myCloseDuanKai = [[UIButton alloc ]initWithFrame:CGRectMake(KWIDTH/2 - 140, KHEIGHT - 40, 120, 35)];
    [myCloseDuanKai setTitle:@"断开蓝牙连接" forState:UIControlStateNormal];
    [myCloseDuanKai setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    myCloseDuanKai.backgroundColor = RGBACOLOR(220, 85, 30, 1);
    myCloseDuanKai.titleLabel.font = [UIFont systemFontOfSize: 12];
    [myCloseDuanKai addTarget:self action:@selector(duankailianjie) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *LianJieSheBei = [[UIButton alloc ]initWithFrame:CGRectMake(KWIDTH/2 +20,KHEIGHT - 40, 120, 35)];
    [LianJieSheBei setTitle:@"查看附近设备" forState:UIControlStateNormal];
    LianJieSheBei.backgroundColor = [UIColor blueColor];
    LianJieSheBei.backgroundColor = RGBACOLOR(120, 170, 215, 1);
    LianJieSheBei.titleLabel.font = [UIFont systemFontOfSize: 12];
    [LianJieSheBei addTarget:self action:@selector(chazhaoshebei) forControlEvents:UIControlEventTouchUpInside];
    
    //    设置控件的属性
    myCloseDuanKai.layer.masksToBounds = YES;
    myCloseDuanKai.layer.cornerRadius = 5;
    LianJieSheBei.layer.masksToBounds = YES;
    LianJieSheBei.layer.cornerRadius = 5;
    
    [self.view addSubview:myCloseDuanKai];
    [self.view addSubview:LianJieSheBei];
}
- (void)chazhaoshebei{
    BluetoothViewController *blueTooth = [[BluetoothViewController alloc]init];
    self.manager.delegate = nil;
    blueTooth.manager = self.manager;
    [self.navigationController pushViewController:blueTooth animated:YES];
}
- (void)creatScrolleView{
    _MyScrollView             = [[UIScrollView alloc]init];
    _MyScrollView.frame       = CGRectMake(0, 1, KScreenWidth, kScreenHeight-44);
    _MyScrollView.contentSize = CGSizeMake(0, 850);
    [self.view addSubview:_MyScrollView];
}
- (void)creatOhMyGod{
    //背景图
    _bgImage = [[UIView alloc]init];
    _bgImage.frame = CGRectMake(0, 0, KScreenWidth, 400);
    UIColor *bgColorS = [UIColor colorWithPatternImage: [UIImage imageNamed:@"登录bg"]];
    [_bgImage setBackgroundColor:bgColorS];
   
    
    //体重
    UILabel *myWidthKgTitleLabel      = [[UILabel alloc]init];
    myWidthKgTitleLabel.frame         = CGRectMake((KScreenWidth-300)/3+ 100, 300,100, 50);
    myWidthKgTitleLabel.text          = @"体重";
    myWidthKgTitleLabel.textColor     = [UIColor whiteColor];
    myWidthKgTitleLabel.font          = [UIFont systemFontOfSize:15];
    myWidthKgTitleLabel.textAlignment =NSTextAlignmentCenter;
    
    //kg
    UILabel *KG  = [[UILabel alloc]init];
    KG.frame     = CGRectMake((KScreenWidth-300)/3+ 170, 360, 30, 30);
    KG.text      = @"kg";
    KG.textColor = [UIColor whiteColor];

    _myWidthKg               = [[UILabel alloc]init];
    _myWidthKg.frame         = CGRectMake((KScreenWidth-300)/3+ 100, 360, 60, 30);
    _myWidthKg.textAlignment = NSTextAlignmentRight;
    _myWidthKg.text          = @"72";
    _myWidthKg.textColor     = [UIColor whiteColor];
    _myWidthKg.tag           = 2;
    
    //身高
    UILabel *HeightTitleLabel      = [[UILabel alloc]init];
    HeightTitleLabel.frame         = CGRectMake(10, 300, 100, 50);
    HeightTitleLabel.text          = @"身高";
    HeightTitleLabel.textColor     = [UIColor whiteColor];
    HeightTitleLabel.font          = [UIFont systemFontOfSize:15];
    HeightTitleLabel.textAlignment =  NSTextAlignmentCenter;
    
    //cm
    UILabel *CM  = [[UILabel alloc]init];
    CM.frame     = CGRectMake(72, 360, 30, 30);
    CM.text      = @"cm";
    CM.textColor = [UIColor whiteColor];
    
    _myHeight               = [[UILabel alloc]init];
    _myHeight.frame         = CGRectMake(10, 360, 60, 30);
    _myHeight.text          = @"175";
    _myHeight.textColor     = [UIColor whiteColor];
    _myHeight.textAlignment = NSTextAlignmentRight;
    _myHeight.tag           = 1;
    

    //BMI
    UILabel *myBMITieleLabel      = [[UILabel alloc]init];
    myBMITieleLabel.frame         = CGRectMake(KScreenWidth-100, 300, 100, 50);
    myBMITieleLabel.text          = @"体质指数(BMI)";
    myBMITieleLabel.textColor     = [UIColor whiteColor];
    myBMITieleLabel.font          = [UIFont systemFontOfSize:15];
    myBMITieleLabel.textAlignment =  NSTextAlignmentCenter;
    
    _myBMI               = [[UILabel alloc]init];
    _myBMI.frame         = CGRectMake(KScreenWidth-100, 360, 100, 30);
    _myBMI.textAlignment = NSTextAlignmentCenter;
    _myBMI.text          = @"23.51";
    _myBMI.textColor     = [UIColor whiteColor];
    
    
    //步数
    UILabel *stepNumLabelTitleLabel      = [[UILabel alloc]init];
    stepNumLabelTitleLabel.frame         = CGRectMake(10, 200, 100, 50);
    stepNumLabelTitleLabel.text          = @"步数";
    stepNumLabelTitleLabel.textColor     = [UIColor whiteColor];
    stepNumLabelTitleLabel.font          = [UIFont systemFontOfSize:15];
    stepNumLabelTitleLabel.textAlignment =  NSTextAlignmentCenter;

    _stepNumLabel               = [[UILabel alloc]init];
    _stepNumLabel.frame         = CGRectMake(10, 260, 100, 30);
    _stepNumLabel.text          = @"0";
    _stepNumLabel.textColor     = [UIColor whiteColor];
    _stepNumLabel.textAlignment = NSTextAlignmentCenter;
    
    //卡路里
    UILabel *caloricValueLabelTitle      = [[UILabel alloc]init];
    caloricValueLabelTitle.frame         = CGRectMake(KScreenWidth-100, 200, 100, 30);
    caloricValueLabelTitle.text          = @"消耗卡路里";
    caloricValueLabelTitle.textColor     = [UIColor whiteColor];
    caloricValueLabelTitle.font          = [UIFont systemFontOfSize:15];
    caloricValueLabelTitle.textAlignment =  NSTextAlignmentCenter;
    
    _caloricValueLabel               = [[UILabel alloc]init];
    _caloricValueLabel.frame         = CGRectMake(KScreenWidth-100, 260, 100, 30);
    _caloricValueLabel.text          = @"0";
    _caloricValueLabel.textColor     = [UIColor whiteColor];
    _caloricValueLabel.textAlignment = NSTextAlignmentCenter;
    
    //蓝牙是否连接
    _defaultDeviceConnectStateTitleLabel               = [[UILabel alloc]init];
    _defaultDeviceConnectStateTitleLabel.frame         = CGRectMake(KScreenWidth/2-50, 260, 100, 30);
    _defaultDeviceConnectStateTitleLabel.text          = @"未连接";
    _defaultDeviceConnectStateTitleLabel.textColor     = [UIColor whiteColor];
    _defaultDeviceConnectStateTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    //温度View
    _wenduView       = [[UIView alloc]init];
    _wenduView.frame = CGRectMake(0, 400, KScreenWidth, 50);
    
    //温度
    UILabel *wendu      = [[UILabel alloc]init];
    wendu.frame         = CGRectMake(50, 10, 100, 30);
    wendu.text          = @"鞋内温度";
    wendu.textAlignment = NSTextAlignmentCenter;
    
    _rowContentLabel               = [[UILabel alloc]init];
    _rowContentLabel.frame         = CGRectMake(KScreenWidth-120, 10, 100, 30);
    _rowContentLabel.textAlignment = NSTextAlignmentCenter;
    _rowContentLabel.text          = @"0 ℃";
    
    //小图片
    UIImageView *wenduImage = [[UIImageView alloc]init];
    wenduImage.frame        = CGRectMake(20, 10, 32, 32);
    [wenduImage setImage:[UIImage imageNamed:@"icon_wendu"]];

    //分割线
    UIView *xian         = [[UIView alloc]init];
    xian.frame           = CGRectMake(20, 50, KScreenWidth - 40, 1);
    xian.backgroundColor = [UIColor darkGrayColor];
    
    
    [self.wenduView    addSubview:xian];
    [self.wenduView    addSubview:wenduImage];
    [self.wenduView    addSubview:_rowContentLabel];
    [self.wenduView    addSubview:wendu];
    [self.bgImage      addSubview:KG];
    [self.bgImage      addSubview:CM];
    [self.bgImage      addSubview:_caloricValueLabel];
    [self.bgImage      addSubview:_defaultDeviceConnectStateTitleLabel];
    [self.bgImage      addSubview:caloricValueLabelTitle];
    [self.bgImage      addSubview:_caloricValueLabel];
    [self.bgImage      addSubview:stepNumLabelTitleLabel];
    [self.bgImage      addSubview:_stepNumLabel];
    [self.bgImage      addSubview:myBMITieleLabel];
    [self.bgImage      addSubview:_myBMI];
    [self.bgImage      addSubview:myWidthKgTitleLabel];
    [self.bgImage      addSubview:_myWidthKg];
    [self.bgImage      addSubview:HeightTitleLabel];
    [self.bgImage      addSubview:_myHeight];
    [self.MyScrollView addSubview:_wenduView];
    [self.MyScrollView addSubview:_bgImage];
    
}

- (void)daybutton:(UIButton *)button{
    //获取当前时间
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int year = [dateComponent year];
    int month = [dateComponent month];
    int day = [dateComponent day];

    NSLog(@"year is: %d", year);
    NSLog(@"month is: %d", month);
    NSLog(@"day is: %d", day);

    if (button.tag == 1) {
        NSLog(@"我是月");
        [self.myDendrogram removeAllSubviews];
        _barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH,  230)];

//   NSMutableArray *dataMonths = [[NSMutableArray alloc]initWithObjects:[[NSString alloc] initWithFormat:@"%@",_ary[0]],[[NSString alloc] initWithFormat:@"%@",_ary[1]],[[NSString alloc] initWithFormat:@"%@",_ary[2]],[[NSString alloc] initWithFormat:@"%@",_ary[3]],[[NSString alloc] initWithFormat:@"%@",_ary[4]],[[NSString alloc] initWithFormat:@"%@",_ary[5]],[[NSString alloc] initWithFormat:@"%@",_ary[6]],[[NSString alloc] initWithFormat:@"%@",_ary[7]],[[NSString alloc] initWithFormat:@"%@",_ary[8]],[[NSString alloc] initWithFormat:@"%@",_ary[9]],[[NSString alloc] initWithFormat:@"%@",_ary[10]],[[NSString alloc] initWithFormat:@"%@",_ary[11]],[[NSString alloc] initWithFormat:@"%@",_ary[12]],[[NSString alloc] initWithFormat:@"%@",_ary[13]],[[NSString alloc] initWithFormat:@"%@",_ary[14]],[[NSString alloc] initWithFormat:@"%@",_ary[15]],[[NSString alloc] initWithFormat:@"%@",_ary[16]],[[NSString alloc] initWithFormat:@"%@",_ary[17]],[[NSString alloc] initWithFormat:@"%@",_ary[18]],[[NSString alloc] initWithFormat:@"%@",_ary[19]],[[NSString alloc] initWithFormat:@"%@",_ary[20]],[[NSString alloc] initWithFormat:@"%@",_ary[21]],[[NSString alloc] initWithFormat:@"%@",_ary[22]],[[NSString alloc] initWithFormat:@"%@",_ary[23]],[[NSString alloc] initWithFormat:@"%@",_ary[24]],[[NSString alloc] initWithFormat:@"%@",_ary[25]],[[NSString alloc] initWithFormat:@"%@",_ary[26]],[[NSString alloc] initWithFormat:@"%@",_ary[27]],[[NSString alloc] initWithFormat:@"%@",_ary[28]],[[NSString alloc] initWithFormat:@"%@",_ary[29]], nil];
//
//        _barChart.xLineValueArray =dataMonths;
//        NSLog(@"ary-----------%@%@",_ary,dataMonths);
        NSMutableArray *ary = [[NSMutableArray alloc]init];
        
        for (int i = day; i >= 0  ; i --) {
            if ( i== 0) {
                for (int j = 0; j < 31-day-1; j++) {
                    [ary addObject:[NSString stringWithFormat:@"%d日", 31 - j]];
                }
            }else {
                [ary addObject: [NSString stringWithFormat:@"%d日", i]];
            }
        }
        
        _barChart.xLineTitleArray = [NSMutableArray arrayWithArray:ary];
         _barChart.yLineMaxValue = 10000;
        _barChart.yLineSectionCount = 5;
        [self.myDendrogram addSubview:_barChart];
        [_barChart strokePath];
    }else if (button.tag == 2){

        [self.myDendrogram removeAllSubviews];
        _barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH,  200)];

//        NSMutableArray *dataArrays=[[NSMutableArray alloc]initWithObjects:[[NSString alloc] initWithFormat:@"%@",_ary1[0]],[[NSString alloc] initWithFormat:@"%@",_ary1[1]],[[NSString alloc] initWithFormat:@"%@",_ary1[2]],[[NSString alloc] initWithFormat:@"%@",_ary1[3]],[[NSString alloc] initWithFormat:@"%@",_ary1[4]],[[NSString alloc] initWithFormat:@"%@",_ary1[5]],[[NSString alloc] initWithFormat:@"%@",_ary1[6]],[[NSString alloc] initWithFormat:@"%@",_ary1[7]],[[NSString alloc] initWithFormat:@"%@",_ary1[8]],[[NSString alloc] initWithFormat:@"%@",_ary1[9]],[[NSString alloc] initWithFormat:@"%@",_ary1[10]],[[NSString alloc] initWithFormat:@"%@",_ary1[11]],nil];
//      
//        _barChart.xLineValueArray = dataArrays;
//
        NSMutableArray *ary = [[NSMutableArray alloc]init];
//
        for (int i = month; i >= 0  ; i --) {
            if ( i== 0) {
                for (int j = 0; j < 12-month; j++) {
                    [ary addObject:[NSString stringWithFormat:@"%d月", 12 - j]];
                }
            }else {
                [ary addObject: [NSString stringWithFormat:@"%d月", i]];
            }
        }
        _barChart.xLineTitleArray = [NSMutableArray arrayWithArray:ary];
        _barChart.yLineMaxValue = 200000;
        _barChart.yLineSectionCount =5;
        [self.myDendrogram addSubview:_barChart];
        [_barChart strokePath];
    }
}
- (void)creatThreeButton{
    UIButton *Daybtn = [[UIButton alloc]init];
    Daybtn.frame = CGRectMake(20, 470, (self.view.bounds.size.width-60)/3, 30);
    Daybtn.layer.masksToBounds= YES;
    Daybtn.layer.cornerRadius = 10;
    [Daybtn setTitle:@"日" forState:UIControlStateNormal];
    [Daybtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    Daybtn.backgroundColor = [UIColor whiteColor];
    [Daybtn  addTarget:self action:@selector(showBarChart) forControlEvents:UIControlEventTouchUpInside];
    [self.MyScrollView addSubview:Daybtn];
    
    UIButton *MonthBtn = [[UIButton alloc]init];
    MonthBtn.frame = CGRectMake(30+(self.view.bounds.size.width-60)/3, 470, (self.view.bounds.size.width-60)/3, 30);
    MonthBtn.layer.masksToBounds= YES;
    MonthBtn.layer.cornerRadius = 10;
    MonthBtn.tag = 1;
    [MonthBtn setTitle:@"月" forState:UIControlStateNormal];
    MonthBtn.backgroundColor = [UIColor whiteColor];
    [MonthBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [MonthBtn  addTarget:self action:@selector(daybutton:) forControlEvents:UIControlEventTouchUpInside];
    [self.MyScrollView addSubview:MonthBtn];
    
    UIButton *YearBtn = [[UIButton alloc]init];
    YearBtn.frame = CGRectMake(40+2*(self.view.bounds.size.width-60)/3, 470, (self.view.bounds.size.width-60)/3, 30);
    YearBtn.layer.masksToBounds= YES;
    YearBtn.layer.cornerRadius = 10;
    [YearBtn setTitle:@"年" forState:UIControlStateNormal];
    YearBtn.backgroundColor = [UIColor whiteColor];
    YearBtn.tag = 2;
    [YearBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [YearBtn  addTarget:self action:@selector(daybutton:) forControlEvents:UIControlEventTouchUpInside];
    [self.MyScrollView addSubview:YearBtn];
    
    
}
//http://www.iclouduv.com:8080/api/shoes/2225?type=1
- (void)loadMonthAndYear{
    
    NSString *userId = [BNContainer instance].userInfo.userId;
    NSLog(@"%@",userId);
    //返回月的数据
    NSString *url = [NSString stringWithFormat:@"%@/api/shoes/%@?type=%d",REST_SERVICE_URL,userId,1];
    NSLog(@"%@",url);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSLog(@"operation = %@",operation);
            NSError * error;
            NSDictionary * resp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@" myisafe error %@",error);
            NSLog(@" myisafe json %@",resp);
            _data = resp[@"data"];
            
            NSArray *originalArray = [_data allKeys];
            //block比较方法，数组中可以是NSInteger，NSString（需要转换）
            NSComparator finderSort = ^(id string1,id string2){
                
                if ([string1 integerValue] > [string2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }else if ([string1 integerValue] < [string2 integerValue]){
                    return (NSComparisonResult)NSOrderedAscending;
                }
                else
                    return (NSComparisonResult)NSOrderedSame;
            };
            
            //数组排序：
            NSArray *resultArray = [originalArray sortedArrayUsingComparator:finderSort];
            NSLog(@"第一种排序结果：%@",resultArray);
            
            _ary = @[_data[resultArray[29]],_data[resultArray[28]],_data[resultArray[27]],_data[resultArray[26]],_data[resultArray[25]],_data[resultArray[24]],_data[resultArray[23]],_data[resultArray[22]],_data[resultArray[21]],_data[resultArray[20]],_data[resultArray[19]],_data[resultArray[18]],_data[resultArray[17]],_data[resultArray[16]],_data[resultArray[15]],_data[resultArray[14]],_data[resultArray[13]],_data[resultArray[12]],_data[resultArray[11]],_data[resultArray[10]],_data[resultArray[9]],_data[resultArray[8]],_data[resultArray[7]],_data[resultArray[6]],_data[resultArray[5]],_data[resultArray[4]],_data[resultArray[3]],_data[resultArray[2]],_data[resultArray[1]],_data[resultArray[0]]];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"---------------------Error: %@", error);
        
    }];
    
    NSString *userId2 = [BNContainer instance].userInfo.userId;
    NSLog(@"%@",userId2);
    //返回年的数据
    NSString *url1 = [NSString stringWithFormat:@"%@/api/shoes/%@?type=%d",REST_SERVICE_URL,userId2,2];
    NSLog(@"%@",url1);
    
    AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
    manager1.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager1.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager1 GET:url1 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            
            NSLog(@"operation = %@",operation);
            NSError * error;
            NSDictionary * resp1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@" myisafe error %@",error);
            NSLog(@" myisafe json %@",resp1);
            _data1 = resp1[@"data"];

            NSArray *originalArray = [_data1 allKeys];
            //block比较方法，数组中可以是NSInteger，NSString（需要转换）
            NSComparator finderSort = ^(id string1,id string2){
                
                if ([string1 integerValue] > [string2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }else if ([string1 integerValue] < [string2 integerValue]){
                    return (NSComparisonResult)NSOrderedAscending;
                }
                else
                    return (NSComparisonResult)NSOrderedSame;
            };
            
            //数组排序：
            NSArray *resultArray = [originalArray sortedArrayUsingComparator:finderSort];
            NSLog(@"第一种排序结果：%@",resultArray);
            
            _ary1 = @[_data1[resultArray[11]],_data1[resultArray[10]],_data1[resultArray[9]],_data1[resultArray[8]],_data1[resultArray[7]],_data1[resultArray[6]],_data1[resultArray[5]],_data1[resultArray[4]],_data1[resultArray[3]],_data1[resultArray[2]],_data1[resultArray[1]],_data1[resultArray[0]]];

            NSLog(@"%@",_ary1);
            NSLog(@"data1返回每年的----------%@",_data1);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"---------------------Error: %@", error);

    }];
}

- (void)setDendrogramView{
    _myDendrogram= [[UIView alloc]initWithFrame:CGRectMake(0, 500, self.view.bounds.size.width, 250)];

    [self.MyScrollView addSubview:_myDendrogram];
}
- (void)refrecedata
{
//    _barChart.xLineTitleArray=[[NSMutableArray alloc]initWithObjects:
//                               [self.arrData objectAtIndex:13],
//                               [self.arrData objectAtIndex:11],
//                               [self.arrData objectAtIndex:9],
//                               [self.arrData objectAtIndex:7],
//                               [self.arrData objectAtIndex:5],
//                               [self.arrData objectAtIndex:3],
//                               [self.arrData objectAtIndex:1], nil];
//    _barChart.xLineTitleArray = [NSMutableArray arrayWithArray:
//                                 [self isWeekdays:
//                                  [self weekdayStringFromDate]]];
//    _barChart.yLineMaxValue = 500;
//    _barChart.yLineSectionCount = 10;
//    [_barChart strokePath];
}

#pragma mark 得到当前日期
- (NSInteger)nowDate{
    NSDate *dates=[NSDate date];
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init];
    //然后设置这个类的dataFormate属性为一个字符串，系统就可以因此自动识别年月日时间
    dateFormat.dateFormat = @"yyyy/MM/dd";
    //之后定义一个字符串，使用stringFromDate方法将日期转换为字符串
    NSString * dateToString = [dateFormat stringFromDate:dates];
    NSArray *dateArray=[dateToString componentsSeparatedByString:@"/"];
    return [[dateArray lastObject] integerValue];
}
- (NSInteger)weekdayStringFromDate{

    NSDate *inputDate=[NSDate date];
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"0", @"1", @"2", @"3", @"4", @"5", @"6", nil];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [[weekdays objectAtIndex:theComponents.weekday] integerValue];
    
}

#pragma mark 得到最近7天是周几
- (NSArray *)isWeekdays:(NSInteger)nowWeek{
    NSInteger j = nowWeek;
    NSMutableArray *weekArray=[[NSMutableArray alloc]initWithCapacity:0];
    for (NSInteger i=nowWeek; i>=0; i--) {
        [weekArray addObject:[self isWeekString:i]];
        
#warning 鞋子里面的星期几Bug的调整
        if(i==0){
//            NSInteger j=7-i;
            for(int x=6;x>=j + 1;x--){
                [weekArray addObject:[self isWeekString:x]];
            }
        }
    }
    //倒序后返回数组
    return [[weekArray reverseObjectEnumerator] allObjects];
}
- (NSString *)isMonthString:(NSInteger)monthInt{
    return [_monthdays objectAtIndex:monthInt];
}
- (NSString *)isWeekString:(NSInteger)weekInt{
    
    return [_weekdays objectAtIndex:weekInt];
    
}
#pragma mark   添加树状图
- (void)showBarChart{
    
    [self.myDendrogram removeAllSubviews];
    _barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH,  230)];
    NSMutableArray *dataArrays=[[NSMutableArray alloc]initWithObjects:@"10",@"20",@"30",@"40",@"50",@"60",@"70", nil];
    if (self.arrData.count==22) {
        [dataArrays removeAllObjects];
        [dataArrays addObjectsFromArray:@[[self.arrData objectAtIndex:13],
                                          [self.arrData objectAtIndex:11],
                                          [self.arrData objectAtIndex:9],
                                          [self.arrData objectAtIndex:7],
                                          [self.arrData objectAtIndex:5],
                                          [self.arrData objectAtIndex:3],
                                          [self.arrData objectAtIndex:1]]];
    }
    _barChart.xLineValueArray = dataArrays;
    NSLog(@"%@-------------------",dataArrays);
    _barChart.xLineTitleArray = [NSMutableArray arrayWithArray:
                                  [self isWeekdays:
                                   [self weekdayStringFromDate]]];
    NSLog(@"Value %@ title%@",_barChart.xLineValueArray,_barChart.xLineTitleArray);
    _barChart.yLineMaxValue = 5000;
    _barChart.yLineSectionCount = 10;
    [self.myDendrogram addSubview:_barChart];
    [_barChart strokePath];
}

-(void)createTimers
{
    //判断连接成功 再写入通过时间 来数据
}
#pragma mark --通过计时器 来不停的写入请求数据
-(void)timerFired:(NSTimer *) sender
{
//    NSLog(@"您被调用了  666666666----tiemr");
//    NSString *UUIDString = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultBluetoothDeviceUUID];
//    self.defaultDevice = [self.manager retrieveDeviceWithUUID:UUIDString];
//    if (self.defaultDevice && self.defaultDevice.state == 2) {
//        self.defaultDevice.delegate = self;
//        unsigned char typeCode = 9;
//        _array=[[NSMutableArray alloc] initWithObjects:@"01",@"02", nil];
//// 1.写入步数
//        NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:2];
//        NSRange range;
//        if ([_array[0] length] % 2 == 0){
//            range = NSMakeRange(0, 2);
//        }
//        else{
//            range = NSMakeRange(0, 1);
//        }
//        for (NSInteger i = range.location; i < [_array[0] length]; i += 2){
//            unsigned int anInt;
//            NSString *hexCharStr = [_array[0] substringWithRange:range];
//            NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
//            [scanner scanHexInt:&anInt];
//            NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
//            [hexData appendData:entity];
//            range.location += range.length;
//            range.length = 2;
//        }
//        //调用写数据的方法
//        [self.defaultDevice writeData:hexData type:typeCode];
//    }
//    else {
////        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"没有连接设备", @"BaseStrings", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"确认", @"BaseStrings", nil) otherButtonTitles:nil, nil];
////        [alertView show];
//    }
}
#pragma mark--创建选择视图的确定和取消
-(void)createViewAndBtn
{
    _myView                = [[UIView alloc]initWithFrame:CGRectMake(0,self.bgImage.frame.size.height-40, self.bgImage.frame.size.width, 40)];
    _myView.backgroundColor= [UIColor grayColor];
    _myView.hidden         = YES;
    _cannle                = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 80, 40)];
    _sures                 = [[UIButton alloc ]initWithFrame:CGRectMake(_myView.frame.size.width-80,0, 80, 40)];
    [_cannle      setTitle:@"取消" forState:UIControlStateNormal];
    [_cannle      addTarget:self action:@selector(cannleEvents) forControlEvents:UIControlEventTouchUpInside];
    
    [_sures       setTitle:@"确定" forState:UIControlStateNormal];
    [_sures       addTarget:self action:@selector(cannleEvents) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImage addSubview:_myView];
    [_myView      addSubview:_cannle];
    [_myView      addSubview:_sures];
    [self.view    bringSubviewToFront:_myView];
}
#pragma mark --确定和取消的 点击事件
-(void)cannleEvents
{
    self.pickerViews.hidden = YES;
    self.myView.hidden      = YES;
}
#pragma mark--创建选择视图
-(void)createPickerView
{
    _pickerViews=[[UIPickerView alloc]initWithFrame:CGRectMake(0, self.bgImage.frame.size.height, self.view.frame.size.width, 150)];
    _pickerViews.tag        = 1;
    _pickerViews.delegate   = self;
    _pickerViews.dataSource = self;
    _pickerViews.hidden     = YES;
    _pickerViews.backgroundColor = [UIColor grayColor];
    [self.MyScrollView addSubview:_pickerViews];
    //    将视图显示在 视图的顶层
    [self.MyScrollView bringSubviewToFront:_pickerViews];
}

#pragma mark---身高和体重的 的选择事件
-(void)laberTapEvent
{
    //    设置laber是否允许与用户交互
    self.myHeight.userInteractionEnabled=YES;
    self.myWidthKg.userInteractionEnabled=YES;
    //    给laber添加触摸事件
    UITapGestureRecognizer * touch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(laberClick:)];
    [self.myHeight addGestureRecognizer:touch];
    //        myWidth
    UITapGestureRecognizer * myWidthTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(laberClick:)];
    
    [self.myWidthKg addGestureRecognizer:myWidthTouch];
}
#pragma mark --pickerView 实现的方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
    
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag==1) {
        return 150;
        
    }else
    {
        return 150;
    }
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag==1) {
        NSString *aaa=[NSString stringWithFormat:@"%ld",(long)row+100];
        return aaa;
    }
    NSString *numbers=[NSString stringWithFormat:@"%ld",(long)row];
    return numbers;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (pickerView.tag==1) {
        //获取对应列，对应行的数据
        self.myHeight.text=[NSString stringWithFormat:@"%ld",(long)row+100];
    }
    else
    {
        //获取对应列，对应行的数据
        self.myWidthKg.text=[NSString stringWithFormat:@"%ld",(long)row];
    }
    if (self.myWidthKg!=0) {
        float iBMI=[self.myWidthKg.text floatValue]/[self.myHeight.text floatValue]/[self.myHeight.text floatValue]*10000;
        
        self.myBMI.text=[NSString stringWithFormat:@"%.2f",iBMI];
    }
}

#pragma mark ---弹出框视图
-(void)laberClick:(UIGestureRecognizer *)tap
{
    //    弹出视图UIPickerView
    NSLog(@"您点击了 ---laber---6666666666666 ");
    if (tap.view.tag==1) {
        self.pickerViews.tag=1;
        self.pickerViews.hidden=NO;
        _myView.hidden=NO;
        [self.pickerViews reloadAllComponents];
    }
    else
    {
        self.pickerViews.tag=2;
        self.pickerViews.hidden=NO;
        _myView.hidden=NO;
        [self.pickerViews reloadAllComponents];
    }
}

//    JumaManagerStateUnknown = 0,
//    JumaManagerStateResetting,
//    JumaManagerStateUnsupported,
//    JumaManagerStateUnauthorized,
//    JumaManagerStatePoweredOff,
//    JumaManagerStatePoweredOn,
#pragma mark-- 展示数据 接收到蓝牙设备的数据时, 这个方法会被调用, 并给出相应的结果.
//- (void)device:(JumaDevice *)device didUpdateData:(NSData *)data type:(const char)typeCode error:(NSError *)error
//{
//    if (self.arrData.count>=22) {
//        [self.arrData removeAllObjects];
//    }
//    if (!error)
//    {
//        if (_array.count>0) {
//            [_array removeObjectAtIndex:0];
//            //写入温度和湿度
//            //当第一条数据发送成功之后 再写入第二条
//            NSString *str1 = @"02";
//            unsigned char typeCode = 9;
//            NSMutableData *hexData1 = [[NSMutableData alloc] initWithCapacity:2];
//            NSRange range1;
//            if ([str1 length] % 2 == 0)
//            {
//                range1 = NSMakeRange(0, 2);
//            }
//            else
//            {
//                range1 = NSMakeRange(0, 1);
//            }
//            for (NSInteger i = range1.location; i < [str1 length]; i += 2)
//            {
//                unsigned int anInt;
//                NSString *hexCharStr = [str1 substringWithRange:range1];
//                NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
//                
//                [scanner scanHexInt:&anInt];
//                NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
//                [hexData1 appendData:entity];
//                
//                range1.location += range1.length;
//                range1.length = 2;
//            }
//            //        要写入数据的类型 必须为 const unsigned char
//            [self.defaultDevice writeData:hexData1 type:typeCode];
//        }
//        
//        //NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        Byte * test = (Byte *)[data bytes];
//        for (int i = 0; i < [data length]; i++)
//        {
//            NSLog(@"------6666666-----Byte array = %d  ",test[i]);
//            //将要显示的湿度 温度 和步数 都添加在数组中
//            //判断数组返回的长度 大于4 表示步数 小于表示温度和湿度
//            [self.arrData addObject:[NSString stringWithFormat:@"%hhu",test[i]]];
//        }
//        NSLog(@"--得到最后数组内容----???????????------%@,%lu",self.arrData,(unsigned long)self.arrData.count);
//        if (self.arrData.count==22)
//        {
//            self.stepNumLabel.text = [NSString stringWithFormat:@"%@", self.arrData[1]];
//            self.rowContentLabel.text=[NSString stringWithFormat:@"%@°C",[self.arrData objectAtIndex:19]];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"shuzhuang" object:nil];
//        }
//        /*
//         w / h / h * 10000;这个是bmi值
//         */
//        //     显示消耗卡里路的值   w*h*0.00000435*stepNum;  身高cm体重kg 卡路里的值
//        
//        //得到身高控件的值 将身高体重转换为int类型的 计算 卡里路的值
//        self.iHeight = [self.myHeight.text intValue];
//        self.iWidth = [self.myWidthKg.text intValue];
//        int iStep = [self.stepNumLabel.text intValue];
//        float caloricValue=self.iWidth*self.iHeight*0.00000435*iStep;
//        NSLog(@"------卡路里数---55656565656----------%.2f",caloricValue);
//        //卡路里的值
//        self.caloricValueLabel.text=[NSString stringWithFormat:@"%.2f",caloricValue];
//        //BMI的值 w/h/h*10000 bmi的值
//        float iBMI=self.iWidth/(self.iHeight*self.iHeight)*10000;
//        NSLog(@"----IBM的值-----9989898955656565656----------%.2f",iBMI);
//        self.precent=[self.rowContentLabel.text intValue];//
//        
//        //        灌水动画 显示的湿度
//        [_animateView setPrecent:self.precent description:@"°C" textColor:[UIColor orangeColor] bgColor:[UIColor clearColor] alpha:1 clips:NO];
//        //[self.animateView1 setPrecent:self.precent];
//    }
//    else
//    {
//        NSLog(@"did fail to  receive data , error: %@",  error);
//    }
//}
#pragma mark - ViewController self Method

- (void)viewWillAppear:(BOOL)animated
{
    //步骤4 设置动画
    self.title = @"我的鞋子";
    [self.animateView1 addAnimateWithType:0];
//    NSString *UUIDString = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultBluetoothDeviceUUID];
//    self.defaultDevice = [self.manager retrieveDeviceWithUUID:UUIDString];
//    if (self.defaultDevice) {
//        //连接默认设备
//        self.bindingDeviceButton.hidden = NO;
//        self.defaultDeviceLabel.text = self.defaultDevice.name;
//        //        JumaDeviceStateDisconnected = 0,
//        //        JumaDeviceStateConnecting,
//        //        JumaDeviceStateConnected,
//        [self loadDefaultDeviceStateLabelText];
//    }else{
//        
//        self.defaultDeviceLabel.text = @"";
//        self.defaultDeviceConnectStateTitleLabel.text = @"";
//        self.bindingDeviceButton.hidden = NO;
//    }
//    
    [self.tabBarController.tabBar setHidden:YES];
}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    
//    [SVProgressHUD dismiss];
//    
//}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

//#pragma mark --添加灌水动画
-(void)guanshui
{
    self.precent=0;
    
    //self.title = @"我的";
    // ------步骤3 用自定义view建立一个view，并使用set方法
    _animateView = [[SXWaveView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2 - SIDES/2, 60+MARGIN,SIDES, SIDES)];
    _animateView.layer.cornerRadius = SIDES/2;
    _animateView.layer.masksToBounds = YES;
    [self.bgImage addSubview:_animateView];
    _animateView.endless=YES;
    self.animateView1 = _animateView;
    [self.animateView1 setPrecent:self.precent description:@"°C" textColor:[UIColor orangeColor] bgColor:[UIColor clearColor] alpha:1 clips:NO];
    //    animateView1.endless=YES;
    [self.MyScrollView addSubview:_animateView1];
}

#pragma mark--- 断开连接的事件
- (void)duankailianjie{
//    停止计时器
    [self.myTimers invalidate];
    //    判断必须为连接状态才能 断开设备
//    if(self.defaultDevice.state==2)
//    {
//        //断开默认设备
//        [self.manager disconnectDevice:self.defaultDevice];
//        // 设置laber控件的值为空
//        self.stepNumLabel.text=@"0";
//        self.caloricValueLabel.text=@"0";
//        self.rowContentLabel.text=@"0°C";
//        self.rowContentLabel.text=@"0°C";
//    }
//    else
//    {
        [SVProgressHUD showErrorWithStatus:@"还没有连接蓝牙设备哦"];
        [SVProgressHUD dismissWithDelay:1];
//    }
    
}
//- (void)loadDefaultDeviceStateLabelText{
//    switch (self.defaultDevice.state) {
//        case 0:
//            self.defaultDeviceConnectStateTitleLabel.text = NSLocalizedStringFromTable(@"未连接", @"BaseStrings", nil);
//            
//            break;
//        case 1:
//            self.defaultDeviceConnectStateTitleLabel.text = NSLocalizedStringFromTable(@"正在连接", @"BaseStrings", nil);
//            
//            break;
//        case 2:
//            
//            self.defaultDeviceConnectStateTitleLabel.text = NSLocalizedStringFromTable(@"已连接", @"BaseStrings", nil);
//            
//            break;
//            
//        default:
//            break;
//    }
//}
//#pragma mark-----错误 每次打印 直接略过正在连接设备
//- (void)managerDidUpdateState:(JumaManager *)manager{
//    NSLog(@"shoes  manager.state = %ld",(long)manager.state);
//    if (manager.state == 5) {
//        
//        NSString *UUIDString = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultBluetoothDeviceUUID];
//        //        self.defaultDevice = [self.manager retrieveDeviceWithUUID:UUIDString];
//        NSLog(@"----0000066666---%@",UUIDString);
//        if (self.defaultDevice) {
//            [SVProgressHUD showWithStatus:@"正在连接设备"];
//            //连接默认设备
//            [self.manager connectDevice:self.defaultDevice];
//        }else{
//            
//        }
//    }
//}
//#pragma  mark - Bluetooth method
//
////连接成功
//- (void)manager:(JumaManager *)manager didConnectDevice:(JumaDevice *)device{
//    NSLog(@"successful");
//    
//    self.defaultDevice.delegate = self;
//    [self loadDefaultDeviceStateLabelText];
//    [SVProgressHUD showSuccessWithStatus:@"连接成功"];
//    [self getBluetoothDataButtonClick:self.getBluetoothDataButton];
//    [SVProgressHUD dismissWithDelay:1];
//    
//}
////
//////连接失败
////- (void)manager:(JumaManager *)manager didFailToConnectDevice:(JumaDevice *)device error:(NSError *)error{
////    NSLog(@"failful");
////    [self loadDefaultDeviceStateLabelText];
////    
////    [SVProgressHUD showErrorWithStatus:@"连接失败"];
////    [SVProgressHUD dismissWithDelay:1];
////}
////#pragma mark ----连`断开
////- (void)manager:(JumaManager *)manager didDisconnectDevice:(JumaDevice *)device error:(NSError *)error{
////    NSLog(@"---6666666666---disconnect");
////    
////    [self loadDefaultDeviceStateLabelText];
////    
////    [SVProgressHUD showErrorWithStatus:@"连接断开"];
////    [SVProgressHUD dismissWithDelay:1];
////}
//////发送数据
////- (void)device:(JumaDevice *)device didWriteData:(NSError *)error {
////    
////    NSLog(@"didWriteData = %@,error = %@",device,error);
////    if (error) {
////        NSLog(@"did fail to send data to %@, error : %@", device.name, error);
////    }
////    else {
////        NSLog(@"did send data to %@", device.name);
////    }
//}
//
@end
