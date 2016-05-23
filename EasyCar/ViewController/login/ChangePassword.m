//
//  ChangePassword.m
//  TLthumb
//
//  Created by 田隆真 on 15/9/17.
//  Copyright (c) 2015年 田隆真. All rights reserved.
//

#import "ChangePassword.h"
#import "LoginVC.h"

@interface ChangePassword ()

@end

@implementation ChangePassword

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.nav setTitle:@"设置新密码" leftText:@"返回" rightTitle:nil showBackImg:YES];
    
    self.passTFnew.secureTextEntry = YES;
    self.passTFnew2.secureTextEntry = YES;
    
    _reBtn.layer.cornerRadius = 5;
    _reBtn.layer.masksToBounds = YES;
    
}
- (IBAction)changeBtn:(id)sender {
}

- (void)left
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reBtn:(id)sender
{
    if (self.passTFnew2.text.length < 6 || self.passTFnew2.text.length >12)
    {
        [MBProgressHUD showError:@"请输入6~12位密码" toView:Window];
        return;
    }

    if ([self.passTFnew2.text isEqualToString:self.passTFnew.text])
    {
        NSString * url = BaseURL@"forgetPassword";
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        
        dic[@"newPassword"] = self.passTFnew.text;
        dic[@"phone"] = _phone;
        
        __weak __typeof(self)weakSelf = self;
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        [MBProgressHUD showHUDAddedTo:Window animated:YES]; // 动画开始
        [manager GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            int status = [responseObject[@"status"] intValue];
            NSString * msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
            if (status == 200)
            {
                [weakSelf left];
                
            }
            [weakSelf alert_Msg:msg];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"错误信息\n%@", [error localizedDescription]);
            [MBProgressHUD showError:@"服务器异常" toView:Window];
            [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        }];
    }
    else
    {
        [self showMessageBox:@"您输入的密码不一致" andDuration:2];
    }
    
}

@end
