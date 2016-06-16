//
//  PeripheralTableViewController.h
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

@interface PeripheralTableViewController : UITableViewController
{
    @public
    BabyBluetooth *baby;
}

@property __block NSMutableArray *services;
@property(strong,nonatomic)CBPeripheral *currPeripheral;

@end
