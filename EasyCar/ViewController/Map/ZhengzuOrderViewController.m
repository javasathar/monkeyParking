//
//  ZhengzuOrderViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/20.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ZhengzuOrderViewController.h"
#import "ChooseBankViewController.h"

@interface ZhengzuOrderViewController ()

@end

@implementation ZhengzuOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self._mainScrollView.frame = CGRectMake(0, 0, Width, Heigth);
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGBA(242, 242, 248, 1);
    self.title = @"订单支付";
    self.addressLabel.text = self.address;
    self.bankLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *chooseBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseBackAction)];
    [self.bankLabel addGestureRecognizer:chooseBack];
    self.zfBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.zfBtn.frame = CGRectMake(15, self.bankLabel.bottom+20, UI_SCREEN_WIDTH-30, 40);
    [self._mainScrollView addSubview:self.zfBtn];
    [self.zfBtn setTitle:@"支付" forState:(UIControlStateNormal)];
    [self.zfBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.zfBtn.backgroundColor = RGBA(50, 129, 255, 1);
    [self.zfBtn addTarget:self action:@selector(zifuAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.zfBtn.layer.cornerRadius = 3;
    self._mainScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, 568);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBankName:) name:@"chooseBank" object:nil];

}

//支付
- (void)zifuAction
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认支付?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

//选择银行
- (void)chooseBackAction
{
    ChooseBankViewController *bankVC = [[ChooseBankViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController pushViewController:bankVC animated:YES];
}

- (void)changeBankName:(NSNotification *)note
{
    self.bankLabel.text = note.object;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(0 == buttonIndex)
    {
        
    }
    else if (1 == buttonIndex)
    {
        [MBProgressHUD showSuccess:@"支付成功" toView:self.view];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(back) userInfo:nil repeats:NO];
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
