////
////  ReaderManagerVC.m
////  GongYouHui
////
////  Created by 陈伟荣 on 16/6/11.
////  Copyright © 2016年 tianqiwang. All rights reserved.
////
//
#import "ReaderManagerVC.h"
//#import<MediaPlayer/MediaPlayer.h>
//#import "rfidreader.h"
//#import "extra.h"
//
//#import "FirstAidDetailViewController.h"
////#import "DeviceDetailViewController.h"
////#import "BottleInfoViewController.h"
////#import "OpenOrCloseViewController.h"
//#define __kWidth  [UIScreen mainScreen].bounds.size.width
//#define __kHeight [UIScreen mainScreen].bounds.size.height
//
@interface ReaderManagerVC ()
{
    NSString * LogInfo;
    UIImageView * loginStatusView;
    UILabel * statusLb;
    NSDate *fireDate;
    NSTimer *timer;
}
@end
//
@implementation ReaderManagerVC
//- (void)viewDidAppear:(BOOL)animated{
////
//    [self.tabBarController.tabBar setHidden:YES];
//    //开启定时器
//    [self startPainting];
//}
//- (void)startPainting{
//    timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(readerManagerTest)  userInfo:nil repeats:YES];
//}
//
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NFC";
    self.view.backgroundColor = [UIColor whiteColor];

//
//    //音量调到最大
//    MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
//    mpc.volume = 1.0;
//    self.view.backgroundColor = [UIColor whiteColor];
    statusLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, KWIDTH, 50)];
//    
    [self initViewnfc];
}
-(void)initViewnfc{
    statusLb.text = @"正在识别,请稍后";
    statusLb.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:statusLb];
    loginStatusView = [[UIImageView alloc]initWithFrame:CGRectMake(0, KHEIGHT-250, KWIDTH, 250)];
    loginStatusView.image = [UIImage imageNamed:@"nfc_interfacility"];
    [self.view addSubview:loginStatusView];
