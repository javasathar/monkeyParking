//
//  CGTool.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/2/18.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "CGTool.h"
#import <Reachability.h>
#import <SystemConfiguration/CaptiveNetwork.h>
@implementation CGTool
{
    UIButton *home_tab1btn;
    UIButton *home_tab2btn;
    UIButton *home_tab3btn;
    UIImageView *fakeTabbarBackground;
    baseVC *_currentVC;
}
//单例
+(id)shareInitial
{
    static CGTool *cgTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cgTool = [[CGTool alloc] init];
    });
    return cgTool;
}
+(BOOL)isConnectWifi
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    //结果说明：0-无连接   1-wifi    2-3G
    NSInteger stateNet = [reachability currentReachabilityStatus];
    NSLog(@"%ld",stateNet);
    if (stateNet == 2)
    {
        return YES;
    }
    return NO;
}

#pragma mark 设置tabbar
-(void)setTabbarWithViewController:(UIViewController *)vc
{
    
    fakeTabbarBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, Heigth-49, Width, 49)];
    fakeTabbarBackground.image = [UIImage imageNamed:@"tabLine"];
    
    [vc.view addSubview:fakeTabbarBackground];
    
    home_tab1btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    home_tab1btn.frame = CGRectMake(0, UI_SCREEN_HEIGHT-49, 110, 49);

