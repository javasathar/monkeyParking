//
//  UserDefaultsFiles.h
//  tl_Good
//
//  Created by 田隆真 on 15/7/20.
//  Copyright (c) 2015年 田隆真. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsFiles : NSObject

+ (void)setUserDataName:(NSString *)name password:(NSString *)password;
+ (void)didFirstLaunch;
+ (BOOL)isSecondLaunch;

- (NSString *)getUserName;
- (NSString *)getUserPassword;
+ (NSString *)getUUID;
- (BOOL)GetLogin;

// 关于微信支付的提示语
+ (void)doNotShowWXPayNoticeAgain;
+ (BOOL)shouldShowWXPayNotice;
@end
