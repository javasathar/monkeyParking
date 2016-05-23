//
//  ZKAnnotation.m
//  SmartCard
//
//  Created by zhangke on 15/5/11.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ZKAnnotation.h"

@implementation ZKAnnotation

- (instancetype)initWithAdressName:(NSString *)name latitude:(double)latitude longitude:(double)longitude
{
    if (self = [super init]) {
        
        self.AdressName = name;
        self.latitude = latitude;
        self.longitude = longitude;
    }
    
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D center;
    center.latitude = self.latitude;
    center.longitude = self.longitude;
    return center;
}

-  (NSString *)title
{
    return self.AdressName;
}

- (NSString *)subtitle
{
    return @"";
}

@end
