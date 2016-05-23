//
//  MapCarViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "MapCarViewController.h"
#import "TouFangAdViewController.h"
#import "YuYueStopViewController.h"
#import "ZhengzuOrderViewController.h"
#import "MyParkingSpaceVC.h"
#import <AMapNaviKit/AMapNaviKit.h>

@interface MapCarViewController ()<AMapNaviManagerDelegate,MAMapViewDelegate,AMapNaviViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *carLists;

@property (nonatomic, strong) AMapNaviManager *naviManager;
@property (nonatomic, strong) AMapNaviViewController *naviViewController;
@property (nonatomic, strong) MAMapView *mmapView;

@property (nonatomic, strong) UIView *bottomView;
@end

@implementation MapCarViewController
{
    MKMapView *_mapView;
    
    NSMutableArray *_annotations;

    NSArray *addressArr;
    int _nowIndex;
    NSUInteger _selectIndex;
    UILabel *_addrLabel;
    UILabel *_priceLabel;
    CGFloat _price;
    UILabel *_addrDetailLabel;
    UIButton *_navigateBtn;
    CLLocationManager *_locationManager;
    CLLocation *_currentLoc;
    CLGeocoder *_geocoder;
    CLPlacemark *_placeMark;
    
    MKAnnotationView *_lastAnnoView;
    CLLocationCoordinate2D _selectedCoordinate;
    BOOL _didRequestParkList;

}


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    _annotations = [[NSMutableArray alloc] init];
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-self.navigationController.navigationBar.height)];
    
    //    _mapView.showsUserLocation = YES;
    _mapView.mapType = MKMapTypeStandard;

    //创建CLLocationManager并设置代理
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    //定位精度
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //触发再次定位距离
    //    _locationManager.distanceFilter = kCLDistanceFilterNone;
    
    
    //当定位服务开启时
    if ([CLLocationManager locationServicesEnabled])
    {
        //获取用户授权
        [_locationManager requestAlwaysAuthorization];
        //开始定位 触发代理方法
        [_locationManager startUpdatingLocation];
        _mapView.userTrackingMode = MKUserTrackingModeFollow;
    }
    
    
    
    
    self.title = @"我要停车";
    self.view.backgroundColor = RGBA(242, 242, 248, 1);
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    


}

//-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
//

#pragma mark 给大头针整容
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{

    //=========== 如果标注是用户的位置保持原样式（定位的蓝点） ===========
    if (_mapView.userLocation == annotation) {

        NSLog(@"%f,%f", annotation.coordinate.latitude, annotation.coordinate.longitude);
        MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationTest"];
        NSLog(@"%f", view.annotation.coordinate.latitude);
        return nil;
    }
    
    //=========== 自定义的大头针类型 ===========
    
    MKAnnotationView *newAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
    newAnnotationView.tag = 1000 + _nowIndex++;
    newAnnotationView.image = [UIImage imageNamed:@"red_pin"];
    newAnnotationView.canShowCallout=YES;
    
    return newAnnotationView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 停车场列表请求
- (void)requestParkListWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    _didRequestParkList = YES;
    NSString *url = BaseURL@"parkList";
    NSDictionary *parameters = @{
                                 @"positionX":[NSString stringWithFormat:@"%f",coordinate.latitude],
                                 @"positionY":[NSString stringWithFormat:@"%f",coordinate.longitude],
                                 @"pageSize":[NSString stringWithFormat:@"%d",10]
                                 };
    
    [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        NSLog(@"%@", dic[@"msg"]);
        
        if ([dic[@"status"] isEqual:@(200)]) {

            self.carLists = [NSMutableArray arrayWithArray:dic[@"data"]];
            [self showParkListOnMap];
        }
        else
        {
            [MBProgressHUD showError:dic[@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"报错：%@", [error localizedDescription]);
        [MBProgressHUD showError:@"网络加载出错" toView:self.view];
    }];
}

#pragma mark 地图上展示停车点
- (void)showParkListOnMap
{

    [_mapView removeAnnotations:_annotations];
    _nowIndex = 0;
    
    int i = 0;
    for (NSDictionary *dic in _carLists) {
        
        // 服务器的经纬度写反了
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dic[@"tlon"] floatValue], [dic[@"tlat"] floatValue]);
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        annotation.title = dic[@"parkName"];
        annotation.subtitle = dic[@"address"];
        [_annotations addObject:annotation];
        [_mapView addAnnotation:annotation];
        i++;
    }
    
    // 添加完后收集所有大头针（包括用户）
    NSMutableArray *annotations = [NSMutableArray arrayWithArray:_mapView.annotations];
    [annotations addObject:_mapView.userLocation];
    
    // 缩放聚焦 到展示数组中所有Annotation
    [_mapView showAnnotations:annotations animated:YES];
}

