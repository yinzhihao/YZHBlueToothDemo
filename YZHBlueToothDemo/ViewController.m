//
//  ViewController.m
//  YZHBlueToothDemo
//
//  Created by yinzhihao on 16/6/12.
//  Copyright © 2016年 yzh. All rights reserved.
//

#import "ViewController.h"
#import "CentralViewController.h"
#import "PeripheralViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
- (IBAction)centralAction:(id)sender {
    CentralViewController *vc = [[CentralViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)peripheralAction:(id)sender {
    PeripheralViewController *vc = [[PeripheralViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
