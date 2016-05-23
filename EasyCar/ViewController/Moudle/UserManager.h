//
//  UserManager.h
//  TLthumb
//
//  Created by 田隆真 on 15/9/19.
//  Copyright (c) 2015年 田隆真. All rights reserved.


#import <Foundation/Foundation.h>

@interface UserManager : NSObject

@property (strong, nonatomic)NSString * head_img;  // 我的头像
@property (strong, nonatomic)NSString * phone;     // 手机
@property (strong, nonatomic)NSString * username;  // 用户名
@property (strong, nonatomic)NSString * password;  // 密码
@property (strong, nonatomic)NSString * userID;    // 我的ID
@property (strong, nonatomic)NSString * email;     // 邮箱
@property (strong, nonatomic)NSString * id_card;   // 身份ID
@property (strong, nonatomic)NSString * nickname;  // 昵称
@property (strong, nonatomic)NSString * address;   // 联系地址
@property (strong, nonatomic)NSString * resume;    // 个人简介
@property (strong, nonatomic)NSString * create_time;// 创建时间
@property (nonatomic,assign) double balance;         // 余额
@property (nonatomic,assign) BOOL sex;              // 性别
@property (nonatomic,assign) BOOL isLogin;  // 登录状态

// 用户坐标信息
@property (strong, nonatomic)NSString * userLat;
@property (strong, nonatomic)NSString * userLon;


+ (UserManager *)manager;

- (void)userManagerDic:(NSDictionary *)dic;

@end
