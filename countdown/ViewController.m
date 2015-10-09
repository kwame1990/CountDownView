//
//  ViewController.m
//  countdown
//
//  Created by KWAME on 15/8/10.
//  Copyright (c) 2015年 autohome. All rights reserved.
//

#import "ViewController.h"
#import "CountDownView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化countDownView 设置倒计时终止时间。
    CountDownView *countDown = [[CountDownView alloc]initWithFrame:CGRectMake(100, 100, 176, 20) shutDownTime:@"2015-11-30 14:21:00"];
    [self.view addSubview:countDown];
}


@end
