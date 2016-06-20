//
//  ParkingYuYueViewController.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/18.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ParkingYuYueViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ParkingYuYueViewController ()<CLLocationManagerDelegate>

@end

@implementation ParkingYuYueViewController
{
    CLLocationManager *_locationManager;//定位
    CLLocation *nowLocation;//位置
    Park *nestestPark; //最近的停车场
    NSInteger locationNum;//只需定位一次
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.nav setTitle:@"大圣停车" leftText:nil rightTitle:nil showBackImg:YES];
    [self viewInitial];
}
-(void)viewInitial
{
    NSLog(@"parkAddress:%@",_appointModel.parkAddress);
    self.parkAddress.text = _appointModel.parkAddress;
    self.parkCar.text = _appointModel.appointCarPlate;
    self.parkPrice.text = _appointModel.appointMoney;
    self.parkAreaNumLB.text = [NSString stringWithFormat:@"%@  %@",_appointModel.parkarea,_appointModel.parkno];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 确定停车
- (IBAction)sureParking:(id)sender {
    locationNum = 0;
    [self checkDistancePass];
}
#pragma mark 操控车库
-(void)controlParking
{
    NSNumber *opration = @1;
    NSString *getUrl = BaseURL@"appointParkCar";
    NSDictionary *parameterDic;
    if(_appointModel.orderId && _appointModel.spaceid)
    {
        parameterDic = @{
                         @"memberId":self.user.userID,
                         @"orderId":_appointModel.orderId,
                         @"spaceId":_appointModel.spaceid
                         };
    }else
    {
        k_orderIdError
        return;
    }
    
    [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
        NSLog(@"预约停车操控车库：%@",dic);
        if ([dic[@"data"] isKindOfClass:[NSDictionary class]]) {
            NSString *netOrderId = dic[@"data"][@"parkinoutId"];
            if (!netOrderId) {
                netOrderId = dic[@"data"][@"parkinoutid"];
            }
            if (netOrderId) {
                [MBProgressHUD showResult:YES text:dic[@"msg"] delay:1.5f];

                [self safeParkingNote:nestestPark andParkArea:_appointModel.parkarea andParkNo:_appointModel.parkno andControlType:2 andOrderId:_appointModel.orderId];

                [self checkControlResult:netOrderId andOpration:@1];
//                [self.navigationController popToRootViewControllerAnimated:YES];

            }else
            {
                [MBProgressHUD showError:@"数据出错,订单号为空" toView:Window];
            }

            
        }else
        {
            [MBProgressHUD showError:@"数据异常，订单为空" toView:Window];
        }
        
    } elseAction:^(NSDictionary *dic) {
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark 取消预约按钮
- (IBAction)cancelYuYue:(id)sender {
    [self showFunctionAlertWithTitle:@"确认取消" message:@"超过五分钟将无法退回预约费" functionName:@"确认" Handler:^{
        [self cancelAppoint];
    }];
}
#pragma mark 取消预约
-(void)cancelAppoint
{
    NSString *getUrl = BaseURL@"appointCancel";
    NSDictionary *parameterDic;
    if(_appointModel.orderId)
    {
        parameterDic = @{
                         @"memberId":self.user.userID,
                         @"orderId":_appointModel.orderId,
                         };
    }else
    {
        k_orderIdError
        return;
    }
    [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
        [MBProgressHUD showSuccess:dic[@"msg"] toView:Window];
        [self.navigationController popViewControllerAnimated:YES];
    } elseAction:^(NSDictionary *dic) {
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
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
    
    //    CLLocation* dist=[[CLLocation alloc] initWithLatitude:_park.parklat_R longitude:_park.parklon_R];
    //    if ([nowLocation distanceFromLocation:dist] < 50) {
    //        [self controlParking];
    //    }else
    //    {
    //        [MBProgressHUD showResult:NO text:@"安全起见，请在车库旁操作" delay:2.0f];
    //    }
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
                
                //                NSLog(@"%f",[nowLocation distanceFromLocation:dist]);
                if([p.ID isEqualToString:_appointModel.parkid]){
                    CLLocationCoordinate2D tempCoo = CLLocationCoordinate2DMake(p.parklat_R, p.parklon_R);
                    tempCoo = [self GCJ02FromBD09:tempCoo];
                    
                    p.parklat_R = tempCoo.latitude;
                    p.parklon_R = tempCoo.longitude;
                    
                    CLLocation* dist=[[CLLocation alloc] initWithLatitude:p.parklat_R longitude:p.parklon_R];
                    nestestPark = p;
                    if([nowLocation distanceFromLocation:dist] < k_allDistance){
                        [self controlParking];
                    }else
                    {
                        [MBProgressHUD showMessag:@"安全起见，请离停车场近点" toView:Window];
                        
                    }
                    break;
                }
            }
            if (!nestestPark) {
                [MBProgressHUD showMessag:@"没有找到停车场" toView:Window];
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

@end
