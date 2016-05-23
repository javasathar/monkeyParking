//
//  CarParkingInfo.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/15.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarParkingInfo : NSObject

// 停车信息的模型，在我要取车
@property (nonatomic, strong) NSString *parkNo;
@property (nonatomic, strong) NSString *parkId;
@property (nonatomic, strong) NSString *inCarPlate;
@property (nonatomic,assign) float inTime;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *spaceId;
@property (nonatomic, strong) NSString *parkArea;

@end
