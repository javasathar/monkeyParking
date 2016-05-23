//
//  MyWalletViewController.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/4/28.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "MyWalletViewController.h"
#import "MyTicketViewController.h"
@interface MyWalletViewController ()

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.nav setTitle:@"我的钱包" leftText:@"返回" rightTitle:nil showBackImg:YES];

}
#pragma mark 我的余额
- (IBAction)wodeyue:(id)sender {
    [self.navigationController pushViewController:[Unit EPStoryboard:@"ZhangHuYuEVC"] animated:YES];
}
#pragma mark 我的优惠劵
- (IBAction)wodeyouhuijuan:(id)sender {
    [self.navigationController pushViewController:[[MyTicketViewController alloc] init] animated:YES];
    
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
