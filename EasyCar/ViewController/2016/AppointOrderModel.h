//
//  AppointOrderModel.h
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/19.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointOrderModel : NSObject
@property (nonatomic ,strong)NSString *appointCarPlate;
@property (nonatomic ,strong)NSString *appointMoney;
@property (nonatomic ,strong)NSString *appointTime;
@property (nonatomic ,strong)NSString *orderId;
@property (nonatomic ,strong)NSString *parkAddress;
@property (nonatomic ,strong)NSString *parkImg;
@property (nonatomic ,strong)NSString *parkarea;
@property (nonatomic ,strong)NSString *parkid;
@property (nonatomic ,strong)NSString *parkno;
@property (nonatomic ,strong)NSString *spaceid;
@property (nonatomic ,strong)NSString *type;
-(id)initWithDic:(NSDictionary *)dic;
@end
