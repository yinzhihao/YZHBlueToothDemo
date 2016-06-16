//
//  CharacteristicViewController.h
//  YZHBlueToothDemo
//
//  Created by yinzhihao on 16/6/16.
//  Copyright © 2016年 yzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "PeripheralInfo.h"
#import "SVProgressHUD.h"

@interface CharacteristicViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
@public
    BabyBluetooth *baby;
    NSMutableArray *sect;
    __block  NSMutableArray *readValueArray;
    __block  NSMutableArray *descriptors;
}

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)CBCharacteristic *characteristic;
@property (nonatomic,strong)CBPeripheral *currPeripheral;

@end
