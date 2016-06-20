//
//  MySpaceViewController.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/11.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "MySpaceViewController.h"
#import "MySpaceModel.h"
#import "MySpaceTableViewCell.h"
#import "WoYaoTingCheVC.h"
#import "TransferViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MySpaceViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
@property (nonatomic ,strong)NSMutableArray *dataArr;
@property (nonatomic ,strong)UITableView *dataTabel;
@end

@implementation MySpaceViewController
{
    UIButton *historyBtn;
    CLLocationManager *_locationManager;//定位
    CLLocation *nowLocation;//位置
    Park *nestestPark; //最近的停车场
    NSNumber *_operation;//操作模式
    UIButton *_clickBtn;//点击的按钮
    NSInteger locationNum;//只需定位一次
}
-(UITableView *)dataTabel
{
    
    if (!_dataTabel) {
        _dataTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Heigth -64-100) style:UITableViewStylePlain];
        _dataTabel.backgroundColor = RGBA(240, 240, 240, 1);
        _dataTabel.dataSource = self;
        _dataTabel.delegate = self;
        _dataTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dataTabel.estimatedRowHeight = 60;
        [_dataTabel registerNib:[UINib nibWithNibName:@"MySpaceTableViewCell" bundle:nil] forCellReuseIdentifier:@"mySpaceCell"];
    }
    return _dataTabel;
}
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.nav setTitle:@"专用车位" leftText:nil rightTitle:nil showBackImg:YES];
    [self.nav.rightImageBtn setImage:[Unit changeImage:[UIImage imageNamed:@"iconfont_tianjia"] toScale:2] forState:UIControlStateNormal];
    
    [self.view addSubview:self.dataTabel];
    
    [self addCoverView];
