//
//  AppDelegate.m
//  GongYouHui
//
//  Created by wendf on 16/3/8.
//  Copyright © 2016年 GYH. All rights reserved.
//

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"



#import "AppDelegate.h"

#import "PersonCenterViewController.h"
#import "PageRootViewController.h"
#import "LoginViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"102a9f9a91da6"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
                 
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.iclouduv.com:8080"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx8ee92b541a4e9068"
                                       appSecret:@"75bbdb5649b2f3f8e3e0618b1707c1a9"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105238968"
                                      appKey:@"KEYClriENz1htrF1GJF"
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
             default:
                 break;
         }
     }];

    //跟新版本号
//    [self checkAppVersionToUpdate];
    [[UINavigationBar  appearance]  setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar  appearance]  setTintColor:[UIColor whiteColor]];
    [[UINavigationBar  appearance]  setBarTintColor:RGBCOLORV(0x18b4ed)];

    //启动页面
    //第一次加载
    BOOL isFristLoadMain = [[NSUserDefaults standardUserDefaults] boolForKey:@"!isFristLoadMain"];
    if (!isFristLoadMain){
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _tabBarViewController = [[MyTabBarViewController alloc]init];
        PageRootViewController *pageViewController = [[PageRootViewController alloc]init];
        self.window.rootViewController = pageViewController;
        [self.window makeKeyAndVisible];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"!isFristLoadMain"];
    }else{
        //跳转主界面
        [self startApp];
    }
    return YES;
}

-(void)startApp
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    _tabBarViewController = [[MyTabBarViewController alloc]init];
    PersonCenterViewController *leftVC = [[PersonCenterViewController alloc] init];
    self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:_tabBarViewController];
    self.window.rootViewController = self.LeftSlideVC;
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//更新版本
//先不用
//- (void)checkAppVersionToUpdate{
//    
//    NSString * urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=1068051213"];
//    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    
//    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSError * error;
//        NSDictionary * resp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
//        if (error) {
//            NSLog(@"error : %@",error);
//        }else {
//            
//            NSArray * resultArray = [resp objectForKey:@"results"];
//            NSDictionary * dictinfo = resultArray[0];
//            NSString * latestVersion  = [dictinfo objectForKey:@"version"];
//            NSString * trackViewUrl = [dictinfo objectForKey:@"trackViewUrl"];
//            NSString * trackName = [dictinfo objectForKey:@"trackName"];
//            
//            
//            NSDictionary * infoDict = [[NSBundle mainBundle] infoDictionary];
//            NSString * currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
//            
//            //            NSLog(@"latestVersion = %@currentVersion = %@",latestVersion,currentVersion);
//            NSArray * latestVersionArray = [latestVersion componentsSeparatedByString:@"."];
//            NSArray * currentVersionArray = [currentVersion componentsSeparatedByString:@"."];
//            
//            NSInteger count = latestVersionArray.count > currentVersionArray.count?currentVersionArray.count:latestVersionArray.count;
//            
//            for (NSInteger i = 0 ; i< count; i++) {
//                
//                if ([latestVersionArray[i] integerValue] >[currentVersionArray[i] integerValue]) {
//                    
//                    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"检查更新:%@",trackName] message:[NSString stringWithFormat:@"发现最新版本(%@),是否升级",latestVersion] preferredStyle:UIAlertControllerStyleAlert];
//                    
//                    UIAlertAction * okbutton = [UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        
//                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:trackViewUrl]];
//                        
//                    }];
//                    
//                    UIAlertAction * cancelbutton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                        
//                    }];
//                    [alertVC addAction:okbutton];
//                    [alertVC addAction:cancelbutton];
//                    
//                    [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
//                    
//                    
//                }
//            }
//            
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//    
//    
//    
//}



@end
