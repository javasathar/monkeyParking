//
//  YuYueStopViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/20.
//  Copyright (c) 2015年 深圳市易停车库科技有限公司. All rights reserved.
//  涉及支付

#import "YuYueStopViewController.h"
#import "ChooseCarViewController.h"
#import "WashCarViewController.h"
#import "ChongdianViewController.h"
#import "BuySomeViewController.h"
#import "OrderCarsViewController.h"
#import "MyCarViewController.h"
#import "MyParkingSpaceVC.h"
#import "AlipayHeader.h"
#import "MyTicketViewController.h"
#import "WoDeDingDanVC.h"
#import "ParkDetailViewController.h"
#import "YuYueOrderViewController.h"
#import "AppointOrderModel.h"
@interface YuYueStopViewController ()
@property (strong, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *parkNameLB;

@property (weak, nonatomic) IBOutlet UILabel *parkMessage;
@end

@implementation YuYueStopViewController
{
    UIView *_dateView;
    UIView *_dateViewBg;
    UIDatePicker *_datePicker;
    Coupon *_coupon;
    
//    NSString *_orderId;
    /** 0支付宝1微信支付2余额3优惠券 */
    NSString *_payType;
    
    NSString *_checkOrderId;//订单num不一定是订单号
    
    NSInteger checkNum; //检查订单有效次数
    
    Order *otherOrder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _payType = @"2";// 默认是余额支付
    
    self.title = @"预约车位";
    [self.nav setTitle:@"预约车位" leftText:@"返回" rightTitle:nil showBackImg:YES];

    _priceLB.text = [NSString stringWithFormat:@"%.0f元",_park.appointFee];
    //    _priceLB.text = [NSString stringWithFormat:@"%@元/每小时",_data[@"price"]];
    
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseCarNote:) name:ReturnCarInfo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseCouponNote:) name:ReturnCouponInfo object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePayResultOfAppointPark:) name:PayResultOfAppointPark_Note object:nil];
    
    
    
    self.view.backgroundColor = RGBA(242, 242, 248, 1);
    self.addressLabel.text = _park.address;
    self.chooseCarLabel.userInteractionEnabled = YES;
    self.parkNameLB.text = _park.parkName;
    
    UITapGestureRecognizer *chooseCar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCarAction)];
    [self.chooseCarLabel addGestureRecognizer:chooseCar];
    UITapGestureRecognizer *chooseCoupon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseAction)];
    [_chooseCouponLB addGestureRecognizer:chooseCoupon];
    
    [self initDatePicker];
    
    [self.washBtn setImage:[UIImage imageNamed:@"select"] forState:(UIControlStateSelected)];
    [self.washBtn setImage:[UIImage imageNamed:@"unselect"] forState:(UIControlStateNormal)];
    [self.chongBtn setImage:[UIImage imageNamed:@"select"] forState:(UIControlStateSelected)];
    [self.chongBtn setImage:[UIImage imageNamed:@"unselect"] forState:(UIControlStateNormal)];
    [self.chongBtn addTarget:self action:@selector(chooseDian:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.washBtn addTarget:self action:@selector(choosewater:) forControlEvents:(UIControlEventTouchUpInside)];
    self.washLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *wash = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(washa)];
    [self.washLabel addGestureRecognizer:wash];
    self.chongLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *chong = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dianaa)];
    [self.chongLabel addGestureRecognizer:chong];
    
    self.buyBtn.layer.cornerRadius = 3;
    [self.buyBtn addTarget:self action:@selector(buyAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self getFirstCar];

    if (_park) {
        self.parkMessage.text = [NSString stringWithFormat:@"! 支付后请在%.0f分钟内到停车场停车",_park.validDate];

    }
}

#pragma mark 获取默认车辆
- (void)getFirstCar
{
    NSString *url = CarURL;
    NSDictionary *parameters = @{
                                 @"memberId":[UserManager manager].userID,
                                 @"pageNo":@"1",
                                 @"pageSize":@"10"
                                 };
    [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        NSLog(@"%@", dic[@"msg"]);
        
        if ([dic[@"status"] isEqual:@(200)]) {
            
            Car *car = [Car new];
            [car mj_setKeyValues:dic[@"data"][0]];
            _car = car;
            _chooseCarLabel.text = car.carPlate;

            _chooseCarLabel.textColor = [UIColor blackColor];
        }
        else
        {
            [MBProgressHUD showError:@"未能获取默认车辆" toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"报错：%@", [error localizedDescription]);
    }];
}

