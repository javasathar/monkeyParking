//
//  ParkingSpaceAreaViewController.h
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/12.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "baseVC.h"
#import "Park.h"
@interface ParkingSpaceAreaViewController : baseVC
@property (nonatomic ,strong)Park *park;
@property (nonatomic)NSInteger operateState;
@property (nonatomic ,strong)NSNumber *opration;
@property (nonatomic ,strong)NSDictionary *parkingNote;//停车记录
@end
