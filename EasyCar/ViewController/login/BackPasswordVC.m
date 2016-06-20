//
//  BackPasswordVC.m
//  TLthumb
//
//  Created by 田隆真 on 15/9/17.
//  Copyright (c) 2015年 田隆真. All rights reserved.
//

#import "BackPasswordVC.h"
#import "ChangePassword.h"
#import <SMS_SDK/SMSSDK.h>

@interface BackPasswordVC ()<MY_nav_delegate>
{
    BOOL iscodeBtn; //     判断验证码按钮是否可用
    BOOL isCode;    //     判断验证码是否发送
    int _timeNum;   //     定时器计时
    NSTimer *_timer;
}
@end

@implementation BackPasswordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addNav];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.phoneTF becomeFirstResponder];
}
- (void)addNav
{
    
    [self.nav setTitle:@"找回密码" leftText:@"返回" rightTitle:nil showBackImg:YES];

    
    self.phoneTF.keyboardType = UIKeyboardTypePhonePad;
    self.phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeTF.keyboardType = UIKeyboardTypePhonePad;
    self.codeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _codeBtn.layer.cornerRadius = 5;
    _codeBtn.layer.masksToBounds = YES;
    _codeBtn.backgroundColor = [UIColor whiteColor];
    //添加边框
    CALayer * layer = [_codeBtn layer];
    layer.borderColor = [[UIColor grayColor] CGColor];
    layer.borderWidth = 0.5f;
    //添加四个边阴影
    _codeBtn.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
    _codeBtn.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    _codeBtn.layer.shadowOpacity = 0.2;//不透明度
    _codeBtn.layer.shadowRadius = 0.5;//半径
    
    
    _backpassBtn.layer.cornerRadius = 5;
    _backpassBtn.layer.masksToBounds = YES;
    

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 点击提交
- (IBAction)backBtn:(id)sender
{
//    测试
//    isCode = YES;
//    NSLog(@"验证失败,测试阶段验证失败但请求继续");

    [MBProgressHUD showHUDAddedTo:Window animated:YES]; // 动画开始
    if (isCode)
    {
        
        [SMSSDK commitVerificationCode:_codeTF.text phoneNumber:_phoneTF.text zone:@"86" result:^(NSError *error) {
            
            
            [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
            if (!error) {
                NSLog(@"验证成功");
                [self backPassword];
            }
            else
            {
                NSLog(@"错误信息:%@",error);
                
                _timeNum = 1;
                [MBProgressHUD showError:@"验证码不正确" toView:Window];
                
            }
        }];
    }
    else
    {
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        [MBProgressHUD showError:@"请先获取验证码" toView:Window];
    }

    
    
}

#pragma mark 获取验证码
- (IBAction)getCodeBtn:(id)sender
{
    if (_phoneTF.text.length == 11)
    {
        [MBProgressHUD showHUDAddedTo:Window animated:YES]; // 动画开始
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneTF.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
            
            [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
            if (!error) {
                
                NSLog(@"获取验证码成功");
                [MBProgressHUD showSuccess:@"获取验证码成功" toView:Window];
                isCode = YES;
                [self openTimer];
                
            } else {
                
                [MBProgressHUD showError:@"获取验证码失败" toView:Window];
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }
    else
    {
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        [MBProgressHUD showError:@"您输入的手机号错误" toView:Window];
    }
}

#pragma mark -- 开启定时器
- (void)openTimer
{
    if (!iscodeBtn)
    {
        _timeNum = 60;
        [_codeBtn setTitle:[NSString stringWithFormat:@"%d秒",_timeNum] forState:UIControlStateNormal];
        if (!_timer)
        {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
        }
        iscodeBtn = YES;
    }
}
- (void)timer
{
    _timeNum --;
    [_codeBtn setTitle:[NSString stringWithFormat:@"%d秒",_timeNum] forState:UIControlStateNormal];
    if (_timeNum == 0)
    {
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        _timer = nil;
        iscodeBtn = NO;
    }
}

- (void)backPassword
{
    if (_phoneTF.text.length == 11)
    {
        ChangePassword * vc = [ChangePassword new];
        vc.phone = _phoneTF.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
