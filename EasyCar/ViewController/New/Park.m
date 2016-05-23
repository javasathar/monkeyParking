//
//  Park.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/10.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "Park.h"

@implementation Park

MJExtensionLogAllProperties

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id",
             @"parklat_R" : @"parkLat",// 交换写反的经纬度(后台已修正)
             @"parklon_R" : @"parkLon"
             };
}

@end
