//
//  MBProgressHUD+Add.h
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)
+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view;
+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showResult:(BOOL)result text:(NSString *)text delay:(double)delay;

// 带标题和点击取消的动画
+ (MBProgressHUD *)showAnimateHUDAddedTo:(UIView *)view text:(NSString *)text;
/** 带标题和关闭的动画 */
+ (MBProgressHUD *)showAnimateExitHUDAddedTo:(UIView *)view text:(NSString *)text;
@end
