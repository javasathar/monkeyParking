//
//  MyCarWeiViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/20.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "MyCarWeiViewController.h"
#import "ChooseTimeViewController.h"

@interface MyCarWeiViewController ()
{
    UIButton *hourBtn;
    UIButton *monthBtn;
}
@end

@implementation MyCarWeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = RGBA(242, 242, 248, 1);
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIScrollView *_mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    [self.view addSubview:_mainScrollView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, UI_SCREEN_WIDTH-20, 200)];
    topView.layer.borderColor = [RGBA(220, 220, 220, 1) CGColor];
    topView.layer.borderWidth = 0.5;
    topView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:topView];
    topView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapTop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseMonthAction)];
    [topView addGestureRecognizer:tapTop];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5,150, 20)];
    titleLabel.textColor = RGBA(230, 137, 14, 1);
    titleLabel.text = @"东区A12";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:18];
    [topView addSubview:titleLabel];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabel.bottom+10, 200, 20)];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.text = @"TCL国际E城地下停车场";
    addressLabel.textColor = RGBA(36, 36, 36, 1);
    addressLabel.font = [UIFont boldSystemFontOfSize:16];
    [topView addSubview:addressLabel];
    
    UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, addressLabel.bottom+10, 290, 20)];
    weekLabel.text = @"周一、周二、周三、周四、周五、周六、周日";
    weekLabel.textColor = RGBA(81, 81, 81, 1);
    weekLabel.font = [UIFont systemFontOfSize:14];
    weekLabel.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:weekLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, weekLabel.bottom+10, 290, 20)];
    timeLabel.text = @"08:00-09:30";
    timeLabel.textColor = RGBA(81, 81, 81, 1);
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:timeLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, timeLabel.bottom+20, topView.width, 0.5)];
    line.backgroundColor = RGBA(220, 220, 220, 1);
    [topView addSubview:line];
    
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, line.bottom+20, 40, 20)];
    monthLabel.text = @"月租";
    monthLabel.font = [UIFont boldSystemFontOfSize:15];
    monthLabel.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:monthLabel];
    
    UITapGestureRecognizer *chooseTime = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseMonthAction)];
    monthLabel.userInteractionEnabled = YES;
    [monthLabel addGestureRecognizer:chooseTime];
    
    monthBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    monthBtn.frame = CGRectMake(monthLabel.right, line.bottom+20, 20, 20);
    [monthBtn setImage:[UIImage imageNamed:@"unselect"] forState:(UIControlStateNormal)];
    [monthBtn setImage:[UIImage imageNamed:@"select"] forState:(UIControlStateSelected)];
    [monthBtn addTarget:self action:@selector(chooseMonth:) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:monthBtn];
    
    UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(topView.width-80, line.bottom+20, 40, 20)];
    hourLabel.text = @"时租";
    hourLabel.font = [UIFont boldSystemFontOfSize:15];
    hourLabel.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:hourLabel];
    
    UITapGestureRecognizer *choosehour = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseMonthAction)];
    hourLabel.userInteractionEnabled = YES;
    [hourLabel addGestureRecognizer:choosehour];
    
    hourBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    hourBtn.frame = CGRectMake(hourLabel.right, line.bottom+20, 20, 20);
    [hourBtn addTarget:self action:@selector(chooseTime:) forControlEvents:(UIControlEventTouchUpInside)];
    [hourBtn setImage:[UIImage imageNamed:@"unselect"] forState:(UIControlStateNormal)];
    [hourBtn setImage:[UIImage imageNamed:@"select"] forState:(UIControlStateSelected)];
    [topView addSubview:hourBtn];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, topView.bottom+10, UI_SCREEN_WIDTH-20, (UI_SCREEN_WIDTH-20)*0.8956)];
    imageV.image = [UIImage imageNamed:@"carBg1"];
    [_mainScrollView addSubview:imageV];
    
    _mainScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, imageV.bottom+10);
    
}

//选择月份
- (void)chooseMonth:(UIButton *)sender
{
    hourBtn.selected = NO;
    sender.selected = !sender.isSelected;
}

//选择时间
- (void)chooseTime:(UIButton *)sender
{
    monthBtn.selected = NO;
    sender.selected = !sender.isSelected;
    
}

//选择时间--月份
- (void)chooseMonthAction
{
    ChooseTimeViewController *chooseTime = [[ChooseTimeViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    chooseTime.ismonth = YES;
    [self.navigationController pushViewController:chooseTime animated:YES];
}

////选择时间--小时
//- (void)chooseHourAction
//{
//    ChooseTimeViewController *chooseTime = [[ChooseTimeViewController alloc] init];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self.navigationItem setBackBarButtonItem:backItem];
//    chooseTime.ismonth = NO;
//    [self.navigationController pushViewController:chooseTime animated:YES];
//}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
