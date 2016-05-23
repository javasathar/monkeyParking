//
//  GuanYuWoMenVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/28.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "GuanYuWoMenVC.h"
#import "CompInfoViewController.h"
#import "ComHistViewController.h"
#import "ComNewsViewController.h"
#import "ComCultureViewController.h"
#import "ComProductViewController.h"
#import "UserAgreementVC.h"
#import "ComNews.h"
@interface GuanYuWoMenVC ()

@end

@implementation GuanYuWoMenVC
{
    NSMutableArray *_datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _datas = [NSMutableArray new];
    [self.nav setTitle:@"关于我们" leftText:@"返回" rightTitle:nil showBackImg:YES];
    [self requestNews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 请求新闻动态
- (void)requestNews
{
    NSString *url = BaseURL@"meInfoList";
    
    NSLog(@"%@",url);
    [self getRequestURL:url parameters:nil
     
                success:^(NSDictionary *dic) {
                    
                    for (NSDictionary *tempDic in dic[@"data"]) {
                        
                        ComNews *n = [[ComNews alloc] mj_setKeyValues:tempDic];
                        [_datas addObject:n];
                    }
                    
                } elseAction:^(NSDictionary *dic) {
                    
                } failure:^(NSError *error) {
                    
                }];
}

//#pragma mark 公司信息
//- (IBAction)onGongSiXinXi:(id)sender {
//    
//    CompInfoViewController *aboutVC = [[CompInfoViewController alloc] init];
//    [self.navigationController pushViewController:aboutVC animated:YES];
//}


#pragma mark 4合1
- (IBAction)onFourInOne:(UITapGestureRecognizer *)sender {
    UIViewController *vc = nil;
    switch (sender.view.tag - 100) {
        case 0:
            vc = [CompInfoViewController new];
            break;
        case 1:
            vc = [[ComNewsViewController alloc] init];
            [vc setValue:_datas forKey:@"datas"];
            break;
        case 2:
            vc = [ComCultureViewController new];
            break;
        case 3:
            vc = [ComProductViewController new];
            break;
        default:
            break;
    }
//    for (ComNews *cn in _datas) {
//        
//        if (cn.type == vc.vc_type) {
//
//            [vc.datas addObject:cn];
//        }
//    }
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
}

//#pragma mark 公司动态（新闻）
//- (IBAction)onGongSiDongTai:(id)sender {
//    
//    
//
//}
//
//#pragma mark 公司文化
//- (IBAction)onGongSiWenHua:(id)sender {
//    
//    ComCultureViewController *aboutVC = [[ComCultureViewController alloc] init];
//
//    [self.navigationController pushViewController:aboutVC animated:YES];
//
//}
//
//#pragma mark 公司产品
//- (IBAction)onChanPin:(id)sender {
//    
//
//    ComProductViewController *aboutVC = [[ComProductViewController alloc] init];
//
//    [self.navigationController pushViewController:aboutVC animated:YES];
//}

//#pragma mark 反馈
//- (IBAction)onFanKui:(id)sender {
//}

#pragma mark 服务须知
- (IBAction)onFuWuXuZhi:(id)sender {
    
    UserAgreementVC *vc = [[UserAgreementVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
