//
//  AppDelegate.m
//  EasyCar
//
//  Created by zhangke on 15/5/14.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "HomeViewController.h"
#import "MLTransition.h"
#import "GBWXPayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <iflyMSC/iflyMSC.h>
#import "MobClick.h"
#import <SMS_SDK/SMSSDK.h>
// 分享相关
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

//2016
#import "ParkingViewController.h"
#import "MeViewController.h"
#import <Reachability.h>
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate




+(AppDelegate *)shareInstance
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    // 创建定时器和监听
    _timer = [NSTimer timerWithTimeInterval:60 target:self selector:@selector(requestUnReadCount) userInfo:nil repeats:YES];
    [[UserManager manager] addObserver:self forKeyPath:@"isLogin" options:NSKeyValueObservingOptionNew context:nil];


    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"%@", docPath);
    
    //=========== 第三方初始化 ===========
    // 高德导航
    [AMapNaviServices sharedServices].apiKey =  @"4cfaba5e955c7adc2a8801393a3b1271";
    [MAMapServices sharedServices].apiKey    =  @"4cfaba5e955c7adc2a8801393a3b1271";
    // 讯飞语音
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"56b068c5"];
    [IFlySpeechUtility createUtility:initString];
    // 执行右拉手势返回
    [MLTransition validatePanPackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypePan];


    // 向微信注册
    [WXApi registerApp:APP_ID withDescription:nil];
    // 友盟统计
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick startWithAppkey:UM_KEY reportPolicy:BATCH channelId:nil];
    // 友盟分享
    [UMSocialData setAppKey:UM_KEY];
    [UMSocialWechatHandler setWXAppId: UM_WX_ID appSecret:UM_WX_KEY url:@"http://www.umeng.com/social"];
    
    [UMSocialQQHandler setQQWithAppId:UM_QQ_ID appKey:UM_QQ_KEY url:@"http://www.umeng.com/social"];
    
    // 短信验证
    [SMSSDK registerApp:appKey_SMS withSecret:appSecret_SMS];
    
//    [MobClick setLogEnabled:YES];

    // 引导页 还是 首页
    if ([UserDefaultsFiles isSecondLaunch])
    {
        // 程序正式入口
        [self initHomeVC];
        // 有用户登录记录 ? 自动登录 : 无
        if ([[[UserDefaultsFiles alloc] init] getUserName]) {
            if([[CGTool shareInitial]isMonkeyWIFI])
            {
            }else
            {
                [self autoLogin];
            }
            
        }
    }
    else
    {
        //是第一次运行
        [UserDefaultsFiles didFirstLaunch];
        WelcomeViewController *welVC = [[WelcomeViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:welVC];
        
        self.window.rootViewController = nav;
    }

    //2016
    //监控网络状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    
    //plc test
    self.plcIPHead = @"192.168.0.";
    self.plcHost = @"1";
    self.plcPort = @"1024";
    self.plcTest = @"@00WD200000";
    self.isEnter = YES;
    return YES;
}
-(void)networkStateChange
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"become" object:nil];
}
#pragma mark 进入主页
- (void)initHomeVC
{
    _tab = [[UITabBarController alloc] init];
    UINavigationController *homeVC = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    UINavigationController *middleVC = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    UINavigationController *meVC = [[UINavigationController alloc] initWithRootViewController:[[MeViewController alloc] init]];
    NSArray *vcArr = @[homeVC,middleVC,meVC];
    _tab.viewControllers = vcArr;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
//    // 隐藏系统导航栏
    homeVC.navigationBarHidden = YES;
    middleVC.navigationBarHidden = YES;
    meVC.navigationBarHidden = YES;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    self.window.rootViewController = nav;
    _tab.tabBar.hidden = YES;
    self.window.rootViewController = _tab;
}