#pragma mark 发送请求（不再传入订单号）作废
//- (void)requestAppointPark:(NSString *)orderId
//{
//
//    NSString *url = BaseURL@"appointParkInfo";
//    
//    NSDictionary *parameters = @{
//                                 
//                                 @"elec":@"7",//_chongBtn.selected ? @"1" : @"0",
//                                 @"wash":@"7",//_washBtn.selected ? @"1" : @"0",
//                                 @"memberId":self.user.userID,
//                                 @"appointCarplate":_car.carPlate,
//                                 @"couponId":_coupon ? _coupon.ID : @"",// 没使用传这个
//                                 @"parkId":_park.ID,
//                                 @"appointMoney":[NSString stringWithFormat:@"%.1f",_park.appointFee],
//                                 @"result":_payType,
//                                 @"validDate":[NSString stringWithFormat:@"%.0f",_park.validDate]
//                                 
//
//                                 };
//    
//    [self getRequestURL:url parameters:parameters success:^(NSDictionary *dic) {
//        
//        [MBProgressHUD showResult:YES text:dic[@"msg"] delay:1];
//
//        [self performSelector:@selector(afterPaySucess) withObject:nil afterDelay:1];
//        
//    } elseAction:^(NSDictionary *dic) {
//        
//        //理论上不应该出错
//        [self showNormalAlertWithTitle:@"出错了,请截图并联系客服" message:[NSString stringWithFormat:@"%@\n%@\n%@",url,parameters,dic]];
//        
//    } failure:^(NSError *error) {
//        
//        [self requestAppointPark:nil];
//        
//    }];
//    
//}
//


#pragma mark 支付成功上传给后台的操作
- (void)afterPaySucess
{
    UIViewController *rootVC = [self.navigationController.viewControllers firstObject];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    WoDeDingDanVC *vc = [Unit EPStoryboard:@"WoDeDingDanVC"];
    [rootVC.navigationController pushViewController:vc animated:YES];
}


