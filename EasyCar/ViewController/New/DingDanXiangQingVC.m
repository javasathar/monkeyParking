//
//  DingDanXiangQingVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/17.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "DingDanXiangQingVC.h"
#import "ZhengZuOrderCell.h"
#import "YuYueOrderCell.h"
@interface DingDanXiangQingVC ()


@property (strong, nonatomic) IBOutlet UILabel *orderNumLB;
@property (strong, nonatomic) IBOutlet UILabel *orderTimeLB;
@property (strong, nonatomic) IBOutlet UILabel *payWayLB;
@property (strong, nonatomic) IBOutlet UILabel *payMoneyLB;
@property (strong, nonatomic) IBOutlet UILabel *carLB;
@property (strong, nonatomic) IBOutlet UILabel *placeLB;

@end

@implementation DingDanXiangQingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.nav setTitle:@"订单详情" leftText:@"返回" rightTitle:nil showBackImg:YES];
    
    if (_cell) {
        
        if ([_cell isKindOfClass:[YuYueOrderCell class]]) {
            
            AppointOrder *order = [_cell valueForKey:@"order"];

            _xxTitleLB.text = @"我的预约详情";
            _xxCarLB.text = @"预约车辆：";
            _xxPlaceLB.text = @"预约场地：";
            
            _orderNumLB.text = order.orderId;
            _orderTimeLB.text = [Unit stringFromTimeInterval:order.appointTime/1000 formatterOrNil:nil];
            _payMoneyLB.text = [NSString stringWithFormat:@"%@元",order.appointMoney];
            _carLB.text = order.appointCarPlate;
            _placeLB.text = order.parkAddress;
            
        }
        if ([_cell isKindOfClass:[ZhengZuOrderCell class]]) {
            
            RentOrder *order = [_cell valueForKey:@"order"];
            
            _xxTitleLB.text = @"我的整租详情";
            _xxCarLB.text = @"整租用户：";
            _xxPlaceLB.text = @"整租场地：";
            
            _orderNumLB.text = order.orderId;
            _orderTimeLB.text = [Unit stringFromTimeInterval:order.orderTime/1000 formatterOrNil:nil];
            _payMoneyLB.text = [NSString stringWithFormat:@"%@元",order.rentMoney];
            
            NSMutableString *phoneNum = [NSMutableString stringWithString:order.phone];
            [phoneNum replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            _carLB.text = phoneNum;
            _placeLB.text = order.parkAddress;
        }
        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
