//
//  HomeViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/14.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "HomeViewController.h"
#import "MyAdverViewController.h"
#import "MyTicketViewController.h"
#import "AboutUsViewController.h"
#import "MyCarViewController.h"
#import "DaijiaViewController.h"
//#import "CarProsViewController.h"
//#import "MyCarWeiViewController.h"
#import "MeViewController.h"
#import "MiddleViewController.h"
#import "YuYueStopViewController.h"
#import "WoYaoQuCheVC.h"
#import "SDCycleScrollView.h"
#import "SelectParkingSpaceVC.h"
#import "WoYaoTingCheVC.h"
#import "MessageVC.h"
#import "WoDeDingDanVC.h"
//2016
#import "ParkingViewController.h"
#import "PickUpViewController.h"
#import "MyWalletViewController.h"
#import "OftenAddressViewController.h"
#import "SetUPViewController.h"
#import "MySpaceViewController.h"
#import "ParkingSpaceAreaViewController.h"
#import "ParkingYuYueViewController.h"
#import "AppointOrderModel.h"
#import <CoreLocation/CoreLocation.h>
@interface HomeViewController ()<SDCycleScrollViewDelegate,UMSocialUIDelegate,CLLocationManagerDelegate>
{
    SDCycleScrollView *_cycleScrollView; //轮播
    UIScrollView *_mainScrollView; //已停用
    UIImageView *_needle;  //指针
    NSTimer *_needleTimer;  //定时旋转指针
    NSInteger _revolve;
    CLLocationManager *_locationManager;//定位
    CLLocation *nowLocation;//位置
    Park *nestestPark; //最近的停车场
    NSInteger locationNum;//只需定位一次
}
@property (nonatomic ,strong)FileData *fileData;
@end

@implementation HomeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"UUID ======= %@", [UserDefaultsFiles getUUID]);
    // KVO观察未读消息数
    //    [DELE addObserver:self forKeyPath:@"unReadCount" options:NSKeyValueObservingOptionNew context:nil];
    // 在通知中心注册跳转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushVC:) name:PushVC object:nil];
    
    // 定制导航栏
    [self.nav setTitle:@"停车大圣" leftText:nil rightTitle:nil showBackImg:NO];
    //    UIImage *rightImg = [UIImage imageNamed:@"iconfont-xiaoxi"];
    //    NSData *imageData = UIImagePNGRepresentation(rightImg);
    //    rightImg = [[UIImage imageWithData:imageData scale:1.1] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];// 右边的图片稍微变小一点
    //    [self.nav.rightImageBtn setImage:rightImg forState:UIControlStateNormal];
    //    self.nav.rightImageBtn.tintColor = [UIColor whiteColor];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"Shape-8"] forState:UIControlStateNormal];
    [leftBtn setFrame:CGRectMake(20, 34,20, 20)];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.nav addSubview:leftBtn];
    
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self codeLayout];
    
    
    [_mainScrollView layoutIfNeeded];
    CGFloat changeY = _mainScrollView.contentSize.height - _mainScrollView.height;
    _mainScrollView.contentOffset = CGPointMake(0, changeY);
    
    [self checkUpVersion];
    
}



#pragma mark 进入消息界面
//- (void)right
//{
//
//
//    if (self.user.isLogin)
//    {
//        MessageVC *vc = [Unit EPStoryboard:@"MessageVC"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else
//    {
//        [self showFunctionAlertWithTitle:@"温馨提示" message:@"您尚未登录" functionName:@"点击登录" Handler:^{
//            [self loginBeforePushVC:NSStringFromClass([MessageVC class])];
//        }];
//    }
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    [self.nav.rightImageBtn showBadgeWithStyle:WBadgeStyleNumber value:DELE.unReadCount animationType:WBadgeAnimTypeNone];
    
}

//#pragma mark 点击中间
//- (void)showMenu
//{
//    //    MiddleViewController *vc = [[MiddleViewController alloc] init];
//    //    [self.navigationController pushViewController:vc animated:NO];
//    self.tabBarController.selectedIndex = 1;
//}

