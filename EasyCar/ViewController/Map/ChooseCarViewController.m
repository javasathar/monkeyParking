//
//  ChooseCarViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/20.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ChooseCarViewController.h"

@interface ChooseCarViewController ()

@end

@implementation ChooseCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的车辆";
    self.view.backgroundColor = RGBA(242, 242, 248, 1);
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIScrollView *_mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    [self.view addSubview:_mainScroll];
    UIView *ad1 = [[UIView alloc] initWithFrame:CGRectMake(15, 15, UI_SCREEN_WIDTH-30, (UI_SCREEN_WIDTH-30)/2+80)];
    ad1.backgroundColor = [UIColor whiteColor];
    [_mainScroll addSubview:ad1];
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ad1.width, ad1.width/2)];
    img1.image = [UIImage imageNamed:@"mycars1"];
    [ad1 addSubview:img1];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseBMW)];
    img1.userInteractionEnabled = YES;
    [img1 addGestureRecognizer:tap1];
    
    UILabel *useLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, img1.bottom+10, 200, 15)];
    useLabel.text = @"车型:  宝马-Z4";
    useLabel.font = [UIFont systemFontOfSize:15];
    useLabel.textAlignment = NSTextAlignmentLeft;
    useLabel.textColor = RGBA(36, 36, 36, 1);
    [ad1 addSubview:useLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, useLabel.bottom+10, UI_SCREEN_WIDTH-20, 15)];
    timeLabel.text = @"位置:  TCL国际E城多媒体大厦停车场A点";
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.font = [UIFont systemFontOfSize:15];
    [ad1 addSubview:timeLabel];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, timeLabel.bottom+10, 200, 15)];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.text = @"停留:  2小时30分钟";
    addressLabel.font = [UIFont systemFontOfSize:15];
    [ad1 addSubview:addressLabel];
    
    UIView *ad2 = [[UIView alloc] initWithFrame:CGRectMake(15, ad1.bottom+15, UI_SCREEN_WIDTH-30, (UI_SCREEN_WIDTH-30)/2+80)];
    ad2.backgroundColor = [UIColor whiteColor];
    [_mainScroll addSubview:ad2];
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ad1.width, ad1.width/2)];
    img2.image = [UIImage imageNamed:@"mycars2"];
    [ad2 addSubview:img2];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseBenz)];
    img2.userInteractionEnabled = YES;
    [img2 addGestureRecognizer:tap2];
    
    UILabel *useLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, img2.bottom+10, 200, 15)];
    useLabel2.text = @"车型:  奔驰-CLS300";
    useLabel2.font = [UIFont systemFontOfSize:15];
    useLabel2.textAlignment = NSTextAlignmentLeft;
    useLabel2.textColor = RGBA(36, 36, 36, 1);
    [ad2 addSubview:useLabel2];
    
    UILabel *timeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, useLabel2.bottom+10, UI_SCREEN_WIDTH-20, 15)];
    timeLabel2.textColor = RGBA(36, 36, 36, 1);
    timeLabel2.text = @"位置:  TCL国际E城多媒体大厦停车场A点";
    timeLabel2.textAlignment = NSTextAlignmentLeft;
    timeLabel2.font = [UIFont systemFontOfSize:15];
    [ad2 addSubview:timeLabel2];
    
    UILabel *addressLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, timeLabel2.bottom+10, 200, 15)];
    addressLabel2.textAlignment = NSTextAlignmentLeft;
    addressLabel2.text = @"停留:  2小时30分钟";
    addressLabel2.font = [UIFont systemFontOfSize:15];
    addressLabel2.textColor = RGBA(36, 36, 36, 1);
    [ad2 addSubview:addressLabel2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chooseBMW
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ReturnCarInfo object:@"宝马-Z4"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseBenz
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ReturnCarInfo object:@"奔驰-CLS300"];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
