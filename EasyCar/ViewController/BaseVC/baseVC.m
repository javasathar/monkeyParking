//
//  baseVC.m
//  tl_Good
//
//  Created by 田隆真 on 15/7/21.
//  Copyright (c) 2015年 田隆真. All rights reserved.
//

#import "baseVC.h"
// 设备
#import "sys/sysctl.h"
#import "AppDelegate.h"

#import "LoginVC.h"




@interface baseVC ()<UIAlertViewDelegate,UITextFieldDelegate>
{
    UIView * alertView_;
    BOOL isAlertView;
}
@end

@implementation baseVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.user = [UserManager manager];
    
}



#pragma mark 提示box
-(void)showMessageBox:(NSString *)mess andDuration:(float)time
{
    if (time <= 0)
    {
        return;
    }
    
    if (alertView_ != nil && isAlertView)
    {
        [alertView_ removeFromSuperview];
        alertView_ = nil;
        isAlertView = NO;
    }
    alertView_ = [[UIView alloc]initWithFrame:CGRectMake((UI_SCREEN_WIDTH - (mess.length * 14 + 40))/2, UI_SCREEN_HEIGHT-150, mess.length * 14 + 40 , 40)];
    alertView_.layer.masksToBounds=YES;
    alertView_.layer.cornerRadius=8;
    [alertView_ setBackgroundColor:[UIColor blackColor]];
    alertView_.alpha = 0.75;
    
    UILabel *messL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (mess.length * 14 + 40), 40)];
    [messL setText:mess];
    messL.textColor = [UIColor whiteColor];
    [messL setFont:[UIFont boldSystemFontOfSize:14]];
    [messL setLineBreakMode:NSLineBreakByCharWrapping];
    [messL setNumberOfLines:0];
    [messL setTextAlignment:NSTextAlignmentCenter];
    [alertView_ addSubview:messL];
    [self.view addSubview:alertView_];
    isAlertView = YES;
    
    [NSThread detachNewThreadSelector:@selector(alertHide:) toTarget:self withObject:[NSString stringWithFormat:@"%f",time]];
}


-(void)alertHide:(NSString *)time
{
    
    float ftime =[time floatValue];
    [NSThread sleepForTimeInterval:ftime/2];
    
    if (alertView_  != nil && isAlertView)
    {
        [UIView animateWithDuration:ftime/2.0 animations:^
         {
             if (alertView_ != nil  && isAlertView)
             {
                 [alertView_ removeFromSuperview];
                 alertView_ = nil;
                 isAlertView = NO;
             }
             
         }];
    }
    
}

#pragma mark 网络状态监测
-(void)checkNetworkStatus
{
    //创建一个用于测试的url
    NSURL *url=[NSURL URLWithString:@"http://www.baidu.com"];
    AFHTTPRequestOperationManager *operationManager=[[AFHTTPRequestOperationManager alloc]initWithBaseURL:url];
    //根据不同的网络状态改变去做相应处理
    [operationManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         switch (status) {
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 [self showMessageBox:@"当前网络状态:2G/3G/4G" andDuration:2];
                 [AppDelegate shareInstance].netState = 1;
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 [self showMessageBox:@"当前网络状态:WiFi" andDuration:2 ];
                 [AppDelegate shareInstance].netState = 2;
                 break;
             case AFNetworkReachabilityStatusNotReachable:
                 [self showMessageBox:@"当前没有网络!" andDuration:2 ];
                 [AppDelegate shareInstance].netState = 0;
                 break;
             default:
                 [self showMessageBox:@"Unknown." andDuration:2];
                 [AppDelegate shareInstance].netState = 3;
                 break;
         }
     }];
    
    //开始监控
    [operationManager.reachabilityManager startMonitoring];
}

//- (void)tabbarshow:(BOOL)show
//{
//    MY_tabbarViewController * tabbar = (MY_tabbarViewController *)self.tabBarController;
//    [tabbar tabbarshow:show];
//}



#pragma mark -- 设备型号判断