#pragma mark 点击右边 我的
- (void)meVC
{
    
    if (self.user.isLogin)
    {
        self.tabBarController.selectedIndex = 2;
    }
    else
    {
        if ([[CGTool shareInitial] isMonkeyWIFI]) {
            
            [self showFunctionAlertWithTitle:@"温馨提示" message:@"当前为停车场WIFI，无法连网" functionName:@"停用WIFI" Handler:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
                //                [base gotoLoginVC];
            }];
        }else
        {
            [self showFunctionAlertWithTitle:@"温馨提示" message:@"您尚未登录" functionName:@"点击登录" Handler:^{
                [self gotoLoginVC];
            }];
        }
    }
}

#pragma mark 预约停车
- (void)stopCarAction
{
    
    [_needle.layer removeAllAnimations];
    [UIView animateWithDuration:0.2f animations:^{
        
        _needle.transform = CGAffineTransformMakeRotation(180 * (M_PI / 180.0f));
        
    }completion:^(BOOL finished) {
        WoYaoTingCheVC *mapVC = [[WoYaoTingCheVC alloc] initWithNibName:@"WoYaoTingCheVC" bundle:nil];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backItem];
        [self.navigationController pushViewController:mapVC animated:YES];
    }];
}
#pragma mark 我的钱包
-(void)myMoney
{
    [_needle.layer removeAllAnimations];
    
    [UIView animateWithDuration:0.2f animations:^{
        
        _needle.transform = CGAffineTransformMakeRotation(-48 * (M_PI / 180.0f));
        
    }completion:^(BOOL finished) {
        if (self.user.isLogin) {
            
            MyWalletViewController *vc = [[MyWalletViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            if ([[CGTool shareInitial] isMonkeyWIFI]) {
                
                [self showFunctionAlertWithTitle:@"温馨提示" message:@"当前为停车场WIFI，无法连网" functionName:@"停用WIFI" Handler:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
                    //                [base gotoLoginVC];
                }];
            }else
            {
                [self showFunctionAlertWithTitle:@"温馨提示" message:@"您尚未登录" functionName:@"点击登录" Handler:^{
                    [self gotoLoginVC];
                }];
            }
        }
        
    }];
}
#pragma mark 专用车位
-(void)mySpace
{
    [_needle.layer removeAllAnimations];
    
    [UIView animateWithDuration:0.2f animations:^{
        
        _needle.transform = CGAffineTransformMakeRotation(48 * (M_PI / 180.0f));
        
    }completion:^(BOOL finished) {
        if (self.user.isLogin) {
            
            MySpaceViewController *vc = [[MySpaceViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            if ([[CGTool shareInitial] isMonkeyWIFI]) {
                
                [self showFunctionAlertWithTitle:@"温馨提示" message:@"当前为停车场WIFI，无法连网" functionName:@"停用WIFI" Handler:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
                    //                [base gotoLoginVC];
                }];
            }else
            {
                [self showFunctionAlertWithTitle:@"温馨提示" message:@"您尚未登录" functionName:@"点击登录" Handler:^{
                    [self gotoLoginVC];
                }];
            }
        }
        
    }];
}
#pragma mark 常用地址
-(void)myAddress
{
    [_needle.layer removeAllAnimations];
    
    [UIView animateWithDuration:0.2f animations:^{
        
        _needle.transform = CGAffineTransformMakeRotation(90 * (M_PI / 180.0f));
        
    }completion:^(BOOL finished) {
        if (self.user.isLogin) {
            
            OftenAddressViewController *VC = [[OftenAddressViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
            
        }
        else
        {
            if ([[CGTool shareInitial] isMonkeyWIFI]) {
                
                [self showFunctionAlertWithTitle:@"温馨提示" message:@"当前为停车场WIFI，无法连网" functionName:@"停用WIFI" Handler:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
                    //                [base gotoLoginVC];
                }];
            }else
            {
                [self showFunctionAlertWithTitle:@"温馨提示" message:@"您尚未登录" functionName:@"点击登录" Handler:^{
                    [self gotoLoginVC];
                }];
            }
        }
        
    }];
    
}
#pragma mark 我的订单
- (void)myOrder
{
    //    AboutUsViewController *aboutVC = [[AboutUsViewController alloc] init];
    //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    //    [self.navigationItem setBackBarButtonItem:backItem];
    //    [self.navigationController pushViewController:aboutVC animated:YES];
    [_needle.layer removeAllAnimations];
    
    [UIView animateWithDuration:0.2f animations:^{
        
        _needle.transform = CGAffineTransformMakeRotation(-89 * (M_PI / 180.0f));
        
    }completion:^(BOOL finished) {
        if (self.user.isLogin) {
            
            WoDeDingDanVC *vc = [Unit EPStoryboard:@"WoDeDingDanVC"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            if ([[CGTool shareInitial] isMonkeyWIFI]) {
                
                [self showFunctionAlertWithTitle:@"温馨提示" message:@"当前为停车场WIFI，无法连网" functionName:@"停用WIFI" Handler:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
                    //                [base gotoLoginVC];
                }];
            }else
            {
                [self showFunctionAlertWithTitle:@"温馨提示" message:@"您尚未登录" functionName:@"点击登录" Handler:^{
                    [self gotoLoginVC];
                }];
            }
        }
        
    }];
    
    
    
}
#pragma mark 检查是否有预约
-(NSString *)checkHaveAppointment:(NSNumber *)opration
{
    //测试用
    //    ParkingSpaceAreaViewController *vc = [[ParkingSpaceAreaViewController alloc] init];
    //    vc.operateState = 1;
    //    vc.opration = opration;
    //    [self.navigationController pushViewController:vc animated:YES];
    
    NSString *getUrl = BaseURL@"myAppointOrderList";
    NSLog(@"userID:%@",self.user.userID);
    NSDictionary *parameterDic = @{
                                   @"memberId":self.user.userID
                                   };
    [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
        NSLog(@"检查是否有预约:%@",dic);
        if (![dic[@"data"] isEqual:[NSNull null]])  {
            NSArray *dataArr = dic[@"data"];
            if (dataArr.count > 0) {
                ParkingYuYueViewController *vc = [[ParkingYuYueViewController alloc] init];
                AppointOrderModel *model = [[AppointOrderModel alloc] initWithDic:dataArr[0]];
                vc.appointModel = model;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } elseAction:^(NSDictionary *dic) {
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        
        //        ParkingSpaceAreaViewController *vc = [[ParkingSpaceAreaViewController alloc] init];
        //        vc.operateState = 1;
        //        vc.opration = opration;
        //        [self.navigationController pushViewController:vc animated:YES];
        //
        locationNum = 0;
        [self checkNestestParking];
        
    } failure:^(NSError *error) {
        
    }];
    return nil;
}
#pragma mark 我要停车2016
-(void)parkingCar
{
    if ([[CGTool shareInitial] isMonkeyWIFI] && [CGTool wasLogin]) {
        ParkingViewController *vc = [ParkingViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(!self.user.userID)
    {
        
        [self showFunctionAlertWithTitle:@"温馨提示" message:@"您尚未登录" functionName:@"点击登录" Handler:^{
            //[self loginBeforePushVC:NSStringFromClass([ParkingViewController class])];
            [self gotoLoginVC];
        }];
    }else
    {
        [self checkHaveAppointment:@1];
        
    }
}
#pragma mark 我要取车2016
-(void)pickupCar
{
    [_needle.layer removeAllAnimations];
    [UIView animateWithDuration:0.2f animations:^{
        
        _needle.transform = CGAffineTransformMakeRotation(0 );
        
    }completion:^(BOOL finished) {
        if ([[CGTool shareInitial] isMonkeyWIFI] && [CGTool wasLogin]) {
            PickUpViewController *vc = [PickUpViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }else if(!self.user.userID)
        {
            [self showFunctionAlertWithTitle:@"温馨提示" message:@"您尚未登录" functionName:@"点击登录" Handler:^{
                //                [self loginBeforePushVC:NSStringFromClass([PickUpViewController class])];
                [self gotoLoginVC];
                
            }];
            
        }else
        {
            //                [self checkHaveAppointment:@2];
            
            NSDictionary *parkingNote = [[NSUserDefaults standardUserDefaults]objectForKey:@"parkingNote"];
            if (parkingNote) {
                ParkingSpaceAreaViewController *vc = [[ParkingSpaceAreaViewController alloc] init];
                vc.operateState = 1;
                vc.opration = @2;
                Park *park = [[Park alloc] initWithDic:parkingNote];
                vc.park = park;
                vc.parkingNote = parkingNote;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                [MBProgressHUD showResult:NO text:@"没有停车记录" delay:1.0f];
                
            }
        }
    }];
}
#pragma mark 搜索最近停车场
-(void)checkNestestParking
{
    //定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    if ([CLLocationManager locationServicesEnabled]) {
        [_locationManager requestWhenInUseAuthorization];
        
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    nowLocation = [locations firstObject];//取出第一个位置
    
    // 收到地球后立即转火星
    nowLocation = [self transformToMars:nowLocation];// 转
    
    CLLocationCoordinate2D coordinate=nowLocation.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,nowLocation.altitude,nowLocation.course,nowLocation.speed);
    
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
    if (locationNum == 0) {
        locationNum = 1;
        [self checkNestestParkingFromNet];
    }
}
-(void)checkNestestParkingFromNet
{
    NSString *getUrl = BaseURL@"parkList";
    NSDictionary *parameterDic = @{
                                   @"positionX":[NSString stringWithFormat:@"%f",nowLocation.coordinate.latitude],
                                   @"positionY":[NSString stringWithFormat:@"%f",nowLocation.coordinate.longitude],
                                   @"pageSize":[NSString stringWithFormat:@"%d",10],
                                   @"pageNo":[NSString stringWithFormat:@"%ld",(long)1]
                                   };
    [[AFHTTPRequestOperationManager manager] GET:getUrl parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = responseObject;
        //        NSLog(@"dic:%@",dic);
        if ([dic[@"status"] isEqual:@(200)]) {
            
            [MBProgressHUD hideAllHUDsForView:Window animated:YES];
            // 建模（车库）
            for (NSDictionary *tempDic in dic[@"data"]) {
                //                NSLog(@"parkList:%@",tempDic);
                Park *p = [[Park alloc] mj_setKeyValues:tempDic];
                CLLocationCoordinate2D tempCoo = CLLocationCoordinate2DMake(p.parklat_R, p.parklon_R);
                tempCoo = [self GCJ02FromBD09:tempCoo];
                NSLog(@"%f   %f",p.parklat_R,tempCoo.latitude);
                p.parklat_R = tempCoo.latitude;
                p.parklon_R = tempCoo.longitude;
                
                CLLocation* dist=[[CLLocation alloc] initWithLatitude:p.parklat_R longitude:p.parklon_R];
                // 比较出一定距离内的停车场  暂定50m
                if ([nowLocation distanceFromLocation:dist] < k_allDistance ) {
                    //if([p.parkName isEqualToString:@"广州市钟村医院停车场"]){
#warning 测试用
                    NSLog(@"%f",[nowLocation distanceFromLocation:dist]);
                    
                    ParkingSpaceAreaViewController *vc = [[ParkingSpaceAreaViewController alloc] init];
                    vc.operateState = 1;
                    vc.opration = @1;
                    vc.park = p;
                    nestestPark = p;
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
            }
            if (!nestestPark) {
                [MBProgressHUD showMessag:@"200m内没有立体车库" toView:Window];
            }
        }else
        {
            [MBProgressHUD showError:dic[@"msg"] toView:self.view];
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"报错：%@", [error localizedDescription]);
        [MBProgressHUD showError:@"网络加载出错" toView:self.view];
    }];
}
#pragma mark 点击正中间猴子
-(void)clickMonkey
{
    [self stopCarAction];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 在主页设置跳转中心
- (void)pushVC:(NSNotification*)notification
{
    NSString *VC_Name = [notification userInfo][@"pushVCName"];
    
    UIViewController *vc = [[NSClassFromString(VC_Name) alloc] init];
    if (vc)
    {
        // 普通alloc的VC
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        // SB创建的VC
        vc = [Unit EPStoryboard:VC_Name];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - SDCycleScrollViewDelegate(图片轮播器代理)

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            //            [self myCheWei];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            //            MyAdverViewController *myAdvc = [[MyAdverViewController alloc] init];
            //            //[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
            //
            //            UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
            //
            //            [self.navigationItem setBackBarButtonItem:backItem];
            //            [self.navigationController pushViewController:myAdvc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 代码布局
- (void)codeLayout
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    
    
    
    
    if (!isIphone4s) {
        NSArray *images = @[[UIImage imageNamed:@"img15"],
                            //                        [UIImage imageNamed:@"img13"],
                            //                        [UIImage imageNamed:@"img14"],
                            //                        [UIImage imageNamed:@"img11"]
                            ];
        
        // 本地加载 --- 创建不带标题的图片轮播器
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH/2) imageNamesGroup:images];
        //    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH/2) imagesGroup:images];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        
        
        // 注意：上面如果是Classic类型，才可以直接强转成UIPageControl
        //    UIPageControl *pageControl = (UIPageControl *)_cycleScrollView.pa;
        //    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        //    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.251 green:0.482 blue:0.996 alpha:1.000];
        
        _cycleScrollView.infiniteLoop = YES;
        _cycleScrollView.delegate = self;
        
        //        _cycleScrollView.autoScrollTimeInterval = 4;
        _cycleScrollView.autoScroll = NO;
        [self.view addSubview:_cycleScrollView];
        
        UIImageView *waveImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64 + Width * (0.5 - 0.1), Width, Width * 0.1)];
        waveImage.image = [UIImage imageNamed:@"wave"];
        [self.view addSubview:waveImage];
    }
    
    
    UIView *meterView = [[UIView alloc] initWithFrame:CGRectMake(0, Heigth - 70 - Width, Width, Width)];
    [self.view addSubview:meterView];
    
    
#pragma mark 大圣停车
    CGFloat stopFloat = meterView.width * 0.3;
    UIButton *stopCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [stopCarBtn setFrame:CGRectMake(meterView.width * 0.35, meterView.height * 0.6, stopFloat, stopFloat)];
    [stopCarBtn setImage:[UIImage imageNamed:@"stopCar"] forState:UIControlStateNormal];
    [stopCarBtn addTarget:self action:@selector(parkingCar) forControlEvents:UIControlEventTouchUpInside];
    [meterView addSubview:stopCarBtn];
    UILabel *stopCarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, stopCarBtn.height/2, stopCarBtn.width, stopCarBtn.height/3)];
    stopCarLabel.textAlignment = NSTextAlignmentCenter;
    stopCarLabel.textColor = [UIColor whiteColor];
    stopCarLabel.text = @"大圣停车";
    stopCarLabel.font = [UIFont systemFontOfSize:13];
    [stopCarBtn addSubview:stopCarLabel];
    
#pragma mark 环
    UIImageView *roundImage = [[UIImageView alloc] initWithFrame:CGRectMake(meterView.width * 0.15, stopCarBtn.bottom - meterView.height * 0.5, meterView.width * 0.7,meterView.height * 0.5)];
    [roundImage setImage:[UIImage imageNamed:@"round"]];
    [meterView addSubview:roundImage];
    
#pragma mark 大圣取车
    CGFloat pickFloat1 = meterView.width * 0.2;
    CGFloat pickFloat2 = meterView.width * 0.25;
    UIButton *pickCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pickCarBtn setFrame:CGRectMake(meterView.width * 0.4, meterView.height * 0.15, pickFloat1, pickFloat2)];
    [pickCarBtn setImage:[UIImage imageNamed:@"pick"] forState:UIControlStateNormal];
    [pickCarBtn addTarget:self action:@selector(pickupCar) forControlEvents:UIControlEventTouchUpInside];
    [meterView addSubview:pickCarBtn];
    UILabel *pickCarLabel;
    if (isIphone6P) {
        pickCarLabel = [[UILabel alloc] initWithFrame:CGRectMake(pickCarBtn.width * 0.3, 0 , pickCarBtn.width * 0.4, pickCarBtn.height * 0.8)];
        pickCarLabel.font = [UIFont systemFontOfSize:15];
        
    }else
    {
        pickCarLabel = [[UILabel alloc] initWithFrame:CGRectMake(pickCarBtn.width * 0.2, 0 , pickCarBtn.width * 0.6, pickCarBtn.height * 0.8)];
        pickCarLabel.font = [UIFont systemFontOfSize:13];
        
    }
    
    pickCarLabel.textAlignment = NSTextAlignmentCenter;
    pickCarLabel.textColor = RGBA(46, 46, 46, 1);
    pickCarLabel.text = @"大圣\n取车";
    
    pickCarLabel.numberOfLines = 0;
    [pickCarBtn addSubview:pickCarLabel];
    
    CGFloat littleFloat = meterView.width * 0.2;
#pragma mark 我的钱包
    UIButton *myMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [myMoneyBtn setFrame:CGRectMake(roundImage.left , roundImage.top + roundImage.height * 0.05, littleFloat, littleFloat)];
    [myMoneyBtn setImage:[UIImage imageNamed:@"$"] forState:UIControlStateNormal];
    [meterView addSubview:myMoneyBtn];
    [myMoneyBtn addTarget:self action:@selector(myMoney) forControlEvents:UIControlEventTouchUpInside];
    UILabel *myMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake( - littleFloat * 0.75, littleFloat / 2, littleFloat, littleFloat / 2)];
    myMoneyLabel.textAlignment = NSTextAlignmentCenter;
    myMoneyLabel.text = @"我的钱包";
    myMoneyLabel.font = [UIFont systemFontOfSize:10];
    myMoneyLabel.textColor = RGBA(46, 46, 46, 1);
    [myMoneyBtn addSubview:myMoneyLabel];
    
#pragma mark 专用车位
    UIButton *mySpaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mySpaceBtn setFrame:CGRectMake(roundImage.right - littleFloat , roundImage.top + roundImage.height * 0.05, littleFloat, littleFloat)];
    [mySpaceBtn setImage:[UIImage imageNamed:@"Calendar"] forState:UIControlStateNormal];
    [meterView addSubview:mySpaceBtn];
    [mySpaceBtn addTarget:self action:@selector(mySpace) forControlEvents:UIControlEventTouchUpInside];
    UILabel *mySpaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(littleFloat * 0.75, littleFloat / 2, littleFloat, littleFloat / 2)];
    mySpaceLabel.textAlignment = NSTextAlignmentCenter;
    mySpaceLabel.text = @"专用车位";
    mySpaceLabel.font = [UIFont systemFontOfSize:10];
    mySpaceLabel.textColor = RGBA(46, 46, 46, 1);
    [mySpaceBtn addSubview:mySpaceLabel];
    
