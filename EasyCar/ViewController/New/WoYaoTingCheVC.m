//
//  WoYaoTingCheVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/26.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "WoYaoTingCheVC.h"

#import "TouFangAdViewController.h"
#import "YuYueStopViewController.h"
#import "ZhengzuOrderViewController.h"
#import "MyParkingSpaceVC.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import "Park.h"
#import <iflyMSC/iflyMSC.h>
#import "LoginVC.h"
#import "WoYaoTingCheListVC.h"
#import "OftenAddressViewController.h"
#import "ParkDetailViewController.h"
#import <ParkingViewController.h>
#import "MySpaceViewController.h"
#import "ParkingSpaceAreaViewController.h"
#define UnChecked_bounds CGRectMake(0, 0, 90, 90)
#define Checked_bounds CGRectMake(0, 0, 90, 138)
#define FanWei 0.3

@interface WoYaoTingCheVC ()<CLLocationManagerDelegate,MKMapViewDelegate,AMapNaviManagerDelegate,MAMapViewDelegate,AMapNaviViewControllerDelegate,IFlySpeechSynthesizerDelegate>


@property (nonatomic, strong) CLLocationManager *locationManager;

// 地图小控件
@property (strong, nonatomic) IBOutlet UIButton *trafficBtn;



// 模型数组

@property (nonatomic, strong) NSMutableArray *parkList;

@property (nonatomic, strong) AMapNaviManager *naviManager;
@property (nonatomic, strong) AMapNaviViewController *naviViewController;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) MAMapView *mmapView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottom;

@end

@implementation WoYaoTingCheVC
{
    // 讯飞语音
    IFlySpeechSynthesizer *_iFlySpeechSynthesizer;
    /** 所有要展示的点，不含用户位置 */
    NSMutableArray *_annotations;
    NSArray *addressArr;
    NSUInteger _selectIndex;
    
    UIButton *_addMySpaceBtn;
    UIButton *_oftenAddressBtn;
    UILabel *_addrLabel;
    UILabel *_priceLabel;
    CGFloat _price;
    UILabel *_addrDetailLabel;
    UIButton *_navigateBtn;
    UILabel *_freeSpaceLB;
    UILabel *_totalSpaceLB;
    UILabel *_distanceLabel;
    
    CLLocation *_CLLocation;
    CLGeocoder *_geocoder;
    CLPlacemark *_placeMark;
    
    MKAnnotationView *_lastAnnoView;
    
    BOOL _didRequestParkList;
    BOOL _didShowUserLocation;
    
    Park *_nearestPark;
    
    UIButton *stopBtn;
    
    //2016
    UILabel *_addState;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:Window animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_locationManager startUpdatingLocation];
    _mapView.showsUserLocation = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_locationManager stopUpdatingLocation];
    _mapView.showsUserLocation = NO;// 视图消失后 让mapView不再定位，状态栏的定位图标才会消失

}

// 点击列表
- (void)right
{
    if (_parkList.count > 0) {
        WoYaoTingCheListVC *vc = [Unit EPStoryboard:@"WoYaoTingCheListVC"];
        vc.lastVC = self;
        vc.parkList = _parkList;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nav setTitle:@"地图" leftText:@"返回" rightTitle:nil showBackImg:YES];
    [self.nav.rightImageBtn setImage:[UIImage imageNamed:@"iconfont_liebiao"] forState:UIControlStateNormal];
    _parkList = [[NSMutableArray alloc] init];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;

    _annotations = [[NSMutableArray alloc] init];

    
    //定位精度
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10.0f;
    _mapView.delegate = self;
    // 追踪模式 关系到用户位置标记
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    //当定位服务开启时
    if ([CLLocationManager locationServicesEnabled])
    {
        //获取用户授权
//        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
        //开始定位 触发代理方法
        //设置允许后台定位参数，保持不会被系统挂起
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
//            [_locationManager setAllowsBackgroundLocationUpdates:YES];//iOS9(含)以上系统需设置
//        }
        
        [_locationManager startUpdatingLocation];
        [_mapView showsUserLocation];
        
        // 可穿透的动画（代表正在 定位＋搜索）
        [[MBProgressHUD showAnimateHUDAddedTo:Window text:@"正在搜索周边停车场"] setUserInteractionEnabled:NO];

    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewDidClicked)];
    [_mapView addGestureRecognizer:tap];
}