- (void)washa
{
    WashCarViewController *washVC = [[WashCarViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController pushViewController:washVC animated:YES];
}

- (void)dianaa
{
    ChongdianViewController *chongVC = [[ChongdianViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController pushViewController:chongVC animated:YES];
}

- (void)chooseproduct
{
    BuySomeViewController *chongVC = [[BuySomeViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController pushViewController:chongVC animated:YES];
    
}

#pragma mark
- (void)chooseDian:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
}

- (void)choosewater:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
}

//#pragma mark 选择车位
//- (void)chooseParkSpaceAction
//{
//
//    MyParkingSpaceVC *vc = [[MyParkingSpaceVC alloc] initWithNibName:@"MyParkingSpaceVC" bundle:nil];
//    #warning 注意啦 后台有数据后修改A
//    vc.data = @{
//                @"parkId":_data[@"id"],
//                @"parkArea":@"A"
//                };
//    vc.function = toChooseParkSpace;
//    [self.navigationController pushViewController:vc animated:YES];
//
//}

#pragma mark 选择车辆
- (void)chooseCarAction
{
    MyCarViewController *vc = [[MyCarViewController alloc] init];
    vc.selectType = selectForReturnValue;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 选择优惠券
- (void)chooseAction
{
    MyTicketViewController *vc = [[MyTicketViewController alloc] init];
    vc.returnType = ReturnTypeCoupon;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 调优惠劵支付
-(void)gotoPreferential:(Order *)order
{
    [self chooseAction];
    otherOrder = order;
}

#pragma mark - 点击提交
- (void)buyAction
{
    // 必须选车
    if (!_car) {
        [MBProgressHUD showError:@"请选择车辆" toView:self.view];
        return;
    }
    else
    {
        // 检查可否预约，通过后进入支付流程，，，现在是直接进入支付流程
        
        [self doPay];
    }
}

#pragma mark 重复预约检查请求 作废

//- (void)checkAppointOrNot
//{
//    NSString *url = BaseURL"appointOr";
//    NSDictionary *parameters = @{
//                                 @"parkId":_park.ID,
//                                 @"carPlate":_car.carPlate
//                                 };
//    [self getRequestURL:url parameters:parameters success:^(NSDictionary *dic) {
//        
//        // 可预约进支付
//        
//        
//    } elseAction:^(NSDictionary *dic) {
//        
//        
//    } failure:^(NSError *error) {
//        
//        
//    }];
//}


#pragma mark 进行支付

- (void)doPay
{
    [self yuyueSpace];

    // 如果选择了优惠券,判断优惠券金额是否足够直接支付 ，，，现在下订单时暂时没有优惠劵
//    if (_coupon) {
//        
//        if (_coupon.amount >= _park.appointFee) {
//            NSLog(@"直接使用优惠券");
//            
//            _payType = @"3";// 3:优惠券支付
//            // 不再传入订单号
//            [self requestAppointPark:nil];
//        }
//        else
//        {
//            double payPrice = _park.appointFee - _coupon.amount;// 应付款
//            NSLog(@"使用优惠券抵用金额%f,还需支付%f", _coupon.amount, payPrice);
//            
//            Order *order = [Order new];
//            order.productName = [NSString stringWithFormat:@"%@预约停车",_car.carPlate];
//            order.productDescription = @"预约停车";
//#warning 注意啦：测试价格0.01
//            order.amount = @"0.01";//[NSString stringWithFormat:@"%.1f",payPrice];
//            
//            // 调支付
//            [self showPayAlertWithOrder:order];
//            
//        }
//    }
//    // ❸ 如果没有选择优惠券
//    else
//    {
//        NSLog(@"不使用优惠券");
//        Order *order = [Order new];
//        order.productName = [NSString stringWithFormat:@"%@预约停车",_car.carPlate];
//        order.productDescription = @"预约停车";
//#warning 注意啦：测试价格0.01
//        order.amount = @"0.01";//[NSString stringWithFormat:@"%.1f",_appointPrice];
//        // 调支付
//        [self showPayAlertWithOrder:order];
//    }
//
}
#pragma mark 弹出支付弹框
-(void)showPayAlertWithPrice:(NSString *)truePrice and:(NSString *)orderNum
{
    Order *order = [Order new];
    order.productName = [NSString stringWithFormat:@"%@预约停车",_car.carPlate];
    order.productDescription = @"预约停车";
#warning 注意啦：测试价格0.01
//    order.amount = @"0.01";
    order.amount = [NSString stringWithFormat:@"%.1f",[_priceLB.text floatValue]];
    // 调支付
    order.orderNum = orderNum;
    order.orderID = _checkOrderId;
    order.payType = @1;//预约订单
    [self showPayAlertWithOrder:order];
}
#pragma mark 取消
-(void)cancelHandler
{
    NSLog(@"取消支付，取消订单");
//    NSString *getUrl = BaseURL@"appointCancel";
//    NSDictionary *parameterDic = @{@"memberId":self.user.userID,
//                                   @"orderId":_checkOrderId,
//                                   
//                                   };
//    [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
//        
//    } elseAction:^(NSDictionary *dic) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
}
#pragma mark 预约车位
-(void)yuyueSpace
{
    
#pragma mark 预约车位先  //现在是先预约成功，服务器保留车位，再生成订单后再支付
    NSString *getUrl = BaseURL@"appointParkInfo";
    NSDictionary *parameterDic = @{@"appointCarplate":_car.carPlate,
                                   @"parkId":_park.ID,
//                                   @"parkId":@"8aafdae854a3048a0154a39042d10004",
                                   @"elec":@0,
                                   @"wash":@0,
#warning 注意啦：测试价格0.01
                                   @"appointMoney":_priceLB.text,
                                   @"memberId":self.user.userID
                                   };
    
    
#warning 测试用
//    _checkOrderId = @"8aafdae854b7f1b20154bcaf877a0071";
//    checkNum = 1;
//    [self performSelector:@selector(checkOrderEffectiveness) withObject:nil afterDelay:1.0f];

    [[AFHTTPRequestOperationManager manager] GET:getUrl parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSLog(@"预约结果：%@  %@",dic,dic[@"msg"]);

        if ([dic[@"status"] isEqual:@200]) {
//            NSLog(@"预约成功：%@",dic);

            [MBProgressHUD showSuccess:dic[@"msg"] toView:Window];
            if(![dic[@"data"] isEqual:[NSNull null]])
            {
                if (dic[@"data"]) {
                    if ([dic[@"data"] isKindOfClass:[NSDictionary class]]) {
                        _checkOrderId = dic[@"data"][@"orderid"];

                    }else
                    {
                        _checkOrderId = dic[@"data"];

                    }
                }
                
                checkNum = 1;
                [self performSelector:@selector(checkOrderEffectiveness) withObject:nil afterDelay:1.0f];
            }
            
        }
//        else if([dic[@"status"] isEqual:@500])
//        {
//            [self showFunctionAlertWithTitle:@"是否重新预约" message:dic[@"msg"] functionName:@"重新预约" Handler:^{
//                [self checkHaveAppointment:nil];

//                    NSString *getUrl = BaseURL@"appointCancel";
//                    NSDictionary *parameterDic = @{@"memberId":self.user.userID,
//                                                   @"orderId":_checkOrderId,
//                
//                                                   };
//                    [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
//                
//                    } elseAction:^(NSDictionary *dic) {
//                        
//                    } failure:^(NSError *error) {
//                        
//                    }];
//                [self yuyueSpace];
//            }];
//        }
        else{
//            NSLog(@"已预约：%@",dic);

            [MBProgressHUD showSuccess:dic[@"msg"] toView:Window];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"预约失败" toView:Window];
    }];
}
#pragma mark 检查是否有预约
-(NSString *)checkHaveAppointment:(NSNumber *)opration
{
    NSString *getUrl = BaseURL@"myAppointOrderList";
    NSDictionary *parameterDic = @{
                                   @"memberId":self.user.userID
                                   };
    [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
        NSLog(@"检查是否有预约:%@",dic);
        if (![dic[@"data"] isEqual:[NSNull null]]) {
            NSArray *dataArr = dic[@"data"];
            if (dataArr.count > 0) {
                AppointOrderModel *model = [[AppointOrderModel alloc] initWithDic:dataArr[0]];
                    NSString *getUrl = BaseURL@"appointCancel";
                    NSDictionary *parameterDic = @{@"memberId":self.user.userID,
                                                   @"orderId":model.orderId,
                
                                                   };
                    [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
                        NSLog(@"取消订单成功:%@",dic);

                    } elseAction:^(NSDictionary *dic) {
                
                    } failure:^(NSError *error) {
                
                    }];
            }
        }
        [self yuyueSpace];

    } elseAction:^(NSDictionary *dic) {
        NSLog(@"数据有问题：%@",dic);
    } failure:^(NSError *error) {
        
    }];
    
    return nil;
}
#pragma mark 查询订单是否失效
-(void)checkOrderEffectiveness
{
//    [self showPayAlertWithPrice:@"0.01" and:_checkOrderId];

    NSString *getUrl = BaseURL@"getStatus/appoint";
    NSDictionary *parameterDic;
    if (_checkOrderId) {
        parameterDic = @{@"id":_checkOrderId};

    }
//    NSLog(@"%@%@",getUrl,parametersDic);
//    [MBProgressHUD showHUDAddedTo:Window animated:YES];
    [MBProgressHUD showAnimateHUDAddedTo:Window text:@"正在分配车位"];
    [[AFHTTPRequestOperationManager manager] GET:getUrl parameters:parameterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        NSDictionary *dic = responseObject;
        //        NSLog(@"getDic:%@%@",dic,dic[@"msg"]);
        if ([dic[@"status"] isEqual:@(200)]) {
            [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏

            NSLog(@"订单有效：%@",dic);
            //        YuYueOrderViewController *vc = [[YuYueOrderViewController alloc] init];
            //        vc.orderID = orderID;
            //        [self.navigationController pushViewController:vc animated:YES];
            NSDictionary *dataDic = dic[@"data"];
            if(![dataDic isEqual:[NSNull null]])
            {
                [MBProgressHUD hideAllHUDsForView:Window animated:YES];

                [MBProgressHUD showSuccess:@"车位分配成功" toView:Window];
                
                [self showPayAlertWithPrice:@"0.01" and:dataDic[@"orderid"]];
            }else
            {
                [MBProgressHUD hideAllHUDsForView:Window animated:YES];

                [MBProgressHUD showSuccess:@"服务器订单数据为空" toView:Window];
                
            }
            
        }
        else
        {
            //            [MBProgressHUD showError:dic[@"msg"] toView:Window];
            NSLog(@"订单无效：%@",dic);
            if (checkNum < 3) {
                [self performSelector:@selector(checkOrderEffectiveness) withObject:nil afterDelay:++checkNum];
                
            }else if (checkNum == 3)
            {
                [MBProgressHUD hideAllHUDsForView:Window animated:YES];
                [MBProgressHUD showError:dic[@"msg"] toView:Window];

            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"%@",operation);
        
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        NSLog(@"报错：%@", [error localizedDescription]);
        [MBProgressHUD showError:@"网络加载出错" toView:Window];
    }];

}
/**
 *  功能型警告视图(临时版)
 */
- (void)showFunctionAlertWithTitle:(NSString *)title message:(NSString *)str Handler:(void (^)())handler Handler:(void (^)())handler1
{
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:title message:str preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *handleAction = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:handler];
    UIAlertAction *handleAction1 = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:handler1];
    UIAlertAction *handleAction2 = [UIAlertAction actionWithTitle:@"优惠劵" style:UIAlertActionStyleDefault handler:handler1];
    
    [alertCtl addAction:cancelAction];
    [alertCtl addAction:handleAction];
    [alertCtl addAction:handleAction1];
    [alertCtl addAction:handleAction2];
    [self presentViewController:alertCtl animated:YES completion:nil];
}


