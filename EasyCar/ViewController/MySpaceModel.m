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
        self.orderId = dic[@"id"];
        self.orderTime = dic[@"orderTime"];
        self.parkAddress = dic[@"parkAddress"];
//        self.parkImg = dic[@"parkImg"];
//        self.phone = dic[@"phone"];
//        self.rentMoney = dic[@"rentMoney"];
        self.rentTime = dic[@"rentTime"];
        self.endTime = dic[@"endTime"];
        self.memberId = dic[@"memberId"];
        self.parkArea = dic[@"parkArea"];
        self.parkNo = dic[@"parkNo"];
        self.parkName = dic[@"parkName"];
        self.parkspaceId = dic[@"parkspaceId"];
        self.parkId = dic[@"parkId"];
        self.result = dic[@"result"];
    }
    return self;
}
@end
