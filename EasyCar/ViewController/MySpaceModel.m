//
//  MySpaceModel.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/11.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "MySpaceModel.h"

@implementation MySpaceModel
- (id)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.orderId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.orderTime = [NSString stringWithFormat:@"%@",dic[@"orderTime"]];
        self.parkAddress = dic[@"parkAddress"];
//        self.parkImg = dic[@"parkImg"];
//        self.phone = dic[@"phone"];
//        self.rentMoney = dic[@"rentMoney"];
        self.rentTime = [NSString stringWithFormat:@"%@",dic[@"rentTime"]];
        self.endTime = [NSString stringWithFormat:@"%@",dic[@"endTime"]];
        self.memberId = [NSString stringWithFormat:@"%@",dic[@"memberId"]];
        self.parkArea = [NSString stringWithFormat:@"%@",dic[@"parkArea"]];
        self.parkNo = [NSString stringWithFormat:@"%@",dic[@"parkNo"]];
        self.parkName = dic[@"parkName"];
        self.parkspaceId = [NSString stringWithFormat:@"%@",dic[@"parkspaceId"]];
        self.parkId = [NSString stringWithFormat:@"%@",dic[@"parkId"]];
        self.result = dic[@"result"];
        self.rentType = dic[@"rentType"];
    }
    return self;
}
@end
