//
//  MessageVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/7.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "MessageVC.h"
#import "PushInfo.h"
#import "MessageCell.h"
#import "MessageDetailVC.h"
@interface MessageVC ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *messages;
@end

@implementation MessageVC
{
    NSInteger _page;
}
- (instancetype)init
{
    return nil;// 不许使用这个方法
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nav setTitle:@"消息" leftText:@"返回" rightTitle:nil showBackImg:YES];
    
    _messages = [NSMutableArray new];

    [self showCoverViewOn:_tableView title:nil image:nil handle:^{
        
        [self requestMessageWithPage:FirstPage];
    }];
    
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.estimatedRowHeight = 44;
    

    // 上下拉刷新
    [self setPullRefresh];
    
    [self requestMessageWithPage:FirstPage];
    
}


#pragma mark 上下拉刷新
- (void)setPullRefresh
{
    MJRefreshGifHeader *head = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        [self requestMessageWithPage:FirstPage];
    }];
    [head setImages:RefreshImages forState:MJRefreshStateRefreshing];
    _tableView.mj_header = head;
    
    MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        [self requestMessageWithPage:++_page];
    }];
    [foot setImages:RefreshImages forState:MJRefreshStateRefreshing];
    _tableView.mj_footer = foot;
}

#pragma mark - <UITableViewDataSource>

#pragma mark 段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messages.count;
}

#pragma mark ［配置单元格］
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    [cell setCellInfo:_messages[indexPath.row]];
    return cell;
}

#pragma mark 单元格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.redIcon.hidden == NO) {
        // 点击了未读消息，未读数减1 红点消失
        cell.redIcon.hidden = YES;
        DELE.unReadCount--;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 请求消息
- (void)requestMessageWithPage:(NSInteger)page
{
    [MBProgressHUD showHUDAddedTo:Window animated:YES]; // 动画开始
    
    // 如果刷新到第一页，则上拉也从第一页往上加
    if (page == FirstPage) {
        _page = FirstPage;
    }

    NSString *url = BaseURL@"pushInfo";
    NSDictionary *parameters = @{
                                 @"memberId":[UserManager manager].userID,
                                 @"pageNo":[NSString stringWithFormat:@"%ld",(long)page],
                                 @"pageSize":@"10"
                                 };
    
    [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
        
        NSDictionary *dic = responseObject;

        if ([dic[@"status"] isEqual:@(200)]) {
            
            
            if (page == FirstPage) {
                
                // 先清空原来的消息数组
                [_messages removeAllObjects];
            }
            
            for (NSDictionary *tempDic in dic[@"data"]) {
                
                PushInfo *pi = [[PushInfo alloc] mj_setKeyValues:tempDic];
                [_messages addObject:pi];
            }
            
            [DELE requestUnReadCount];
            
            NSLog(@"未读消息：%ld", (long)DELE.unReadCount);
            [_tableView reloadData];
            
            [self removeCoverView];
            [MBProgressHUD showSuccess:dic[@"msg"] toView:Window];
        }
        else
        {
            [MBProgressHUD showError:dic[@"msg"] toView:Window];

            [self.coverView setTitle:dic[@"msg"] image:[UIImage imageNamed:@"icon_message_nomal"] handle:nil];
            
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        [MBProgressHUD showError:[error localizedDescription] toView:Window];
        
    }];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([sender isKindOfClass:[MessageCell class]]) {
        
        MessageCell *cell = sender;
        MessageDetailVC *vc = [segue destinationViewController];
        vc.info = cell.info;

    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