- (int) doDevicePlatform
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    int device = 0;
    
    /*
     *  iphone4s一下 标示为1
     *  iphone5 标示为5
     *  ipod touch 标示为2
     *  ipad 标示为3
     *  ipad mini 标示为4
     */
    
    if ([platform isEqualToString:@"iPhone1,1"]) {
        
        platform = @"iPhone";
        device = 1;
        
    } else if ([platform isEqualToString:@"iPhone1,2"]) {
        
        platform = @"iPhone 3G";
        device = 1;
        
    } else if ([platform isEqualToString:@"iPhone2,1"]) {
        
        platform = @"iPhone 3GS";
        device = 1;
        
    } else if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"]) {
        
        platform = @"iPhone 4";
        device = 1;
        
    } else if ([platform isEqualToString:@"iPhone4,1"]) {
        
        platform = @"iPhone 4S";
        device = 1;
        
    } else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]) {
        
        platform = @"iPhone 5";
        device = 5;
        
    }else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]) {
        
        platform = @"iPhone 5C";
        device = 5;
        
    }else if ([platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone6,1"]) {
        
        platform = @"iPhone 5S";
        device = 5;
        
    }else if ([platform isEqualToString:@"iPod4,1"]) {
        
        platform = @"iPod touch 4";
        device = 2;
        
    }else if ([platform isEqualToString:@"iPod5,1"]) {
        
        platform = @"iPod touch 5";
        device = 2;
        
        
    }else if ([platform isEqualToString:@"iPod3,1"]) {
        
        platform = @"iPod touch 3";
        device = 2;
        
        
    }else if ([platform isEqualToString:@"iPod2,1"]) {
        
        platform = @"iPod touch 2";
        device = 2;
        
    }else if ([platform isEqualToString:@"iPod1,1"]) {
        
        platform = @"iPod touch";
        device = 2;
        
    } else if ([platform isEqualToString:@"iPad3,2"]||[platform isEqualToString:@"iPad3,1"]) {
        
        platform = @"iPad 3";
        device = 3;
        
    } else if ([platform isEqualToString:@"iPad2,2"]||[platform isEqualToString:@"iPad2,1"]||[platform isEqualToString:@"iPad2,3"]||[platform isEqualToString:@"iPad2,4"]) {
        
        platform = @"iPad 2";
        device = 3;
        
    }else if ([platform isEqualToString:@"iPad1,1"]) {
        
        platform = @"iPad 1";
        device = 3;
        
    }else if ([platform isEqualToString:@"iPad2,5"]||[platform isEqualToString:@"iPad2,6"]||[platform isEqualToString:@"iPad2,7"]) {
        
        platform = @"ipad mini";
        device = 4;
        
    } else if ([platform isEqualToString:@"iPad3,3"]||[platform isEqualToString:@"iPad3,4"]||[platform isEqualToString:@"iPad3,5"]||[platform isEqualToString:@"iPad3,6"]) {
        
        platform = @"ipad 3";
        device = 3;
        
    }
    
    return device;
}
- (void)showMessageAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"您还没有登陆"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"登陆", nil];
    alert.tag = LoginTag;
    [alert show];
}


/**
 *  通知型警告视图
 */
- (void)showNormalAlertWithTitle:(NSString *)title message:(NSString *)str
{
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:title message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertCtl addAction:cancelAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
}


/**
 *  功能型警告视图
 */
- (void)showFunctionAlertWithTitle:(NSString *)title message:(NSString *)str functionName:(NSString *)functionName Handler:(void (^)())handler
{
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:title message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self cancel];
    }];
    UIAlertAction *handleAction = [UIAlertAction actionWithTitle:functionName style:UIAlertActionStyleDefault handler:handler];
    [alertCtl addAction:cancelAction];
    [alertCtl addAction:handleAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
    
}
-(void)clickMonkey
{
    [AppDelegate shareInstance].tab.selectedIndex = 1;
}
-(void)cancel
{
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == LoginTag)
    {
        if (buttonIndex == 1)
        {
            [self gotoLoginVC];
        }
    }
}

#pragma mark 登录后发跳转通知
- (void)loginBeforePushVC:(NSString *)pushVCName
{
    
    LoginVC * login = [LoginVC new];
    login.pushVCName = pushVCName;
    
    UINavigationController * nav_login = [[UINavigationController alloc]initWithRootViewController:login];
    
    [self presentViewController:nav_login animated:YES completion:^{
        
    }];
}

