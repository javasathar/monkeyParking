//
//  ChangePwdViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/21.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ChangePwdViewController.h"

@interface ChangePwdViewController ()

@end

@implementation ChangePwdViewController
{
    UITextField *_originPassword;  // 原密码
    UITextField *_password1; // 密码
    UITextField *_password2; // 确认密码
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    [self.nav setTitle:@"修改密码" leftText:@"返回" rightTitle:nil showBackImg:YES];
    self.view.backgroundColor = RGBA(242, 242, 248, 1);
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    addLabel.text = @"原始密码";
    addLabel.textAlignment = NSTextAlignmentCenter;
    addLabel.font = [UIFont boldSystemFontOfSize:16];
    
    
    _originPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, 45)];
    _originPassword.secureTextEntry = YES;
    _originPassword.backgroundColor = [UIColor whiteColor];
    _originPassword.delegate = self;
    _originPassword.returnKeyType = UIReturnKeyDone;
    _originPassword.leftView = addLabel;
    _originPassword.font = [UIFont systemFontOfSize:15];
    _originPassword.textColor = RGBA(51, 51, 51, 1);
    _originPassword.placeholder = @"输入原始密码";
    _originPassword.leftViewMode = UITextFieldViewModeAlways;

    [self.view addSubview:_originPassword];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(20, _originPassword.bottom, UI_SCREEN_WIDTH-20, 0.5)];
    line1.backgroundColor = RGBA(200, 200, 200, 1);
    [self.view addSubview:line1];
    
    UILabel *addLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    addLabel1.text = @"新密码";
    addLabel1.textAlignment = NSTextAlignmentCenter;
    addLabel1.font = [UIFont boldSystemFontOfSize:16];
    _password1 = [[UITextField alloc] initWithFrame:CGRectMake(0, line1.bottom, UI_SCREEN_WIDTH, 45)];
    _password1.secureTextEntry = YES;
    _password1.backgroundColor = [UIColor whiteColor];
    _password1.delegate = self;
    _password1.returnKeyType = UIReturnKeyDone;
    _password1.leftView = addLabel1;
    _password1.font = [UIFont systemFontOfSize:15];
    _password1.textColor = RGBA(51, 51, 51, 1);
    _password1.placeholder = @"输入新密码";
    _password1.leftViewMode = UITextFieldViewModeAlways;

    [self.view addSubview:_password1];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(20, _password1.bottom, UI_SCREEN_WIDTH-20, 0.5)];
    line2.backgroundColor = RGBA(200, 200, 200, 1);
    [self.view addSubview:line2];
    UILabel *addLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    addLabel3.text = @"确认密码";
    addLabel3.textAlignment = NSTextAlignmentCenter;
    addLabel3.font = [UIFont boldSystemFontOfSize:16];
    _password2 = [[UITextField alloc] initWithFrame:CGRectMake(0, line2.bottom, UI_SCREEN_WIDTH, 45)];
    _password2.secureTextEntry = YES;
    _password2.backgroundColor = [UIColor whiteColor];
    _password2.delegate = self;
    _password2.returnKeyType = UIReturnKeyDone;
    _password2.leftView = addLabel3;
    _password2.font = [UIFont systemFontOfSize:15];
    _password2.textColor = RGBA(51, 51, 51, 1);
    _password2.placeholder = @"请再次输入新密码";
    _password2.leftViewMode = UITextFieldViewModeAlways;

    [self.view addSubview:_password2];
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(20, _password2.bottom, UI_SCREEN_WIDTH-20, 0.5)];
    line3.backgroundColor = RGBA(200, 200, 200, 1);
    [self.view addSubview:line3];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(15, _password2.bottom + 20, UI_SCREEN_WIDTH-30, 40);
    [btn setTitle:@"提交" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.backgroundColor = RGBA(59, 129, 255, 1);
    btn.layer.cornerRadius = 5;
    [btn addTarget:self action:@selector(submitAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
}

- (void)submitAction
{
    if (_originPassword.text.length < 6) {
        
        [MBProgressHUD showError:@"请输入6位以上原始密码" toView:Window];
        return;
    }
    if (_password1.text.length < 6 || _password2.text.length < 6) {
        
        [MBProgressHUD showError:@"密码必须大于6位" toView:Window];
        return;
    }
    if (!([_password1.text isEqualToString:_password2.text])) {
        
        [MBProgressHUD showError:@"两次密码输入不一致" toView:Window];
        return;
    }
    if (([_password1.text isEqualToString:_originPassword.text])) {
        
        [MBProgressHUD showError:@"新密码不能与原密码相同" toView:Window];
        return;
    }
    [self sendRequest];
}

- (void)sendRequest
{
    UserManager *user = [UserManager manager];
    
    NSString *url = BaseURL@"doUpdatePassword";
    NSDictionary *parameters = @{
                                 @"memberId":user.userID,
                                 @"oldPassword":_originPassword.text,
                                 @"newPassword":_password1.text,
                                 @"rnewPassword":_password2.text
                                 };
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] isEqual:@(200)]) {
            
            [MBProgressHUD showSuccess:dic[@"msg"] toView:self.view];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(back) userInfo:nil repeats:NO];
            NSLog(@"%@", dic[@"msg"]);
        }
        else
        {
            [MBProgressHUD showError:dic[@"msg"] toView:self.view];
            NSLog(@"%@", dic[@"msg"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"请求失败" toView:self.view];
        NSLog(@"报错：%@", [error localizedDescription]);
    }];

}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
