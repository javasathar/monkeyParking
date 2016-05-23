//
//  MySpaceModel.h
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/11.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySpaceModel : NSObject
@property (nonatomic ,strong)NSString *orderId;
@property (nonatomic ,strong)NSString *orderTime;
@property (nonatomic ,strong)NSString *parkAddress;
//@property (nonatomic ,strong)NSString *parkImg;
//@property (nonatomic ,strong)NSString *phone;
//@property (nonatomic ,strong)NSString *rentMoney;
@property (nonatomic ,strong)NSString *rentTime;
@property (nonatomic ,strong)NSString *endTime;
@property (nonatomic ,strong)NSString *parkspaceId;
@property (nonatomic ,strong)NSString *memberId;
@property (nonatomic ,strong)NSString *parkArea;
@property (nonatomic ,strong)NSString *parkId;
@property (nonatomic ,strong)NSString *parkName;
@property (nonatomic ,strong)NSString *parkNo;
@property (nonatomic ,strong)NSNumber *result;
-(id)initWithDict:(NSDictionary *)dic;
@end
