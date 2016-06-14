//
//  ParkingYuYueViewController.h
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/18.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "baseVC.h"
#import "AppointOrderModel.h"

@interface ParkingYuYueViewController : baseVC
@property (nonatomic ,strong) AppointOrderModel * appointModel;
@property (weak, nonatomic) IBOutlet UILabel *parkAddress;
@property (weak, nonatomic) IBOutlet UILabel *parkCar;
@property (weak, nonatomic) IBOutlet UILabel *parkPrice;
@property (weak, nonatomic) IBOutlet UILabel *parkAreaNumLB;

@end
