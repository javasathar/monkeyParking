//
//  WoDeDingDanVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/7.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "WoDeDingDanVC.h"
#import "AppointOrder.h"
#import "DingDanXiangQingVC.h"
#import "YuYueOrderCell.h"
#import "ZhengZuOrderCell.h"
#import "RentOrder.h"

typedef NS_ENUM (NSUInteger, OrderListType)
{
    appointOrderList,
    rentOrderList
};

@interface WoDeDingDanVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>



@property (strong, nonatomic) IBOutlet UILabel *yuYueLB;
@property (strong, nonatomic) IBOutlet UILabel *zhengZuLB;
@property (strong, nonatomic) IBOutlet UITableView *leftTableView;
@property (strong, nonatomic) IBOutlet UITableView *rightTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leading;// 蓝色指示条的leading

@property (nonatomic, strong) NSMutableArray *appointList;
@property (nonatomic, strong) NSMutableArray *rentList;
@end

@implementation WoDeDingDanVC
{
    NSInteger _leftPage;
    NSInteger _rightPage;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return nil;// 不要用这个方法
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nav setTitle:@"我的订单" leftText:@"返回" rightTitle:nil showBackImg:YES];
    
    _leftTableView.estimatedRowHeight = 44;
    _rightTableView.estimatedRowHeight = 44;
    
    
    _appointList = [[NSMutableArray alloc] init];
    _rentList = [NSMutableArray new];
    
    
    [self.view layoutIfNeeded];

    _leftTableView.frame = CGRectMake(0, 0, _scrollView.width, _scrollView.height);

    _rightTableView.frame = CGRectMake(Width+0, 0, _scrollView.width, _scrollView.height);
    
    [_scrollView addSubview:_leftTableView];
    [_scrollView addSubview:_rightTableView];
    
    
    _scrollView.contentSize = CGSizeMake(Width * 2, _leftTableView.height);


    _scrollView.contentOffset = CGPointMake(_pageIndex * Width, 0);
    
    
    // 上拉下拉
    [self setPullRefresh];
    
    // coverView
    [self addCoverView];

    [self requestOrderListType:appointOrderList page:FirstPage];
    [self requestOrderListType:rentOrderList page:FirstPage];
    

}

- (void)addCoverView
{
    CoverView *leftCover = [[NSBundle mainBundle] loadNibNamed:@"CoverView" owner:nil options:nil][0];
    leftCover.frame = _leftTableView.bounds;
    leftCover.tag = 100;
    [leftCover setTitle:@"努力加载中" image:[UIImage imageNamed:@"zhanweitu-1"] handle:^{
        
        [self requestOrderListType:appointOrderList page:FirstPage];
    }];
    
    [_leftTableView addSubview:leftCover];

    CoverView *rightCover = [[NSBundle mainBundle] loadNibNamed:@"CoverView" owner:nil options:nil][0];
    rightCover.frame = _rightTableView.bounds;
    rightCover.tag = 100;
    [rightCover setTitle:@"努力加载中" image:[UIImage imageNamed:@"zhanweitu-1"] handle:^{
        
        [self requestOrderListType:rentOrderList page:FirstPage];
    }];
    
    [_rightTableView addSubview:rightCover];
}

#pragma mark 上下拉刷新
- (void)setPullRefresh
{
    MJRefreshGifHeader *leftHead = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        [self requestOrderListType:appointOrderList page:FirstPage];
    }];
    [leftHead setImages:RefreshImages forState:MJRefreshStateRefreshing];
    _leftTableView.mj_header = leftHead;
    
    
    MJRefreshBackGifFooter *leftFoot = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        [self requestOrderListType:appointOrderList page:++_leftPage];
    }];
    [leftFoot setImages:RefreshImages forState:MJRefreshStateRefreshing];
    _leftTableView.mj_footer = leftFoot;
    
    
    MJRefreshGifHeader *head = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        [self requestOrderListType:rentOrderList page:FirstPage];
    }];
    [head setImages:RefreshImages forState:MJRefreshStateRefreshing];
    _rightTableView.mj_header = head;
    
    
    MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        [self requestOrderListType:rentOrderList page:++_rightPage];;
    }];
    [foot setImages:RefreshImages forState:MJRefreshStateRefreshing];
    _rightTableView.mj_footer = foot;
    
}