#pragma mark - 点击地标 显示BottomView
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    if (view.tag == 0) {
        return;
    }
    
    _selectIndex = view.tag - 1000;
    // 记录当前点击地标的坐标
    NSDictionary *dic = _carLists[_selectIndex];
    _selectedCoordinate.latitude = [dic[@"tlat"] floatValue];
    _selectedCoordinate.longitude = [dic[@"tlon"] floatValue];
    
    // 反选
    if (!_lastAnnoView || [_lastAnnoView isEqual:view]) {
        _lastAnnoView = view;
    }
    else
    {
        _lastAnnoView.image = [UIImage imageNamed:@"red_pin"];
        _lastAnnoView = view;
    }
    view.image = [UIImage imageNamed:@"pin_blue"];
    self.bottomView.top = UI_SCREEN_HEIGHT;
    [UIView animateWithDuration:0.5 animations:^{
        _bottomView.top = UI_SCREEN_HEIGHT-150;
    } completion:^(BOOL finished) {
    }];
    
    // 取字典
    
    _addrLabel.text = _carLists[_selectIndex][@"parkName"];
    _addrDetailLabel.text = _carLists[_selectIndex][@"address"];
    if ([_carLists[_selectIndex][@"price"] isKindOfClass:[NSNull class]]) {
        
        _priceLabel.text = @"暂无价格信息";
        _price = 0;
    }
    else
    {
        _price = [_carLists[_selectIndex][@"price"] floatValue];
        _priceLabel.text = [NSString stringWithFormat:@"%.1f元/每小时",_price];
        
    }
    
    
}


#pragma mark - <CLLocationManagerDelegate>

#pragma mark 位置更新回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _currentLoc = locations[0];
    CLLocationCoordinate2D coordinate = _currentLoc.coordinate;
    NSLog(@"当前位置:( %f , %f )", coordinate.latitude,coordinate.longitude);

    // 收到位置后只需发一次请求
    if (!_didRequestParkList) {
        
//        MKCoordinateSpan span = {0.5,0.5};
//        MKCoordinateRegion region = {coordinate,span};
//        [_mapView setRegion:region animated:YES];
        
        [self requestParkListWithCoordinate:coordinate];
    }
}


#pragma mark - 检测应用是否开启定位服务
- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error {
    [manager stopUpdatingLocation];
    switch([error code]) {
        case kCLErrorDenied:
            [self openGPSTips];
            break;
        case kCLErrorLocationUnknown:
            break;
        default:
            break;
    }
}

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    NSLog(@"%@",userLocation);
//}



-(void)openGPSTips{
    UIAlertView *alet = [[UIAlertView alloc] initWithTitle:@"当前定位服务不可用" message:@"请到“设置->隐私->定位服务”中开启定位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alet show];
}

#pragma mark 点击我要停车
- (void)stopCarAction:(UIButton *)btn
{
    YuYueStopViewController *vc = [[YuYueStopViewController alloc] init];
    vc.data = _carLists[_selectIndex];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touAdAction
{
    TouFangAdViewController *vc = [[TouFangAdViewController alloc] init];
    vc.address = _addrLabel.text;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark 车位整租
- (void)carZhengZu
{
    MyParkingSpaceVC *vc = [[MyParkingSpaceVC alloc] initWithNibName:@"MyParkingSpaceVC" bundle:nil];
    vc.function = toChooseRentParkSpace; // 用于整租
    NSDictionary *dic = _carLists[_selectIndex];
    vc.data = @{
                @"parkId":dic[@"id"],
                @"parkArea":@"A" // 默认进入A区
                };
    [self.navigationController pushViewController:vc animated:YES];
    
//    ZhengzuOrderViewController *vc = [[ZhengzuOrderViewController alloc] init];
//    vc.address = _addrLabel.text;
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self.navigationItem setBackBarButtonItem:backItem];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)carLists
{
    if (!_carLists) {
        _carLists = [[NSMutableArray alloc] init];
    }
    return _carLists;
}

#pragma mark - 开始高德导航

- (void)startNavigate
{
//    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:_currentLoc.coordinate.latitude longitude:_currentLoc.coordinate.longitude];
//    NSArray *startPoints = @[startPoint];
    

    //导航视图展示
    [self.naviManager presentNaviViewController:self.naviViewController animated:YES];
    
}

#pragma mark AMapNaviViewController被展示出来后的回调
- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
{

    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:_selectedCoordinate.longitude longitude:_selectedCoordinate.latitude];
    NSArray *endPoints = @[endPoint];
    //驾车路径规划（未设置途经点、导航策略为速度优先）
    [self.naviManager calculateDriveRouteWithEndPoints:endPoints wayPoints:nil drivingStrategy:0];
}

//路径规划成功的回调函数
- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
    NSLog(@"路径规划成功");
    [_naviManager startGPSNavi];

}

//路径规划失败的回调函数
- (void)naviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error;
{
    NSLog(@"路径规划失败");
    NSLog(@"%@", [error localizedDescription]);
    [MBProgressHUD showError:[error localizedDescription] toView:self.view];
}