#pragma mark 选车辆后接收通知
- (void)chooseCarNote:(NSNotification *)note
{
    _car = note.object;
    self.chooseCarLabel.text = _car.carPlate;
    _chooseCarLabel.textColor = [UIColor blackColor];
}
#pragma mark 选优惠券后接收通知
- (void)chooseCouponNote:(NSNotification *)note
{
    _coupon = note.userInfo[@"coupon"];
    _chooseCouponLB.textColor = [UIColor blackColor];
    self.chooseCouponLB.text = [NSString stringWithFormat:@"优惠券金额：%.1f元",_coupon.amount];
    
    CGFloat totalPrice = _park.appointFee - _coupon.amount >= 0 ? _park.appointFee - _coupon.amount : 0;
    
//    _totalPrice.text = totalPrice > 0 ? [NSString stringWithFormat:@"使用优惠券后还需支付%.1f元",totalPrice] : @"使用优惠券后可免费预约";
    _totalPrice.hidden = NO;
    

        // 没有传入nil订单号则在此生成  作废
        //        order.orderNum = [AlipayToolKit genTradeNoWithTime];
        // 调用支付宝
        NSLog(@"%@",otherOrder.productDescription);
        NSLog(@"%@注册了支付通知\n将使用订单号：%@", self, otherOrder.orderNum);
        
        NSString *postURL = PayURL@"coupon";
        NSDictionary *parameterDic = @{@"orderId":otherOrder.orderID,
                                       @"orderType":otherOrder.payType,
                                       @"couponId":_coupon.ID,
                                       };
        [self postRequestURL:postURL parameters:parameterDic success:^(NSDictionary *dic) {
            NSLog(@"%@",dic[@"msg"]);
            NSLog(@"支付订单信息：%@",dic);
            if (![dic[@"data"] isEqual:[NSNull null]]) {
                NSLog(@"%@",dic[@"data"]);
                //                [self alipayWithServerStr:dic[@"data"]];
            }
            
            
        } elseAction:^(NSDictionary *dic) {
            NSLog(@"%@",dic[@"msg"]);
            NSLog(@"支付订单信息请求异常：%@",dic);
            
        } failure:^(NSError *error) {
            
        }];
}


