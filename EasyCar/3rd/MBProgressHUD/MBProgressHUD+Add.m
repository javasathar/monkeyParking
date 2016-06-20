//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

#pragma mark 橙晓侯自制MBProgressHUD方法
+ (MBProgressHUD *)showResult:(BOOL)result text:(NSString *)text delay:(double)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:Window animated:YES];
    hud.alpha = 0.8;
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", result ? @"icon_gg" : @"icon_xx"]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // n秒之后再消失
    [hud hide:YES afterDelay:delay];
    
    return hud;
}


// 带标题的动画
+ (MBProgressHUD *)showAnimateHUDAddedTo:(UIView *)view text:(NSString *)text {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];

    HUD.labelText = text;
    [view addSubview:HUD];
    [HUD show:YES];

    return HUD;
}


+ (MBProgressHUD *)showAnimateExitHUDAddedTo:(UIView *)view text:(NSString *)text {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];

    HUD.labelText = text;

    //===========
    [HUD layoutIfNeeded];
    
    UILabel *lb = [HUD valueForKey:@"label"];
    CGFloat x = text.length > 0 ? lb.right - 3 : lb.right + 20;
    CGFloat y = lb.top - 58;

    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setTitle:@"×" forState:UIControlStateNormal];
    exitBtn.frame = CGRectMake( x, y, 20 , 20);
    [exitBtn addTarget:self action:@selector(clickX) forControlEvents:UIControlEventTouchUpInside];
    //===========
    
    [HUD addSubview:exitBtn];
    [view addSubview:HUD];
    [HUD show:YES];
    
    return HUD;
}

// 点击 × 的操作
+ (void)clickX
{
    if ([[MBProgressHUD getCurrentVC] isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *navCtl = (UINavigationController *)[MBProgressHUD getCurrentVC];
        [navCtl popViewControllerAnimated:YES];
    }
}

// 点击取消的操作
+ (void)removeHUD:(UITapGestureRecognizer *)tap
{
    [tap.view removeFromSuperview];
}



#pragma mark 显示信息
+ (MBProgressHUD *)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.alpha = 0.8;
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.5];
    
    return hud;
}

#pragma mark 显示错误信息
+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view{
    [MBProgressHUD hideAllHUDsForView:Window animated:YES];

    return [self show:error icon:@"icon_xx" view:view];
}

+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:Window animated:YES];

    return [self show:success icon:@"icon_gg" view:view];
}



#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    [hud hide:YES afterDelay:1.5f];
    return hud;
}


//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
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
    
    return result;
}

@end
