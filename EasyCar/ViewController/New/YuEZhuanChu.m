//
//  YuEZhuanChu.m
//  EasyCar
//
//  Created by 橙晓侯 on 16/1/14.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "YuEZhuanChu.h"
#import "JieGuoXiangQingVC.h"

@interface YuEZhuanChu ()
@property (strong, nonatomic) IBOutlet UIButton *zhuanChuBtn;
@property (strong, nonatomic) IBOutlet UILabel *remainCountLB;
@property (strong, nonatomic) IBOutlet UITextField *accountTF;
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *moneyTF;

@end

@implementation YuEZhuanChu

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nav setTitle:@"余额转出" leftText:@"返回" rightTitle:nil showBackImg:YES];
    
    [_accountTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_nameTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_moneyTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _moneyTF.placeholder = [NSString stringWithFormat:@"本次最多取出%.2f元",self.user.balance];
    
    
    
    
    NSMutableAttributedString *MAString = [[NSMutableAttributedString alloc] initWithAttributedString:_remainCountLB.attributedText];
    [MAString replaceCharactersInRange:NSMakeRange(7, 1) withString:[NSString stringWithFormat:@"%d",_remainTime]];
    _remainCountLB.attributedText = MAString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 点击转出
- (IBAction)onZhuanChuBtn:(id)sender {

    [self requestTiXian];
//    [self.navigationController pushViewController:[Unit EPStoryboard:@"JieGuoXiangQingVC"] animated:YES];
}

/*
 37.余额转出
 测试地址：h1ttp://localhost:8080/ytcSystem/rest/api/member/transferInfo
 htt1p://localhost:8080/ytcSystem/rest/api/member/transferInfo?memberId=1&alipayAccount=1&alipayName=1&alipayMoney=1

 测试参数：alipayMoney=转出金额
 memberId=会员id
 alipayAccount=支付宝账号
 alipayName=支付宝名称
 返回参数：status:200,msg:转出申请提交成功,data:null
 status:300,msg:每天有3次余额转出，已使用完,data:null
 status:500,msg:请求异常，data:null
 */

#pragma mark 提现请求
- (void)requestTiXian
{
    
    [self getRequestURL:BaseURL@"transferInfo"
     
             parameters:@{
                          @"memberId":self.user.userID,
                          @"alipayMoney":_moneyTF.text,
                          @"alipayAccount":_accountTF.text,
                          @"alipayName":_nameTF.text
                          }
     
                success:^(NSDictionary *dic) {
                    
                    [MBProgressHUD showSuccess:dic[@"msg"] toView:Window];

                    // 界面跳转
                    UIViewController *rootVC = [self.navigationController.viewControllers firstObject];
                    [self.navigationController popViewControllerAnimated:NO];
                    JieGuoXiangQingVC *vc = [Unit EPStoryboard:@"JieGuoXiangQingVC"];
                    vc.time1 = [dic[@"data"][@"transferTime"] doubleValue]/1000;
                    vc.time2 = [dic[@"data"][@"toBanlance"] doubleValue]/1000;
                    [rootVC.navigationController pushViewController:vc animated:YES];
                    
                }
                elseAction:^(NSDictionary *dic) {
                 
                 
                }
                failure:^(NSError *error) {
                    
                    
                }];
}

- (void)textFieldChanged:(UITextField *)textField
{
    
    NSLog(@"%@", textField);
    
    if ([_nameTF hasText] && [_accountTF hasText] && [_moneyTF hasText]) {
        
        _zhuanChuBtn.backgroundColor = [UIColor colorWithRed:0.157 green:0.404 blue:0.996 alpha:1.000];
    }
    else
    {
        _zhuanChuBtn.backgroundColor = [UIColor lightGrayColor];
    }
}



@end
