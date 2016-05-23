//
//  MySpaceOrderViewController.h
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/12.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "baseVC.h"
#import "Park.h"
#import "Car.h"
@interface MySpaceOrderViewController : baseVC
@property (nonatomic ,strong) Park *park;
@property (nonatomic ,strong) NSString *parkArea;
@property (nonatomic ,strong) NSString *parkNO;
@property (nonatomic ,strong) Car *car;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UILabel *carID;
@property (weak, nonatomic) IBOutlet UILabel *spaceNumber;
@property (weak, nonatomic) IBOutlet UILabel *timeLong;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
- (IBAction)payBtn:(id)sender;

@end
