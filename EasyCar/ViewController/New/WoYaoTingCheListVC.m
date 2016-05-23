//
//  WoYaoTingCheListVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/28.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "WoYaoTingCheListVC.h"
#import "ParkCell.h"
#import "ParkDetailViewController.h"
@interface WoYaoTingCheListVC ()<UIScrollViewDelegate,MKMapViewDelegate>
{
    UILabel *_addrLabel;
    UILabel *_priceLabel;
    CGFloat _price;
    UILabel *_addrDetailLabel;
    UIButton *_navigateBtn;
    UILabel *_freeSpaceLB;
    UILabel *_totalSpaceLB;
    UILabel *_distanceLabel;
    UIButton *stopBtn;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation WoYaoTingCheListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.nav setTitle:@"附近停车场" leftText:@"返回" rightTitle:nil showBackImg:YES];
    _tableView.estimatedRowHeight = 44;
    
//    //    可能还要经纬度啊
//    if (!_parkList) {
//        // 如果没有传入停车场list，再请求
//    }
    [self setPullRefresh];
    
}


#pragma mark 上下拉刷新
- (void)setPullRefresh
{
    MJRefreshGifHeader *head = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        [_lastVC requestParkListWithCoordinate:_lastVC.mapView.userLocation.coordinate page:FirstPage tableView:_tableView];
    }];
    [head setImages:RefreshImages forState:MJRefreshStateRefreshing];
    _tableView.mj_header = head;
    
    MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        [_lastVC requestParkListWithCoordinate:_lastVC.mapView.userLocation.coordinate page:++_lastVC.pageNo tableView:_tableView];
    }];
    [foot setImages:RefreshImages forState:MJRefreshStateRefreshing];
    _tableView.mj_footer = foot;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource>

#pragma mark 段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_parkList) {
        
        return _parkList.count;
    }
    return 0;
}
#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark ［配置单元格］
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ParkCell" forIndexPath:indexPath];
    [cell setCellInfo:_parkList[indexPath.section]];
    return cell;
}

#pragma mark 单元格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // 点击cell时务必模拟出地图界面点击地标的效果（地标tag与_parkList的标号相差1000）
    [_lastVC mapView:_lastVC.mapView didSelectAnnotationView:[_lastVC.view viewWithTag:indexPath.section + 1000]];
    
    // 展示
//    self.bottomView.bottom = Heigth+190;
    // 上数据
    Park *park = _parkList[indexPath.section];
    
    // 取字典
//    _addrLabel.text = park.parkName;
//    _addrDetailLabel.text = park.address;
//    _priceLabel.text = [NSString stringWithFormat:@"%.1f元",park.appointFee];
//    _freeSpaceLB.text = [NSString stringWithFormat:@"空车位：%ld",(long)park.freeSpace];
//    _totalSpaceLB.text = [NSString stringWithFormat:@"总车位：%ld",(long)park.totalSpace];
//    _distanceLabel.text = [NSString stringWithFormat:@"距离您%@km",park.distance];
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        self.bottomView.bottom = Heigth;
//    }];
    
    ParkDetailViewController *VC = [[ParkDetailViewController alloc] init];
    VC.park = park;
    VC.lastVC = _lastVC;
    [self.navigationController pushViewController:VC animated:YES];
}




