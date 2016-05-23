//
//  AppointOrderModel.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/19.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "AppointOrderModel.h"

@implementation AppointOrderModel
- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _appointCarPlate = dic[@"appointCarPlate"];
//        NSLog(@"%@",dic[@"appointMoney"]);
#warning 这里
        _appointMoney = [NSString stringWithFormat:@"%@",dic[@"appointMoney"]];
        _appointTime = dic[@"appointTime"];
        _orderId = dic[@"orderId"];
        _parkAddress = dic[@"parkAddress"];
        _parkImg = dic[@"parkImg"];
        _parkarea = dic[@"parkarea"];
        _parkid = dic[@"parkid"];
        _parkno = dic[@"parkno"];
        _spaceid = dic[@"spaceid"];
        _type = dic[@"type"];
    }
    return self;
}
@end
