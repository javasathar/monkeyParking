//
//  ChangeInfoViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/21.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ChangeInfoViewController.h"

@interface ChangeInfoViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nicknameTF;
@property (strong, nonatomic) IBOutlet UITextField *idCardTF;
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITextField *addressTF;
@property (strong, nonatomic) IBOutlet UITextField *resumeTF;

@end

@implementation ChangeInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUserInfo];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"修改资料";
    [self.nav setTitle:@"修改资料" leftText:@"返回" rightTitle:@"提交" showBackImg:YES];
    self.view.backgroundColor = RGBA(50, 129, 255, 1);//RGBA(242, 242, 248, 1);
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:(UIBarButtonItemStylePlain) target:self action:@selector(tianjia)];

}

- (void)setUserInfo
{
    UserManager *user = [UserManager manager];
    _nicknameTF.text = user.nickname;
    _idCardTF.text = user.id_card;
    _phoneTF.text = user.phone;
    _emailTF.text = user.email;
    _addressTF.text = user.address;
    _resumeTF.text = user.resume;
    
}

- (void)right
{
    [self tianjia];
}

- (void)tianjia
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // 动画开始
    UserManager *user = [UserManager manager];
    NSString *url = BaseURL@"alterInfo";
    NSDictionary *parameters = @{
                                 @"memberId":user.userID,
                                 @"nickname":_nicknameTF.text,
                                 @"idCard":_idCardTF.text,
                                 @"phone":_phoneTF.text,
                                 @"email":_emailTF.text,
                                 @"address":_addressTF.text,
                                 @"resume":_resumeTF.text
                                 };

    [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES]; // 动画隐藏
      
        NSDictionary *dic = responseObject;
        
        
        if ([dic[@"status"] isEqual: @(200)]) {
            NSLog(@"修改成功\n%@", dic);
            // 同时修改用户模型的内容
            [[UserManager manager] userManagerDic:dic[@"data"]];
            [MBProgressHUD showSuccess:@"修改资料成功" toView:self.view];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(back) userInfo:nil repeats:NO];
        }
        else
        {
            [MBProgressHUD showError:dic[@"msg"] toView:self.view];
            NSLog(@"修改失败了");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];// 动画隐藏

        [MBProgressHUD showError:[error localizedDescription] toView:self.view];
        NSLog(@"错误提示：%@", [error localizedDescription]);
    }];
    
    
    
    
    
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    self._mainScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
