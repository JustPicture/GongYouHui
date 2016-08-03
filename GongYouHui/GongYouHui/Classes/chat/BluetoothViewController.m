//
//  BluetoothViewController.m
//  GongYouHui
//
//  Created by 陈伟荣 on 15/12/31.
//  Copyright © 2015年 tianqiwang. All rights reserved.
//

#import "BluetoothViewController.h"
#import "SVProgressHUD.h"


@interface BluetoothViewController ()

@property (nonatomic,strong)JumaDevice * connectDevice;
//原数据清空,重新开始扫描 再添加
@property (nonatomic,strong)NSMutableArray * deviceArray;
//内容成功
@property (nonatomic,assign)BOOL isConnectSuccessful;
@property (nonatomic,strong)NSIndexPath * selectIndexPath;

//停止扫描的属性
@property (strong, nonatomic) IBOutlet UIButton *stopScanDeviceBtn;
@end

@implementation BluetoothViewController
#pragma mark----UIViewController对象的视图即将消失、被覆盖或是隐藏时调用；
- (void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}
- (void)dealloc
{
    self.manager.delegate = nil;
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    self.deviceArray = [NSMutableArray arrayWithCapacity:1];
    self.isConnectSuccessful = NO;
    //    JumaManagerOptionShowPowerAlertKey   蓝牙关闭时回弹出警告框
    /*判断蓝牙的状态知否打开 若为打开 弹出警告 蓝牙关闭 当蓝牙关闭 的时候 回弹出警告框*/
    
    [self.manager setDelegate:self];
    
    [self.stopScanDeviceBtn setTitle:NSLocalizedStringFromTable(@"停止扫描", @"BaseStrings", nil) forState:UIControlStateNormal];
    
    //    若扫描出成功 有数据的芯片名字 再发送数据
    if (self.isConnectSuccessful==YES) {
        [self.stopScanDeviceBtn setTitle:NSLocalizedStringFromTable(@"发送数据", @"BaseStrings", nil) forState:UIControlStateNormal];
    }else {
        [self.stopScanDeviceBtn setTitle:NSLocalizedStringFromTable(@"停止扫描", @"BaseStrings", nil) forState:UIControlStateNormal];
    }
}
#pragma mark---扫描开始 设备的点击事件
- (IBAction)searchDeviceButtonClk:(UIButton *)sender {
    [SVProgressHUD showWithStatus:@"正在扫描设备..."];
    //原数据清空,重新开始扫描
    [self.deviceArray removeAllObjects];
    [self.tableView reloadData];
    //    调用蓝牙 开始扫描的方法
    [self.manager scanForDeviceWithOptions:nil];
    //    将停止扫描的 控件显示出来
    self.stopScanDeviceBtn.hidden = NO;
    //    如果说扫描到了设备就HUD动画停止
}
#pragma mark--停止扫描 点击事件
- (IBAction)stopScanDeviceClk:(UIButton *)sender {
    
    [SVProgressHUD dismiss];
    if (self.isConnectSuccessful) {
        UIAlertController * textAlertController =[UIAlertController alertControllerWithTitle:@"获取数据" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [textAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
        }];
        __weak BluetoothViewController * bluetoothVC = self;
        UIAlertAction * okbutton = [UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString * string = textAlertController.textFields[0].text;
            NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
            
            char code = 9;
            const unsigned char typeCode = (const unsigned char)code;
            
            [bluetoothVC.connectDevice writeData:data type:typeCode];
            
        }];
        UIAlertAction * cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [textAlertController addAction:okbutton];
        [textAlertController addAction:cancelButton];
        [self presentViewController:textAlertController animated:YES completion:nil];
        
    }else{
        [self.manager stopScan];
        self.stopScanDeviceBtn.hidden = YES;
    }
    
    
}


#pragma mark - JumaManager
//状态参数
//JumaManagerStateUnknown = 0,
//JumaManagerStateResetting,
//JumaManagerStateUnsupported,
//JumaManagerStateUnauthorized,
//JumaManagerStatePoweredOff,
//JumaManagerStatePoweredOn,

//初始化成功自动调用
- (void)managerDidUpdateState:(JumaManager *)manager{
    NSLog(@"JumaManager = %ld",(long)manager.state);
}

//开始扫描  发现设备
- (void)manager:(JumaManager *)manager didDiscoverDevice:(JumaDevice *)device RSSI:(NSNumber *)RSSI
{
    //    NSLog(@"--蓝牙设备会持续的发出信号来显示自己的存在, 手机每收到一次信号, JumaManagerDelegate 中的 manager:didDiscoverDevice:RSSI: 就可能会被调用一次.-%@",RSSI);
    [SVProgressHUD dismissWithDelay:1];
    
    NSLog(@"发现设备 device = %@ ,设备信号强度 = %@",device ,RSSI);
    
    [self.deviceArray addObject:device];
    
    //插入动画
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:self.deviceArray.count - 1 inSection:0];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

//停止扫描
- (void)managerDidStopScan:(JumaManager *)manager{
    NSLog(@"停止扫描 %@",manager);
}