#pragma mark 自动登录
- (void)autoLogin
{
    NSString *url = BaseURL@"login";
    NSString *password = [[[UserDefaultsFiles alloc] init] getUserPassword];
    NSDictionary *parameters = @{
                                 @"phone":[[[UserDefaultsFiles alloc] init] getUserName],
                                 @"password":password
                                 };
    NSLog(@"正在自动登录...");
    [MBProgressHUD showAnimateHUDAddedTo:Window text:@"正在登陆"];
    [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];
        NSDictionary *dic = responseObject;
        NSLog(@"%@", dic[@"msg"]);
        
        if ([dic[@"status"] isEqual:@(200)]) {
            
            NSLog(@"自动登录成功");
            UserManager *user  = [UserManager manager];
            
            // 由于存在定时查询的kvo，务必先填好用户信息，再标注登录状态
            [user userManagerDic:dic[@"data"]];
            user.isLogin = YES; // 标记登录状态
            
            NSString *successMsg = [NSString stringWithFormat:@"欢迎回来  %@",user.nickname];
            [[MBProgressHUD showSuccess:successMsg toView:Window] setUserInteractionEnabled:NO];
            
        }
        else
        {
            [[MBProgressHUD showError:@"自动登录失败，您已下线" toView:Window] setUserInteractionEnabled:NO];

            NSLog(@"自动登录失败");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];

        NSLog(@"报错：%@", [error localizedDescription]);
        [[MBProgressHUD showError:@"服务器异常,自动登录失败" toView:Window] setUserInteractionEnabled:NO];;
    }];
}

#pragma mark - 微信支付回调
-(void) onResp:(BaseResp*)resp
{
    
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {}
    if([resp isKindOfClass:[PayResp class]]){
        
        //支付返回结果，实际支付结果需要去微信服务器端查询
        /*
         resp.errCode
         0	成功	展示成功页面
         -1	错误	可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等。
         -2	用户取消	无需处理。发生场景：用户不支付了，点击取消，返回APP。
         */
        
        // 仅自定义两种必要操作，支付成功一个通知或者失败一个通知。后面提供的更详细的回调类型有需要再说
        if (resp.errCode == WXSuccess) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PayResult object:@1 userInfo:@{@"payType":@"1"}];// 1表示微信 这是特殊需要];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:PayResult object:@0];
        }
        
        switch (resp.errCode) {
                
                // 成功
            case WXSuccess:

                [[NSNotificationCenter defaultCenter] postNotificationName:WXpayresult object:@"0"];
                NSLog(@"微信SDK:支付确实成功了");

                break;
                
                // 取消
            case WXErrCodeUserCancel:
            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:WXpayresult object:@"-2"];
                [MBProgressHUD showResult:NO text:@"您取消了支付" delay:2];
            }
                break;
                
                // 出错
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                
                [[NSNotificationCenter defaultCenter] postNotificationName:WXpayresult object:@"0"];
                break;
        }
    }
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{

    // 友盟先瞧瞧看
    [UMSocialSnsService handleOpenURL:url];

    // 如果是微信支付
    if ([url.host isEqualToString:@"pay"])
    {
        [WXApi handleOpenURL:url delegate:self];
    }
    
    #pragma mark - 支付宝回调 (AlipayRequestConfig.m)
     // 如果是支付宝客户端
     if ([url.host isEqualToString:@"safepay"])
     {
     [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic){
     
     }];
     }
     
     // 如果是支付宝极简SDK
     if ([url.host isEqualToString:@"platformapi"])
     {
     [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic){

     }];
     }


    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"background");
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"enter");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"become");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"become" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"terminate");

}

#pragma mark - KVC回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    // 登录状态变化
    if([keyPath isEqualToString:@"isLogin"]){
        if ([change[@"new"] boolValue] == YES)
        {
            NSLog(@"开起定时查询消息");
            
            [self requestUnReadCount];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
        else
        {
            NSLog(@"关闭定时查询消息");
            [_timer setFireDate:[NSDate distantFuture]];
        }
    }
}

// 获取未读消息
- (void)requestUnReadCount
{
    NSString *url = BaseURL@"pushCheck";
    NSDictionary *parameters = @{
                                 @"memberId":[UserManager manager].userID
                                 };
    [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        
        if ([dic[@"status"] isEqual:@(200)]) {
            
            self.unReadCount = [dic[@"data"] integerValue];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"报错：%@", [error localizedDescription]);

    }];
    
}


@end
