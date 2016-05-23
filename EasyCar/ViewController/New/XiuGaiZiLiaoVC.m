//
//  XiuGaiZiLiaoVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/24.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "XiuGaiZiLiaoVC.h"
#import "ChangePwdViewController.h"
@interface XiuGaiZiLiaoVC ()
@property (strong, nonatomic) IBOutlet UITextField *userNameTF;
@property (strong, nonatomic) IBOutlet UITextField *resumeTF;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sexSegm;

@end

@implementation XiuGaiZiLiaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.nav setTitle:@"修改资料" leftText:@"返回" rightTitle:@"修改密码" showBackImg:YES];
    
    UserManager *user = [UserManager manager];
    
    _userNameTF.text = user.nickname;
    _resumeTF.text = user.resume;
    _sexSegm.selectedSegmentIndex = user.sex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 提交
- (IBAction)onCommitBtn:(id)sender {
    
    [self tianjia];
}


- (void)tianjia
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // 动画开始
    UserManager *user = [UserManager manager];
    NSString *url = BaseURL@"alterInfo";
    NSDictionary *parameters = @{
                                 @"memberId":user.userID,
                                 @"nickname":_userNameTF.text,
                                 @"resume"  :_resumeTF.text,
                                 @"sex"     :[NSString stringWithFormat:@"%ld",(long)_sexSegm.selectedSegmentIndex]
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

- (void)right
{
    [self.navigationController pushViewController:[[ChangePwdViewController alloc] init] animated:YES];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