#pragma mark 点击预约
- (IBAction)clickYuYueBtn:(id)sender {
    
    _yuYueLB.textColor = [UIColor colorWithRed:0.235 green:0.510 blue:0.851 alpha:1.000];
    _zhengZuLB.textColor = [UIColor colorWithRed:0.410 green:0.451 blue:0.493 alpha:1.000];
    
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 0);
        [self.view layoutIfNeeded];
    }];
    
}
#pragma mark 点击整租
- (IBAction)clickZhengZuBtn:(id)sender {
    
    _zhengZuLB.textColor = [UIColor colorWithRed:0.235 green:0.510 blue:0.851 alpha:1.000];
    _yuYueLB.textColor = [UIColor colorWithRed:0.410 green:0.451 blue:0.493 alpha:1.000];
    
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.contentOffset = CGPointMake(Width, 0);
        [self.view layoutIfNeeded];
    }];
}


#pragma mark 请求订单(类型)
- (void)requestOrderListType:(OrderListType)type page:(NSInteger)page
{
    
    // 如果刷新到第一页，则上拉也从第一页往上加
    if (page == FirstPage) {
        if (type == appointOrderList)
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
    if (type == appointOrderList) {
        
        url = BaseURL@"appointOrderList";
        list = _appointList;
        tableView = _leftTableView;
        class = NSStringFromClass([AppointOrder class]);

    }
    if (type == rentOrderList) {
        
        url = BaseURL@"rentOrderList";
        list = _rentList;
        tableView = _rightTableView;
        class = NSStringFromClass([RentOrder class]);
    }
    
    [MBProgressHUD showHUDAddedTo:Window animated:YES]; // 动画开始
    
    NSDictionary *parameters = @{@"memberId":self.user.userID,
                                 @"pageNo":[NSString stringWithFormat:@"%ld",(long)page],
                                 @"pageSize":@"10"
                                 };
    CoverView *cover = (CoverView *)[tableView viewWithTag:100];
    [self getRequestURL:url parameters:parameters success:^(NSDictionary *dic) {
//        NSLog(@"订单信息：%@",dic);
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        [cover removeFromSuperview];
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
        
        
        NSArray *arr = dic[@"data"];
        // 先清空数据源
        if (page == FirstPage) {
            
            [list removeAllObjects];
        }

        for (NSDictionary *tempDic in arr) {
            
            id order = [[NSClassFromString(class) alloc] mj_setKeyValues:tempDic];
            [list addObject:order];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource>

#pragma mark 段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:_leftTableView]) {
        
        return _appointList.count;
    }
    else
    {
        return _rentList.count;
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
        YuYueOrderCell *cell = [_leftTableView dequeueReusableCellWithIdentifier:@"YuYueOrderCell" forIndexPath:indexPath];
        [cell setCellInfoWithAppointOrder:_appointList[indexPath.section]];
        return cell;
    }
    else
    {
        ZhengZuOrderCell *cell = [_rightTableView dequeueReusableCellWithIdentifier:@"ZhengZuOrderCell" forIndexPath:indexPath];
        [cell setCellInfoWithRentOrder:_rentList[indexPath.section]];
        return cell;
    }
}

#pragma mark 段上下间隔
- (CGFloat)tableView:( UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}



#pragma mark 单元格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if ([scrollView isEqual:_scrollView]) {
        
        _leading.constant = scrollView.contentOffset.x/2;// 指示条滚动
        
        if (_leading.constant == 0) {
            [self clickYuYueBtn:nil];
        }
        if (_leading.constant == Width/2) {
            [self clickZhengZuBtn:nil];
        }
    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.destinationViewController isKindOfClass:[DingDanXiangQingVC class]]) {
        
        DingDanXiangQingVC *vc = (DingDanXiangQingVC *)segue.destinationViewController;
        vc.cell = sender;
    }
    
}



@end
