//
//  WoYaoQuCheVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/16.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "WoYaoQuCheVC.h"
#import "WoYaoQuCheCell.h"
#import "MyParkingSpaceVC.h"
#import "CarParkingInfo.h"





@interface WoYaoQuCheVC ()

@end

@implementation WoYaoQuCheVC
{
    NSMutableArray *_datas;
}

- (instancetype)init
{
    return nil;// 不许使用这个方法
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _datas = [[NSMutableArray alloc] init];

    
    [self showCoverViewOn:_tableView title:nil image:nil handle:^{
        [self requestParkInOutInfo];
    }];
    
    [self requestParkInOutInfo];
    
    self.title = @"我要取车";
    [self.nav setTitle:@"我要取车" leftText:@"返回" rightTitle:nil showBackImg:YES];
    
    _tableView.tableFooterView = [[UIView alloc] init];
    
}

- (void)requestParkInOutInfo
{
    [MBProgressHUD showHUDAddedTo:Window animated:YES]; // 动画开始
    NSString *url = BaseURL@"parkInOutInfo";
    NSDictionary *parameters = @{
                                 @"memberId":[UserManager manager].userID
                                 };
    NSString *testUrl = @"http://119.29.9.61:8080:8080/ytcSystem/rest/api/member/parkInOutInfo?memberId=8ae8b92c518f1ff801519f5e7a960014";
    [[AFHTTPRequestOperationManager manager] GET:testUrl  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        NSDictionary *dic = responseObject;
        NSArray *arr = dic[@"data"];
        NSLog(@"%@",dic);
        if ([dic[@"status"] isEqual:@(200)] && arr.count > 0) {

            [_datas removeAllObjects];
            for (NSDictionary *tempDic in arr) {
                CarParkingInfo *info = [[CarParkingInfo alloc] mj_setKeyValues:tempDic];
                [_datas addObject:info];
            }

            [self removeCoverView];
            [_tableView reloadData];
        }
        else
        {
            [MBProgressHUD showError:dic[@"msg"] toView:Window];
            if ([dic[@"msg"] isEqualToString:@"成功"]) {
                
                self.coverView.titleLB.text = @"暂无车辆信息";
            }
            else
            {
                self.coverView.titleLB.text = dic[@"msg"];
            }
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        NSLog(@"报错：%@", [error localizedDescription]);
        [MBProgressHUD showError:@"网络加载出错" toView:Window];
    }];
}



#pragma mark - <UITableViewDataSource>

#pragma mark 段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_datas.count > 0) {
        return 1;
    }
    return 0;
}

#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

#pragma mark ［配置单元格］
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WoYaoQuCheCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"WoYaoQuCheCell" forIndexPath:indexPath];
    
    [cell setCellInfo:_datas[indexPath.row]];
    return cell;
}


#pragma mark 单元格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
}


#pragma mark 点击投放广告
- (IBAction)onTouFang:(id)sender {
    
    
    
}

#pragma mark 点击停车状态
- (IBAction)onParkingState:(UIButton *)sender {
    
    WoYaoQuCheCell *cell = (WoYaoQuCheCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSDictionary *dic = _datas[indexPath.row];
    
    MyParkingSpaceVC *vc = [[MyParkingSpaceVC alloc] initWithNibName:@"MyParkingSpaceVC" bundle:nil];
    vc.myCarSpaceId = dic[@"spaceId"];
    [vc necessaryPropertyParkFunction:0 parkArea:dic[@"parkArea"] parkId:dic[@"parkId"]];
    
    [self.navigationController pushViewController:vc animated:YES];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
