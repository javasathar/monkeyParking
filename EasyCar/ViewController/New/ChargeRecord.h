//
//  chargeRecord.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/22.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChargeRecord : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, assign) double orderTime;
@property (nonatomic, assign) double type;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, assign) double orderMoney;

@end
