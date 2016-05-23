//
//  XiCheVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/18.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "XiCheVC.h"
#import "XiCheCell.h"
@interface XiCheVC ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation XiCheVC
{
    NSArray *_datas;
}

- (instancetype)init
{
    return nil;// 不许使用这个方法
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要洗车";
    [self.nav setTitle:@"我要洗车" leftText:@"返回" rightTitle:nil showBackImg:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self showCoverViewOn:_tableView title:nil image:nil handle:^{
        
        [self requestParkInOutInfo];
    }];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self requestParkInOutInfo];
}


- (void)requestParkInOutInfo
{
    [MBProgressHUD showHUDAddedTo:_tableView animated:YES]; // 动画开始
    NSString *url = BaseURL@"parkInOutInfo";
    NSDictionary *parameters = @{
                                 @"memberId":[UserManager manager].userID
                                 };
    
    [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:_tableView animated:YES];// 动画隐藏
        NSDictionary *dic = responseObject;
        NSLog(@"%@", dic[@"msg"]);
        
        if ([dic[@"status"] isEqual:@(200)]) {
            [MBProgressHUD showSuccess:dic[@"msg"] toView:self.view];
            _datas = dic[@"data"];
            [self removeCoverView];
            [_tableView reloadData];
        }
        else
        {
            [MBProgressHUD showError:dic[@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];// 动画隐藏
        NSLog(@"报错：%@", [error localizedDescription]);
        [MBProgressHUD showError:@"网络加载出错" toView:self.view];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [_datas count];
}

#pragma mark ［配置单元格］
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XiCheCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"XiCheCell" forIndexPath:indexPath];
    [cell setCellInfoWithDic:_datas[indexPath.row]];
    
    return cell;
}

@end
