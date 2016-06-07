//
//  SetUPViewController.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/5.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "SetUPViewController.h"
#import "HelpCenterViewController.h"
#import "YiJianFanKuiVC.h"
#import "GuanYuWoMenVC.h"
@interface SetUPViewController ()
@property (weak, nonatomic) IBOutlet UILabel *checkUpLB;

@end

@implementation SetUPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.nav setTitle:@"设置" leftText:nil rightTitle:nil showBackImg:YES];
}
#pragma mark 帮助中心
- (IBAction)helpCenter:(id)sender {
}
#pragma mark 活动
- (IBAction)active:(id)sender {
}
#pragma mark 意见反馈
- (IBAction)idea:(id)sender {
    [self.navigationController pushViewController:[Unit EPStoryboard:@"YiJianFanKuiVC"] animated:YES];
}
#pragma mark 关于我们
- (IBAction)aboutUS:(id)sender {
    [self.navigationController pushViewController:[Unit EPStoryboard:@"GuanYuWoMenVC"] animated:YES];

}
#pragma mark 检查更新
- (IBAction)checkUpdate:(id)sender {
    if ([self.checkUpLB.text isEqualToString: @"有新版本可更新"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/ting-che-da-sheng/id1080875914?mt=8"]];
    }else
    {
        self.checkUpLB.text = @"正在检查...";
        //    [self.navigationController pushViewController:[Unit EPStoryboard:@"SelectParkingSpaceVC"] animated:YES];
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        
        NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        NSLog(@"当前版本：   %@",appVersion);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager POST:APP_URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            if (dic[@"results"]) {
                if (dic[@"results"][0]) {
                    if (dic[@"results"][0][@"version"]) {
                        if ([appVersion isEqualToString:dic[@"results"][0][@"version"] ]) {
                            self.checkUpLB.text = @"已是最新版本";
                        }else
                        {
                            self.checkUpLB.text = @"有新版本可更新";
                            
                        }
                    }
                }
            }
            NSLog(@"appstore版本：  %@",dic[@"results"][0][@"version"]);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            self.checkUpLB.text = @"网络有问题";
            
        }];
    }
}
#pragma mark 退出当前账户
- (IBAction)closeUser:(id)sender {
    [self showFunctionAlertWithTitle:@"温馨提示" message:@"您确定退出当前账户吗" functionName:@"确认" Handler:^{
        [self alertViewClick];
    }];
    
}
#pragma mark 确认退出登录
- (void)alertViewClick
{
    
    [UserManager manager].isLogin = NO;
    [UserManager manager].userID = nil;
    // 清除消息
    DELE.unReadCount = 0;
    
    [UserDefaultsFiles setUserDataName:nil password:nil];
    
    self.tabBarController.selectedIndex = 0;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