//    
////    [self performSelector:@selector(readerManagerTest) withObject:nil afterDelay:0.5];
}
//- (void)readerManagerTest {
//    statusLb.text = @"正在识别,请稍后";
////    statusLb.text = @"正在识别,请稍后";
//    int rc;
//    NSMutableArray * dataSource = [NSMutableArray arrayWithCapacity:0];
//    NSLog(@"%s","reader manager Test get reader");
//    LogInfo = @"";
//    RFIDReader * reader = [RFIDReader getInstance:@"sound",nil];
//    if (reader == nil){
//        LogInfo = [LogInfo
//                   stringByAppendingString: [NSString stringWithFormat:@"fail to get rfidreaer \n reader manager  test end:\n"]];
//        
//        puts("fail to get rfidreaer");
//        statusLb.text = @"未检测到外接设备,请插入重试";
//        return;
//    }
//    LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"get rfidreaer ok \n"]];
//    //    rc = [reader control:CONNECT, @"sound"];
//    rc = [reader control:ULTRA_CONNECT, @"sound", 3, 2, 5512];  //for ios, we can set the freq directly
//    if (rc < 0){
//        LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"fail to connect reader  :%@\n",
//                                                     errorString([reader lastError])]];
//        LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"ID card test end:\n"]];
//        
//        statusLb.text = @"连接设备失败";
//        [self performSelector:@selector(initViewnfc) withObject:nil afterDelay:1];
////        [self readerManagerTest];
//        return;
//    }
//    
//    statusLb.text = @"连接设备成功,正在读取";
//    loginStatusView.image = [UIImage imageNamed:@"swiping"];
//    LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"connect reader ok \n"]];
//    NSLog(@"%s","connect reader ok");
//    
//    
//    NSData *msn = [[NSMutableData alloc] init];
//    [reader control:GET_MSN, msn];
//    NSLog(@"GET_MSN response:%@",msn);
//    
//    [reader control:GET_OTP_SN, msn];
//    NSLog(@"GET_OTP_SN response:%@",msn);
//    
//    [reader control:GET_FIRMWARE_VERSION, msn];
//    NSLog(@"GET_FIRMWARE_VERSION response:%@",msn);
//    NSLog(@"%s","close antenna");
//    rc = [reader control:ANTENNA_OFF];
//    if (rc < 0){
//        LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"fail to close antenna:%@\n",
//                                                     errorString([reader lastError])]];
//        LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"reader manager test end:\n"]];
//        statusLb.text = @"antenna 失败";
////        [self readerManagerTest];
//        return;
//    }
//    LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"close antenna ok \n"]];
//    NSLog(@"%s","close antenna ok");
//    
//    NSLog(@"%s","open antenna");
//    rc = [reader control:ANTENNA_ON];
//    if (rc < 0){
//        LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"fail to open antenna:%@\n",
//                                                     errorString([reader lastError])]];
//        LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"reader manager test end:\n"]];        statusLb.text = @"antenna 失败";
////        [self readerManagerTest];
//
//        return;
//    }
//    LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"open antenna ok \n"]];
//    NSLog(@"%s","open antenna ok");
//    
//    NSLog(@"%s","get power\n");
//    rc = [reader control:GET_POWER];
//    if (rc < 0){
//        LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"fail to get power:%@\n",
//                                                     errorString([reader lastError])]];
//        LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"reader manager test end:\n"]];
//        statusLb.text= @"power 失败";
////        [self readerManagerTest];
//        return;
//    }
//    LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"get power ok \n"]];
//    NSLog(@"%s","get power ok:");
//    LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"power:%d \n", rc]];
//    
//    NSDictionary * power = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"power:%d \n", rc] forKey:@"power"];
//    [dataSource addObject:power];
//    
//    rc = [reader open:@"iso14443A_card"];
//    if (rc < 0){
//        LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"fail to open iso14443A card:%@\n",
//                                                     errorString([reader lastError])]];
//        LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"reader manager test end:\n"]];
//        statusLb.text = @"未检测到卡";
////        [self readerManagerTest];
//        return;
//    }
//    LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"open iso14443A card  ok \n"]];
//    NSLog(@"%s","open iso14443A card ok");
//    
////   char str[144] = "com.iclouduv2225,13162333854,18817509212,A,0,0,李鹏飞,,,魏菊|ac2015002,aid";
////    char str[48] = "李鹏飞,13162333854,A,魏菊,18817509212";
////    NSData *data = [NSData dataWithBytes:str length:48];
////    int rc1 = [reader writeData:0 size:48 data:data];
////    if (rc1 < 0){
////        NSLog(@"error: %@",errorString(rc));
////        return; }
////    
////    NSData *u = [reader readData:3 size:50];
////    NSString *su=[[NSString alloc] initWithData:u encoding:NSUTF8StringEncoding];
////    NSData *uid2 = [reader readData:2 size:100];
////    NSString *suid2=[[NSString alloc] initWithData:uid2 encoding:NSUTF8StringEncoding];
//    NSData *uid1 = [reader readData:34 size:34];
//    NSString *suid1=[[NSString alloc] initWithData:uid1 encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",suid1);
//    if (suid1!=nil) {
//        if ([[suid1 substringFromIndex:suid1.length-2] isEqualToString:@"rt"]) {
////            OpenOrCloseViewController *openOrclose = [[OpenOrCloseViewController alloc]init];
////            openOrclose.suojuId = [NSString stringWithFormat:@"%d",12];
////            openOrclose.lockNumber = [NSString stringWithFormat:@"%d",85];
////            [self.navigationController pushViewController:openOrclose animated:YES];
//        }
//    }
//    
//    
//    NSData *uid = [reader readData:5 size:120];
//    NSString *suid=[[NSString alloc] initWithData:uid encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",suid);
// 
//    NSArray * array = [suid componentsSeparatedByString:@","];
//    
//    if (uid == nil){
//        LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"fail to get uid \n reader manager test end:\n"]];
//        LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"fail to get uid :%@\n",
//                                                     errorString([reader lastError])]];
//        statusLb.text = @"读卡失败";
//        LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"reader manager test end:\n"]];
//        return;
//    }
//    LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"get uid  ok \n"]];
//    LogInfo = [LogInfo stringByAppendingString: [NSString stringWithFormat:@"UID: "]];
//    
//     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//         //衣服和帽子aidInfoTandroid.com:pkgcom.icloudu
//         if ([[[array lastObject] substringToIndex:7] isEqualToString:@"aidInfo"]) {
//             statusLb.text = @"正在读取卡号信息";
//             //关闭定时器
//             [self stopPainting];
//             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//             NSString *str = array[0];
//             NSString *eidStr = [str substringFromIndex:str.length-3];
//             
//             NSString *str1 = array[9];
//             NSString *eidstr1 = [str1 substringToIndex:2];
//             NSDictionary *dic = nil;
//             //dic = @{@"userId":eidStr};
//             dic = @{@"userId":eidStr,@"username":array[6],@"bloodType":array[3],@"phone":array[1],@"bloodType":array[3],@"directlyLeaderName":eidstr1,@"directlyLeaderPhone":array[2],@"instancyContactName":array[4],@"instancyContactPhone":array[5]};
//             FirstAidDetailViewController *nfcview = [storyboard instantiateViewControllerWithIdentifier:@"FirstAidDetailViewController"];
////             nfcview.dataDic = dic;
//             nfcview.title = @"急救查询";
//             [self.navigationController pushViewController:nfcview animated:YES];
//
//         }
//         //[string substringFromIndex:2];//截取掉下标2之前的字符串
//         //巡检,公司设备
//         if ([[[array lastObject] substringToIndex:4] isEqualToString:@"http"]) {
//             NSData *uid1 = [reader readData:5 size:150];
//             NSString *suid1=[[NSString alloc] initWithData:uid1 encoding:NSUTF8StringEncoding];
//             if ([suid1  isEqual: @""]) {
//                 statusLb.text = @"读卡失败";
//                 return;
//             }else{
//                 statusLb.text = @"正在读取卡号信息";
//                 //关闭定时器
//                 [self stopPainting];
//                 /**
//                  application/com.iclouduv18,
//                  1号车间灭火器,
//                  MHQ-01,
//                  ,
//                  http://www.iclouduv.com:8080/upload/files2016/04/01/1604011743086038.jpg,
//                  http://www.iclouduv.co
//                  principalName;
//                  deviceState;//
//                  deviceCode;
//                  **/
//                 NSArray * array1 = [suid1 componentsSeparatedByString:@","];
//                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
////                 DeviceDetailViewController *deviceDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"DeviceDetailViewController"];
////                 NSString *str = array1[0];
////                 NSString *eidStr = [str substringFromIndex:str.length-2];
////                 NSDictionary *dic = nil;
////                 dic = @{@"deviceId":eidStr,@"imgUrl":array1[4],@"deviceName":array1[1],@"deviceCode":array1[2],@"principalName":array1[3]};
////                 deviceDetailVC.dataDic = dic;
////                 deviceDetailVC.title = @"设备信息";
//                 
//  //               [self.navigationController pushViewController:deviceDetailVC animated:YES];
//             }
//         }
//         //气瓶
//         if ([[array lastObject] isEqualToString:@"biTandroid.com:pkgcom.iclou"]) {
//             statusLb.text = @"正在读取卡号信息";
//             //关闭定时器
//             [self stopPainting];
//             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//             NSString *st1 = array[0];
//             NSString *eidst1 = [st1 substringFromIndex:st1.length - 1];
//             NSDictionary *dic = nil;
//             dic = @{@"id":eidst1,@"model":array[2],@"volume":array[4],@"weight":array[3],@"workingPressure":array[11],@"hydrostaticPressure":array[7],@"medium":@"",@"burstPressure":array[6],@"designLife":array[5],@"retest":array[9],@"thread":array[10],@"productionDate":@"-",@"ree":array[8]};
////             BottleInfoViewController *BottleInfoView = [storyboard instantiateViewControllerWithIdentifier:@"BottleInfoViewController"];
//////             BottleInfoView.ary = array3;
////             BottleInfoView.dic = dic;
////             BottleInfoView.title = @"气瓶信息";
////             [self.navigationController pushViewController:BottleInfoView animated:YES];
////             
//         }
//     });
//    if (array == nil) {
//        statusLb.text = @"读卡失败";
//    }
//}
//- (void)stopPainting{
//    if (timer != nil) {
//        [timer invalidate];
//    }
//    
//}
//- (void)viewDidDisappear:(BOOL)animated{
//    [self stopPainting];
//}
//- (void)viewWillAppear:(BOOL)animated{
//    [self stopPainting];
//}
@end
