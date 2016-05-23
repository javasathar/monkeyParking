//
//  ZKAnnotation.h
//  SmartCard
//
//  Created by zhangke on 15/5/11.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ZKAnnotation : NSObject<MKAnnotation>

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSString *AdressName;
@property (nonatomic, strong) NSString *title;

- (instancetype)initWithAdressName:(NSString *)name latitude:(double)latitude longitude:(double)longitude;

@end
