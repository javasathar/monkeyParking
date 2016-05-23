//
//  Coupon.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/24.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coupon : NSObject


@property (nonatomic, copy) NSString *ID;
@property (nonatomic,assign) double endTime;
@property (nonatomic,assign) double createTime;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic,assign) double amount;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic, strong) NSString *couponimg;

- (instancetype)initWithDic:(NSDictionary *)dic;
- (void)setInfo:(NSDictionary *)dic;





@end
