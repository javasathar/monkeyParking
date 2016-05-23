//
//  ZhangHuYuEVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/22.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ZhangHuYuEVC.h"
#import "YuEZhuanChu.h"
#import "JieGuoXiangQingVC.h"
@interface ZhangHuYuEVC ()
@property (strong, nonatomic) IBOutlet UILabel *moneyLB;

@end

@implementation ZhangHuYuEVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 每次进来更细余额(从本地更新)
    _moneyLB.text = [NSString stringWithFormat:@"%.2f",self.user.balance];
    // 从服务器更新，以防万一
    [self requestBalance];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.nav setTitle:@"账户余额" leftText:@"返回" rightTitle:@"消费记录" showBackImg:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)right{
    
    [self.navigationController pushViewController:[Unit EPStoryboard:@"XiaoFeiJiLuVC"] animated:YES];
}

#pragma mark 请求余额
- (void)requestBalance
{
    NSString *url = BaseURL@"getBalance";
    NSDictionary *parameters = @{@"memberId":self.user.userID};
    [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        NSLog(@"%@", dic[@"msg"]);
        
        if ([dic[@"status"] isEqual:@(200)]) {
            
            self.user.balance = [dic[@"data"] doubleValue];
            _moneyLB.text = [NSString stringWithFormat:@"%.2f",self.user.balance];
        }
        else
        {
            NSLog(@"%@", dic[@"msg"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"报错：%@", [error localizedDescription]);
    }];
}

/*
 37.审核状态
 测试地址：h1ttp://localhost:8080/ytcSystem/rest/api/member/getTransferType
 http1://localhost:8080/ytcSystem/rest/api/member/getTransferType?memberId=1
 测试参数：memberId=会员id
 返回参数：status:200,msg:审核中,data:数据
 status:300,msg:无审核申请,data:剩余次数
 status:500,msg:请求异常，data:null
 */
#pragma mark 请求审核状态
- (void)requestShenHeState
{
    [self getRequestURL:BaseURL@"getTransferType"
             parameters:@{
                          @"memberId":self.user.userID
                          }
     
                success:^(NSDictionary *dic) {
                    /*
                     {
                     "data": {
                     "type": 0,
                     "toBanlance": 1453028112433,
                     "transferTime": 1452854555000
                     },
                     "msg": "审核中",
                     "status": 200
                     }
                     */
                    // 审核中
                    JieGuoXiangQingVC *vc = [Unit EPStoryboard:@"JieGuoXiangQingVC"];
                    vc.time1 = [dic[@"data"][@"transferTime"] doubleValue]/1000;
                    vc.time2 = [dic[@"data"][@"toBanlance"] doubleValue]/1000;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                } elseAction:^(NSDictionary *dic) {
                    
                    [MBProgressHUD hideAllHUDsForView:Window animated:NO];
                    /*{
                     "data": 3,
                     "msg": "无审核申请",
                     "status": 300
                     }
                     */
                    // 无审核
                    YuEZhuanChu *vc = [Unit EPStoryboard:@"YuEZhuanChu"];
                    vc.remainTime = [dic[@"data"] integerValue];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    
                } failure:^(NSError *error) {
                    
                    
                }];
}


- (IBAction)onZhuanChu:(id)sender {
    
    [self requestShenHeState];
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