//    [home_tab1btn setTitle:@"首页" forState:UIControlStateNormal];
    [home_tab1btn setImage:[UIImage imageNamed:@"home2"] forState:(UIControlStateNormal)];
    [home_tab1btn setImage:[UIImage imageNamed:@"home"] forState:UIControlStateSelected];
    [home_tab1btn addTarget:self action:@selector(showHome) forControlEvents:UIControlEventTouchUpInside];
    [vc.view addSubview:home_tab1btn];
    UILabel *home_label = [[UILabel alloc] initWithFrame:CGRectMake(0, home_tab1btn.height/ 2, home_tab1btn.width, home_tab1btn.height / 2)];
    home_label.tag = 111;
    home_label.text = @"首页";
    home_label.font = [UIFont systemFontOfSize:10];
    home_label.textAlignment = NSTextAlignmentCenter;
    home_label.textColor = RGBA(108, 132, 164, 1);
    [home_tab1btn addSubview:home_label];
    
    home_tab2btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    home_tab2btn.frame = CGRectMake(UI_SCREEN_WIDTH/2-35, UI_SCREEN_HEIGHT-70, 70, 70);
    [home_tab2btn setImage:[UIImage imageNamed:@"monkeyLogo"] forState:(UIControlStateNormal)];
    [home_tab2btn addTarget:self action:@selector(showMenu) forControlEvents:(UIControlEventTouchUpInside)];
    [vc.view addSubview:home_tab2btn];
    UILabel *monkey_label = [[UILabel alloc] initWithFrame:CGRectMake(0, home_tab2btn.height/ 2, home_tab2btn.width, home_tab2btn.height / 2)];
    monkey_label.tag = 111;
    monkey_label.text = @"预约车位";
    monkey_label.font = [UIFont systemFontOfSize:10];
    monkey_label.textAlignment = NSTextAlignmentCenter;
    monkey_label.textColor = [UIColor whiteColor];
    [home_tab2btn addSubview:monkey_label];
    
    home_tab3btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    home_tab3btn.frame = CGRectMake(UI_SCREEN_WIDTH-110, UI_SCREEN_HEIGHT-49, 110, 49);
    [home_tab3btn setImage:[UIImage imageNamed:@"friends"] forState:(UIControlStateNormal)];
    [home_tab3btn setImage:[UIImage imageNamed:@"friends2"] forState:UIControlStateSelected];
    [home_tab3btn addTarget:self action:@selector(meVC) forControlEvents:(UIControlEventTouchUpInside)];
    [vc.view addSubview:home_tab3btn];
    UILabel *me_label = [[UILabel alloc] initWithFrame:CGRectMake(0, home_tab3btn.height/ 2, home_tab3btn.width, home_tab3btn.height / 2)];
    me_label.tag = 111;
    me_label.text = @"个人中心";
    me_label.font = [UIFont systemFontOfSize:10];
    me_label.textAlignment = NSTextAlignmentCenter;
    me_label.textColor = RGBA(108, 132, 164, 1);
    [home_tab3btn addSubview:me_label];
    
    if([NSStringFromClass([vc class]) isEqualToString:@"HomeViewController"])
    {
        home_tab1btn.selected = YES;
        UILabel *label = [home_tab1btn viewWithTag:111];
        label.textColor = RGBA(40, 96, 180, 1);
    }else if([NSStringFromClass([vc class]) isEqualToString:@"MeViewController"])
    {
        UILabel *label = [home_tab3btn viewWithTag:111];
        label.textColor = RGBA(40, 96, 180, 1);
        home_tab3btn.selected = YES;
    }
}
-(void)showHome
{
    
    [AppDelegate shareInstance].tab.selectedIndex = 0;
}
-(void)showMenu
{
    //    if ([UserManager manager].isLogin)
    //    {
    //        [AppDelegate shareInstance].tab.selectedIndex = 1;
    //    }
    //    else
    //    {
    //        baseVC *base = (baseVC *)[self getCurrentVC];
    //        [base showFunctionAlertWithTitle:@"温馨提示" message:@"您尚未登录" functionName:@"点击登录" Handler:^{
    //            [base gotoLoginVC];
    //        }];
    //    }
    baseVC *base = (baseVC *)[self getCurrentVC];
    [base clickMonkey];
}
-(void)meVC
{
    if ([UserManager manager].isLogin)
    {
        [AppDelegate shareInstance].tab.selectedIndex = 2;
    }
    else
    {
        if ([self isMonkeyWIFI]) {
            baseVC *base = (baseVC *)[self getCurrentVC];
            [base showFunctionAlertWithTitle:@"温馨提示" message:@"当前为停车场WIFI，无法上网" functionName:@"去设置" Handler:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
                //                [base gotoLoginVC];
            }];
        }else
        {
            baseVC *base = (baseVC *)[self getCurrentVC];
            [base showFunctionAlertWithTitle:@"温馨提示" message:@"您尚未登录" functionName:@"点击登录" Handler:^{
                [base gotoLoginVC];
            }];
        }
        
    }
    
}
#pragma mark 获取当前屏幕显示的viewController    (自制)
- (UIViewController *)getCurrentVC
{
    NSInteger i = [AppDelegate shareInstance].tab.selectedIndex;
    UINavigationController *nav = [AppDelegate shareInstance].tab.viewControllers[i];
    UIViewController *vc = nav.topViewController;
    return vc;
}
#pragma mark 获取当前屏幕显示的viewcontroller    (bug)
- (UIViewController *)getCurrentVC2
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    NSLog(@"当前视图：%@",result);
    return result;
}
#pragma mark 获取wifi名称
- (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
//    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
//        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}
-(BOOL)isMonkeyWIFI
{
//    return NO;

    NSDictionary* _wifiInfo = (NSDictionary *)[self fetchSSIDInfo];
    if([_wifiInfo[@"SSID"] length] > 10)
    {
        if ([_wifiInfo[@"SSID"] isEqualToString:wifiName]) {
            NSLog(@"%@",[[NSString alloc] initWithData:_wifiInfo[@"SSIDDATA"] encoding:NSUTF8StringEncoding] );
            return YES;
        }
    }
    return NO;
}

#pragma mark 是不是美猴王
+(BOOL)isMonkey
{
    NSLog(@"%@",[UserManager manager].nickname);
    if ([[UserManager manager].nickname isEqualToString:@"停车大圣2016"]) {
        return YES;
    }
    return NO;
}
#pragma mark 爱过
+(BOOL)wasLogin
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"wasLogin"]) {
        return YES;
    }
    return NO;
}
@end
