//
//  UserAgreementVC.m
//  tl_Good
//
//  Created by 田隆真 on 15/9/9.
//  Copyright (c) 2015年 田隆真. All rights reserved.
//

#import "UserAgreementVC.h"

@interface UserAgreementVC ()<MY_nav_delegate>

@end

@implementation UserAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.nav setTitle:@"软件使用协议" leftText:@"返回" rightTitle:nil showBackImg:YES];
    
//    去请求用户协议
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:UserAgreementURL]];
    UIWebView * web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, Width, Heigth - 64)];
    [web loadRequest:request];
    [self.view addSubview:web];
    
    // Do any additional setup after loading the view.
}
- (void)left
{
    [self.navigationController popViewControllerAnimated:YES];
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
