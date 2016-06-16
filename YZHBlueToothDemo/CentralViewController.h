//
//  CentralViewController.h
//  YZHBlueToothDemo
//
//  Created by yinzhihao on 16/6/12.
//  Copyright © 2016年 yzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CentralViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) UITableView *tableView;
@end
