//
//  AppDelegate.h
//  EasyCar
//
//  Created by zhangke on 15/5/14.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSTimer *timer;
//@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic,assign) NSInteger unReadCount;
@property (nonatomic ,assign)NSInteger netState;
@property (nonatomic , strong) UITabBarController *tab;

+(AppDelegate *)shareInstance;
- (void)initHomeVC;
- (void)requestUnReadCount;

//plc 测试
@property (nonatomic ,strong) NSString *plcHost;
@property (nonatomic ,strong) NSString *plcPort;
@property (nonatomic ,strong) NSString *plcTest;
@property (nonatomic ,strong) NSString *plcIPHead;
@property (nonatomic ,assign) BOOL isEnter;
@end

