//
//  AppointOrder.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/9.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "AppointOrder.h"

@implementation AppointOrder

MJExtensionLogAllProperties

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id",
             @"desc" : @"desciption"
             };
}

@end
