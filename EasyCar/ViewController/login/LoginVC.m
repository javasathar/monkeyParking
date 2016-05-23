//
//  LoginVC.m
//  TLthumb
//
//  Created by 田隆真 on 15/9/16.
//  Copyright (c) 2015年 田隆真. All rights reserved.
//

#import "LoginVC.h"
#import "BackPasswordVC.h"
#import "reVC.h"



@interface LoginVC ()<UITextFieldDelegate>

@end

@implementation LoginVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_phoneTF becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    
    [self.nav setTitle:@"登录" leftText:nil rightTitle:@"取消" showBackImg:NO];
    
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTF.secureTextEntry = YES;
    self.phoneTF.text = [[[UserDefaultsFiles alloc]init] getUserName];
    self.passwordTF.text = [[[UserDefaultsFiles alloc]init] getUserPassword];
#pragma mark --  设置圆角
    _codeBtn.layer.cornerRadius = 5;
//    _codeBtn.layer.masksToBounds = YES;
//    _codeBtn.backgroundColor = [UIColor whiteColor];
    
    //添加边框
//    CALayer * layer = [_codeBtn layer];
//    layer.borderColor = [[UIColor grayColor] CGColor];
//    layer.borderWidth = 0.5f;
    //添加四个边阴影
//    _codeBtn.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
//    _codeBtn.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
//    _codeBtn.layer.shadowOpacity = 0.2;//不透明度
//    _codeBtn.layer.shadowRadius = 0.5;//半径
    
    
    _loginBtn.layer.cornerRadius = 5;
    _loginBtn.layer.masksToBounds = YES;
    
    _reBtn.layer.cornerRadius = 5;
    _reBtn.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.phoneTF.text = [[[UserDefaultsFiles alloc]init] getUserName];
    self.passwordTF.text = [[[UserDefaultsFiles alloc]init] getUserPassword];
}

- (void)right
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)left
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backPasswordBtn:(id)sender
{
    BackPasswordVC * vc = [BackPasswordVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginBtn:(id)sender
{
    
    if (self.phoneTF.text.length != 11)
    {
        [MBProgressHUD showError:@"请输入11位手机号" toView:Window];
        return;
    }
    
    if (self.passwordTF.text.length < 6)
    {
        [MBProgressHUD showError:@"请输入6位的密码" toView:Window];
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    
    NSString *url = BaseURL@"login";
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"phone"] = self.phoneTF.text;
    dic[@"password"] = self.passwordTF.text;

    NSLog(@"正在登录中...");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // 开始动画
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];// 动画隐藏
         int status = [responseObject[@"status"] intValue];
         
         NSString * msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
         
         if (status == 200)
         {
             NSDictionary * data = responseObject[@"data"];
             NSLog(@"登录成功返回数据\n%@", data);
             weakSelf.user = [UserManager manager];
             
             [weakSelf.user userManagerDic:data];
             weakSelf.user.isLogin = YES; // 记录登录状态
             [UserDefaultsFiles setUserDataName:_phoneTF.text password:weakSelf.passwordTF.text];
             

             // 登录成功，关闭登录页
             [self dismissViewControllerAnimated:YES completion:^{
                 
                 // 如果需要跳转
                 if (_pushVCName.length != 0) {
                     // 通知包含需跳转到的VC名
                     [[NSNotificationCenter defaultCenter] postNotificationName:PushVC object:nil userInfo:@{@"pushVCName":_pushVCName}];
                 }
             }];
             
             [MBProgressHUD showSuccess:msg toView:self.view];
             
         }
         else
         {
            NSLog(@"%@", msg);
            [MBProgressHUD showError:msg toView:self.view];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];// 动画隐藏
         [MBProgressHUD showError:@"网络加载出错" toView:self.view];
         NSLog(@"%@", [error localizedDescription]);
     }];
}

- (IBAction)reBtn:(id)sender
{
    reVC * vc = [reVC new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)lookBtn:(id)sender
{
    [self left];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_phoneTF]) {
        
        [_passwordTF becomeFirstResponder];
    }

    if ([textField isEqual:_passwordTF]) {
        
        [self.view endEditing:YES];
        [self loginBtn:nil];
    }
    return YES;
}

@end