#pragma mark 自车位置更新后的回调函数
- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviLocation:(AMapNaviLocation *)naviLocation
{
    
    NSLog(@"自车位置更新:%@", naviLocation.coordinate);
    NSLog(@"%ld", (long)naviLocation.heading);
}

// MAMapView
- (MAMapView *)mmapView
{
    if (_mmapView == nil)
    {
        _mmapView = [[MAMapView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _mmapView.delegate = self;
//打开会出现两个用户位置        [_mmapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    }
    return _mmapView;
}

- (AMapNaviManager *)naviManager
{
    if (_naviManager == nil)
    {
        [_naviManager  setAllowsBackgroundLocationUpdates:YES];//iOS9(含)以上系统需设置
        _naviManager = [[AMapNaviManager alloc] init];
        [_naviManager setDelegate:self];
    }
    return _naviManager;
}

// 导航视图初始化
- (AMapNaviViewController *)naviViewController
{
    if (_naviViewController == nil)
    {
        _naviViewController = [[AMapNaviViewController alloc] initWithMapView:self.mmapView delegate:self];
    }
    return _naviViewController;
}

#pragma mark 关闭导航
- (void)naviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController
{
    [self.naviManager stopNavi];
    
    [self.naviManager dismissNaviViewControllerAnimated:YES];
}

//- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
//updatingLocation:(BOOL)updatingLocation
//{
//    if(updatingLocation)
//    {
//        //取出当前位置的坐标
//        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
//    }
//}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 150)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.alpha = 0.9;
        [self.view addSubview:_bottomView];
        
        _addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        _addrLabel.font = [UIFont systemFontOfSize:16];
        _addrLabel.textColor = RGBA(36, 36, 36, 1);
        _addrLabel.textAlignment = NSTextAlignmentLeft;
        [_bottomView addSubview:_addrLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _addrLabel.bottom, 200, 20)];
        _priceLabel.font = [UIFont systemFontOfSize:14];
        [_bottomView addSubview:_priceLabel];
        
        
        _navigateBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _navigateBtn.frame = CGRectMake(UI_SCREEN_WIDTH - 100, 10, 80, 40);
        _navigateBtn.layer.cornerRadius = 3;
        [_navigateBtn setTitle:@"开始导航" forState:(UIControlStateNormal)];
        _navigateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_navigateBtn addTarget:self action:@selector(startNavigate) forControlEvents:(UIControlEventTouchUpInside)];
        [_navigateBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _navigateBtn.backgroundColor = RGBA(251, 70, 96, 1);
        [_bottomView addSubview:_navigateBtn];
        
        
        UIButton *stopBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        stopBtn.frame = CGRectMake(10, _priceLabel.bottom+10, 80, 40);
        stopBtn.layer.cornerRadius = 3;
        [stopBtn setTitle:@"我要停车" forState:(UIControlStateNormal)];
        stopBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [stopBtn addTarget:self action:@selector(stopCarAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [stopBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        stopBtn.backgroundColor = RGBA(251, 70, 96, 1);
        [_bottomView addSubview:stopBtn];
        
        UIButton *touAdBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        touAdBtn.frame = CGRectMake(stopBtn.right+15, _priceLabel.bottom+10, 80, 40);
        touAdBtn.layer.cornerRadius = 3;
        [touAdBtn setTitle:@"投放广告" forState:(UIControlStateNormal)];
        touAdBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [touAdBtn addTarget:self action:@selector(touAdAction) forControlEvents:(UIControlEventTouchUpInside)];
        [touAdBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        touAdBtn.backgroundColor = RGBA(50, 129, 255, 1);
        [_bottomView addSubview:touAdBtn];
        
        UIButton *chewzzBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        chewzzBtn.frame = CGRectMake(touAdBtn.right+15, _priceLabel.bottom+10, 80, 40);
        chewzzBtn.layer.cornerRadius = 3;
        [chewzzBtn setTitle:@"车位整租" forState:(UIControlStateNormal)];
        chewzzBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [chewzzBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [chewzzBtn addTarget:self action:@selector(carZhengZu) forControlEvents:(UIControlEventTouchUpInside)];
        chewzzBtn.backgroundColor = RGBA(104, 141, 255, 1);
        [_bottomView addSubview:chewzzBtn];
        
        _addrDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, touAdBtn.bottom+5, UI_SCREEN_WIDTH-20, 40)];
        _addrDetailLabel.numberOfLines = 0;
        _addrDetailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _addrDetailLabel.font = [UIFont systemFontOfSize:14];
        _addrDetailLabel.textAlignment = NSTextAlignmentLeft;
        _addrDetailLabel.textColor = [UIColor grayColor];
        [_bottomView addSubview:_addrDetailLabel];
    }
    
    return _bottomView;
}



@end
