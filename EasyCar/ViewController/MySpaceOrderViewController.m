//
//  MySpaceOrderViewController.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/12.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "MySpaceOrderViewController.h"
#import "MyCarViewController.h"
#import "MyTicketViewController.h"
#import "WoDeDingDanVC.h"
@interface MySpaceOrderViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic ,strong)UIPickerView *pickerView;
@property (nonatomic ,strong)NSArray *monthArr;
@end

@implementation MySpaceOrderViewController
{
    UIButton *_pickerBtn;
    NSInteger _rusult;
    NSString *_checkOrderId;
    NSInteger checkNum;
    
    Coupon *_coupon;
    Order *otherOrder;
}
-(UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, Heigth - 180, Width,  132)];
        _pickerView.backgroundColor = RGBA(220, 220, 220, 1);
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [self.view addSubview:_pickerView];
        _pickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pickerBtn setFrame:CGRectMake(Width - 50 , _pickerView.top - 30, 50, 30)];
        [_pickerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_pickerBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_pickerBtn addTarget:self action:@selector(chosseTimeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_pickerBtn];
    }
    return _pickerView;
}
- (void)chosseTimeAction:(id)sender {
    _rusult = [self.pickerView selectedRowInComponent:0];
    //    NSLog(@"%ld",result);
    if (self.monthArr[_rusult]) {
        _timeLong.text = self.monthArr[_rusult];
        
    }
    //    NSLog(@"选中%@",self.monthArr[result]);
    _totalPrice.text = [NSString stringWithFormat:@"%ld",(long)(800 * (++_rusult))];
    
    [_pickerView removeFromSuperview];
    [_pickerBtn removeFromSuperview];
    _pickerView = nil;
    _pickerBtn = nil;
}
-(NSArray *)monthArr
{
    if (!_monthArr) {
        _monthArr = @[@"一个月",
                      @"两个月",
                      @"三个月",
                      @"四个月",
                      @"五个月",
                      @"六个月",
                      @"七个月",
                      @"八个月",
                      @"九个月",
                      @"十个月",
                      @"十一个月",
                      @"十二个月"
                      ];
    }
    return _monthArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.nav setTitle:@"订单支付" leftText:nil rightTitle:nil showBackImg:YES];
    [self viewInitinal];
}
-(void)viewInitinal
{
    _rusult++;
    self.userPhone.text = [UserManager manager].phone;
    self.spaceNumber.text = [NSString stringWithFormat:@"%@库",_parkArea];
    [self getFirstCar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseCarNote:) name:ReturnCarInfo object:nil];
    
    [self getRentPrice];
    
}
#pragma mark 获取车库整租价格，失败则返回
-(void)getRentPrice
{
    NSString *getUrl = BaseURL@"getRentPrice";
    NSMutableDictionary *parameterDic = [NSMutableDictionary new];
    if (_park) {
        [parameterDic setObject:_park.ID forKey:@"parkId"];
    }else
    {
        [MBProgressHUD showError:@"数据出错，请联系管理员" toView:Window];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
//        NSLog(@"rentPrice:%@",dic);
        if ([dic[@"data"] isKindOfClass:[NSNumber class]]) {
            _totalPrice.text = [NSString stringWithFormat:@"%@",dic[@"data"]];
        }else
        {
            [MBProgressHUD showError:@"数据出错，请联系管理员" toView:Window];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } elseAction:^(NSDictionary *dic) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];

    }];
}
#pragma mark 选择车辆
- (IBAction)chosseCarAction:(id)sender {
    
    MyCarViewController *vc = [[MyCarViewController alloc] init];
    vc.selectType = selectForReturnValue;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark 选车辆后接收通知
- (void)chooseCarNote:(NSNotification *)note
{
    _car = note.object;
    _carID.text = _car.carPlate;
    _carID.textColor = [UIColor blackColor];
}
#pragma mark 选择时间
- (IBAction)chosseTimer:(id)sender {
    self.pickerView.showsSelectionIndicator = YES;
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
            _carID.text = car.carPlate;
            
            _carID.textColor = [UIColor blackColor];
        }
        else
        {
            [MBProgressHUD showError:@"未能获取默认车辆" toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"报错：%@", [error localizedDescription]);
    }];
}
#pragma mark pickerView代理
#pragma mark - 该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.monthArr.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.monthArr[row];
}
#pragma mark - 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //    self.timeLong = self.monthArr[row];
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