#pragma mark - [停车场列表请求]
- (void)requestParkListWithCoordinate:(CLLocationCoordinate2D)coordinate page:(NSInteger)page tableView:(UITableView *)tableView
{
    
    
    if (page == FirstPage) {
        
        _pageNo = FirstPage;
    }
    
    _didRequestParkList = YES;
    NSString *url = BaseURL@"parkList";
    NSDictionary *parameters = @{
                                 @"positionX":[NSString stringWithFormat:@"%f",coordinate.latitude],
                                 @"positionY":[NSString stringWithFormat:@"%f",coordinate.longitude],
                                 @"pageSize":[NSString stringWithFormat:@"%d",10],
                                 @"pageNo":[NSString stringWithFormat:@"%ld",(long)_pageNo]
                                 };
    
    [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
//        NSLog(@"dic:%@",dic);
        if ([dic[@"status"] isEqual:@(200)]) {
            
            [MBProgressHUD hideAllHUDsForView:Window animated:YES];
            
            if (page == FirstPage) {
                
                [_parkList removeAllObjects];
            }

            // 建模（车库）
            for (NSDictionary *tempDic in dic[@"data"]) {
//                NSLog(@"parkList:%@",tempDic);
                Park *p = [[Park alloc] mj_setKeyValues:tempDic];
                CLLocationCoordinate2D tempCoo = CLLocationCoordinate2DMake(p.parklat_R, p.parklon_R);
                tempCoo = [self GCJ02FromBD09:tempCoo];
                
                p.parklat_R = tempCoo.latitude;
                p.parklon_R = tempCoo.longitude;
                
                // 比较出最近的停车场
                if (!_nearestPark)
                {
                    _nearestPark = p;
                }
                else
                {
                    _nearestPark =  [p.distance floatValue] < [_nearestPark.distance floatValue] ? p : _nearestPark;
                    
                }
                
                [_parkList addObject:p];
            }
            [tableView.mj_header endRefreshing];
            [tableView.mj_footer endRefreshing];
            [tableView reloadData];
            
            [self showParkListOnMap];
        }
        else
        {
            [MBProgressHUD showError:dic[@"msg"] toView:self.view];
            [tableView.mj_header endRefreshing];
            [tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"报错：%@", [error localizedDescription]);
        [MBProgressHUD showError:@"网络加载出错" toView:self.view];
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
    }];
}

#pragma mark 地图上展示停车点
- (void)showParkListOnMap
{
    
    [_mapView removeAnnotations:_annotations];
    [_annotations removeAllObjects];
    
    for (Park *park in _parkList) {
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(park.parklat_R, park.parklon_R);
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        
        annotation.coordinate = coordinate;
        annotation.title = park.parkName;
        annotation.subtitle = park.address;
        [_annotations addObject:annotation];
        
    }
    [_mapView addAnnotations:_annotations];
    
    // 添加完后收集所有大头针（包括用户）
    NSMutableArray *annotations = [NSMutableArray arrayWithArray:_mapView.annotations];
    
    #warning 注意啦：+
    [annotations addObject:_mapView.userLocation];


    // 缩放聚焦 到展示数组中所有Annotation
    NSMutableArray *tempArr = [NSMutableArray new];
    [tempArr addObject:_mapView.userLocation];
    MKPointAnnotation *annotation = [_annotations objectAtIndex:[_parkList indexOfObject:_nearestPark]];
    [tempArr addObject:annotation];
    if (annotations.count > 2) {
//        [tempArr removeObjectsInRange:NSMakeRange(0, annotations.count - 2)];
    }
    [_mapView showAnnotations:tempArr animated:YES];
    

    [self performSelector:@selector(test) withObject:nil afterDelay:1];
}
#pragma mark test
- (void)test
{

    
    switch (_mapType) {
        case 0:
            // 自动显示最近停车场
            [self mapView:_mapView didSelectAnnotationView:[self.view viewWithTag:[_parkList indexOfObject:_nearestPark] + 1000]];
            [MBProgressHUD showResult:YES text:@"已为您查询最近停车场" delay:1.0f];
            break;
        case 1:
            //导航向常用地址
            [self navigateOftenAddress];
            break;
        case 2:
            //添加常用地址
            // 自动显示最近停车场
            [self mapView:_mapView didSelectAnnotationView:[self.view viewWithTag:[_parkList indexOfObject:_nearestPark] + 1000]];
            break;
        case 3:
            //添加专用车位
            // 自动显示最近停车场
            [self mapView:_mapView didSelectAnnotationView:[self.view viewWithTag:[_parkList indexOfObject:_nearestPark] + 1000]];
        default:
            break;
    }
}

