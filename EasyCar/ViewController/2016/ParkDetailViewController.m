//
//  ParkDetailViewController.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/4/29.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ParkDetailViewController.h"
#import "CircularView.h"
#import "YuYueStopViewController.h"
@interface ParkDetailViewController ()
//全部车位
@property (weak, nonatomic) IBOutlet UILabel *allSpaceLabel;
//剩余车位
@property (weak, nonatomic) IBOutlet UILabel *beleftSpaceLabel;
//圆形进度条
@property (weak, nonatomic) IBOutlet UIView *circularView;
//停车场名
@property (weak, nonatomic) IBOutlet UILabel *parkNameLabel;
//停车场详细地址
@property (weak, nonatomic) IBOutlet UILabel *parkAddressLabel;
//停车场距离
@property (weak, nonatomic) IBOutlet UILabel *parkDisdanceLabel;


@end

@implementation ParkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.nav setTitle:@"停车场简介" leftText:nil rightTitle:nil showBackImg:YES];
    [self initial];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (_hiddenBottomBar) {
        _bottomBar.hidden = YES;
    }
}
-(void)initial
{
    [self initialPark];
    [self initialCircular];

}
#pragma mark 加载车库信息
-(void)initialPark
{
    _parkNameLabel.text = _park.parkName;
    _parkAddressLabel.text = _park.address;
    _parkDisdanceLabel.text = [NSString stringWithFormat:@"%@km",_park.distance];
    _beleftSpaceLabel.text = [NSString stringWithFormat:@"%ld",(long)_park.freeSpace];
    _allSpaceLabel.text = [NSString stringWithFormat:@"%ld",(long)_park.totalSpace];
}
#pragma mark 加载进度条
-(void)initialCircular
{
    CircularView *circular = [[CircularView alloc] initWithFrame:CGRectMake(0, 0, _circularView.width, _circularView.height)];
    circular.arcUnfinishColor = RGBA(45, 140, 220, 1);
    circular.arcBackColor = RGBA(220, 220, 220, 1);
    circular.percent = [_beleftSpaceLabel.text floatValue] / [_allSpaceLabel.text floatValue];
    [_circularView addSubview:circular];
    [_circularView sendSubviewToBack:circular];
}
#pragma mark 预约
- (IBAction)yuyueAction:(id)sender {
    [_lastVC stopCarAction];
}

#pragma mark 导航
- (IBAction)daohangAction:(id)sender {

    [_lastVC startNavigate];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
