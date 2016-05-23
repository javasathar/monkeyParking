//
//  SelectParkingSpaceVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/16.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "SelectParkingSpaceVC.h"
#import "SelectParkingSpaceCell.h"
#import "MyParkingSpaceVC.h"
#import "RentInfo.h"
#import "ZhuanZuXiangQingVC.h"
@interface SelectParkingSpaceVC ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SelectParkingSpaceVC
{
    NSMutableArray *_datas;
}

- (instancetype)init
{
    return nil;// 不许使用这个方法
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showCoverViewOn:_tableView title:nil image:nil handle:^{
        
        [self requestParkInOutInfo];
    }];
    
    [self.nav setTitle:@"我的车位" leftText:@"返回" rightTitle:nil showBackImg:YES];

    _datas = [NSMutableArray new];

    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [self requestParkInOutInfo];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestParkInOutInfo
{
    [MBProgressHUD showHUDAddedTo:_tableView animated:YES]; // 动画开始
    NSString *url = BaseURL@"carSpace";
    NSDictionary *parameters = @{
                                 @"memberId":[UserManager manager].userID
                                 };
    
    [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:_tableView animated:YES];// 动画隐藏
        NSDictionary *dic = responseObject;
        
        if ([dic[@"status"] isEqual:@(200)]) {
            [MBProgressHUD showSuccess:dic[@"msg"] toView:self.view];
            
            NSArray *arr = dic[@"data"];
            
            for (NSDictionary *tempDic in arr) {
                
                RentInfo *i = [[RentInfo alloc] mj_setKeyValues:tempDic];
                [_datas addObject:i];
            }

            [self removeCoverView];
            [_tableView reloadData];
        }
        else
        {
            
            [MBProgressHUD showError:dic[@"msg"] toView:self.view];
            self.coverView.titleLB.text = dic[@"msg"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:_tableView animated:YES];// 动画隐藏
        NSLog(@"报错：%@", [error localizedDescription]);
        [MBProgressHUD showError:@"网络加载出错" toView:self.view];
    }];
}

#pragma mark - <UITableViewDataSource>

#pragma mark 段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_datas count] > 0) {
        return 1;
    }
    return 0;
}

#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%@", _datas);
    return [_datas count];
}

#pragma mark ［配置单元格］
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectParkingSpaceCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"SelectParkingSpaceCell" forIndexPath:indexPath];
    [cell setCellInfo:_datas[indexPath.row]];
    
    return cell;
}

#pragma mark 单元格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark 转租
- (IBAction)onZhuanZu:(UIButton *)sender {
    
    SelectParkingSpaceCell *cell = (SelectParkingSpaceCell *)sender.superview.superview;
    NSUInteger row = [_tableView indexPathForCell:cell].row ;
    
    NSString *alertMsg = sender.selected ? @"一个车位24小时只能转租一次，您确定要取消转租吗？" : @"一个车位24小时只能转租一次，您确定要转租吗？";
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"温馨提示" message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        RentInfo *info = _datas[row];
        
        NSString *url = BaseURL@"rentTran";
        NSDictionary *parameters = @{
                                     @"id"  :info.spaceId,
                                     @"con" :[NSString stringWithFormat:@"%d",!info.condition]
                                     };
        [MBProgressHUD showHUDAddedTo:Window animated:YES]; // 动画开始
        [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dic = responseObject;
            NSLog(@"%@", dic[@"msg"]);
            [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
            if ([dic[@"status"] isEqual:@(200)]) {
                [MBProgressHUD showSuccess:dic[@"msg"] toView:self.view];
                info.condition = [dic[@"data"] boolValue];
            }
            else
            {
                if ([dic[@"status"] isEqual:@(301)]) {
                    
                    [self showNormalAlertWithTitle:@"提示" message:dic[@"msg"]];
                    return ;
                }
                [MBProgressHUD showError:dic[@"msg"] toView:self.view];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
            NSLog(@"报错：%@", [error localizedDescription]);
            [MBProgressHUD showError:@"网络加载失败" toView:self.view];
        }];
        
    }]];
    
    [self presentViewController:ac animated:YES completion:nil];

    
    
}

#pragma mark 点击收益
- (IBAction)onShouYi:(UIButton *)sender {

    SelectParkingSpaceCell *cell = (SelectParkingSpaceCell *)sender.superview.superview;
    NSUInteger row = [_tableView indexPathForCell:cell].row ;
    RentInfo *info = _datas[row];
    
    ZhuanZuXiangQingVC *vc = [Unit EPStoryboard:@"ZhuanZuXiangQingVC"];
    vc.info = info;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
