//
//  UserDefaultsFiles.m
//  tl_Good
//
//  Created by 田隆真 on 15/7/20.
//  Copyright (c) 2015年 田隆真. All rights reserved.
//

#import "UserDefaultsFiles.h"
#define UD [NSUserDefaults standardUserDefaults]

@implementation UserDefaultsFiles


+ (void)setUserDataName:(NSString *)name password:(NSString *)password
{
    [UD setObject:name forKey:@"name"];// name是手机号
    [UD setObject:password forKey:@"password"];
    [UD synchronize];
}
- (NSString *)getUserName
{
    NSString * name = [UD objectForKey:@"name"];
    return name;
}

- (NSString *)getUserPassword
{
    NSString * password = [UD objectForKey:@"password"];
    return password;
}


#pragma mark 第一次运行 （UUID保存）
+ (void)didFirstLaunch
{
    [UD setBool:YES forKey:@"isSecondLunch"];
    [self setUUID:[[NSUUID UUID] UUIDString]];
}

+ (void)setUUID:(NSString *)UUID
{
    [UD setValue:UUID forKey:@"UUID"];
}

+ (NSString *)getUUID
{
    return [UD valueForKey:@"UUID"];
}

+ (BOOL)isSecondLaunch
{
    return [UD boolForKey:@"isSecondLunch"];
}

- (BOOL)GetLogin
{
    return [UD boolForKey:@"isLogin"];
}


+ (void)doNotShowWXPayNoticeAgain
{
    [UD setBool:YES forKey:@"doNotShowWXPayNoticeAgain"];
}

+ (BOOL)shouldShowWXPayNotice
{
    return ![UD boolForKey:@"doNotShowWXPayNoticeAgain"];
}
@end
