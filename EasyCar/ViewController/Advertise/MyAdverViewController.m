//
//  MyAdverViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/15.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "MyAdverViewController.h"
#import "TouFangAdViewController.h"

@interface MyAdverViewController ()

@end

@implementation MyAdverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的广告";
    [self.nav setTitle:@"我的广告" leftText:@"返回" rightTitle:nil showBackImg:YES];
    self.view.backgroundColor = RGBA(242, 242, 248, 1);
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"投放广告" style:(UIBarButtonItemStylePlain) target:self action:@selector(touAd)];
    
    UIScrollView *_mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64)];
    [self.view addSubview:_mainScroll];
    UIView *ad1 = [[UIView alloc] initWithFrame:CGRectMake(15, 15, UI_SCREEN_WIDTH-30, (UI_SCREEN_WIDTH-30)/2+60)];
    ad1.backgroundColor = [UIColor whiteColor];
    [_mainScroll addSubview:ad1];
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ad1.width, ad1.width/2)];
    img1.image = [UIImage imageNamed:@"img1"];
    [ad1 addSubview:img1];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, img1.bottom+10, 200, 15)];
    timeLabel.text = @"时间：2015-03-22 13:00";
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.font = [UIFont systemFontOfSize:15];
    [ad1 addSubview:timeLabel];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, timeLabel.bottom+10, 200, 15)];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.text = @"地点：TCL国际E城停车场2层";
    addressLabel.font = [UIFont systemFontOfSize:15];
    [ad1 addSubview:addressLabel];
    
    UIView *ad2 = [[UIView alloc] initWithFrame:CGRectMake(15, ad1.bottom+15, UI_SCREEN_WIDTH-30, (UI_SCREEN_WIDTH-30)/2+60)];
    ad2.backgroundColor = [UIColor whiteColor];
    [_mainScroll addSubview:ad2];
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ad1.width, ad1.width/2)];
    img2.image = [UIImage imageNamed:@"ad1"];
    [ad2 addSubview:img2];
    
    UILabel *timeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, img1.bottom+10, 200, 15)];
    timeLabel2.text = @"时间：2015-03-22 13:00";
    timeLabel2.textAlignment = NSTextAlignmentLeft;
    timeLabel2.font = [UIFont systemFontOfSize:15];
    [ad2 addSubview:timeLabel2];
    
    UILabel *addressLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, timeLabel.bottom+10, 200, 15)];
    addressLabel2.textAlignment = NSTextAlignmentLeft;
    addressLabel2.text = @"地点：TCL国际E城停车场2层";
    addressLabel2.font = [UIFont systemFontOfSize:15];
    [ad2 addSubview:addressLabel2];
    
    UIView *ad3 = [[UIView alloc] initWithFrame:CGRectMake(15, ad2.bottom+15, UI_SCREEN_WIDTH-30, (UI_SCREEN_WIDTH-30)/2+60)];
    ad3.backgroundColor = [UIColor whiteColor];
    [_mainScroll addSubview:ad3];
    UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ad1.width, ad1.width/2)];
    img3.image = [UIImage imageNamed:@"ad2"];
    [ad3 addSubview:img3];
    
    UILabel *timeLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10, img1.bottom+10, 200, 15)];
    timeLabel3.text = @"时间：2015-03-22 13:00";
    timeLabel3.textAlignment = NSTextAlignmentLeft;
    timeLabel3.font = [UIFont systemFontOfSize:15];
    [ad3 addSubview:timeLabel3];
    
    UILabel *addressLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10, timeLabel.bottom+10, 200, 15)];
    addressLabel3.textAlignment = NSTextAlignmentLeft;
    addressLabel3.text = @"地点：TCL国际E城停车场3层";
    addressLabel3.font = [UIFont systemFontOfSize:15];
    [ad3 addSubview:addressLabel3];
    
    _mainScroll.contentSize = CGSizeMake(UI_SCREEN_WIDTH, ad3.bottom+10);
}

//投放广告
- (void)touAd
{
    TouFangAdViewController *myAdvc = [[TouFangAdViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController pushViewController:myAdvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
