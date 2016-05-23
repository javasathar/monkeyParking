//
//  RentOrder.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/18.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RentOrder : NSObject

@property (nonatomic,assign) int rentTime;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *rentMoney;
@property (nonatomic, strong) NSString *parkAddress;
@property (nonatomic,assign) float orderTime;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, strong) NSString *parkImg;

@end
