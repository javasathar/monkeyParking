//
//  AppointOrder.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/9.｀
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointOrder : NSObject

@property (nonatomic,assign) float appointTime;
@property (nonatomic, copy) NSString *appointMoney;
@property (nonatomic, copy) NSString *parkAddress;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *appointCarPlate;
@property (nonatomic, strong) NSString *parkImg;
@property (nonatomic, assign) NSInteger type;
//@property (nonatomic, copy) NSString *ID;
//@property (nonatomic, copy) NSString *result;
//@property (nonatomic, copy) NSString *expiretime;
//
//@property (nonatomic, copy) NSString *parking_No;
//@property (nonatomic, copy) NSString *park_id;
//@property (nonatomic, copy) NSString *park_area;
//@property (nonatomic, copy) NSString *member_id;
//@property (nonatomic, copy) NSString *coupon_id;
//@property (nonatomic, copy) NSString *order_id;
//@property (nonatomic, copy) NSString *appoint_carPlate;
//@property (nonatomic, copy) NSString *appoint_money;
//@property (nonatomic, copy) NSString *park_garage_no;
//
//@property (nonatomic, assign) double appoint_time;
//@property (nonatomic, assign) double appoint_wash;
//@property (nonatomic, assign) double appoint_elec;



@end
