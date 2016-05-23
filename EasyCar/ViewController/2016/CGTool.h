//
//  CGTool.h
//  EasyCar
//
//  Created by 易停科技－18 on 16/2/18.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGTool : NSObject
+(BOOL)isConnectWifi;
-(void)setTabbarWithViewController:(UIViewController*)vc;//设置tabbar
+(id)shareInitial;//单例
- (UIViewController *)getCurrentVC;//获取当前视图控制器
- (id)fetchSSIDInfo;//获取wifi SSID
-(BOOL)isMonkeyWIFI;
+(BOOL)isMonkey;
+(BOOL)wasLogin;// 曾经登陆过
@end
