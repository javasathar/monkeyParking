//
//  baseVC.h
//  tl_Good
//
//  Created by 田隆真 on 15/7/21.
//  Copyright (c) 2015年 田隆真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "MY_nav.h"
#import "CoverView.h"
#import "Park.h"
#import <CoreLocation/CoreLocation.h>

@class Order;



@interface baseVC : UIViewController<MY_nav_delegate>

// 用户信息
@property (strong, nonatomic)UserManager * user;
/**
 *  空页面
 */
@property (nonatomic, strong) CoverView *coverView;
@property (nonatomic, strong) MY_nav *nav;

// 提示信息
-(void)showMessageBox:(NSString *)mess andDuration:(float)time;
// 网络状态
-(void)checkNetworkStatus;
// 设备判断
-(int)doDevicePlatform;
// 登陆提示
- (void)showMessageAlertView;
// 客户端提示信息
- (void)alert_Msg:(NSString *)msg;
// 功能型警告视图
- (void)showFunctionAlertWithTitle:(NSString *)title message:(NSString *)str functionName:(NSString *)functionName Handler:(void (^)())handler;
- (void)showNormalAlertWithTitle:(NSString *)title message:(NSString *)str;
// 去登录界面
- (void)gotoLoginVC;
/**
 *  登录后发跳转通知
 */
- (void)loginBeforePushVC:(NSString *)pushVCName;

// 空页面相关方法
- (void)showCoverViewOn:(UIView *)view title:(NSString *)title image:(UIImage *)image handle:(OneMoreThing)block;
- (void)removeCoverView;
- (CoverView *)coverView;

#pragma mark -- 关闭侧滑
//- (void)closeSlide:(UIViewController *)vc;

- (void)getRequestURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure;
- (void)postRequestURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure;

#pragma mark 调支付视图
- (NSString *)showPayAlertWithOrder:(Order *)order;
#pragma mark 调优惠劵支付
-(void)gotoPreferential:(Order *)order;
#pragma mark 调支付宝
- (NSString *)gotoAliPay:(Order *)order;
#pragma mark 调微信支付
- (NSString *)gotoWXPay:(Order *)order;

#pragma mark 支付结果处理（子类重写前需调用一遍父类方法）
- (void)payResultHandle:(NSNotification *)notification;

#pragma mark 调易停车余额支付 (仅用于子类重写)
- (void)gotoBalancePay:(Order *)order;

//2016
-(void)clickMonkey;
#pragma mark 保存停车记录
-(void)safeParkingNote:(Park *)park andParkArea:(NSString *)parkArea andParkNo:(NSString *)parkNo andControlType:(NSInteger)type andOrderId:(NSString *)orderId;
#pragma mark 查询操作结果
-(void)checkControlResult:(NSString *)orderId andOpration:(NSNumber *)opration;

#pragma mark 百度坐标转高德坐标
- (CLLocationCoordinate2D)GCJ02FromBD09:(CLLocationCoordinate2D)coor;


#pragma mark 高德坐标转百度坐标
- (CLLocationCoordinate2D)BD09FromGCJ02:(CLLocationCoordinate2D)coor;

#pragma mark 地球转火星
- (CLLocation *)transformToMars:(CLLocation *)location;
@end
