//
//  Coupon.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/24.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "Coupon.h"

@implementation Coupon

/*
 @property (nonatomic, copy) NSString *ID;
 @property (nonatomic,assign) NSTimeInterval endTime;
 @property (nonatomic,assign) NSTimeInterval createTime;
 @property (nonatomic, strong) NSString *memberId;
 @property (nonatomic,assign) CGFloat amount;
 @property (nonatomic,assign) NSInteger type;
 @property (nonatomic,assign) NSInteger status;
*/
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id"
             };
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _ID         = dic[@"id"];
        _memberId   = dic[@"memberId"];
        _endTime    = [dic[@"endTime"] doubleValue];
        _createTime = [dic[@"createTime"] doubleValue];
        _amount     = [dic[@"amount"] doubleValue];
        _status     = [dic[@"status"] doubleValue];
        _type       = [dic[@"type"] doubleValue];
    }
    return self;
}

- (void)setInfo:(NSDictionary *)dic
{
    _ID         = dic[@"id"];
    _memberId   = dic[@"memberId"];
    _endTime    = [dic[@"endTime"] doubleValue];
    _createTime = [dic[@"createTime"] doubleValue];
    _amount     = [dic[@"amount"] doubleValue];
    _status     = [dic[@"status"] doubleValue];
    _type       = [dic[@"type"] doubleValue];
}

@end