#pragma mark 登陆事件
- (void)gotoLoginVC
{
    
    LoginVC * login = [LoginVC new];
    
    UINavigationController * nav_login = [[UINavigationController alloc]initWithRootViewController:login];
    
    [self presentViewController:nav_login animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}


//- (void)closeSlide:(UIViewController *)vc
//{
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//
//    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
//
//    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
//
//    [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
//}

//客户端提示信息
- (void)alert_Msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"恭喜" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
    
}

- (void)showCoverViewOn:(UIView *)view title:(NSString *)title image:(UIImage *)image handle:(OneMoreThing)block
{
    if (!_coverView) {
        
        _coverView = [[NSBundle mainBundle] loadNibNamed:@"CoverView" owner:nil options:nil][0];
        _coverView.frame = CGRectMake(0, 0, Width, Heigth-64);
        
        
    }
    [_coverView setTitle:title image:image handle:block];
    [view addSubview:_coverView];
    [view bringSubviewToFront:_coverView];
}



- (void)removeCoverView
{
    [self.coverView removeFromSuperview];
}

//#pragma mark CoverView Getter
//- (CoverView *)coverView
//{
//    if (!_coverView) {
//        _coverView = [[NSBundle mainBundle] loadNibNamed:@"CoverView" owner:nil options:nil][0];
//        _coverView.frame = CGRectMake(0, 0, Width, Heigth-64);
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCoverView)];
//        [_coverView addGestureRecognizer:tap];
//    }
//    return _coverView;
//}

- (MY_nav *)nav
{
    if (!_nav) {
        _nav = [[MY_nav alloc]initWithFrame:CGRectMake(0, 0, Width, 64) leftImage:nil title:nil rigthTitle:nil];
        _nav.backgroundColor = RGBA(50, 129, 255, 1);
        
        UIImageView *navImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top"]];
        navImage.frame = CGRectMake(0, 0, Width, 64);
        [_nav addSubview:navImage];
        _nav.delegate = self;
        [self.view addSubview:_nav];
    }
    return _nav;
}

// 如需自定义，重写覆盖即可
- (void)left
{
    // 默认返回
    [self.navigationController popViewControllerAnimated:YES];
    //    [[[AFHTTPRequestOperationManager manager] operationQueue] cancelAllOperations];
    
}

- (void)right
{
    
}

#pragma mark 复用请求
/** 带动画 无成功提示 */
- (void)getRequestURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure
{
    
    [MBProgressHUD showHUDAddedTo:Window animated:YES]; // 动画开始
    [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        NSDictionary *dic = responseObject;
//        NSLog(@"getDic:%@",dic);
        if ([dic[@"status"] isEqual:@(200)]) {
            
            success(dic);
        }
        else
        {
            [MBProgressHUD showError:dic[@"msg"] toView:Window];
            elseAction(dic);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"%@",operation);
        
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        NSLog(@"报错：%@", [error localizedDescription]);
        [MBProgressHUD showError:@"网络加载出错" toView:Window];
        failure(error);
    }];
}
//复用post请求
- (void)postRequestURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure
{
    [MBProgressHUD showHUDAddedTo:Window animated:YES]; // 动画开始
    AFHTTPRequestOperationManager *mangager = [AFHTTPRequestOperationManager manager];
//    mangager.responseSerializer = [AFJSONResponseSerializer serializer];
    [mangager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"%@",operation);
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        NSDictionary *dic = responseObject;
        NSLog(@"postDic:%@   msg:%@",dic,dic[@"msg"]);
        
        if ([dic[@"resultCode"] isEqual:@(0)]) {
            
            success(dic);
        }
        else
        {
            [MBProgressHUD showError:dic[@"msg"] toView:Window];
            elseAction(dic);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"%@",operation);
        
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        NSLog(@"报错：%@", [error localizedDescription]);
        [MBProgressHUD showError:@"网络加载出错" toView:Window];
        failure(error);
    }];
    
}
//
//#pragma mark 调支付通知（返回支付类型）
//
//- (NSString *)showPayAlertWithOrder:(Order *)order
//{
//    __block NSString *payType;
//
//    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"支付" message:@"选择支付方式" preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//
//    UIAlertAction *aliPayAction = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        payType = @"0";// 支付宝
//        [self gotoAliPay:order orderID:nil];
//
//    }];
//
//
//    UIAlertAction *wxPayAction = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        payType = @"1";// 微信
//        [self gotoWXPay:order orderID:nil];
//
//    }];
//
//
//    [alertCtl addAction:cancelAction];
//    [alertCtl addAction:aliPayAction];
//    [alertCtl addAction:wxPayAction];
//    [self presentViewController:alertCtl animated:YES completion:nil];
//
//    return payType;
//}


