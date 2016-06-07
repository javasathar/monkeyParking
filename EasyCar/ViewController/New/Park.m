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

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        NSDictionary *parkDic = dic[@"park"];
        _type = [parkDic[@"type"] integerValue];
        _parklat_R = [parkDic[@"parklat_R"] floatValue];
        _parklon_R = [parkDic[@"parklon_R"] floatValue];
        _appointFee = [parkDic[@"appointFee"] floatValue];
        _validDate = [parkDic[@"validDate"] floatValue];
        _parkName = parkDic[@"parkName"];
        _ID = parkDic[@"ID"];
        _address = parkDic[@"address"];
        _comParkImg = parkDic[@"comParkImg"];
    }
    return self;
}

@end