#pragma mark 我的订单
    UIButton *myOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [myOrderBtn setFrame:CGRectMake(roundImage.left - littleFloat * 0.4, roundImage.bottom - roundImage.height * 0.5, littleFloat, littleFloat)];
    [myOrderBtn setImage:[UIImage imageNamed:@"DOCUMENT"] forState:UIControlStateNormal];
    [myOrderBtn addTarget:self action:@selector(myOrder) forControlEvents:UIControlEventTouchUpInside];
    [meterView addSubview:myOrderBtn];
    UILabel *myOrderLabel = [[UILabel alloc] initWithFrame:CGRectMake( - littleFloat * 0.5, littleFloat *0.75, littleFloat, littleFloat / 2)];
    myOrderLabel.textAlignment = NSTextAlignmentCenter;
    myOrderLabel.text = @"我的订单";
    myOrderLabel.font = [UIFont systemFontOfSize:10];
    myOrderLabel.textColor = RGBA(46, 46, 46, 1);
    [myOrderBtn addSubview:myOrderLabel];
    
#pragma mark 常用地址
    UIButton *myAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [myAddressBtn setFrame:CGRectMake(roundImage.right - littleFloat * 0.5, roundImage.bottom - roundImage.height * 0.5, littleFloat, littleFloat)];
    [myAddressBtn setImage:[UIImage imageNamed:@"address"] forState:UIControlStateNormal];
    [meterView addSubview:myAddressBtn];
    [myAddressBtn addTarget:self action:@selector(myAddress) forControlEvents:UIControlEventTouchUpInside];
    UILabel *myAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake( littleFloat * 0.4, littleFloat *0.75, littleFloat, littleFloat / 2)];
    myAddressLabel.textAlignment = NSTextAlignmentCenter;
    myAddressLabel.text = @"常用地址";
    myAddressLabel.font = [UIFont systemFontOfSize:10];
    myAddressLabel.textColor = RGBA(46, 46, 46, 1);
    [myAddressBtn addSubview:myAddressLabel];
    