#pragma mark 底部栏
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH * 0.05, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH * 0.9, UI_SCREEN_WIDTH * 0.36)];
        _bottomView.clipsToBounds = NO; // 显示定位按钮
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.alpha = 0.9;
        [self.view addSubview:_bottomView];
        
        //车场名
        _addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        _addrLabel.font = [UIFont systemFontOfSize:16];
        _addrLabel.textColor = RGBA(36, 36, 36, 1);
        _addrLabel.textAlignment = NSTextAlignmentLeft;
        //        _addrLabel.hidden = YES;
        
        [_bottomView addSubview:_addrLabel];
        
        //距离
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bottomView.width * 0.6, 10, _bottomView.width * 0.3, 20)];
        _distanceLabel.textAlignment = NSTextAlignmentRight;
        _distanceLabel.font = [UIFont systemFontOfSize:10];
        _distanceLabel.textColor = RGBA(100, 100, 100, 1);
        [_bottomView addSubview:_distanceLabel];
        
        //价格
        //        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _addrLabel.bottom, 200, 20)];
        //        _priceLabel.textColor = [UIColor colorWithRed:0.957 green:0.200 blue:0.145 alpha:1.000];
        //        _priceLabel.font = [UIFont systemFontOfSize:14];
        //        [_bottomView addSubview:_priceLabel];
        
        //空车位
        _freeSpaceLB = [[UILabel alloc] initWithFrame:CGRectMake(10, _addrLabel.bottom, 100, _bottomView.height * 0.33)];
        _freeSpaceLB.textColor = [UIColor colorWithRed:0.957 green:0.200 blue:0.145 alpha:1.000];
        _freeSpaceLB.font = [UIFont systemFontOfSize:14];
        //        _freeSpaceLB.backgroundColor = [UIColor redColor];
        [_bottomView addSubview:_freeSpaceLB];
        
        //总车位
        _totalSpaceLB = [[UILabel alloc] initWithFrame:CGRectMake(_freeSpaceLB.right, _freeSpaceLB.top, 100, _freeSpaceLB.height)];
        _totalSpaceLB.textColor = RGBA(120, 120, 120, 1);
        _totalSpaceLB.font = [UIFont systemFontOfSize:14];
        [_bottomView addSubview:_totalSpaceLB];
        
        //导航按钮
        _navigateBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _navigateBtn.frame = CGRectMake(_bottomView.width * 0.5, _bottomView.height * 0.66, _bottomView.width * 0.5, _bottomView.height * 0.33);
        [_navigateBtn setTitle:@"导航" forState:(UIControlStateNormal)];
        _navigateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_navigateBtn addTarget:self action:@selector(startNavigate) forControlEvents:(UIControlEventTouchUpInside)];
        [_navigateBtn setTitleColor:RGBA(46, 46, 46, 1.0) forState:(UIControlStateNormal)];
        //        _navigateBtn.backgroundColor = [UIColor colorWithRed:0.204 green:0.439 blue:1.000 alpha:1.000];
        UIImageView *navigateImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Shape"]];
        [navigateImage setFrame:CGRectMake(_navigateBtn.width * 0.25, _navigateBtn.height * 0.3, _navigateBtn.height * 0.4, _navigateBtn.height * 0.4)];
        
        [_navigateBtn addSubview:navigateImage];
        [_bottomView addSubview:_navigateBtn];
        
        
        //预约车位
        stopBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        stopBtn.bounds = CGRectMake(0, 0, _bottomView.width * 0.5, _bottomView.height * 0.33);
        stopBtn.center = CGPointMake(_bottomView.width * 0.25, _bottomView.height * 0.825);
        //        stopBtn.layer.cornerRadius = 3;
        
        
        [stopBtn setTitle:@"预约" forState:(UIControlStateNormal)];
        stopBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [stopBtn addTarget:self action:@selector(stopCarAction) forControlEvents:(UIControlEventTouchUpInside)];
        [stopBtn setTitleColor:RGBA(46, 46, 46, 1.0) forState:(UIControlStateNormal)];
        //        stopBtn.backgroundColor = RGBA(251, 70, 96, 1);
        
        UIImageView *stopBtnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Shape-14"]];
        [stopBtnImage setFrame:CGRectMake(stopBtn.width * 0.25, stopBtn.height * 0.3, stopBtn.height * 0.4, stopBtn.height * 0.4)];
        [stopBtn addSubview:stopBtnImage];
        [_bottomView addSubview:stopBtn];
        
        //        UIButton *touAdBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        //        touAdBtn.bounds = CGRectMake(0, 0, stopBtn.width, 40);
        //        touAdBtn.center = CGPointMake(OneOfSix * 3, stopBtn.centerY);
        //        touAdBtn.layer.cornerRadius = 3;
        //        [touAdBtn setTitle:@"投放广告" forState:(UIControlStateNormal)];
        //        touAdBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        //        [touAdBtn addTarget:self action:@selector(touAdAction) forControlEvents:(UIControlEventTouchUpInside)];
        //        [touAdBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        //        touAdBtn.backgroundColor = RGBA(50, 129, 255, 1);
        //        [_bottomView addSubview:touAdBtn];
        
        //        UIButton *chewzzBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        //        chewzzBtn.bounds = CGRectMake(0, 0, stopBtn.width, 40);
        //        chewzzBtn.center = CGPointMake(OneOfFour * 3, stopBtn.centerY);
        //        chewzzBtn.layer.cornerRadius = 3;
        //        [chewzzBtn setTitle:@"车位整租" forState:(UIControlStateNormal)];
        //        chewzzBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        //        [chewzzBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        //        [chewzzBtn addTarget:self action:@selector(carZhengZu) forControlEvents:(UIControlEventTouchUpInside)];
        //        chewzzBtn.backgroundColor = RGBA(104, 141, 255, 1);
        //        [_bottomView addSubview:chewzzBtn];
        
        //停车场详细地址
        //        _addrDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _priceLabel.bottom +1.5, UI_SCREEN_WIDTH-20, 30)];
        //        _addrDetailLabel.numberOfLines = 0;
        //        _addrDetailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        //        _addrDetailLabel.font = [UIFont systemFontOfSize:14];
        //        _addrDetailLabel.textAlignment = NSTextAlignmentLeft;
        //        _addrDetailLabel.textColor = [UIColor grayColor];
        //        [_addrDetailLabel setMinimumScaleFactor:7];
        
        //        _addrDetailLabel.hidden = YES;
        //        [_bottomView addSubview:_addrDetailLabel];
        
        //2016
        //        _addState = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 70, 10, 50, 20)];
        //        _addState.lineBreakMode = NSLineBreakByWordWrapping;
        //        _addState.font = [UIFont systemFontOfSize:14];
        //        _addState.textAlignment= NSTextAlignmentCenter;
        //        _addState.textColor = [UIColor purpleColor];
        //        [_bottomView addSubview:_addState];
        
        //右箭头，显示车场详细信息
        UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [arrowBtn setImage:[UIImage imageNamed:@"Shape-10"] forState:UIControlStateNormal];
        [arrowBtn setFrame:CGRectMake(_bottomView.width * 0.9, _bottomView.height * 0.45, _bottomView.height * 0.1, _bottomView.height * 0.1)];
        [arrowBtn addTarget:self action:@selector(clickArrow) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_bottomView addSubview:arrowBtn];
        
        //两条线
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(_bottomView.width * 0.05, _bottomView.height * 0.66, _bottomView.width * 0.9, 1)];
        line1.backgroundColor = RGBA(220, 220, 220, 0.8);
        [_bottomView addSubview:line1];
        
        
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(_bottomView.width * 0.5, _bottomView.height * 0.66, 1 , _bottomView.height * 0.33)];
        line2.backgroundColor = RGBA(220, 220, 220, 0.8);
        [_bottomView addSubview:line2];
    }
    
    return _bottomView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 如果是展现状态
    if (_bottomView.bottom == Heigth) {
        // 收起
        [UIView animateWithDuration:0.3 animations:^{
            _bottomView.bottom = Heigth+190;
        }];
        
    }
}

- (void)startNavigate
{
    [_lastVC startNavigate];
}
-(void)controlParking
{
    [_lastVC controlParking];
}
- (void)stopCarAction
{
    [_lastVC stopCarAction];
}

- (void)carZhengZu
{
    [_lastVC carZhengZu];
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
