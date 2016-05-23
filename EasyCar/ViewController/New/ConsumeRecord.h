//
//  consumeRecord.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/22.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsumeRecord : NSObject

@property (nonatomic, assign) double outSpaceTime;
@property (nonatomic, strong) NSString *parkName;
@property (nonatomic, assign) double inTime;
@property (nonatomic, assign) double inSpaceTime;
@property (nonatomic, assign) double parkFee;
@property (nonatomic, assign) double outTime;
@property (nonatomic, assign) double parkFeeTime;
@property (nonatomic, assign) double appointTime;

@end
