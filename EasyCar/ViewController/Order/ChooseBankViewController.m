//
//  ChooseBankViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ChooseBankViewController.h"
#import "BankCell.h"

@interface ChooseBankViewController ()
{
    NSMutableArray *bankArray;
    NSMutableArray *bankImgArr;
}
@end

@implementation ChooseBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    bankImgArr = [[NSMutableArray alloc] initWithObjects:@"bank1",@"bank2",@"bank3",@"bank4",@"bank5",@"bank6",@"bank7",@"bank8",@"bank9",@"bank10",@"bank11", nil];
    bankArray = [[NSMutableArray alloc] initWithObjects:@"中国工商银行",@"中国农业银行",@"中国建设银行",@"中国邮政储蓄银行",@"中国银行",@"招商银行",@"交通银行",@"中国光大银行",@"中国平安银行",@"中国民生银行",@"兴业银行", nil];
    self.view.backgroundColor = RGBA(242, 242, 248, 1);
    self.title = @"选择银行";
    UISearchBar *_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, UI_SCREEN_WIDTH, 40)];
    _searchBar.placeholder = @"搜索";
    [self.view addSubview:_searchBar];
    UITableView *tableviews = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-_searchBar.bottom) style:(UITableViewStylePlain)];
    tableviews.rowHeight = 45;
    tableviews.dataSource = self;
    tableviews.delegate = self;
    [self.view addSubview:tableviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return bankArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"BankCell";
    BankCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[BankCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    cell.imgviEW.image = [UIImage imageNamed:bankImgArr[indexPath.row]];
    cell.nameLabel.text = bankArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BankCell *cell = (BankCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseBank" object:cell.nameLabel.text];
}
@end
