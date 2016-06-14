//
//  SpaceNumViewController.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/12.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "SpaceNumViewController.h"
#import "MySpaceOrderViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ParkingSpaceModel.h"
@interface SpaceNumViewController ()<CLLocationManagerDelegate>
@property (nonatomic ,strong)NSMutableArray *btnArr;
@property (nonatomic ,strong)UIButton *addBtn;
@end

@implementation SpaceNumViewController
{
    UIButton *selectBtn;
    CLLocationManager *_locationManager;//定位
    CLLocation *nowLocation;//位置
    NSInteger locationNum;//只需定位一次
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.nav setTitle:@"选择车位" leftText:nil rightTitle:nil showBackImg:YES];
    
    [self viewInitial];
    
    
    if (_spaceArr) {
        [self viewInitialFromNet];
    }
    if(_parkNo)//取车时限制车位
    {
        [self limitSpace];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewInitialFromNet
{
    for (ParkingSpaceModel *model in _spaceArr) {
        for (NSDictionary *dict in self.btnArr) {
            UIButton *btn = dict[@"btn"];
            if ([model.parkNo isEqualToString:[NSString stringWithFormat:@"%ld",(long)btn.tag]]) {
                if (model.type == 1) {
                    if(model.renttype == 0)
                    {
                        [btn setImage:[UIImage imageNamed:@"专"] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"r"] forState:UIControlStateSelected];
                        
                        btn.userInteractionEnabled = NO;
                    }else if (model.status == 1)
                    {
                        [btn setImage:[UIImage imageNamed:@"h"] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"r"] forState:UIControlStateSelected];
                        
                        btn.userInteractionEnabled = NO;
                        
                    }
                    
                    
                }else if (model.appointtype == 1)
                {
                    [btn setImage:[UIImage imageNamed:@"约"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"r"] forState:UIControlStateSelected];
                    
                    btn.userInteractionEnabled = NO;
                    
                }else if (model.status == 1)
                {
                    [btn setImage:[UIImage imageNamed:@"h"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"r"] forState:UIControlStateSelected];
                    
                    btn.userInteractionEnabled = NO;
                    
                }
            }
        }
    }
}
- (void)viewInitial
{
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setFrame:CGRectMake(10, Heigth - 50, Width - 20 , 40)];
    [_addBtn setBackgroundColor:RGBA(40, 125, 195, 1.0)];
    [_addBtn setTitle:@"提交" forState:UIControlStateNormal];
    _addBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:_addBtn];
    [_addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnArr = [[NSMutableArray alloc] init];
    //    NSLog(@"%@",_mapArr);
    NSInteger list = 0;
    NSInteger storey = 0;
    if (_spaceArr) {
        ParkingSpaceModel *lastModel = [_spaceArr lastObject];
        list = [[lastModel.parkNo substringWithRange:NSMakeRange(2, 1)] integerValue]; //列
        storey = [[lastModel.parkNo substringWithRange:NSMakeRange(0, 1)] integerValue];  //层
    }else
    {
        list = [_mapArr[5] integerValue]; //列
        storey = [_mapArr[6] integerValue];  //层
    }
    
    
    UIView *parkView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, Width, Width)];
    float parkFloat = Width / 6;
    for (NSInteger i = list - 1; i >= 0; i --) {
        for (NSInteger j = storey - 1; j >= 0; j --) {
            if (j != 0 && i == list - 1) {
                
            }else
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(Width / 2 - parkFloat * list / 2 + parkFloat * i, Width / 2 - parkFloat * storey / 2 + parkFloat * j, parkFloat, parkFloat - 10)];
                [btn setImage:[UIImage imageNamed:@"nullcar"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"r"] forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(spaceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = (storey - j ) * 100 + i + 1;
                [parkView addSubview:btn];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Width / 2 - parkFloat * list / 2 + parkFloat * i,Width / 2 - parkFloat * storey / 2 + parkFloat * (j + 1) - 10, parkFloat, 10)];
                label.tag = btn.tag + 10000;
                label.textColor = [UIColor grayColor];
                label.text = [NSString stringWithFormat:@"%ld",(long) btn.tag];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:10];
                [parkView addSubview:label];
                
                [self.btnArr addObject:@{@"btn":btn,@"label":label}];
            }
        }
    }
    
    [self.view addSubview:parkView];
}
-(void)spaceBtnClick:(UIButton *)sender
{
    selectBtn.selected = NO;
    sender.selected = !sender.selected;
    selectBtn = sender;
}
-(void)addBtnClick:(UIButton *)sender
{
    if (selectBtn) {
        locationNum = 0;
        [self checkDistancePass];
    }
    
}
#pragma mark 操控车库
-(void)controlParking
{
    if (selectBtn) {
        //        MySpaceOrderViewController *vc = [[MySpaceOrderViewController alloc] init];
        //        vc.park = _park;
        //        vc.parkArea = _parkArea;
        //        vc.parkNO = [NSString stringWithFormat:@"%ld",(long)selectBtn.tag];
        //        [self.navigationController pushViewController:vc animated:YES];
        
        NSString *getUrl = BaseURL@"remoteParkOrTakeCar";
        NSDictionary *parameterDic = @{
                                       @"memberId":self.user.userID,
                                       @"parkId":_park.ID,
                                       @"parkArea":_parkArea.length > 1 ?_parkArea:[NSString stringWithFormat:@"%@0",_parkArea],
                                       @"spaceNo":[NSString stringWithFormat:@"%ld",(long) selectBtn.tag],
                                       @"operation":_opration
                                       
                                       };
        NSDictionary *parkNote = [[NSUserDefaults standardUserDefaults] valueForKey:@"parkingNote"];
        if([_opration isEqualToNumber:@2] && [parkNote[@"type"] isEqualToString:@"2"])
        {
            
            for (ParkingSpaceModel *model in _spaceArr) {
                if ([model.parkNo isEqualToString:[NSString stringWithFormat:@"%ld",(long)selectBtn.tag]]) {
                    getUrl = BaseURL@"appointTakeCar";
                    parameterDic = @{
                                     @"memberId":self.user.userID,
                                     @"spaceId":model.dataIdentifier,
                                     @"orderId":parkNote[@"parkOrderId"]
                                     };
                }
            }
        }
        [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
            NSLog(@"getDic%@ %@",dic,dic[@"msg"]);
            [MBProgressHUD showResult:YES text:dic[@"msg"] delay:1.5f];
            if([dic[@"data"] isKindOfClass:[NSDictionary class]])
            {
                NSString *netOrderId = dic[@"data"][@"orderid"];
                if (!netOrderId) {
                    netOrderId = dic[@"data"][@"orderId"];
                }
                if (netOrderId) {
                    [self checkControlResult:netOrderId];
                }else
                {
                    [MBProgressHUD showError:@"数据出错,订单号为空" toView:Window];
                }
                
            }
            if ([_opration isEqualToNumber:@1]) {
                //保存停车记录
                [self safeParkingNote:_park andParkArea:_parkArea.length > 1 ?_parkArea:[NSString stringWithFormat:@"%@0",_parkArea] andParkNo:[NSString stringWithFormat:@"%ld",(long) selectBtn.tag] andControlType:1 andOrderId:@""];
                
            }else if([_opration isEqualToNumber:@2])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"parkingNote"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
        } elseAction:^(NSDictionary *dic) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}
#pragma mark 判断操作距离
-(void)checkDistancePass
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
    
    CLLocation* dist=[[CLLocation alloc] initWithLatitude:_park.parklat_R longitude:_park.parklon_R];
    NSLog(@"distance%f",[nowLocation distanceFromLocation:dist]);
    if ([nowLocation distanceFromLocation:dist] < k_allDistance) {
        if (locationNum == 0) {
            locationNum = 1;
            if([_opration isEqualToNumber:@2])
            {
                NSDictionary *parkingNote = [[NSUserDefaults standardUserDefaults] valueForKey:@"parkingNote"];
                [self showFunctionAlertWithTitle:@"请确认" message:[NSString stringWithFormat:@"请确认%@ %@是不是之前停的车位，若不是，请联系现场管理员",parkingNote[@"parkArea"],parkingNote[@"parkNo"]] functionName:@"确认（是）" Handler:^{
                    [self controlParking];
                    
                }];
            }else
            {
                [self controlParking];
                
            }
        }
    }else
    {
        [MBProgressHUD showResult:NO text:@"安全起见，请在车库旁操作" delay:2.0f];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark 限制取车能点的车位
-(void)limitSpace
{
    
    for (NSDictionary *dic in self.btnArr) {
        UIButton *btn = dic[@"btn"];
        if ([_parkNo isEqualToString:[NSString stringWithFormat:@"%ld",(long)btn.tag]]) {
            [self spaceBtnClick:btn];
        }else
        {
            btn.userInteractionEnabled = NO;
        }
    }
}

@end
