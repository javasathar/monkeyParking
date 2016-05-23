//
//  ParkingYuYueViewController.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/18.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ParkingYuYueViewController.h"

@interface ParkingYuYueViewController ()

@end

@implementation ParkingYuYueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.nav setTitle:@"大圣停车" leftText:nil rightTitle:nil showBackImg:YES];
    [self viewInitial];
}
-(void)viewInitial
{
    NSLog(@"parkAddress:%@",_appointModel.parkAddress);
    self.parkAddress.text = _appointModel.parkAddress;
    self.parkCar.text = _appointModel.appointCarPlate;
    self.parkPrice.text = _appointModel.appointMoney;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 确定停车
- (IBAction)sureParking:(id)sender {
    NSNumber *opration = @1;
    NSString *getUrl = BaseURL@"appointParkCar";
    NSDictionary *parameterDic = @{
                                   @"memberid":self.user.userID,
                                   @"orderid":_appointModel.orderId,
                                   @"spaceid":_appointModel.spaceid
                                   
                                   };
    [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
        [MBProgressHUD showResult:YES text:dic[@"msg"] delay:1.5f];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } elseAction:^(NSDictionary *dic) {
        
    } failure:^(NSError *error) {
        
    }];

}
#pragma mark 取消预约
- (IBAction)cancelYuYue:(id)sender {
        NSString *getUrl = BaseURL@"appointCancel";
        NSDictionary *parameterDic = @{@"memberId":self.user.userID,
                                       @"orderId":_appointModel.orderId,
                                       };
        [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
            [MBProgressHUD showSuccess:dic[@"msg"] toView:Window];
        } elseAction:^(NSDictionary *dic) {
    
        } failure:^(NSError *error) {
            
        }];
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