- (IBAction)payBtn:(id)sender {
    //    _checkOrderId = @"8aafdae854c6d4850154c6d5542d0000";
    //    checkNum = 1;
    //    [self checkOrderEffectiveness];
    
    NSString *getUrl = BaseURL@"rentOrder";
    NSDictionary *parameterDic = @{@"memberId":[UserManager manager].userID,
                                   //                                   @"parkId":@"402880f350ef8c640150efac6a560007",
                                   @"parkId":_park.ID,
                                   @"carPlate":_car.carPlate,
                                   @"rentTime":[NSString stringWithFormat:@"%ld",(long)_rusult],
                                   //                                   @"parkNo":_parkNO,
                                   @"parkArea":_parkArea.length > 1 ?_parkArea:[NSString stringWithFormat:@"%@0",_parkArea],
//                                   @"rentMoney":@"0.01",
                                   @"rentMoney":_totalPrice.text
                                   };
    NSLog(@"totalPrice:%@",_totalPrice.text);
    [[AFHTTPRequestOperationManager manager] GET:getUrl parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSLog(@"结果：%@  %@",dic,dic[@"msg"]);
        
        if ([dic[@"status"] isEqual:@200]) {
            //                [MBProgressHUD showSuccess:dic[@"msg"] toView:Window];
            if([dic[@"data"] isKindOfClass:[NSDictionary class]])
            {
                _checkOrderId = dic[@"data"][@"orderId"];
                if (!_checkOrderId) {
                    _checkOrderId = dic[@"data"][@"orderid"];
                }
                
                if (_checkOrderId) {
                    checkNum = 1;
                    [self performSelector:@selector(checkOrderEffectiveness) withObject:nil afterDelay:1.0f];
                    //                [self showPayAlertWithPrice:_totalPrice.text and:_checkOrderId];
                }else
                {
                    [MBProgressHUD showError:@"数据出错，订单号为空" toView:Window];
                }
                
            }
            
        }else if([dic[@"status"] isEqual:@500]){
            //            NSLog(@"已预约：%@",dic);
            
//            [MBProgressHUD showError:dic[@"msg"] toView:Window];
#warning 需要改成取消整租订单或者不要这段
            [self showFunctionAlertWithTitle:@"是否重新申请" message:dic[@"msg"] functionName:@"重新申请" Handler:^{
                NSString *getUrl = BaseURL@"appointCancel";
                if ([dic[@"data"] isKindOfClass:[NSDictionary class]]) {
                    if (dic[@"data"][@"orderId"]) {
                        _checkOrderId = dic[@"data"][@"orderId"];
                    }else if (dic[@"data"][@"orderid"])
                    {
                        _checkOrderId = dic[@"data"][@"orderid"];
                    }else
                    {
                        [MBProgressHUD showError:@"没有订单号" toView:Window];
                    }
                    
                    NSDictionary *parameterDic = @{@"memberId":self.user.userID,
                                                   @"orderId":_checkOrderId,
                                                   };
                    [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
                        [MBProgressHUD showSuccess:@"取消订单成功" toView:Window];
                        [self payBtn:nil];
                    } elseAction:^(NSDictionary *dic) {
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }
            }];
        }else
        {
            [MBProgressHUD showError:dic[@"msg"] toView:Window];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"预约失败" toView:Window];
    }];
    
}
-(void)checkOrderEffectiveness
{
    
    //    [self showPayAlertWithPrice:@"0.01" and:_checkOrderId];
    
    NSString *getUrl = BaseURL@"getStatus/rentOrder";
    NSDictionary *parametersDic = @{@"id":_checkOrderId};
        NSLog(@"%@%@",getUrl,parametersDic);
    [MBProgressHUD showAnimateHUDAddedTo:Window text:@"正在分配车位"];
    [[AFHTTPRequestOperationManager manager] GET:getUrl parameters:parametersDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        NSDictionary *dic = responseObject;
        //        NSLog(@"getDic:%@%@",dic,dic[@"msg"]);
        if ([dic[@"status"] isEqual:@(200)]) {
            
            NSLog(@"订单有效：%@",dic);
            //        YuYueOrderViewController *vc = [[YuYueOrderViewController alloc] init];
            //        vc.orderID = orderID;
            //        [self.navigationController pushViewController:vc animated:YES];
            NSDictionary *dataDic = dic[@"data"];
            if(![dataDic isEqual:[NSNull null]])
            {
                if ([dataDic[@"status"] isEqual:@1]) {
                    [MBProgressHUD hideAllHUDsForView:Window animated:YES];
                    
                    [MBProgressHUD showSuccess:@"下单成功" toView:Window];
                    
                    if (dataDic[@"orderid"]) {
                        [self showPayAlertWithPrice:[NSString stringWithFormat:@"%@",_totalPrice.text] and:dataDic[@"orderid"]];
                    }else if(dataDic[@"orderId"])
                    {
                    [self showPayAlertWithPrice:[NSString stringWithFormat:@"%@",_totalPrice.text] and:dataDic[@"orderId"]];
                    }else
                    {
                        [MBProgressHUD showError:@"数据出错，订单号为空" toView:Window];
                    }
                }else
                {
                    if (checkNum < 3) {
                        [self performSelector:@selector(checkOrderEffectiveness) withObject:nil afterDelay:++checkNum];
                    }else if(checkNum == 3){
                        //                [MBProgressHUD showSuccess:@"服务器订单数据为空" toView:Window];
                        [MBProgressHUD hideAllHUDsForView:Window animated:YES];
                        [MBProgressHUD showMessag:@"车位分配失败，请稍后再试" toView:Window];
                    }
                }
                
            }else
            {
                if (checkNum < 3) {
                    [self performSelector:@selector(checkOrderEffectiveness) withObject:nil afterDelay:++checkNum];
                }else if(checkNum == 3){
                    [MBProgressHUD hideAllHUDsForView:Window animated:YES];
                    
                    [MBProgressHUD showMessag:@"车位分配失败，请稍后再试" toView:Window];
                }
                
            }
            
        }
        else if([dic[@"status"] isEqual:@(500)])
        {
            //            [MBProgressHUD showError:dic[@"msg"] toView:Window];
//            if (checkNum < 3) {
//                [self performSelector:@selector(checkOrderEffectiveness) withObject:nil afterDelay:++checkNum];
//            }else if(checkNum == 3){
//                [MBProgressHUD hideAllHUDsForView:Window animated:YES];
//                
//                [MBProgressHUD showMessag:@"车位分配失败，请稍后再试" toView:Window];
//            }
            [MBProgressHUD showError:dic[@"msg"] toView:Window];
        }else
        {
            [MBProgressHUD showError:dic[@"msg"] toView:Window];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation);
        
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        NSLog(@"报错：%@", [error localizedDescription]);
        [MBProgressHUD showError:@"网络加载出错" toView:Window];
    }];
    
    
    
}
#pragma mark 弹出支付弹框
-(void)showPayAlertWithPrice:(NSString *)truePrice and:(NSString *)orderID
{
    Order *order = [Order new];
    order.productName = [NSString stringWithFormat:@"%@专用车位",_car.carPlate];
    order.productDescription = @"专用车位";
#warning 注意啦：测试价格0.01
    order.amount = truePrice;//[NSString stringWithFormat:@"%.1f",_appointPrice];
    // 调支付
    order.orderID = _checkOrderId;
    order.payType = @2;//专用订单
    [self showPayAlertWithOrder:order];
}
#pragma mark 余额支付
- (void)gotoBalancePay:(Order *)order
{
    NSString *postURL = PayURL@"balance";
    NSDictionary *parameters = @{
                                 @"orderId":order.orderID,
                                 @"orderType":@2
                                 };
    
    [self postRequestURL:postURL parameters:parameters success:^(NSDictionary *dic) {
        [self performSelector:@selector(afterPaySucess) withObject:nil afterDelay:1];
        
        
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
#pragma mark 选优惠券后接收通知
- (void)chooseCouponNote:(NSNotification *)note
{
    _coupon = note.userInfo[@"coupon"];
    
    CGFloat totalPrice = _park.appointFee - _coupon.amount >= 0 ? _park.appointFee - _coupon.amount : 0;
    
    //    _totalPrice.text = totalPrice > 0 ? [NSString stringWithFormat:@"使用优惠券后还需支付%.1f元",totalPrice] : @"使用优惠券后可免费预约";
    _totalPrice.hidden = NO;
    
    // 没有传入nil订单号则在此生成  作废
    //        order.orderNum = [AlipayToolKit genTradeNoWithTime];
    // 调用支付宝
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
#pragma mark 收到支付结果(仅限支付宝微信。余额支付有单独方法)
- (void)payResultHandle:(NSNotification *)notification
{
    [super payResultHandle:notification];
    if ([notification.object isEqual: @1]) {
        
        //        _payType = notification.userInfo[@"payType"];
        NSLog(@"VC：支付成功");
        //        [self requestAppointPark:nil];
        [self performSelector:@selector(afterPaySucess) withObject:nil afterDelay:1];
        
    }
    else
    {
        NSLog(@"VC：支付失败");
    }
    
}

-(void)left
{
    [super left];
    checkNum = 3;
}
@end
