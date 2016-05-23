//
//  MyTicketViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "MyTicketViewController.h"
#import "YHQCell.h"
#import "Coupon.h"
#import "TiketHelpViewController.h"


@interface MyTicketViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyTicketViewController
{
    UITableView *_tableView;
    NSMutableArray *_couponLists;
    NSInteger _page;
    
    UIView * _inputView;
    UILabel * _inputLabel;
    UIButton * _inputBtn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _couponLists = [NSMutableArray new];
    
    [self.nav setTitle:@"我的优惠券" leftText:@"返回" rightTitle:nil showBackImg:YES];
    [self.nav.rightImageBtn setImage:[Unit changeImage:[UIImage imageNamed:@"doubt"] toScale:2] forState:UIControlStateNormal];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.rowHeight = 100;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"YHQCell" bundle:nil] forCellReuseIdentifier:@"YHQCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self showCoverViewOn:_tableView title:nil image:nil handle:^{
        
        [self requestCouponListToPage:FirstPage];
    }];
    
    // 上下拉刷新
    [self setPullRefresh];
    
    // 发请求
    [self requestCouponListToPage:FirstPage];
    
    [self viewInitinal];
}

#pragma mark UI初始化
-(void)viewInitinal
{
//    _inputView = [[UIView alloc] initWithFrame:CGRectMake(Width * 0.1, Heigth - 80, Width * 0.8, 60)];
//    [self.view addSubview:_inputView];
//    
//    _inputView.layer.borderWidth = 1;
//    _inputView.layer.borderColor = [RGBA(57, 191, 233, 1) CGColor];
//    
//    _inputLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _inputView.width - _inputView.height , _inputView.height)];
    
}
- (void)setPullRefresh
{
    MJRefreshGifHeader *head = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        [self requestCouponListToPage:FirstPage];
    }];
    [head setImages:RefreshImages forState:MJRefreshStateRefreshing];
    _tableView.mj_header = head;
    
    MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        [self requestCouponListToPage:++_page];
    }];
    [foot setImages:RefreshImages forState:MJRefreshStateRefreshing];
    _tableView.mj_footer = foot;
}

#pragma mark 点击右边的加号
- (void)right
{
//    __block UITextField *inputTF;
//
//    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"添加优惠券" message:@"输入优惠码可换取优惠券" preferredStyle:UIAlertControllerStyleAlert];
//
//
//
//    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        
//        inputTF = textField;
//        textField.placeholder = @"输入优惠码";
//    }];
//    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//    [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        [self requestAddCoupon:inputTF.text];// 请求输入的优惠码
//    }]];
//
//    [self presentViewController:ac animated:YES completion:nil];
    
    TiketHelpViewController *vc = [[TiketHelpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
    if (_couponLists.count == 0) {
     
        return 0;
    }
    return _couponLists.count;
}

#pragma mark ［配置单元格］
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YHQCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"YHQCell"];
    Coupon *coupon = _couponLists[indexPath.row];
    [cell setCellInfoWithCoupon:coupon];
    
    return cell;
}

#pragma mark 单元格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YHQCell *cell = (YHQCell *)[_tableView cellForRowAtIndexPath:indexPath];
    if (_returnType == ReturnTypeCoupon) {
        
        // 发出包含车位信息的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:ReturnCouponInfo object:nil userInfo:@{@"coupon":cell.coupon}];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 请求添加优惠券
- (void)requestAddCoupon:(NSString *)ID
{
    NSDictionary *parameters = @{
                          @"memberId":self.user.userID,
                          @"code":ID
                          };
    
    [self getRequestURL:BaseURL@"couponCode" parameters:parameters success:^(NSDictionary *dic) {
        
        [MBProgressHUD showSuccess:dic[@"msg"] toView:Window];
        [self requestCouponListToPage:FirstPage];// 再请求一次以刷新
        
    } elseAction:^(NSDictionary *dic) {
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark 请求优惠券(带页数)
- (void)requestCouponListToPage:(NSInteger)page
{
    
    // 如果刷新到第一页，则上拉也从第一页往上加
    if (page == FirstPage) {
        _page = FirstPage;
    }
    
    NSString *url = CouponURL;
    NSDictionary *parameters = @{
                                 @"memberId":[UserManager manager].userID,
                                 @"pageNo":[NSString stringWithFormat:@"%ld",(long)page],
                                 @"pageSize":@"10"
                                 };
//    NSLog(@"%@",parameters);
    [MBProgressHUD showHUDAddedTo:Window animated:YES];// 动画开始
    [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
        
        NSDictionary *dic = responseObject;
        
        if ([dic[@"status"] isEqual:@(200)]) {
            
            if (page == FirstPage) {
                
                [self removeCoverView];
                [_couponLists removeAllObjects];
            }
            
            for (NSDictionary *temp in dic[@"data"]) {
                
                Coupon *c = [[Coupon alloc] mj_setKeyValues:temp];
                [_couponLists addObject:c];
            }
            [_tableView reloadData];
        }
        else
        {
            [MBProgressHUD showError:dic[@"msg"] toView:Window];
            [self.coverView setTitle:dic[@"msg"] image:[UIImage imageNamed:@"icon_coupon_nomal"] handle:nil];

            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        

            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        NSLog(@"报错：%@", [error localizedDescription]);
        [MBProgressHUD showError:@"网络加载异常" toView:Window];
        self.coverView.titleLB.text = @"网络加载异常，点击重新加载";
    }];
}

@end
