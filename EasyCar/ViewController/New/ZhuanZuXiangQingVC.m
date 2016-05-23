//
//  ZhuanZuXiangQingVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 16/1/14.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ZhuanZuXiangQingVC.h"
#import "ShouYiCell.h"
#import "ShouYiHeaderCell.h"
#import "DayProfit.h"
#import "CarProfit.h"

@interface ZhuanZuXiangQingVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLB;
@property (strong, nonatomic) IBOutlet UILabel *totalProfitLB;
@property (strong, nonatomic) IBOutlet UITextField *heheTF;
@property (nonatomic, strong) NSMutableArray *dayList;
@end

@implementation ZhuanZuXiangQingVC
{
    NSInteger _selectedSection;
    NSInteger _selectedMonth;
    double _totalCount;
    double _totalBalance;
    NSArray *_months;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nav setTitle:@"转租详情" leftText:@"返回" rightTitle:@"更多" showBackImg:YES];
    _tableView.estimatedRowHeight = 44;
    _dayList = [NSMutableArray new];
    
    _selectedMonth = [[Unit getTimeWithFormat:@"M"] integerValue];// 默认查询日期为当月
    _bottomView.hidden = YES;

    // picker相关
    _months = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    _heheTF.inputView = _pickerView;
    _heheTF.inputAccessoryView = _toolBar;



    [self showCoverViewOn:_tableView title:@"努力加载中..." image:[UIImage imageNamed:@"zhanweitu-1"] handle:^{
        
        [self requestDataForMonth:_selectedMonth];
    }];


    [self requestDataForMonth:_selectedMonth];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - <UITableViewDataSource>

#pragma mark TV段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dayList.count;
}
#pragma mark TV行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DayProfit * dp = _dayList[section];

    if (dp.shouldHiden) {
        return 0;
    }
    return dp.rentList.count;
}




#pragma mark ［自定义段头］
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShouYiHeaderCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ShouYiHeaderCell"];
    cell.tag = 100 + section;
    [cell setCellInfo:_dayList[section]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectHeader:)];
    [cell addGestureRecognizer:tap];
    
    return cell;
}

#pragma mark ［配置TV单元格］
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShouYiCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ShouYiCell" forIndexPath:indexPath];
    DayProfit *dp = _dayList[indexPath.section];
    CarProfit *cp = dp.rentList[indexPath.row];
    [cell setCellInfo:cp];
    return cell;
}

#pragma mark TV单元格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark 点击段头
- (void)didSelectHeader:(UITapGestureRecognizer *)sender {

    _selectedSection = sender.view.tag -100;

    // 展示与隐藏
    DayProfit *dp = _dayList[_selectedSection];
    dp.shouldHiden = !dp.shouldHiden;
    
    // 刷新界面
    [_tableView reloadData];
    
}

#pragma mark 段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

#pragma mark 请求
- (void)requestDataForMonth:(NSInteger)month
{

    [self getRequestURL:BaseURL@"findRentInfo"
             parameters:@{
                          @"spaceId":_info.spaceId,//@"8ae8b92c51d6f51a0151d7533af9001c",//_info.spaceId,
                          @"rentMonth":[NSString stringWithFormat:@"%ld",(long)month],
                          @"memberId":self.user.userID
                          }
                success:^(NSDictionary *dic) {
                    
                    [_dayList removeAllObjects];// 先清空原数据
                    _totalCount = [(dic[@"data"][@"totalCount"]) doubleValue];
                    _totalBalance = [(dic[@"data"][@"totalBalance"]) doubleValue];
                    
                    // 模型中有个数组属性，数组里面又要装着其他模型CarProfit
                    [DayProfit mj_setupObjectClassInArray:^NSDictionary *{
                        
                        return @{
                                 @"rentList" : @"CarProfit",
                                 };
                    }];
                    
                    for (NSDictionary *temp in dic[@"data"][@"totalList"]) {
                        
                        DayProfit *dp = [DayProfit mj_objectWithKeyValues:temp];
                        dp.shouldHiden = YES;// 默认隐藏
                        [_dayList addObject:dp];
                    }
                    DayProfit *dp = [_dayList firstObject];
                    dp.shouldHiden = NO;// 第一条展开
                    // 刷新数据
                    [self removeCoverView];
                    _bottomView.hidden = NO;
                    [_tableView reloadData];
                    _totalTimeLB.text = [NSString stringWithFormat:@"本月总转租次数：%.0f",_totalCount];
                    _totalProfitLB.text = [NSString stringWithFormat:@"总收益：%.1f元",_totalBalance];
                    
                    
                }
                elseAction:^(NSDictionary *dic) {
                    
                    _bottomView.hidden = YES;
                    [self showCoverViewOn:_tableView title:@"该月份暂无数据" image:[UIImage imageNamed:@"zhanweitu-1"] handle:^{
                        
                        [self requestDataForMonth:_selectedMonth];
                    }];

                    
                }
                failure:^(NSError *error) {
                    
                    self.coverView.titleLB.text = @"网络加载失败";
                }];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark 点击选择月份
- (void)right
{
    [_heheTF becomeFirstResponder];
    [_pickerView selectRow:_selectedMonth-1 inComponent:0 animated:YES];// 默认显示当前选中的月份
}
#pragma mark 取消选择月份
- (IBAction)cancelPicker:(id)sender {
    
    [_heheTF resignFirstResponder];
}
#pragma mark 确定选择月份
- (IBAction)confirmPicker:(id)sender {
    
    [_heheTF resignFirstResponder];
    NSInteger row = [_pickerView selectedRowInComponent:0];
    NSString *value=[_months objectAtIndex:row];
    
    _selectedMonth = [value integerValue];// 更改选中月份
    [self requestDataForMonth:_selectedMonth];
}


#pragma mark - pickerView

#pragma mark 列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

#pragma mark 行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _months.count;
}

#pragma mark [配置数据]
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@月",_months[row]];
}


@end
