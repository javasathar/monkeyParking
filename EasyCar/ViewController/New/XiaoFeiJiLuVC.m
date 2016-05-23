//
//  XiaoFeiJiLuVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/17.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "XiaoFeiJiLuVC.h"
#import "ConsumeRecord.h"
#import "ChargeRecord.h"
#import "ConsumeCell.h"
#import "ChargeCell.h"
#import "ConsumeDetailVC.h"
typedef NS_ENUM (NSUInteger, ListType)
{
    /**充值记录*/
    chargeType,
    /**消费记录*/
    consumeType
};

@interface XiaoFeiJiLuVC ()<UIScrollViewDelegate>

@property (nonatomic,assign) ListType listType;

@property (strong, nonatomic) IBOutlet UILabel *yuELB;
@property (strong, nonatomic) IBOutlet UILabel *chongZhiLB;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *leftTableView;
@property (strong, nonatomic) IBOutlet UITableView *rightTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leading;

@property (nonatomic, strong) NSMutableArray *chargeList;
@property (nonatomic, strong) NSMutableArray *consumeList;
@end

@implementation XiaoFeiJiLuVC
{
    NSInteger _leftPage;
    NSInteger _rightPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _leftTableView.estimatedRowHeight = 44;
    _rightTableView.estimatedRowHeight = 44;
    
    _chargeList = [NSMutableArray new];
    _consumeList = [NSMutableArray new];
    
    [self.nav setTitle:@"消费记录" leftText:@"返回" rightTitle:nil showBackImg:YES];
    
    
    
    [self.view layoutIfNeeded];
    _leftTableView.frame = _scrollView.bounds;
    _rightTableView.frame = CGRectMake(Width, 0, _leftTableView.width, _leftTableView.height);
    [_scrollView addSubview:_leftTableView];
    [_scrollView addSubview:_rightTableView];
    _scrollView.contentSize = CGSizeMake(Width * 2, _leftTableView.height);
    
    [self setPullRefresh];
    // coverView
    [self addCoverView];
    [self requestListType:chargeType page:FirstPage];
    [self requestListType:consumeType page:FirstPage];

}

- (void)addCoverView
{
    CoverView *leftCover = [[NSBundle mainBundle] loadNibNamed:@"CoverView" owner:nil options:nil][0];
    leftCover.frame = _leftTableView.bounds;
    leftCover.tag = 100;
    [leftCover setTitle:@"努力加载中" image:[UIImage imageNamed:@"zhanweitu-1"] handle:^{
        
        [self requestListType:consumeType page:FirstPage];
    }];
    
    [_leftTableView addSubview:leftCover];
    
    CoverView *rightCover = [[NSBundle mainBundle] loadNibNamed:@"CoverView" owner:nil options:nil][0];
    rightCover.frame = _rightTableView.bounds;
    rightCover.tag = 100;
    [rightCover setTitle:@"努力加载中" image:[UIImage imageNamed:@"zhanweitu-1"] handle:^{
        
        [self requestListType:chargeType page:FirstPage];
    }];
    
    [_rightTableView addSubview:rightCover];
}

#pragma mark 上下拉刷新
- (void)setPullRefresh
{
    MJRefreshGifHeader *leftHead = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        [self requestListType:consumeType page:FirstPage];
        
        
    }];
    [leftHead setImages:RefreshImages forState:MJRefreshStateRefreshing];
    _leftTableView.mj_header = leftHead;
    
    
    MJRefreshBackGifFooter *leftFoot = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        [self requestListType:consumeType page:++_leftPage];
    }];
    [leftFoot setImages:RefreshImages forState:MJRefreshStateRefreshing];
    _leftTableView.mj_footer = leftFoot;
    
    
    MJRefreshGifHeader *head = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        [self requestListType:chargeType page:FirstPage];
    }];
    [head setImages:RefreshImages forState:MJRefreshStateRefreshing];
    _rightTableView.mj_header = head;
    
    
    MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        [self requestListType:chargeType page:++_rightPage];
    }];
    [foot setImages:RefreshImages forState:MJRefreshStateRefreshing];
    _rightTableView.mj_footer = foot;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 余额消费
