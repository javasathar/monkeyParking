//
//  ChongZhiVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/23.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//  涉及支付

#import "ChongZhiVC.h"

@interface ChongZhiVC ()
@property (strong, nonatomic) IBOutlet UIButton *aliBtn;

@property (strong, nonatomic) IBOutlet UIButton *wxBtn;
@end

@implementation ChongZhiVC
{
    UIButton *_sMoneyBtn;
    UIButton *_sPayTypeBtn;
    UIButton *_lMoneyBtn;
    UIButton *_lPayTypeBtn;
    NSString *_orderId;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.nav setTitle:@"充值" leftText:@"返回" rightTitle:nil showBackImg:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 选择金额
- (IBAction)onMoney:(UIButton *)sender {

    _sMoneyBtn = sender;
    sender.selected = YES;
    
    if (!_lMoneyBtn || [_lMoneyBtn isEqual:sender])
    {
        
    }
    else
    {
        _lMoneyBtn.selected = NO;
    }
    
    _lMoneyBtn = sender;

}


#pragma mark 选择支付方式
- (IBAction)onPayType:(UIButton *)sender {

    _sPayTypeBtn = sender;
    sender.selected = YES;
    
    if (!_lPayTypeBtn || [_lPayTypeBtn isEqual:sender])
    {
        
    }
    else
    {
        _lPayTypeBtn.selected = NO;
    }
    
    _lPayTypeBtn = sender;
    
}

// 手势版
- (IBAction)tapPayType:(UITapGestureRecognizer *)sender {
    
    [self onPayType:(UIButton *)[sender.view viewWithTag:100]];

}


#pragma mark 点击充值
- (IBAction)onChongZhi:(id)sender {

    if (!_sMoneyBtn) {
        
        [MBProgressHUD showError:@"请选择充值金额" toView:Window];
        return;
    }
    if (!_sPayTypeBtn) {
        
        [MBProgressHUD showError:@"请选择支付方式" toView:Window];
        return;
    }
    NSString *getUrl = BaseURL@"recharge";
    NSDictionary *parameterDic = @{
                                    @"memberid":self.user.userID,
                                    @"money":_sMoneyBtn.titleLabel.text
                                   };
    [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
//        NSLog(@"充值：%@",dic);
        if ([dic[@"data"] isKindOfClass:[NSDictionary class]]) {
            if (dic[@"data"][@"orderid"]) {
                [self gotoPay:dic[@"data"][@"orderid"]];
            }
        }
    } elseAction:^(NSDictionary *dic) {
        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark 准备支付
-(void)gotoPay:(NSString *)payOrderId
{
    Order *order = [Order new];
    order.productName = @"充值";
    order.productDescription = [NSString stringWithFormat:@"余额充值%@元",_sMoneyBtn.titleLabel.text];
#warning 注意啦：测试价格0.01
//    order.amount = @"0.01";
    order.amount = _sMoneyBtn.titleLabel.text;
    order.payType = @3;//充值
    order.orderID = payOrderId;
    
    if ([_sPayTypeBtn isEqual:_aliBtn]) {
        _orderId = [self gotoAliPay:order];
    }
    if ([_sPayTypeBtn isEqual:_wxBtn]) {
        _orderId = [self gotoWXPay:order];
    }
}
- (void)requestAfterPaySuccess
{
    NSDictionary *parameters = @{
                                 @"memberId"    :self.user.userID,
//                                 @"orderId"     :_orderId,
                                 @"orderMoney"  :_sMoneyBtn.titleLabel.text,
                                 @"type"        :[[self payWayDic] allKeysForObject:_sPayTypeBtn][0]
                                 };
    [self getRequestURL:BaseURL@"chargeBalance" parameters:parameters success:^(NSDictionary *dic) {
        
        self.user.balance = [dic[@"data"] doubleValue]; // 更改余额
        
        [self showNormalAlertWithTitle:@"恭喜" message:[NSString stringWithFormat:@"您已成功充值%@元",_sMoneyBtn.titleLabel.text]];
        
        
        
        
    } elseAction:^(NSDictionary *dic) {
        
        [self requestAfterPaySuccess];
    } failure:^(NSError *error) {
        
        [self requestAfterPaySuccess];
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

- (void)payResultHandle:(NSNotification *)notification
{
    [super payResultHandle:notification];
    if ([notification.object isEqual: @1]) {
        
        NSLog(@"VC：支付成功");
        [self requestAfterPaySuccess];
    }
    else
    {
        NSLog(@"VC：支付失败");
    }

    
}

- (NSDictionary *)payWayDic {
    
    return @{
             @"0":_aliBtn,
             @"1":_wxBtn
             };
}

@end

