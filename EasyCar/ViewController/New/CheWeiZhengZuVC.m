//
//  CheWeiZhengZuVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/30.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//  涉及支付

#import "CheWeiZhengZuVC.h"
#import "WoDeDingDanVC.h"
@interface CheWeiZhengZuVC ()
@property (strong, nonatomic) IBOutlet UILabel *nameLB;
@property (strong, nonatomic) IBOutlet UILabel *phoneLB;
@property (strong, nonatomic) IBOutlet UILabel *parkNumLB;
@property (strong, nonatomic) IBOutlet UILabel *carPlateLB;
@property (strong, nonatomic) IBOutlet UILabel *rentTimeLB;
@property (strong, nonatomic) IBOutlet UILabel *rentPriceLB;


@end

@implementation CheWeiZhengZuVC
{
    Car *_car;
    //    NSString *_orderId;
    NSString *_payType;
    // 必要属性
    NSString *_parkSpaceId;
    NSString *_parkNo;
    NSString *_parkId;
    NSString *_parkArea;
    
    
    CGFloat _unitRentPrice;     // 整租单价
    CGFloat _totalRentPrice;    // 整租总价
    NSInteger _rentTime;        // 整租时长
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _payType = @"2";// 默认是余额支付
    _rentTime = 3;  // 默认时长三个月
    
    [self.nav setTitle:@"车位整租订单" leftText:@"返回" rightTitle:nil showBackImg:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseCarNote:) name:ReturnCarInfo object:nil];
    
    _nameLB.text = self.user.nickname;
    _phoneLB.text = self.user.phone;
    _parkNumLB.text = [NSString stringWithFormat:@"%@%@",_parkArea,_parkNo];
    _rentTimeLB.text = [NSString stringWithFormat:@"%ld个月",_rentTime];
    [self getFirstCar];
    [self getRentPrice];
}




#pragma mark 选择车辆
- (IBAction)selectCar:(id)sender {
    MyCarViewController *vc = [[MyCarViewController alloc] init];
    vc.selectType = selectForReturnValue;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 点击选择时长
- (IBAction)onChooseTime:(id)sender {
    
    // 在获取到整租价格前提下
    if (_unitRentPrice != 0) {
        
        UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"请选择整租时长" message:[NSString stringWithFormat:@"%.1f元／月",_unitRentPrice] preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSString *rent1 = [NSString stringWithFormat:@"1个月 共%.1f元",_unitRentPrice * 1];
        NSString *rent3 = [NSString stringWithFormat:@"3个月 共%.1f元",_unitRentPrice * 3];
        NSString *rent6 = [NSString stringWithFormat:@"6个月 共%.1f元",_unitRentPrice * 6];
        NSString *rent12 = [NSString stringWithFormat:@"12个月 共%.1f元",_unitRentPrice * 12];
        
        [alertCtl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertCtl addAction:[UIAlertAction actionWithTitle:rent1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selecteTime:1];
        }]];
        [alertCtl addAction:[UIAlertAction actionWithTitle:rent3 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selecteTime:3];
        }]];
        [alertCtl addAction:[UIAlertAction actionWithTitle:rent6 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selecteTime:6];
        }]];
        [alertCtl addAction:[UIAlertAction actionWithTitle:rent12 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selecteTime:12];
        }]];
        [self presentViewController:alertCtl animated:YES completion:nil];
        
    }
    
}

- (void)selecteTime:(NSInteger)time
{
    _totalRentPrice = time *_unitRentPrice;
    _rentTime = time;
    _rentTimeLB.text = [NSString stringWithFormat:@"%ld个月",_rentTime];
    _rentPriceLB.text = [NSString stringWithFormat:@"%.1f元",_totalRentPrice];
}




#pragma mark 选车辆后接收通知
- (void)chooseCarNote:(NSNotification *)note
{
    _car = note.object;
    self.carPlateLB.text = _car.carPlate;
    _carPlateLB.textColor = [UIColor blackColor];
}

#pragma mark - 获取默认车辆请求
- (void)getFirstCar
{
    NSString *url = CarURL;
    NSDictionary *parameters = @{
                                 @"memberId":[UserManager manager].userID,
                                 @"pageNo":@"1",
                                 @"pageSize":@"10"// 只获取第一辆车
                                 };
    [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        NSLog(@"%@", dic[@"msg"]);
        
        if ([dic[@"status"] isEqual:@(200)]) {
            
            Car *car = [Car new];
            [car mj_setKeyValues:dic[@"data"][0]];
            _car = car;
            _carPlateLB.text = car.carPlate;
            _carPlateLB.textColor = [UIColor blackColor];
        }
        else
        {
            [MBProgressHUD showError:@"未能获取默认车辆" toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"报错：%@", [error localizedDescription]);
    }];
}

#pragma mark 整租价格请求