#pragma mark - CLLocationManager收到位置更新
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _CLLocation = locations[0];
    
    CLLocationCoordinate2D coordinate = _CLLocation.coordinate;
    NSLog(@"地球坐标:( %f , %f )", coordinate.latitude,coordinate.longitude);
    
    // 收到地球后立即转火星
    _CLLocation = [self transformToMars:_CLLocation];// 转
    
    // KVC强改 地图的userLocation 诱导系统立即在地图上标记用户位置
    [_mapView.userLocation setValue:_CLLocation forKey:@"location"];
    
    
    // 如果还没显示用户标记就可以进行缩放（避免之后再收到位置又会缩放）
    if (_didShowUserLocation == NO) {
        
        //地图缩放到指定的region
        
        MKCoordinateRegion region = MKCoordinateRegionMake(_CLLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01));

        [_mapView setRegion:region animated:NO];
        
        NSLog(@"地图火星坐标:( %f , %f )", _mapView.userLocation.coordinate.latitude,_mapView.userLocation.coordinate.longitude);
        
        [_mapView showAnnotations:@[_mapView.userLocation] animated:YES];
    }
    
}


#pragma mark 定位出错
- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error {
    [manager stopUpdatingLocation];
    switch([error code]) {
        case kCLErrorDenied:
            [self openGPSTips]; // 提示打开定位
            break;
        case kCLErrorLocationUnknown:
            break;
        default:
            break;
    }
}

#pragma mark - mapView 给大头针整容
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSUInteger index = [_annotations indexOfObject:annotation];
    //=========== 自定义的大头针类型 ===========
    if (index != NSNotFound) {
        
        MKAnnotationView *annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
        annoView.canShowCallout = YES;
        annoView.tag = 1000 + index;
        
        
        [annoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];// 移除子控件
        Park *park = _parkList[index];

        #warning 注意啦：first
        annoView.bounds = UnChecked_bounds;
        UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, annoView.width, annoView.height/2)];
        image1.contentMode = UIViewContentModeScaleAspectFit;
        image1.tag = 101;
        image1.image = [self autoSelecetAnnoColor:park checked:NO];
        
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, annoView.height/2, annoView.width, annoView.height/2)];
        button2.tag = 102;

        [button2 addTarget:self action:@selector(noThing) forControlEvents:UIControlEventTouchUpInside];

        [annoView addSubview:image1];
        [annoView addSubview:button2];
        
        UILabel *lb = [[UILabel alloc] init];
        lb.frame = CGRectMake(0, -8, image1.width, image1.height);//image1.bounds;
        lb.textAlignment = NSTextAlignmentCenter;
        lb.textColor = [UIColor blackColor];
        lb.font = [UIFont systemFontOfSize:12];
        lb.text = [NSString stringWithFormat:@"%ld",(long)park.freeSpace];
        lb.tag = 100;
        [image1 addSubview:lb];
        return annoView;
    }

    //=========== 如果标注是用户的位置保持原样式（定位的蓝点） ===========
    if (_mapView.userLocation == annotation) {
        
        NSLog(@"在地图标记用户大头针 （%f,%f）", annotation.coordinate.latitude, annotation.coordinate.longitude);
        // 收到位置后只需发一次请求
        if (!_didRequestParkList) {
            
            _didShowUserLocation = YES;
            [self requestParkListWithCoordinate:_mapView.userLocation.coordinate page:FirstPage tableView:nil];
        }
        return nil;
    }
    
    return nil;
}