#pragma mark 指针旋转
    _needle = [[UIImageView alloc] initWithFrame:CGRectMake(meterView.width * 0.5 - 4, stopCarBtn.top + stopCarBtn.width * 0.25, 8,meterView.width * 0.15)];
    _needle.image = [UIImage imageNamed:@"needle"];
    _needle.layer.anchorPoint = CGPointMake(0.5 , 2);
    [meterView addSubview:_needle];
    
    _needleTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(needleRevolve) userInfo:nil repeats:YES];
    //循环旋转
    
    
    
    
    [[CGTool shareInitial] setTabbarWithViewController:self];
}

-(void)needleRevolve
{
    if (_revolve) {
        [UIView animateWithDuration:2.0f animations:^{
            _needle.transform = CGAffineTransformMakeRotation(90 * (M_PI / 180.0f));
            _revolve = 0;
        }];
    }else
    {
        [UIView animateWithDuration:2.0f animations:^{
            _needle.transform = CGAffineTransformMakeRotation(-89 * (M_PI / 180.0f));
            _revolve = 1;
        }];
    }
    
}

#pragma mark - 监听回调更新小红点
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"unReadCount"]){
        
        
        [self.nav.rightImageBtn showBadgeWithStyle:WBadgeStyleNumber value:DELE.unReadCount animationType:WBadgeAnimTypeNone];
    }
}