#pragma mark 调支付通知（订单号由服务器生成）

- (NSString *)showPayAlertWithOrder:(Order *)order
{
    
    
    __block Order *blockOrder = order;
    
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"支付" message:@"选择支付方式" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertCtl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self cancelHandler];
    }]];
    
    [alertCtl addAction:[UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        order.orderNum = [self gotoAliPay:blockOrder];// 支付宝
    }]];
    
    [alertCtl addAction:[UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        order.orderNum = [self gotoWXPay:blockOrder];// 微信
    }]];
    
    [alertCtl addAction:[UIAlertAction actionWithTitle:@"余额支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self gotoBalancePay:blockOrder];
    }]];
    
    [alertCtl addAction:[UIAlertAction actionWithTitle:@"优惠劵支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self gotoPreferential:blockOrder];
    }]];
    
    [self presentViewController:alertCtl animated:YES completion:nil];
    
    NSLog(@"查询用订单号：%@", order.orderID);
    return order.orderNum;
}

#pragma mark 取消弹框后（子类重写）
-(void)cancelHandler
{
    NSLog(@"取消支付");
}

#pragma mark 调优惠劵支付（子类重写）
-(void)gotoPreferential:(Order *)order
{
    
        // 没有传入nil订单号则在此生成  作废
        //        order.orderNum = [AlipayToolKit genTradeNoWithTime];
        // 调用支付宝
        NSLog(@"%@",order.productDescription);
        NSLog(@"%@注册了支付通知\n将使用订单号：%@", self, order.orderNum);
        
        NSString *postURL = PayURL@"coupon";
        NSDictionary *parameterDic = @{@"orderId":order.orderID,
                                       @"orderType":order.payType,
                                       @"couponId":@"",
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

#pragma mark 调支付宝
- (NSString *)gotoAliPay:(Order *)order
{
    // 先注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResultHandle:) name:PayResult object:nil];
    
        // 没有传入nil订单号则在此生成  作废
        //        order.orderNum = [AlipayToolKit genTradeNoWithTime];
        // 调用支付宝
        NSLog(@"%@",order.productDescription);
        NSLog(@"%@注册了支付通知\n", self);
        
        NSString *postURL = PayURL@"alipay";
        NSDictionary *parameterDic = @{@"orderId":order.orderID,
                                       @"orderType":order.payType
                                       };
        [self postRequestURL:postURL parameters:parameterDic success:^(NSDictionary *dic) {
            
            NSLog(@"msg:%@  支付订单信息：%@",dic[@"msg"],dic[@"data"]);
            if (![dic[@"data"] isEqual:[NSNull null]]) {
//                NSLog(@"data:%@",dict2[@"body"]);
//                [self alipayWithServerDic:dict2];
                NSString *dicStr = dic[@"data"];
//                dicStr = [dicStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[dicStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
                if (!err) {
                    [self alipayWithServerDic:dict];
                }
            }
            
            
        } elseAction:^(NSDictionary *dic) {
            NSLog(@"%@",dic[@"msg"]);
            NSLog(@"支付订单信息请求异常：%@",dic);
            
        } failure:^(NSError *error) {
            
        }];
        
    
    
    return order.orderNum;
}
//从服务器获取签名数据并解析
-(void)alipayWithServerDic:(NSDictionary *)dict2
{
    if (dict2) {
        [AlipayRequestConfig alipayWithPartner:dict2[@"partner"] seller:dict2[@"seller_id"] tradeNO:dict2[@"out_trade_no"] productName:dict2[@"subject"] productDescription:dict2[@"body"] amount:dict2[@"total_fee"] notifyURL:dict2[@"notify_url"] itBPay:@"30m" service:dict2[@"service"] payment_type:dict2[@"payment_type"]];
    }
    
}
#pragma mark 调微信支付
- (NSString *)gotoWXPay:(Order *)order
{
    // 先注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResultHandle:) name:PayResult object:nil];

        // 没有传入nil订单号则在此生成 作废
        //        order.orderNum = [AlipayToolKit genTradeNoWithTime];
        NSLog(@"%@注册了支付通知", self);
        
        NSString *postURL = PayURL@"weixin";
        NSDictionary *parameterDic = @{@"orderId":order.orderID,
                                       @"orderType":order.payType
                                       };
        [self postRequestURL:postURL parameters:parameterDic success:^(NSDictionary *dic) {
            

            NSLog(@"msg:%@  支付订单信息：%@",dic[@"msg"],dic[@"data"]);
            if (![dic[@"data"] isEqual:[NSNull null]]) {
                NSString *dicStr = dic[@"data"];
                NSLog(@"dicStr:%@",dicStr);
                //                dicStr = [dicStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[dicStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                [self WXPayWithServerDic:dict];
            }
            
            
        } elseAction:^(NSDictionary *dic) {
            NSLog(@"%@",dic[@"msg"]);
            NSLog(@"支付订单信息请求异常：%@",dic);
            
        } failure:^(NSError *error) {
            
        }];
        
//        // 以下是发起支付，但是新增加了提示语
//        if ([UserDefaultsFiles shouldShowWXPayNotice]) {
//            // 如果要提示
//            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"iOS9用户微信支付须知" message:@"在使用微信付款后请直接点击右上角绿色的“返回停车大圣”以确保完成订单支付，切勿点击左上角系统提供的返回功能或者其他无关操作" preferredStyle:UIAlertControllerStyleAlert];
//            
//            
//            
//            [ac addAction:[UIAlertAction actionWithTitle:@"不再提示" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                
//                [UserDefaultsFiles doNotShowWXPayNoticeAgain];
//                [GBWXPayManager wxpayWithOrderID:order.orderNum orderTitle:order.productName amount:order.amount];
//            }]];
//            
//            [ac addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//                [GBWXPayManager wxpayWithOrderID:order.orderNum orderTitle:order.productName amount:order.amount];
//            }]];
//            
//            [self presentViewController:ac animated:YES completion:nil];
//        }
//        else
//        {
//            // 如果无需提示，直接进支付
//            [GBWXPayManager wxpayWithOrderID:order.orderNum orderTitle:order.productName amount:order.amount];
//        }
 
    return order.orderNum;
}
-(void)WXPayWithServerDic:(NSDictionary *)dic
{
    [[[GBWXPayManager alloc] init]wxpayWithOrderID:nil orderTitle:nil amount:nil partnerID:dic[@"partnerid"] prepayID:dic[@"prepayid"] package:dic[@"package"] nonceStr:dic[@"noncestr"] timeStamp:dic[@"timestamp"] signKey:dic[@"signKey"]];

}

#pragma mark 支付结果处理（子类重写前需调用一遍父类方法）
- (void)payResultHandle:(NSNotification *)notification
{
    /*
     子类最好在重写前调用一遍父类方法
     支付时，点击支付宝或微信都会注册通知，等待支付结果。收到结果进入这个方法，此时有必要移除这个通知。
     点击取消不会注册通知
     
     不论哪种支付方式，notification.object 为@1表示成功 @0为失败，我们只需要在子类方法写出这两种状态的操作
     */
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PayResult object:nil];
    NSLog(@"%@的通知删除了", self);
}

#pragma mark 调易停车余额支付 (仅用于子类重写)
- (void)gotoBalancePay:(Order *)order
{
    
}

- (void)dealloc
{
    NSLog(@"控制器释放了");
}
#pragma mark 自定义字符串截取
-(NSString *)subString:(NSString *)str fromStr:(NSString *)fromStr ToStr:(NSString *)toStr
{
    NSRange range1 = [str rangeOfString:fromStr];
    NSRange range2 = [str rangeOfString:toStr];
    
    return [str substringWithRange:NSMakeRange(range1.location+range1.length, range2.location)];
}
@end
