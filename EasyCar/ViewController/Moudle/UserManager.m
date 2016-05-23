//
//  UserManager.m
//  TLthumb
//
//  Created by 田隆真 on 15/9/19.
//  Copyright (c) 2015年 田隆真. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

+ (UserManager *)manager
{
    static UserManager *user = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^
                  {
                      user = [[self alloc] init];
                  });
    return user;
}


- (void)userManagerDic:(NSDictionary *)dic
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"wasLogin"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSString *imgStr = [SysURL stringByAppendingString:dic[@"headImg"]];
    self.head_img = imgStr;
    self.username  = [NSString stringWithFormat:@"%@",dic[@"username"]];
    self.password = [NSString stringWithFormat:@"%@",dic[@"password"]];
    self.phone = [NSString stringWithFormat:@"%@",dic[@"phone"]];
    self.userID = [NSString stringWithFormat:@"%@",dic[@"id"]];
    self.email = [NSString stringWithFormat:@"%@",dic[@"email"]];
    self.id_card  = [NSString stringWithFormat:@"%@",dic[@"idCard"]];
    self.nickname = [NSString stringWithFormat:@"%@",dic[@"nickname"]];
    self.address = [NSString stringWithFormat:@"%@",dic[@"address"]];
    self.resume = [NSString stringWithFormat:@"%@",dic[@"resume"]];
    self.create_time = [NSString stringWithFormat:@"%@",dic[@"create_time"]];
    
    if(![dic[@"balance"] isEqual:[NSNull null]])
    {
        self.balance = [dic[@"balance"] floatValue];
    }
    
    self.sex = [dic[@"sex"] floatValue];
}

@end
