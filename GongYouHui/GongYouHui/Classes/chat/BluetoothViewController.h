//
//  BluetoothViewController.h
//  GongYouHui
//
//  Created by 陈伟荣 on 15/12/31.
//  Copyright © 2015年 tianqiwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <JumaBluetoothSDK/JumaBluetoothSDK.h>


@interface BluetoothViewController : UIViewController<JumaManagerDelegate,JumaDeviceDelegate,UITableViewDataSource,UITableViewDelegate>

//1.创建中心设备
@property (nonatomic,strong)JumaManager * manager;
@property (strong, nonatomic) IBOutlet UITableView *tableView;




@end