- (IBAction)onYuEXiaoFei:(id)sender {
    
    _yuELB.textColor = [UIColor colorWithRed:0.235 green:0.510 blue:0.851 alpha:1.000];
    _chongZhiLB.textColor = [UIColor colorWithRed:0.410 green:0.451 blue:0.493 alpha:1.000];
    
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 0);
        [self.view layoutIfNeeded];
    }];
}

#pragma mark 充值记录
- (IBAction)onChongZhiJiLu:(id)sender {
    
    _chongZhiLB.textColor = [UIColor colorWithRed:0.235 green:0.510 blue:0.851 alpha:1.000];
    _yuELB.textColor = [UIColor colorWithRed:0.410 green:0.451 blue:0.493 alpha:1.000];
    
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.contentOffset = CGPointMake(Width, 0);
        [self.view layoutIfNeeded];
    }];
}


#pragma mark 请求列表(类型)
- (void)requestListType:(ListType)type page:(NSInteger)page
{
    // 如果刷新到第一页，则上拉也从第一页往上加
    if (page == FirstPage) {
        if (type == consumeType)
        {
            _leftPage = FirstPage;
        }
        else
        {
            _rightPage = FirstPage;
        }
    }
    
    NSString *url;
    NSMutableArray *list;
    UITableView *tableView;
    NSString *class;
    if (type == chargeType) {
        
        url = BaseURL@"meChargeInfo";
        list = _chargeList;
        tableView = _rightTableView;
        class = NSStringFromClass([ChargeRecord class]);
        
    }
    if (type == consumeType) {
        
        url = BaseURL@"chargeList";
        list = _consumeList;
        tableView = _leftTableView;
        class = NSStringFromClass([ConsumeRecord class]);
    }
    
    

    
    NSDictionary *parameters = @{@"memberId":self.user.userID,
                                 @"pageNo":[NSString stringWithFormat:@"%ld",page],
                                 @"pageSize":@"10"
                                 };
    CoverView *cover = (CoverView *)[tableView viewWithTag:100];
    [self getRequestURL:url parameters:parameters success:^(NSDictionary *dic) {
        
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
        [cover removeFromSuperview];
        NSArray *arr = dic[@"data"];
        // 先清空数据源
        if (page == FirstPage) {
            
            [list removeAllObjects];
        }
        
        for (NSDictionary *tempDic in arr) {
            
            id record = [[NSClassFromString(class) alloc] mj_setKeyValues:tempDic];
            [list addObject:record];
        }

        [tableView reloadData];
        
    } elseAction:^(NSDictionary *dic) {
        
        
        [cover setTitle:dic[@"msg"] image:[UIImage imageNamed:@"icon_order_nomal"] handle:nil];
        
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshingWithNoMoreData];
        
    } failure:^(NSError *error) {
        
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
    }];
}



#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if ([scrollView isEqual:_scrollView]) {
        
        _leading.constant = scrollView.contentOffset.x/2;// 指示条滚动
        
        if (_leading.constant == 0) {
            [self onYuEXiaoFei:nil];
        }
        if (_leading.constant == Width/2) {
            [self onChongZhiJiLu:nil];
        }
    }
    
}


#pragma mark - <UITableViewDataSource>

#pragma mark 段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:_leftTableView]) {
        
        return _consumeList.count;
    }
    else
    {
        return _chargeList.count;
    }
}

#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark ［配置单元格］
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_leftTableView]) {
        ConsumeCell *cell = [_leftTableView dequeueReusableCellWithIdentifier:@"ConsumeCell" forIndexPath:indexPath];
        [cell setCellInfo:_consumeList[indexPath.section]];
        return cell;
    }
    else
    {
        ChargeCell *cell = [_rightTableView dequeueReusableCellWithIdentifier:@"ChargeCell" forIndexPath:indexPath];
        [cell setCellInfo:_chargeList[indexPath.section]];
        return cell;
    }
}

#pragma mark 段上下间隔
- (CGFloat)tableView:( UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark 单元格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"gotoConsumeDetail"]) {
        ConsumeCell *cell = sender;
        ConsumeDetailVC *vc = [segue destinationViewController];
        vc.record = cell.record;

    }
}


@end
