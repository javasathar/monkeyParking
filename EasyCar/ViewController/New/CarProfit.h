//
//  CarProfit.h
//  EasyCar
//
//  Created by 橙晓侯 on 16/1/15.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarProfit : NSObject

@property (nonatomic, assign) double inTime;
@property (nonatomic, assign) double outTime;
@property (nonatomic, assign) double parkFee;
@property (nonatomic, strong) NSString *carPlate;

@end
