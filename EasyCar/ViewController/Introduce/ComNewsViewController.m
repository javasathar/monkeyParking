//
//  ComNewsViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ComNewsViewController.h"
#import "ComHisCell.h"
#import "NewsDetailViewController.h"
#import "ComNews.h"
@interface ComNewsViewController ()
{

    UITableView *_tableview;
    
    NSMutableArray *imgArr;
    NSMutableArray *contentArr;
    NSMutableArray *timeArr;
    NSMutableArray *detailContent;
}
@end

@implementation ComNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSString *title;
    if (_vc_type == 0) {
        title = @"公司信息";
    }
    if (_vc_type == 1) {
        title = @"公司动态";
    }
    if (_vc_type == 2) {
        title = @"公司文化";
    }
    if (_vc_type == 3) {
        title = @"公司产品";
    }
    [self.nav setTitle:title leftText:@"返回" rightTitle:nil showBackImg:YES];

    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64) style:(UITableViewStylePlain)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.rowHeight = 80;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
    
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
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"ComHisCell";
    ComHisCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[ComHisCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    [cell setCellInfo:_datas[indexPath.row]];
    return cell;
}


#pragma mark 单元格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    baseVC *vc = [baseVC new];
    [vc.nav setTitle:@"" leftText:@"返回" rightTitle:nil showBackImg:YES];
    
    ComNews *n = _datas[indexPath.row];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:n.contenturl]];
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, Width, Heigth - 64)];
    webView.scalesPageToFit = YES;
    [webView loadRequest:request];
    [vc.view addSubview:webView];
    [self.navigationController pushViewController:vc animated:YES];
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NewsDetailViewController *detailVC = [[NewsDetailViewController alloc] init];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self.navigationItem setBackBarButtonItem:backItem];
//    detailVC.content = detailContent[indexPath.row];
//    switch (indexPath.row) {
//        case 0:
//        {
//            detailVC.img1 = @"news6.jpg";
//            detailVC.img2 = @"news1.jpg";
//        }
//            break;
//        case 1:
//        {
//            detailVC.img1 = @"news2.jpg";
//            detailVC.img2 = @"";
//        }
//            break;
//        case 2:
//        {
//            detailVC.img1 = @"news4.jpg";
//            detailVC.img2 = @"news5.jpg";
//        }
//            break;
//            
//        default:
//            break;
//    }
//    [self.navigationController pushViewController:detailVC animated:YES];

}
@end