- (void)getRentPrice
{
    NSString *url = BaseURL"getRentPrice";
    NSDictionary *parameters = @{
                                 @"parkId" : _parkId
                                 };
    [self getRequestURL:url parameters:parameters success:^(NSDictionary *dic) {
        
        _unitRentPrice = [dic[@"data"] floatValue]; // 获取到单价
        _totalRentPrice = _rentTime * _unitRentPrice;   // 计算总价
        _rentPriceLB.text = [NSString stringWithFormat:@"%.1f元",_totalRentPrice]; //显示总价
        
        
    } elseAction:^(NSDictionary *dic) {
        
        
    } failure:^(NSError *error) {
        
        
    }];
}
/*
 
 38.判断车牌在同一个停车场是否整租
 测试地址：h1ttp://localhost:8080/ytcSystem/rest/api/member/rentOr
 htt1p://localhost:8080/ytcSystem/rest/api/member/rentOr?memberId=402880fd50daddc60150dae4d36e0000&parkId=1&carPlate=1
 测试参数：memberId=会员id
 parkId=停车场id
 carPlate=车牌
 返回参数：status:200,msg:可从该停车场整租车位,data:null
 status:300,msg:已在停车场整租了车位，不能再次整租车位,data:null
 status:500,msg:请求异常，data:null
 */

#pragma mark 整租查重请求
- (void)requestZhengZuChaChong
{
    [self getRequestURL:BaseURL@"rentOr" parameters:@{
                                                      @"memberId":self.user.userID,
                                                      @"parkId":_parkId,
                                                      @"carPlate":_car.carPlate
                                                      }
                success:^(NSDictionary *dic) {
                    
                    // 查重请求通过 进行支付
                    Order *order = [Order new];
                    order.productName = @"整租订单";
                    order.productDescription = _nameLB.text;
                    #warning 注意啦：测试价格0.01
                    order.amount = @"0.01";
                    
                    [self showPayAlertWithOrder:order];

                    
                } elseAction:^(NSDictionary *dic) {
                    
                    
                } failure:^(NSError *error) {
                    
                    
                }];
}

#pragma mark 整租请求
- (void)requestZhengZuCheWei
{
    
    NSString *url = BaseURL@"rentOrder";
    
    NSDictionary *parameters = @{
                                 @"memberId"    :self.user.userID,
                                 @"parkId"      :_parkId,
                                 @"carPlate"    :_car.carPlate,
                                 @"rentTime"    :[NSString stringWithFormat:@"%ld",(long)_rentTime],
                                 @"parkSpaceId" :_parkSpaceId,
                                 @"parkNo"      :_parkNo,
                                 @"parkArea"    :_parkArea,
                                 @"rentMoney"   :[NSString stringWithFormat:@"%.2f",_totalRentPrice],
                                 @"type"        :_payType
                                 };
    [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        NSLog(@"%@", dic[@"msg"]);
        
        if ([dic[@"status"] isEqual:@(200)]) {
            
            [MBProgressHUD showResult:YES text:dic[@"msg"] delay:1];
            
            [self performSelector:@selector(afterPaySucess) withObject:nil afterDelay:1];
            
            
        }
        else
        {
            [MBProgressHUD showError:dic[@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"报错：%@", [error localizedDescription]);
        [MBProgressHUD showError:@"网络加载失败" toView:self.view];
    }];
}

#pragma mark 点击支付
- (IBAction)clickPayBtn:(id)sender {
    
    if (!_car) {
        
        [MBProgressHUD showResult:NO text:@"您还没选择车辆" delay:0.7];
        return;
    }
    if (_totalRentPrice == 0) {
        
        [MBProgressHUD showResult:NO text:@"尚未获取到整租价格" delay:0.7];
        return;
    }
    
    [self requestZhengZuChaChong];
}

- (void)payResultHandle:(NSNotification *)notification
{
    [super payResultHandle:notification];
    
    if ([notification.object isEqual: @1]) {
        
        _payType = notification.userInfo[@"payType"];
        NSLog(@"VC：支付成功");
        [self requestZhengZuCheWei];
    }
    else
    {
        NSLog(@"VC：支付失败");
    }
}


/**
 *  设置必要属性
 */
- (void)necessaryProperty:(NSDictionary *)dic parkArea:(NSString *)parkArea parkId:(NSString *)parkId
{
    _parkNo = dic[@"parkNo"];
    _parkSpaceId = dic[@"parkSpaceId"];
    _parkId = parkId;
    _parkArea = parkArea;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)gotoBalancePay:(Order *)order
{
    NSDictionary *parameters = @{
                                 @"memberId":self.user.userID,
                                 @"payFee":order.amount
                                 };
    
    [self getRequestURL:BaseURL@"payByBalance" parameters:parameters success:^(NSDictionary *dic) {
        
        self.user.balance = [dic[@"data"] doubleValue];
        
        [self requestZhengZuCheWei];
        
    } elseAction:^(NSDictionary *dic) {
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark 支付成功上传给后台的操作
- (void)afterPaySucess
{
    UIViewController *rootVC = [self.navigationController.viewControllers firstObject];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    WoDeDingDanVC *vc = [Unit EPStoryboard:@"WoDeDingDanVC"];
    vc.pageIndex = 1;
    [rootVC.navigationController pushViewController:vc animated:YES];
    
    
    
}
@end