// mapView停止定位了
- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView
{
    NSLog(@"mapView停止定位了");
}

#pragma mark [点击大头针] 显示BottomView
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (view.tag == 0) {
        return;
    }

    _selectIndex = view.tag - 1000;
    // 记录当前点击地标的坐标
    Park *park = _parkList[_selectIndex];
    _selectedCoordinate.latitude = park.parklat_R;
    _selectedCoordinate.longitude = park.parklon_R;
    
    // 反选
    if (!_lastAnnoView || [_lastAnnoView isEqual:view]) {
        _lastAnnoView = view;
    }
    else
    {
        // 取消选择上一个
        Park *lastPark = _parkList[_lastAnnoView.tag - 1000];

        _lastAnnoView.bounds = UnChecked_bounds;
        UIImageView *image1 = [_lastAnnoView viewWithTag:101];
        image1.frame  = CGRectMake(0, 0, _lastAnnoView.width, _lastAnnoView.height/2);
        image1.image = [self autoSelecetAnnoColor:lastPark checked:NO];
        UIButton *button2 = [_lastAnnoView viewWithTag:102];
        button2.frame = CGRectMake(0, _lastAnnoView.height/2, _lastAnnoView.width, _lastAnnoView.height/2);
        UILabel *lb = [_lastAnnoView viewWithTag:100];
        lb.frame = CGRectMake(0, -8, image1.width, image1.height);
        lb.font = [UIFont systemFontOfSize:12];
        lb.text = [NSString stringWithFormat:@"%ld",(long)lastPark.freeSpace];
        // 最后更新_lastAnnoView
        _lastAnnoView = view;
    }
    #warning 注意啦：second
    // 选择当前
    
    view.bounds = Checked_bounds;
    UIImageView *image1 = [view viewWithTag:101];
    image1.frame  = CGRectMake(0, 0, view.width, view.height/2);
    image1.image = [self autoSelecetAnnoColor:park checked:NO];
    UIButton *button2 = [view viewWithTag:102];
    button2.frame = CGRectMake(0, view.height/2, view.width, view.height/2);
    UILabel *lb = [view viewWithTag:100];
    lb.frame = CGRectMake(0, -10, image1.width, image1.height);
    lb.font = [UIFont systemFontOfSize:14];
    lb.text = [NSString stringWithFormat:@"%ld",(long)park.freeSpace];

    
    
    self.bottomView.top = UI_SCREEN_HEIGHT;
    _bottom.constant = 0;
    [self.view layoutIfNeeded];
    [self stopBtnInitial];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bottomView.top = UI_SCREEN_HEIGHT-145;
        _bottom.constant = 145;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    
    // 取字典
    _addrLabel.text = park.parkName;
    _addrDetailLabel.text = park.address;
    _priceLabel.text = [NSString stringWithFormat:@"%.1f元",park.appointFee];
    _freeSpaceLB.text = [NSString stringWithFormat:@"空车位：%ld",(long)park.freeSpace];
    _totalSpaceLB.text = [NSString stringWithFormat:@"总车位：%ld",(long)park.totalSpace];
    _distanceLabel.text = [NSString stringWithFormat:@"距离您%@km",park.distance];

}

-(void)openGPSTips{
    UIAlertView *alet = [[UIAlertView alloc] initWithTitle:@"当前定位服务不可用" message:@"请到“设置->隐私->定位服务”中开启定位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alet show];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[MKAnnotationView class]]) {
        // 不知道怎么拦截下半截长按事件
    }
}

#pragma mark 点击路况
- (IBAction)clickTrafficBtn:(UIButton *)sender {
    
    _mapView.showsTraffic = !_mapView.showsTraffic;
    sender.selected = _mapView.showsTraffic;
    
}

#pragma mark 点击定位 到用户位置
- (IBAction)clickFindLocBtn:(id)sender {
    
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    _mapView.showsUserLocation = YES;
}

#pragma mark 点击加号
- (IBAction)clickIncrease:(id)sender {
    
    MKCoordinateRegion region = _mapView.region;
    region.span.latitudeDelta=region.span.latitudeDelta * 0.5;
    region.span.longitudeDelta=region.span.longitudeDelta * 0.5;
    [_mapView setRegion:region animated:YES];
}

