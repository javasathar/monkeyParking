//
//  PushInfo.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/11.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "PushInfo.h"

@implementation PushInfo

MJExtensionLogAllProperties

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id"
             };
}

@end