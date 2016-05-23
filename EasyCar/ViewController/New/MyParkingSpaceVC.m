//
//  MyParkingSpaceVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/16.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "MyParkingSpaceVC.h"
#import "ParkIngSpaceItemCell.h"
#import "ParkingSpace.h"
#import "CheWeiZhengZuVC.h"

#define ParkInfo _lists[section-1][@"info"][row-1]

@interface MyParkingSpaceVC ()


/**
 *  一层几个车位
 */
@property (nonatomic,assign) NSUInteger SPF;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *topAreaView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *multableHeight;
@property (strong, nonatomic) IBOutlet UITableView *tableView_XL;
@property (strong, nonatomic) IBOutlet UIImageView *coverInBlack;
@property (strong, nonatomic) IBOutlet UILabel *currentAreaLB;





@end

@implementation ParkingSpaceFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    NSUInteger n = _ctl.SPF; // 一行n个（用于计算）
    CGFloat IISpacing = 10;  // 间距
    CGFloat LRInset = 10;    // 左右边距
    
    
    CGFloat width = ( (UI_SCREEN_WIDTH - LRInset *2) - IISpacing * (n-1) ) /n;
    CGFloat height = width;
    //    self.estimatedItemSize = CGSizeMake(width, height);
    self.itemSize = CGSizeMake(width, height);
    //    ((320 - 6*2) - 10*(6-1))/6
    
    
    // cv的上左下右边距
    self.sectionInset = UIEdgeInsetsMake(7, LRInset, 7, LRInset);
    // (全局)设置段头视图大小它才能显示出来
    //    self.headerReferenceSize = CGSizeMake(WIDTH, 40);
}
@end


@implementation MyParkingSpaceVC
{
    NSArray *_lists;
    NSArray *_areas;
    NSInteger _floor;
    BOOL _didConfigAreaScrollView;
    UIButton *_lastAreaBtn;
    BOOL _XL_isShow;// 下拉菜单显示
    
    
    #pragma mark 必要参数
    NSString *_parkArea;
    NSString *_parkId;
    ParkFunction _function;
}

- (void)necessaryPropertyParkFunction:(ParkFunction)function parkArea:(NSString *)parkArea parkId:(NSString *)parkId
{
    _parkArea = parkArea;
    _parkId = parkId;
    _function = function;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _areas = [[NSArray alloc] init];
    _currentAreaLB.text = [NSString stringWithFormat:@"%@区",_parkArea];// 初次进入页面显示当前区域，_parkArea务必有值
    
    if (_function == toChooseParkSpace)
    {
        [self.nav setTitle:@"选择车位" leftText:@"返回" rightTitle:nil showBackImg:YES];
    }
    if (_function == toChooseRentParkSpace)
    {
        [self.nav setTitle:@"选择整租车位" leftText:@"返回" rightTitle:nil showBackImg:YES];
    }
    else
    {
        [self.nav setTitle:@"停车状态" leftText:@"返回" rightTitle:nil showBackImg:YES];
    }
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self registerCVCellsAndRefreshView];
    
    ParkingSpaceFlowLayout *flowLayout = [[ParkingSpaceFlowLayout alloc] init];
    flowLayout.ctl = self;
    _collectionView.collectionViewLayout = flowLayout;
    
    NSLog(@"%@", _topAreaView.subviews);
    
    [self showCoverViewOn:_topAreaView title:nil image:nil handle:^{
        
        [self requestCarInfoWithArea:nil];
    }];
    [self requestCarInfoWithArea:nil];
    
}


#pragma mark 发送请求
- (void)requestCarInfoWithArea:(NSString *)area
{
    [MBProgressHUD showHUDAddedTo:Window animated:YES]; // 动画开始

    NSString *url = BaseURL@"parkSpaceList";
    
    _parkArea = (area.length == 0 ? _parkArea : area);
    _currentAreaLB.text = [NSString stringWithFormat:@"%@区",_parkArea];
    
    NSDictionary *parameters = @{
                                 @"parkId":_parkId,
                                 @"parkArea":_parkArea
                                 };
    
    [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        NSDictionary *dic = responseObject;
        
        if ([dic[@"status"] isEqual:@(200)]) {
            
            [self removeCoverView];
            
            _lists = dic[@"data"][0][@"list"];
            _areas = dic[@"data"][0][@"set"];

            // 解析车场数据，找到一共多少层,
            _floor = _lists.count;
            // 再找一层最多多少个车位
            int maxCount = 0;
            for (NSDictionary *floorDic in _lists) {
                int count = (int)[floorDic[@"info"] count];
                maxCount = count > maxCount ? count : maxCount;
            }
            _SPF = maxCount;

            [_collectionView reloadData];
        }
        else
        {
            [MBProgressHUD showError:dic[@"msg"] toView:Window];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        NSLog(@"报错：%@", [error localizedDescription]);
        [MBProgressHUD showError:@"网络加载出错" toView:Window];
    }];
}



#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _floor;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _SPF;
}





