//
//  PeripheralViewController.m
//  YZHBlueToothDemo
//
//  Created by yinzhihao on 16/6/12.
//  Copyright © 2016年 yzh. All rights reserved.
//

#import "PeripheralViewController.h"
#import "SVProgressHUD.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define notiyCharacteristicUUID @"2AD09E73-3340-45C1-9800-20E19A628E71"
#define readwriteCharacteristicUUID @"883856FA-8BB3-40D5-85BB-34A0E7243512"
#define readCharacteristicUUID @"646AB3CE-6CBC-42D0-8E3C-9A33A33A96AC"
#define ServiceUUID1 @"D27BE94B-BECC-4920-84D9-E0352CFACF2D"
#define ServiceUUID2 @"CF42E98C-B898-4557-9DEC-F19007CDF7BA"

@interface PeripheralViewController ()
{
    // 外设管理
    CBPeripheralManager *peripheralManager;
    //定时器
    NSTimer *timer;
}
@end

@implementation PeripheralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /*
     1. 打开peripheralManager，设置peripheralManager的委托
     2. 创建characteristics，characteristics的description 创建service，把characteristics添加到service中，再把service添加到peripheralManager中
     3. 开启广播advertising
     4. 对central的操作进行响应
     - 4.1 读characteristics请求
     - 4.2 写characteristics请求
     - 4.4 订阅和取消订阅characteristics
     */
    
    /*
     和CBCentralManager类似，蓝牙设备打开需要一定时间，打开成功后会进入委托方法
     - (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral;
     模拟器永远也不会得CBPeripheralManagerStatePoweredOn状态
     */
    peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    
}

#pragma mark -CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"infoDic:%@",infoDic);
    
    NSString *name = [[UIDevice currentDevice] name];
    
    NSString *systemName = [[UIDevice currentDevice] systemName];
    
    switch (peripheral.state) {
        case CBPeripheralManagerStateUnknown:
            NSLog(@">>>CBPeripheralManagerStateUnknown");
            break;
        case CBPeripheralManagerStateResetting:
            NSLog(@">>>CBPeripheralManagerStateResetting");
            break;
        case CBPeripheralManagerStateUnsupported:
            NSLog(@">>>CBPeripheralManagerStateUnsupported");
            break;
        case CBPeripheralManagerStateUnauthorized:
            NSLog(@">>>CBPeripheralManagerStateUnauthorized");
            break;
        case CBPeripheralManagerStatePoweredOff:
            NSLog(@">>>CBPeripheralManagerStatePoweredOff");
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备名%@已经关闭",systemName]];
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@">>>CBCentralManagerStatePoweredOn");
            
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备名%@已经打开，可以使用center进行连接",systemName]];
            
            [self setup];
            break;
        default:
            break;
    }
}

//配置bluetooch的
- (void)setup
{
    //characteristics字段描述
    CBUUID *CBUUIDCharacteristicUserDescriptionStringUUID = [CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString];
    
    /*
     可以通知的Characteristic
     properties：CBCharacteristicPropertyNotify
     permissions CBAttributePermissionsReadable
     */
    CBMutableCharacteristic *notiyCharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:notiyCharacteristicUUID] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    
    /*
     可读写的characteristics
     properties：CBCharacteristicPropertyWrite | CBCharacteristicPropertyRead
     permissions CBAttributePermissionsReadable | CBAttributePermissionsWriteable
     */
    CBMutableCharacteristic *readwriteCharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:readwriteCharacteristicUUID] properties:CBCharacteristicPropertyWrite | CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable | CBAttributePermissionsWriteable];
    //设置description
    CBMutableDescriptor *readwriteCharacteristicDescription1 = [[CBMutableDescriptor alloc]initWithType: CBUUIDCharacteristicUserDescriptionStringUUID value:@"name"];
    [readwriteCharacteristic setDescriptors:@[readwriteCharacteristicDescription1]];
    
    
    /*
     只读的Characteristic
     properties：CBCharacteristicPropertyRead
     permissions CBAttributePermissionsReadable
     */
    CBMutableCharacteristic *readCharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:readCharacteristicUUID] properties:CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable];
    
    
    //service1初始化并加入两个characteristics
    CBMutableService *service1 = [[CBMutableService alloc]initWithType:[CBUUID UUIDWithString:ServiceUUID1] primary:YES];
    [service1 setCharacteristics:@[notiyCharacteristic,readwriteCharacteristic]];
    
    //service2初始化并加入一个characteristics
    CBMutableService *service2 = [[CBMutableService alloc]initWithType:[CBUUID UUIDWithString:ServiceUUID2] primary:YES];
    [service2 setCharacteristics:@[readCharacteristic]];
    
    //添加后就会调用代理的- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
    [peripheralManager addService:service1];
    [peripheralManager addService:service2];
}

//perihpheral添加了service
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(nullable NSError *)error
{
    NSLog(@"did Add Service...");
    NSLog(@"peripheral : %@",peripheral);
    NSLog(@"service : %@",service);
    [peripheralManager startAdvertising:@{
                                          CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:ServiceUUID1],[CBUUID UUIDWithString:ServiceUUID2]],
                                          CBAdvertisementDataLocalNameKey : [[UIDevice currentDevice] systemName]
                                          }];
}

//peripheral开始发送advertising
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(nullable NSError *)error
{
    NSLog(@"Did Start Advertising");
//    [SVProgressHUD showInfoWithStatus:@"开始发送广播！"];
}



//订阅characteristics
-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic{
    NSLog(@"订阅了 %@的数据",characteristic.UUID);
    //每秒执行一次给主设备发送一个当前时间的秒数
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendData:) userInfo:characteristic  repeats:YES];
}

//取消订阅characteristics
-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic{
    NSLog(@"取消订阅 %@的数据",characteristic.UUID);
    //取消回应
    [timer invalidate];
}

//发送数据，发送当前时间的秒数
-(BOOL)sendData:(NSTimer *)t {
    CBMutableCharacteristic *characteristic = t.userInfo;
    NSDateFormatter *dft = [[NSDateFormatter alloc]init];
    [dft setDateFormat:@"ss"];
    NSLog(@"%@",[dft stringFromDate:[NSDate date]]);
    
    //执行回应Central通知数据
    return  [peripheralManager updateValue:[[dft stringFromDate:[NSDate date]] dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:(CBMutableCharacteristic *)characteristic onSubscribedCentrals:nil];
    
}


//读characteristics请求
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request{
    NSLog(@"didReceiveReadRequest");
    //判断是否有读数据的权限
    if (request.characteristic.properties & CBCharacteristicPropertyRead) {
        NSData *data = request.characteristic.value;
        [request setValue:data];
        //对请求作出成功响应
        [peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
    }else{
        [peripheralManager respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
    }
}


//写characteristics请求
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests{
    NSLog(@"didReceiveWriteRequests");
    CBATTRequest *request = requests[0];
    
    //判断是否有写数据的权限
    if (request.characteristic.properties & CBCharacteristicPropertyWrite) {
        //需要转换成CBMutableCharacteristic对象才能进行写值
        CBMutableCharacteristic *c =(CBMutableCharacteristic *)request.characteristic;
        c.value = request.value;
        [peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
    }else{
        [peripheralManager respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
    }
    
    
}

@end