#pragma mark 初始化时间选择器
- (void)initDatePicker
{
    _dateViewBg = [[UIView alloc] initWithFrame:self.view.bounds];
    _dateViewBg.backgroundColor = [UIColor blackColor];
    _dateViewBg.hidden = YES;
    _dateViewBg.alpha = .5;
    [self.view addSubview:_dateViewBg];
    _dateView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 265)];
    _dateView.layer.borderColor = [RGBA(244, 244, 244, 1) CGColor];
    _dateView.layer.borderWidth = 0.5;
    _dateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_dateView];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 215)];
    _datePicker.backgroundColor = [UIColor clearColor];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    _datePicker.locale = locale;
    _datePicker.tag = 2002;
    //datePicker.minimumDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [_dateView addSubview:_datePicker];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 215, UI_SCREEN_WIDTH, .5)];
    line.backgroundColor = RGBA(220, 220, 220, 1);
    [_dateView addSubview:line];
    
    UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelBtn.frame = CGRectMake(0, line.bottom, (UI_SCREEN_WIDTH-0.5)/2, 49.5);
    [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelBtn setTitleColor:RGBA(50, 129, 255, 1) forState:(UIControlStateNormal)];
    [cancelBtn addTarget:self action:@selector(dismissPicker) forControlEvents:(UIControlEventTouchUpInside)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_dateView addSubview:cancelBtn];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(cancelBtn.right, line.bottom, .5, 49.5)];
    line2.backgroundColor = RGBA(220, 220, 220, 1);
    [_dateView addSubview:line2];
    
    UIButton *confirmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    confirmBtn.frame = CGRectMake(line2.right, line.bottom, (UI_SCREEN_WIDTH-0.5)/2, 49.5);
    [confirmBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [confirmBtn setTitleColor:RGBA(50, 129, 255, 1) forState:(UIControlStateNormal)];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirmBtn addTarget:self action:@selector(confirmTime) forControlEvents:(UIControlEventTouchUpInside)];
    [_dateView addSubview:confirmBtn];
}