#pragma mark ［配置单元格］
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section = [self realSection:indexPath.section];
    NSInteger row = [self realRow:indexPath.row];
    
    ParkIngSpaceItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ParkIngSpaceItemCell" forIndexPath:indexPath];
    // 检查某一层的某车位是否存在,超出数组长度的车位是不存在的，需隐藏
    if ([_lists[section-1][@"info"] count] >= row) {
        
        NSDictionary *dic = ParkInfo;
        ParkingSpace *ps = [[ParkingSpace alloc] mj_setKeyValues:dic];
        
        [cell setCellInfoWithParkingSpace:ps myCarSpaceId:_myCarSpaceId ParkFunction:_function];
        return cell;
    }
    else
    {
        cell.hidden = YES;
        return cell;
    }
}

#pragma mark 段尾高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake( UI_SCREEN_WIDTH, 10);
}

#pragma mark 注册
- (void)registerCVCellsAndRefreshView
{
    NSArray *registerArr_CV = @[@"ParkIngSpaceItemCell"];
    for (NSString *cellName in registerArr_CV) {
        [_collectionView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellWithReuseIdentifier:cellName];
    }
    //    //段头
    //    [_collectionView registerNib:[UINib nibWithNibName:@"HeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView"];
}


#pragma mark - 点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 转换后的IndexPath
    NSInteger row = [self realRow:indexPath.row];
    NSInteger section = [self realSection:indexPath.section];
//    NSIndexPath *realIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSLog(@"点击了%@", ParkInfo);
    
    if (_function == toChooseParkSpace) {

        // 发出包含车位信息的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:ReturnParkInfo object:nil userInfo:ParkInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (_function == toChooseRentParkSpace) {
        
        ParkIngSpaceItemCell *cell = (ParkIngSpaceItemCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        // 如果是可以整租的
        if (cell.parkingSpace.type == 0) {
            
            CheWeiZhengZuVC *vc = [Unit EPStoryboard:@"CheWeiZhengZuVC"];
            [vc necessaryProperty:ParkInfo parkArea:_parkArea parkId:_parkId];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [MBProgressHUD showError:@"该车位已被整租" toView:Window];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


    // Dispose of any resources that can be recreated.
}


#pragma mark 转换后的层数
- (NSInteger)realSection:(NSInteger)originSection
{
    NSInteger realSection = _floor - originSection;
    return realSection;
}

#pragma mark 转换后的车位号
- (NSInteger)realRow:(NSInteger)originRow
{
    NSInteger realRow = originRow + 1;
    return realRow;
}
//
//#pragma mark 配置区域选择栏 (不再使用)
//- (void)configAreaScrollView
//{
//    _didConfigAreaScrollView = YES;
//    [self layoutFor:5 SubviewsPerLineWithArray:_areas];
//}
//
//#pragma mark 宫格布局
//- (void)layoutFor:(int)n SubviewsPerLineWithArray:(NSArray *)array
//{
//
//    //小图形的宽高间隙
//    CGFloat gap = 0;
//    CGFloat width = (_areaScrollView.bounds.size.width - gap*(n-1))/n;
//    CGFloat hight = _areaScrollView.bounds.size.height;
//    _areaScrollView.contentSize = CGSizeMake(array.count *width, hight);
//    for (int i = 0; i < array.count ; i++) {
//        UIButton *thumbBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        [thumbBtn setTitle:array[i] forState:UIControlStateNormal];
//        [thumbBtn setTintColor:[UIColor whiteColor]];
//        [thumbBtn addTarget:self action:@selector(changeArea:) forControlEvents:UIControlEventTouchUpInside];
//        
//        CGFloat x = (width+gap) * (i);
//        CGFloat y = 0;
//        thumbBtn.frame = CGRectMake( x, y, width, hight);
//        [_areaScrollView addSubview:thumbBtn];
//        
//        if ([_parkArea isEqual:array[i]]) {
//            thumbBtn.selected = YES;
//            _lastAreaBtn = thumbBtn;
//        }
//    }
//}

- (void)changeArea:(UIButton *)sender
{

    if (!_lastAreaBtn || [_lastAreaBtn isEqual:sender]) {
        _lastAreaBtn = sender;
    }
    else
    {
        _lastAreaBtn.selected = NO;
        _lastAreaBtn = sender;
    }
    sender.selected = YES;
    
    [self requestCarInfoWithArea:sender.titleLabel.text];
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
    return _areas.count;
}

#pragma mark ［配置单元格］
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [_tableView_XL dequeueReusableCellWithIdentifier:@"<#cell#>" forIndexPath:indexPath];
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text = _areas[indexPath.row];
    
    return cell;
}

#pragma mark 单元格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self requestCarInfoWithArea:_areas[indexPath.row]];
    [self showOrNotShow];
}


- (IBAction)clickCoverInBlack:(UITapGestureRecognizer *)sender {
    
    [self showOrNotShow];
    
}

#pragma mark 点击切换区域
- (IBAction)clickAreaBtn:(id)sender {
    
    [self showOrNotShow];
}

#pragma mark 切换区域
- (void)showOrNotShow
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        // 如果是隐藏的，二者都显示
        if (_coverInBlack.hidden) {
            [_tableView_XL reloadData];
            _coverInBlack.hidden = NO;
            _multableHeight.constant = 44 * _areas.count;
        }
        // 如果是显示的，二者都隐藏
        else
        {
            _coverInBlack.hidden = YES;
            _multableHeight.constant = 0;
        }
        [self.view layoutIfNeeded];
    }];
}

@end