//连接成功
- (void)manager:(JumaManager *)manager didConnectDevice:(JumaDevice *)device{
    NSLog(@"successful");
    [SVProgressHUD showSuccessWithStatus:@"连接成功"];
    [SVProgressHUD dismissWithDelay:1];
    
    self.connectDevice = device;
    self.connectDevice.delegate =self;
    
    self.isConnectSuccessful = YES;
    self.stopScanDeviceBtn.hidden = NO;
    [self.stopScanDeviceBtn setTitle:@"获取数据" forState:UIControlStateNormal];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectIndexPath];
    cell.detailTextLabel.text = [self deviceStateWithDevice:device];
    //设置默认蓝牙外设,方便以后自动连接;
    [[NSUserDefaults standardUserDefaults]setObject:device.UUID forKey:DefaultBluetoothDeviceUUID];
    NSLog(@"--6666666--%@",device.UUID);
    [self.navigationController popViewControllerAnimated:YES];
}

//连接失败
- (void)manager:(JumaManager *)manager didFailToConnectDevice:(JumaDevice *)device error:(NSError *)error{
    NSLog(@"failful");
    
    [SVProgressHUD showErrorWithStatus:@"连接失败"];
    [SVProgressHUD dismissWithDelay:1];
    
    self.isConnectSuccessful = NO;
    self.connectDevice = nil;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectIndexPath];
    cell.detailTextLabel.text = [self deviceStateWithDevice:device];
}

//连接断开
- (void)manager:(JumaManager *)manager didDisconnectDevice:(JumaDevice *)device error:(NSError *)error{
    NSLog(@"disconnect");
    
    [SVProgressHUD showErrorWithStatus:@"连接断开"];
    [SVProgressHUD dismissWithDelay:1];
    
    self.isConnectSuccessful = NO;
    self.connectDevice = nil;
    UITableViewCell * cell = [self cellForDevice:device];
    cell.detailTextLabel.text = [self deviceStateWithDevice:device];
}

//发送数据
- (void)device:(JumaDevice *)device didWriteData:(NSError *)error {
    
    NSLog(@"didWriteData = %@,error = %@",device,error);
    if (error) {
        NSLog(@"did fail to send data to %@, error : %@", device.name, error);
    }
    else {
        NSLog(@"did send data to %@", device.name);
    }
}

- (void)device:(JumaDevice *)device didUpdateData:(NSData *)data type:(const char)typeCode error:(NSError *)error {
    NSLog(@"didUpdateData error = %@",error);
    if (!error) {
        
        NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        Byte * test = (Byte *)[data bytes];
        
        for (int i = 0; i < [data length]; i++) {
            NSLog(@"Byte array = %d",test[i]);
        }
        
        NSLog(@"data -> string :%@",string);
        NSLog(@"did receive data %@  type code: %d", data, typeCode);
    }
    else {
        
        NSLog(@"did fail to  receive data , error: %@",  error);
        
    }
}


//查询device所在的Cell

- (UITableViewCell *)cellForDevice:(JumaDevice *)device{
    
    NSInteger idnex =  [self.deviceArray indexOfObject:device];
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:idnex inSection:0];
    return [self.tableView cellForRowAtIndexPath:indexpath];
}

//蓝牙连接状态
- (NSString *)deviceStateWithDevice:(JumaDevice *)device{
    
    //连接状态
    //    JumaDeviceStateDisconnected = 0,
    //    JumaDeviceStateConnecting,
    //    JumaDeviceStateConnected,
    
    switch (device.state) {
        case 0:
            return  NSLocalizedStringFromTable(@"Disconnected", @"BaseStrings", nil);
            break;
            
        case 1:
            return  NSLocalizedStringFromTable(@"Connecting", @"BaseStrings", nil);
            break;
        case 2:
            return  NSLocalizedStringFromTable(@"Connected", @"BaseStrings", nil);
            break;
        default:
            
            break;
    }
    
}

#pragma mark - tabelView -delegate Datasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JumaDevice * device = self.deviceArray[indexPath.row];
    
    static NSString * cellIdentifier = @"basicCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = device.name;
    cell.detailTextLabel.text = [self deviceStateWithDevice:device];
    
    return cell;
}

//链接设备
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    self.selectIndexPath = indexPath;
    
    if (self.isConnectSuccessful) {
        
        
    }else {
        
        JumaDevice * device = self.deviceArray[indexPath.row];
        [self isConnectDeviceAlertControllerWithDevice:device];
        
    }
}

//设置提示框   是否链接设备
- (void)isConnectDeviceAlertControllerWithDevice:(JumaDevice *)device{
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"提示", @"BaseStrings", nil) message:[NSString stringWithFormat:@"%@ : %@",NSLocalizedStringFromTable(@"是否链接设备", @"BaseStrings", nil),device.name]  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"连接", @"BaseStrings", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"链接设备");
        
        [SVProgressHUD showWithStatus:@"正在连接设备"];
        
        
        [self.manager connectDevice:device];
        
    }];
    
    UIAlertAction * cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"取消", @"BaseStrings", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancelButton];
    [alertVC addAction:okButton];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}


#pragma mark - CBCentralManager


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
