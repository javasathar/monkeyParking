//
//  PlcTestViewController.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/3/7.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "PlcTestViewController.h"
#import "MainViewController.h"
@interface PlcTestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *plcHost;
@property (weak, nonatomic) IBOutlet UITextField *plcPort;
@property (weak, nonatomic) IBOutlet UITextField *plcText;
@property (weak, nonatomic) IBOutlet UITextField *plcIPHead;
@property (weak, nonatomic) IBOutlet UISegmentedControl *plcIsEnter;

@end

@implementation PlcTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.plcHost.text = [AppDelegate shareInstance].plcHost;
    self.plcPort.text = [AppDelegate shareInstance].plcPort;
    self.plcText.text = [AppDelegate shareInstance].plcTest;
    self.plcIPHead.text = [AppDelegate shareInstance].plcIPHead;
    if ([AppDelegate shareInstance].isEnter) {
        self.plcIsEnter.selectedSegmentIndex = 0;
    }else
    {
        self.plcIsEnter.selectedSegmentIndex = 1;

    }
    [self.nav setTitle:@"SET" leftText:@"返回" rightTitle:@"PLC测试" showBackImg:YES];
}
- (IBAction)btnClick:(id)sender {
    [AppDelegate shareInstance].plcHost = self.plcHost.text;
    [AppDelegate shareInstance].plcPort = self.plcPort.text;
    [AppDelegate shareInstance].plcTest = self.plcText.text;
    [AppDelegate shareInstance].plcIPHead = self.plcIPHead.text;
    if (self.plcIsEnter.selectedSegmentIndex == 0)
    {
        [AppDelegate shareInstance].isEnter = YES;
    }else
    {
        [AppDelegate shareInstance].isEnter = NO;
    }
    [MBProgressHUD showResult:YES text:@"OKAY" delay:1.0f];
}
-(void)right
{
    MainViewController *vc = [MainViewController new];
    [self.navigationController pushViewController:vc animated:YES];
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