#pragma mark 点击减号
- (IBAction)clickDecrease:(id)sender {
    
    MKCoordinateRegion region = _mapView.region;
    region.span.latitudeDelta=region.span.latitudeDelta * 1.5;
    region.span.longitudeDelta=region.span.longitudeDelta * 1.5;
    [_mapView setRegion:region animated:YES];
}

#pragma mark 地图被点击 取消显示一些东西
- (void)mapViewDidClicked
{
    // 如果存在被选中的大头针 变为取消选中
    if (_lastAnnoView) {
        _selectIndex = 0;
        // 取消选择上一个
        Park *lastPark = _parkList[_lastAnnoView.tag - 1000];
        
        _lastAnnoView.bounds = UnChecked_bounds;
        UIImageView *image1 = [_lastAnnoView viewWithTag:101];
        image1.frame  = CGRectMake(0, 0, _lastAnnoView.width, _lastAnnoView.height/2);
        image1.image = [self autoSelecetAnnoColor:lastPark checked:NO];
        UIButton *button2 = [_lastAnnoView viewWithTag:102];
        button2.frame = CGRectMake(0, _lastAnnoView.height/2, _lastAnnoView.width, _lastAnnoView.height/2);
        UILabel *lb = [_lastAnnoView viewWithTag:100];
        lb.frame = CGRectMake(0, -8, image1.width, image1.height);
        lb.font = [UIFont systemFontOfSize:12];
        lb.text = [NSString stringWithFormat:@"%ld",(long)lastPark.freeSpace];
        // 最后更新_lastAnnoView
        _lastAnnoView = nil;
        [UIView animateWithDuration:0.3 animations:^{
            
            _bottomView.top = Heigth;
            _bottom.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }
}
#pragma mark 点击我要停车
-(void)controlParking
{
    Park *park = _parkList[_selectIndex];
    NSLog(@"准备操控%@",park.parkName);

    if (self.user.isLogin) {
        
        ParkingViewController *parkingVC = [ParkingViewController new];
        parkingVC.park = park;
        [self.navigationController pushViewController:parkingVC animated:YES];
        
    }else
    {
        [self showFunctionAlertWithTitle:@"温馨提示" message:@"此功能需要登录后才能使用" functionName:@"点击登录" Handler:^{
            
            [self gotoLoginVC];
        }];
    }
}
#pragma mark 点击预约车位
- (void)stopCarAction
{
    if (self.user.isLogin)
    {
        
        // 有车位
        YuYueStopViewController *vc = [[YuYueStopViewController alloc] init];
        vc.park = _parkList[_selectIndex];
        // 没车位
        if (vc.park.freeSpace == 0) {
            
            [MBProgressHUD showError:@"该车场没有剩余车位，无法预约" toView:Window];
            return;
        }
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else
    {
        [self showFunctionAlertWithTitle:@"温馨提示" message:@"此功能需要登录后才能使用" functionName:@"点击登录" Handler:^{
            
            [self gotoLoginVC];
        }];
    }
}

- (void)touAdAction
{
    TouFangAdViewController *vc = [[TouFangAdViewController alloc] init];
    vc.address = _addrLabel.text;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 点击右箭头
-(void)clickArrow
{
    ParkDetailViewController *VC = [[ParkDetailViewController alloc] init];
    VC.park = _parkList[_selectIndex];
    VC.lastVC = self;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark 车位整租
- (void)carZhengZu
{

    if (self.user.isLogin)
    {
        Park *park = _parkList[_selectIndex];
        NSLog(@"%@",park);
        MyParkingSpaceVC *vc = [[MyParkingSpaceVC alloc] initWithNibName:@"MyParkingSpaceVC" bundle:nil];
        [vc necessaryPropertyParkFunction:toChooseRentParkSpace parkArea:@"A" parkId:park.ID];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [self showFunctionAlertWithTitle:@"温馨提示" message:@"此功能需要登录后才能使用" functionName:@"点击登录" Handler:^{
            
            [self gotoLoginVC];
        }];
    }
}

#pragma mark - 开始高德导航

- (void)startNavigate
{
//    NSLog(@"导航开始");
    //  讯飞：创建合成对象，为单例模式
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    _iFlySpeechSynthesizer.delegate = self;
    //设置语音合成的参数
    //语速,取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
    //音量;取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
    //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个性化发音人列表
    [_iFlySpeechSynthesizer setParameter:@" kaiselin " forKey: [IFlySpeechConstant VOICE_NAME]];
    //音频采样率,目前支持的采样率有 16000 和 8000
    [_iFlySpeechSynthesizer setParameter:@"8000" forKey: [IFlySpeechConstant SAMPLE_RATE]];
    //asr_audio_path保存录音文件路径，如不再需要，设置value为nil表示取消，默认目录是documents
    [_iFlySpeechSynthesizer setParameter:@" tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    //启动合成会话
    [_iFlySpeechSynthesizer startSpeaking: @"你好，俺老孙来也，俺是花果山水帘洞美猴王齐天大圣孙悟空"];
    
    
    //  导航视图展示
    [self.naviManager presentNaviViewController:self.naviViewController animated:YES];
    
}

#pragma mark AMapNaviViewController被展示出来后的回调
- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
{
    
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:_selectedCoordinate.latitude longitude:_selectedCoordinate.longitude];
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

#pragma mark 高德语音回调＋讯飞
- (void)naviManager:(AMapNaviManager *)naviManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [_iFlySpeechSynthesizer startSpeaking:soundString];//soundString为导航引导语
    });
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
    // 停讯飞
    [_iFlySpeechSynthesizer stopSpeaking];
    [_naviManager stopNavi];
    [_naviManager dismissNaviViewControllerAnimated:YES];
    _naviManager = nil;
}

#pragma mark 底部栏
-(void)stopBtnInitial
{
#warning 简易版车库操控从这里开始啦！
    Park *park = _parkList[_selectIndex];
    park.big = YES;
    park.pass = NO;
//    NSInteger i = arc4random()%2;
//    if (i == 0) {
//        park.pass = YES;
//    }
    if (park.big && !park.pass) {
        _addState.text = @"";   //如果是大型车库则必须是已预约、已整租、月卡用户等情况可直接操作车库
        [stopBtn setTitle:@"预约" forState:(UIControlStateNormal)];
        [stopBtn removeTarget:self action:@selector(controlParking) forControlEvents:(UIControlEventTouchUpInside)];
        [stopBtn addTarget:self action:@selector(stopCarAction) forControlEvents:(UIControlEventTouchUpInside)];
    }else{
        _addState.text = @"已预约";
        [stopBtn setTitle:@"我要停车" forState:(UIControlStateNormal)];//如果是小型车库或者已预约等情况可直接操作车库
        [stopBtn removeTarget:self action:@selector(stopCarAction) forControlEvents:(UIControlEventTouchUpInside)];
        [stopBtn addTarget:self action:@selector(controlParking) forControlEvents:(UIControlEventTouchUpInside)];
    }
}
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
//        [arrowBtn addTarget:self action:@selector(clickArrow) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:arrowBtn];
        
        //触摸面积增加了的按钮
        UIButton *arrowBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [arrowBtn2 setFrame:CGRectMake(0, _bottomView.height * 0.33, _bottomView.width, _bottomView.height* 0.33)];
        [arrowBtn2 setBackgroundColor:[UIColor clearColor]];
        [arrowBtn2 addTarget:self action:@selector(clickArrow) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:arrowBtn2];
        
        //线1
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(_bottomView.width * 0.05, _bottomView.height * 0.66, _bottomView.width * 0.9, 1)];
        line1.backgroundColor = RGBA(220, 220, 220, 0.8);
        [_bottomView addSubview:line1];
        
        switch (_mapType) {
            case 0:
            case 1:
                [self flowMeeting];

                break;
            case 2:
                [self flowOftenAddress];
                break;
            case 3:
                [self flowAddMySpace];
                break;
            default:
                break;
        }
    }
    
    return _bottomView;
}
#pragma mark 添加专用车位
-(void)flowAddMySpace
{
    _addMySpaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addMySpaceBtn setTitle:@"添加专用车位" forState:UIControlStateNormal];
    [_addMySpaceBtn setFrame:CGRectMake(0, _bottomView.height * 0.67, _bottomView.width, _bottomView.height * 0.33)];
    [_addMySpaceBtn addTarget:self action:@selector(addMySpace) forControlEvents:UIControlEventTouchUpInside];
    [_addMySpaceBtn setTitleColor:RGBA(46, 46, 46, 1.0) forState:(UIControlStateNormal)];
    
    [_bottomView addSubview:_addMySpaceBtn];
}
-(void)addMySpace
{
    ParkingSpaceAreaViewController *vc = [[ParkingSpaceAreaViewController alloc] init];
    vc.park = [_parkList objectAtIndex:_selectIndex];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 导航向常用地址
-(void)navigateOftenAddress
{
    if(_selectPark)
    {
        for (Park *park in _parkList) {
            if ([_selectPark isEqualToString:park.parkName]) {
                [self mapView:_mapView didSelectAnnotationView:[self.view viewWithTag:[_parkList indexOfObject:park] + 1000]];
//                [self startNavigate];//暂时不用导航
            }
        }
    }
}
#pragma mark 添加常用地址流程
-(void)flowOftenAddress
{
    _oftenAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_oftenAddressBtn setTitle:@"添加为常用地址" forState:UIControlStateNormal];
    [_oftenAddressBtn setFrame:CGRectMake(0, _bottomView.height * 0.67, _bottomView.width, _bottomView.height * 0.33)];
    [_oftenAddressBtn addTarget:self action:@selector(addOftenAddress) forControlEvents:UIControlEventTouchUpInside];
    [_oftenAddressBtn setTitleColor:RGBA(46, 46, 46, 1.0) forState:(UIControlStateNormal)];

    [_bottomView addSubview:_oftenAddressBtn];
    
}
-(void)addOftenAddress
{
    OftenAddressViewController *vc = (OftenAddressViewController *)_lastVC;
    Park *park = _parkList[_selectIndex];
    [vc addDataIntoSql:park];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 预约流程
-(void)flowMeeting
{

    
    //线2
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(_bottomView.width * 0.5, _bottomView.height * 0.66, 1 , _bottomView.height * 0.33)];
    line2.backgroundColor = RGBA(220, 220, 220, 0.8);
    [_bottomView addSubview:line2];
    
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
}
#pragma mark 自动选择大头针颜色
- (UIImage *)autoSelecetAnnoColor:(Park *)park checked:(BOOL)isChecked
{
    UIImage *image;
    // 根据剩余数量设置颜色  >50绿色  >10黄色  <10红色
    if (park.freeSpace <= 10)
    {
        image = isChecked ? [UIImage imageNamed:@"ytc_red_parkno_checked"] : [UIImage imageNamed:@"ytc_red_parkno_unchecked"];
    }
    else if (park.freeSpace <= 50)
    {
        image = isChecked ? [UIImage imageNamed:@"ytc_yellow_parkno_checked"] : [UIImage imageNamed:@"ytc_yellow_parkno_unchecked"];
    }
    else
    {
        image = isChecked ? [UIImage imageNamed:@"ytc_green_parkno_checked"] : [UIImage imageNamed:@"ytc_green_parkno_unchecked"];
    }

    return image;
//    // 选中图片缩小 1.6
//    if (isChecked) {
//        return [UIImage imageWithData:UIImagePNGRepresentation(image) scale:1.8];
//    }
//    // 非选中图片缩小 1.2
//    else
//    {
//        return [UIImage imageWithData:UIImagePNGRepresentation(image) scale:1.2];
//    }
}

- (void)noThing
{

    NSLog(@"button2拦截点击");
}

#pragma mark - 讯飞语音

//合成结束，此代理必须要实现
- (void)onCompleted:(IFlySpeechError *) error{

    if (error) {
        NSLog(@"讯飞错误：%@", [error errorDesc]);
    }
    else
    {
        NSLog(@"语音结束");
    }
}
//合成开始
- (void) onSpeakBegin{

    NSLog(@"语音开始");
}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg{

//    NSLog(@"讯飞：缓冲进度%@", msg);
}
//合成播放进度
- (void) onSpeakProgress:(int) progress{

//    NSLog(@"讯飞：播放进度%d", progress);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