- (void)chooseTime
{
    _dateViewBg.hidden = NO;
    _dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 265);
    [UIView animateWithDuration:0.5 animations:^{
        _dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-265, UI_SCREEN_WIDTH, 265);
    } completion:^(BOOL finished) {
        ;
    }];
}

-(void)dismissPicker
{
    _dateViewBg.hidden = YES;
    _dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-265, _dateView.frame.size.width, _dateView.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        _dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, _dateView.frame.size.width, _dateView.frame.size.height);
    } completion:^(BOOL finished) {
        ;
    }];
}


#pragma mark 选择时间
- (void)confirmTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:_datePicker.date];
    _timeStr = time;
    _dateViewBg.hidden = YES;
    _dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-265, _dateView.frame.size.width, _dateView.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        _dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, _dateView.frame.size.width, _dateView.frame.size.height);
    } completion:^(BOOL finished) {
        ;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 收到支付结果(仅限支付宝微信。余额支付有单独方法)
- (void)payResultHandle:(NSNotification *)notification
{
    [super payResultHandle:notification];
    if ([notification.object isEqual: @1]) {
        
        _payType = notification.userInfo[@"payType"];
        NSLog(@"VC：支付成功");
//        [self requestAppointPark:nil];
        [self performSelector:@selector(afterPaySucess) withObject:nil afterDelay:1];

    }
    else
    {
        NSLog(@"VC：支付失败");
    }
    
}
#pragma mark 余额支付
- (void)gotoBalancePay:(Order *)order
{
    NSString *postURL = PayURL@"balance";
    NSDictionary *parameters = @{
                                 @"orderId":order.orderID,
                                 @"orderType":@1
                                 };
    
    [self postRequestURL:postURL parameters:parameters success:^(NSDictionary *dic) {
        [self performSelector:@selector(afterPaySucess) withObject:nil afterDelay:1];

        
    } elseAction:^(NSDictionary *dic) {
        
    } failure:^(NSError *error) {
        
    }];
}
//点击车场名查看详情
- (IBAction)parkNameClick:(id)sender {
    ParkDetailViewController *vc = [[ParkDetailViewController alloc] init];
    vc.park = _park;
    vc.hiddenBottomBar = YES;
    [self.navigationController pushViewController:vc animated:YES];



}
-(void)left
{
    [super left];
    checkNum = 3;
    if (_checkOrderId) {
        [self cancelHandler];
    }
}

@end

