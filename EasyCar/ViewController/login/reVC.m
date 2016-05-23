//
//  reVC.m
//  TLthumb
//
//  Created by 田隆真 on 15/9/17.
//  Copyright (c) 2015年 田隆真. All rights reserved.
//

#import "reVC.h"
#import <SMS_SDK/SMSSDK.h>
#import "UserAgreementVC.h"


@interface reVC ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *theHeight;
@property (strong, nonatomic) IBOutlet UIImageView *logoView;
@property (strong, nonatomic) IBOutlet UIButton *lastView;


@end

@implementation reVC
{
    BOOL iscodeBtn; //     判断验证码按钮是否可用
    BOOL isCode;    //     判断验证码是否发送
    int _timeNum;   //     定时器计时
    NSTimer *_timer;
    NSString * iphone;     //     账号
    NSString * password;   //     密码
    
    BOOL isGbtn;      //    协议状态
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [_phoneTF becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moveWithKeyBoard:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self.nav setTitle:@"注册" leftText:@"返回" rightTitle:nil showBackImg:YES];

    _reBtn.layer.cornerRadius = 5;
    _reBtn.layer.masksToBounds = YES;
    _reBtn.backgroundColor = [UIColor grayColor];
    
    
    _codeBtn.layer.cornerRadius = 5;
    _codeBtn.layer.masksToBounds = YES;

    
    //添加边框
    CALayer * layer = [_codeBtn layer];
    layer.borderColor = [[UIColor grayColor] CGColor];
    layer.borderWidth = 0.5f;
    //添加四个边阴影
    _codeBtn.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
    _codeBtn.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    _codeBtn.layer.shadowOpacity = 0.2;//不透明度
    _codeBtn.layer.shadowRadius = 0.5;//半径
    
    self.phoneTF.keyboardType = UIKeyboardTypePhonePad;
    self.phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeTF.keyboardType = UIKeyboardTypePhonePad;
    self.codeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTF.secureTextEntry = YES;
    
    
    [self Gbtn:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)left
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 验证手机号码是否可用
- (void)checkPhone
{
    NSString * url = BaseURL@"checkphone";
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"phone"] = _phoneTF.text;
    
    __weak __typeof(self)weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // 动画开始
    NSLog(@"正在验证手机号...");
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        int status = [responseObject[@"status"] intValue];

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];// 动画隐藏
        if (status == 200)
        {
            NSLog(@"checkPhone验证通过");
            [weakSelf getCode];
        }
        else
        {
            [MBProgressHUD showError:@"该手机号已注册" toView:Window];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];// 动画隐藏
        [MBProgressHUD showError:@"网络加载出错" toView:self.view];
        NSLog(@"报错：%@", [error localizedDescription]);
    }];
}

#pragma mark 获取验证码
- (void)getCode
{
    [MBProgressHUD showHUDAddedTo:Window animated:YES]; // 动画开始
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneTF.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        if (!error) {
            
            NSLog(@"获取验证码成功");
            [MBProgressHUD showSuccess:@"获取验证码成功" toView:self.view];
            isCode = YES;
            [self openTimer];
            
        } else {
            
            [MBProgressHUD showError:@"获取验证码失败" toView:self.view];
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
    
}


#pragma mark 点击验证码
- (IBAction)codeBtn:(id)sender
{
    if (_phoneTF.text.length == 11)
    {
        [self checkPhone];// 通过手机号查重才会发送注册
    }
    else
    {
        [MBProgressHUD showError:@"您输入的手机号错误" toView:self.view];
    }
}


#pragma mark 点击注册
- (IBAction)reBtn:(id)sender
{
    
    if (_phoneTF.text.length != 11) {
        
        [MBProgressHUD showError:@"请输入11位手机号" toView:Window];
        return;
    }
    if (_codeTF.text.length != 4 ) {
        
        [MBProgressHUD showError:@"请输入4位验证码" toView:Window];
        return;
    }
    if (_passwordTF.text.length < 6) {
        
        [MBProgressHUD showError:@"密码必须大于6位" toView:Window];
        return;
    }
    if (![_passwordTF.text isEqualToString:_passwordAgainTF.text]) {
        
        [MBProgressHUD showError:@"您输入的密码不一致" toView:Window];
        return;
    }
    if (!isGbtn)
    {
        [MBProgressHUD showError:@"您需要同意用户协议!" toView:Window];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:Window animated:YES];// 动画开始
    password = _passwordTF.text;
    
    [SMSSDK commitVerificationCode:_codeTF.text phoneNumber:_phoneTF.text zone:@"86" result:^(NSError *error) {
        
        
        if (!error) {
            NSLog(@"验证成功");
            [self registeredUser];
        }
        else
        {
            NSLog(@"错误信息:%@",error);
            [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
            [MBProgressHUD showError:@"验证码不正确" toView:self.view];
            _timeNum = 1;
        }
        
        
    }];
}


#pragma mark -- 开启定时器
- (void)openTimer
{
    iphone = _phoneTF.text;
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

#pragma mark -- 注册用户
- (void)registeredUser
{

    NSString * url = BaseURL@"regist";
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"phone"] = _phoneTF.text;
    dic[@"password"] = _passwordTF.text;;
    
    __weak __typeof(self)weakSelf = self;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        int status = [responseObject[@"status"] intValue];
        NSString * msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
        if (status == 200)
        {
            [UserDefaultsFiles setUserDataName:iphone password:password];
            [MBProgressHUD showSuccess:@"注册成功" toView:Window];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MBProgressHUD showError:msg toView:Window];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        [MBProgressHUD showError:@"服务器异常" toView:Window];
    }];
}

#pragma mark 用户协议
- (IBAction)userMsg:(id)sender
{
    UserAgreementVC * vc = [UserAgreementVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)Gbtn:(id)sender
{
    if (!isGbtn)
    {
        self.Gbtn.image = [UIImage imageNamed:@"circle_selected"];
        self.reBtn.backgroundColor = MainColor(255, 137, 1, 1);
    }
    else
    {
        self.Gbtn.image = [UIImage imageNamed:@"circle_unselect"];
        self.reBtn.backgroundColor = [UIColor grayColor];
    }
    
    isGbtn = !isGbtn;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_phoneTF]) {
        
        [_codeTF becomeFirstResponder];
    }
    if ([textField isEqual:_codeTF]) {
        
        [_passwordTF becomeFirstResponder];
    }
    if ([textField isEqual:_passwordTF]) {
        
        [_passwordAgainTF becomeFirstResponder];
    }
    if ([textField isEqual:_passwordAgainTF]) {
        
        [self.view endEditing:YES];
        [self reBtn:nil];
    }
    return YES;
}



- (void)moveWithKeyBoard:(NSNotification *)note
{
    
    CGFloat KB_Y = [note.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    // 键盘出现
    if (KB_Y == Heigth) {
        
        NSLog(@"%f", Heigth);
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _theHeight.constant = 20;
            _logoView.alpha = 1;
            [self.view layoutIfNeeded];
        }];
    }
    // 键盘隐藏 && 未升起状态
    else if (_theHeight.constant == 20)
    {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGFloat changeY = KB_Y - _lastView.bottom - 23;
            
            
            _theHeight.constant = -changeY;
            
            // logo如果会超出屏幕就隐藏
            if (_logoView.top + changeY < 0) {
                _logoView.alpha = 0;
            }
            
            [self.view layoutIfNeeded];
        }];
    }
}

// 移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