//    NSLog(@"%@",self.user.userID);
    
}
-(void)addCoverView
{
    self.coverView = [[NSBundle mainBundle] loadNibNamed:@"CoverView" owner:nil options:nil][0];
    self.coverView.frame = self.dataTabel.bounds;
    self.coverView.tag = 100;
    [self.coverView setTitle:@"努力加载中" image:[UIImage imageNamed:@"zhanweitu-1"] handle:^{
        
    }];
    
    [self.dataTabel addSubview:self.coverView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
}
#pragma mark 添加车位
-(void)right
{
    WoYaoTingCheVC * vc = [[WoYaoTingCheVC alloc] init];
    vc.mapType = 3;
    vc.lastVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 刷新数据
-(void)requestData
{
    NSLog(@"刷新数据");
    NSString *getUrl = BaseURL@"myRentSpace";
    NSDictionary *parametersDic = @{@"memberId":[UserManager manager].userID,
//                                    @"pageNo":@1,
//                                ;    @"pageSize":@10,
                                    };
//    NSLog(@"%@?memberId:%@&pageNo:1&pageSize:20",getUrl,[UserManager manager].userID);

    [self getRequestURL:getUrl parameters:parametersDic success:^(NSDictionary *dic) {
        [self.coverView removeFromSuperview];
        NSLog(@"%@",dic);
        if (![dic[@"data"] isEqual:[NSNull null]]) {
            [self.dataArr removeAllObjects];
            for (NSDictionary *dict in dic[@"data"]) {
                MySpaceModel *model = [[MySpaceModel alloc] initWithDict:dict];
                [self.dataArr addObject:model];
                
            }
        }
        
        [self.dataTabel reloadData];
    } elseAction:^(NSDictionary *dic) {
        
        [self.coverView setTitle:@"无信息" image:[UIImage imageNamed:@"icon_car_nomal"] handle:nil];

    } failure:^(NSError *error) {
        [self.coverView setTitle:error.localizedDescription image:[UIImage imageNamed:@"icon_car_nomal"] handle:nil];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
//    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MySpaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mySpaceCell"];
    if (self.dataArr.count > indexPath.row) {
        [cell setCellInfoWithModel:self.dataArr[indexPath.row]];
    }
    
    cell.selectBtn.tag = indexPath.row + 10000;
    [cell.selectBtn addTarget:self action:@selector(cellSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.clickBtn.tag = indexPath.row + 20000;
    [cell.clickBtn addTarget:self action:@selector(cellClickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    cell.addressStr.tag = indexPath.row + 10000;
//    cell.addressEdit.tag = indexPath.row + 20000;
//    cell.addressDelete.tag = indexPath.row + 30000;
//    [cell setCellInfoWithModel:_addressArr[indexPath.row]];
//    [cell.addressStr addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigateAddress:)]];
//    [cell.addressEdit addTarget:self action:@selector(editOftenAddress:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.addressDelete addTarget:self action:@selector(deleteOftenAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
#pragma mark 点击cell
-(void)cellClickBtnClick:(UIButton *)sender
{
    MySpaceModel *model = self.dataArr[sender.tag - 20000];
    _clickBtn = sender;
    
    if ([model.rentType isEqualToNumber:@2]) {
        [MBProgressHUD showMessag:[NSString stringWithFormat:@"%@库%@车位上有其他车，整租尚未生效",[model.parkArea substringWithRange:NSMakeRange(0, 1)],model.parkNo] toView:Window];
        return;
    }
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"操控车库" message:[NSString stringWithFormat:@"区域：%@库  车位号：%@",[model.parkArea substringWithRange:NSMakeRange(0, 1)],model.parkNo] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *handleAction1 = [UIAlertAction actionWithTitle:@"停车" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _operation = @1;
        [self mySpaceParkingOrPickUp];
    }];
    UIAlertAction *handleAction2 = [UIAlertAction actionWithTitle:@"取车" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _operation = @2;
        [self mySpaceParkingOrPickUp];

    }];
    [alertCtl addAction:cancelAction];
    [alertCtl addAction:handleAction1];
    [alertCtl addAction:handleAction2];

    if([model.result isEqualToNumber:@4])
    {
        [MBProgressHUD showResult:NO text:@"该车位已转租" delay:1.0f];
    }else
    {
        [self presentViewController:alertCtl animated:YES completion:nil];

    }
}
#pragma mark 专用车位停取车
-(void)mySpaceParkingOrPickUp
{
    locationNum = 0 ;
    [self checkDistancePass];
}

#pragma mark 点击cell左边
-(void)cellSelectBtnClick:(UIButton*)sender
{
    historyBtn.selected = NO;
    historyBtn = sender;
    sender.selected = YES;
}
#pragma mark 转租收益
- (IBAction)checkTransfer:(id)sender {
    TransferViewController *vc = [[TransferViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 转租
- (IBAction)rentTran:(id)sender {
    
    if (!historyBtn) {
        return;
    }
    NSString *getUrl = BaseURL@"rentTran";
    MySpaceModel *model = self.dataArr[historyBtn.tag - 10000];
//    NSLog(@"%@",[Unit stringFromTimeInterval:1467648000 formatterOrNil:@"yyyyMMdd"]);
//    return;
    if ([model.result isEqual:@4]) {
        [MBProgressHUD showResult:YES text:@"已转租" delay:1.0f];

    }
    NSDictionary *parameterDic = @{
                                   @"id":model.parkspaceId,
                                   @"startDay":[Unit getTimeWithFormat:@"yyyyMMdd"],
                                   @"endDay":[Unit stringFromTimeInterval:[model.endTime.length >=10 ?[model.endTime substringToIndex:10]:model.endTime doubleValue] formatterOrNil:@"yyyyMMdd"]
//                                   @"endDay":[Unit stringFromTimeInterval:[model.endTime doubleValue] formatterOrNil:@"yyyyMMdd"]
                                   };
//    NSLog(@"parameterDic:%@",parameterDic);
    [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
        NSLog(@"getDic%@",dic);
        [MBProgressHUD showSuccess:dic[@"msg"] toView:Window];
        if ([dic[@"data"] isKindOfClass:[NSDictionary class]]) {
            NSString *netOrderId = dic[@"data"][@"orderid"];
            if (!netOrderId) {
                netOrderId = dic[@"data"][@"orderId"];

            }
            [self checkRentTranResult:netOrderId];
        
        
        //保存转租记录到本地
        NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
        NSMutableArray *rentTranList = [NSMutableArray arrayWithArray:[users valueForKey:@"rentTranList"]];
        [rentTranList addObject:@{@"parkSpaceId":model.parkspaceId,@"orderId":netOrderId}];
            [users setObject:rentTranList forKey:@"rentTranList"];
            [users synchronize];
        }
    } elseAction:^(NSDictionary *dic) {
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark 转租结果查询
-(void)checkRentTranResult:(NSString *)orderID
{
    NSString *getUrl = BaseURL@"getStatus/rentTran";
    NSDictionary *parameterDic = @{
                                   @"id":orderID
                                   };
    [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
        NSLog(@"getDic%@",dic);
        [MBProgressHUD showSuccess:dic[@"msg"] toView:Window];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(requestData) withObject:nil afterDelay:1.0f];
        });
    } elseAction:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(requestData) withObject:nil afterDelay:1.0f];
        });
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark 取消转租
- (IBAction)cancelRentTran:(id)sender {
    if(!historyBtn)
    {
        return;
    }
    NSString *getUrl = BaseURL@"rentTranCancel";
    NSDictionary *parameterDic = nil;
    MySpaceModel *model = self.dataArr[historyBtn.tag - 10000];
    if (![model.result isEqual:@4]) {
        [MBProgressHUD showResult:YES text:@"已取消转租" delay:1.0f];
        
    }
    
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSMutableArray *rentTranList = [NSMutableArray arrayWithArray:[users valueForKey:@"rentTranList"]];
    for (NSDictionary *dict in rentTranList) {
        if ([dict[@"parkSpaceId" ] isEqualToString:model.parkspaceId]) {
            parameterDic = @{
                                           @"id":model.parkspaceId,
                                           @"supsid":dict[@"orderId"]
                                           };
        }
    }
    if (!parameterDic) {
        [MBProgressHUD showError:@"没有转租记录" toView:Window];
    }else
    {
        //    NSLog(@"parameterDic:%@",parameterDic);
        [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
            [MBProgressHUD showSuccess:dic[@"msg"] toView:Window];
            dispatch_async(dispatch_get_main_queue(), ^{
                //            [self requestData];
                [self performSelector:@selector(requestData) withObject:nil afterDelay:2.0f];
            });
        } elseAction:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(requestData) withObject:nil afterDelay:2.0f];
            });
        } failure:^(NSError *error) {
            
        }];
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
#pragma mark 操控车库
-(void)controlParking
{
    MySpaceModel *model = self.dataArr[_clickBtn.tag - 20000];
    
    NSString *getUrl = BaseURL@"remoteParkOrTakeCar";
    NSDictionary *parameterDic = @{
                                   @"memberId":self.user.userID,
                                   @"parkId":model.parkId,
                                   @"parkArea":model.parkArea.length > 1 ?model.parkArea:[NSString stringWithFormat:@"%@0",model.parkArea],
                                   //                                   @"parkArea":@"A0",
                                   @"spaceNo":model.parkNo,
                                   @"operation":_operation
                                   
                                   };
    [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
        NSLog(@"专用车位停取车：%@",dic);
        if([dic[@"data"] isKindOfClass:[NSDictionary class]])
        {
            NSString *netOrderId = dic[@"data"][@"orderid"];
            if (!netOrderId) {
                netOrderId = dic[@"data"][@"orderId"];
            }
            if (netOrderId) {
                [self checkControlResult:netOrderId andOpration:@9];
            }else
            {
                [MBProgressHUD showError:@"数据出错,订单号为空" toView:Window];
            }
            
        }
        [MBProgressHUD showResult:YES text:dic[@"msg"] delay:1.5f];
    } elseAction:^(NSDictionary *dic) {
        
    } failure:^(NSError *error) {
        
    }];

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
    
    //    CLLocation* dist=[[CLLocation alloc] initWithLatitude:_park.parklat_R longitude:_park.parklon_R];
    //    if ([nowLocation distanceFromLocation:dist] < 50) {
    //        [self controlParking];
    //    }else
    //    {
    //        [MBProgressHUD showResult:NO text:@"安全起见，请在车库旁操作" delay:2.0f];
    //    }
    if(locationNum == 0)
    {
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
                MySpaceModel *model = self.dataArr[_clickBtn.tag - 20000];

                if([p.ID isEqualToString:model.parkId]){
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