#pragma mark - 分享
- (void)onShare {
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UM_KEY
                                      shareText:@"新用户注册分享送这送那"
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToEmail,UMShareToSms,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToYXTimeline,UMShareToLWTimeline,nil]
                                       delegate:self];
}

#pragma mark 分享完成
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //    NSLog(@"%@", response);
    if (response.responseCode == UMSResponseCodeSuccess) {
        
        NSLog(@"============== 分享成功 =================");
        
        [self getRequestURL:BaseURL"shareCoupon"
         
                 parameters:@{
                              @"memberId":self.user.userID,
                              @"type":@"1"
                              }
         
                    success:^(NSDictionary *dic) {
                        
                        [MBProgressHUD showSuccess:dic[@"msg"] toView:Window];
                        
                    } elseAction:^(NSDictionary *dic) {
                        
                        [MBProgressHUD hideAllHUDsForView:Window animated:NO];
                        
                    } failure:^(NSError *error) {
                        
                        
                    }];
    }
    else
    {
        NSLog(@"============== 分享失败 =================");
    }
}

//检查是否强制更新
-(void)checkUpVersion
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
#warning 每次打开APP清除所有缓存  缺点是流量的浪费
    [AFHTTPRequestOperationManager manager].responseSerializer = [AFHTTPResponseSerializer serializer];
    [[AFHTTPRequestOperationManager manager] GET:APP_version parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSLog(@"网络地图版本号：%@",dic[@"map"]);
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        //        NSLog(@"%@",dic);
        if (![dic[@"version"] isEqualToString:appVersion]) {
            for (NSDictionary *dict in dic[@"question"]) {
                if ([appVersion isEqualToString:dict[@"version"]]) {
                    [self showFunctionAlertWithTitle:dict[@"message"][@"title"] message:dict[@"message"][@"message"] functionName:dict[@"message"][@"functionName"] Handler:^{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/cn/app/ting-che-da-sheng/id1080875914?mt=8"]];
                    }];
                }
            }
            
        }
        if ([self.fileData checkupFile:@"map.json"]) {
            
            if (![[self.fileData checkupMapVersion] isEqualToString:dic[@"map"]]) {
                [self.fileData updatedMap];
            }
        }else
        {
            [self.fileData updatedMap];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
        
    }];
}
-(FileData *)fileData
{
    if (!_fileData) {
        _fileData = [[FileData alloc] init];
    }
    return _fileData;
}
#pragma mark 点击左按钮
-(void)leftBtnClick
{
    SetUPViewController *vc = [[SetUPViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
