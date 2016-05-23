//
//  ComHistViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ComHistViewController.h"
#import "ComHisCell.h"
#import "HisDetailViewController.h"

@interface ComHistViewController ()
@end

@implementation ComHistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"公司事迹";
    UITableView *tableviews = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) style:(UITableViewStylePlain)];
    tableviews.dataSource = self;
    tableviews.delegate = self;
    tableviews.rowHeight = 80;
    tableviews.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"ComHisCell";
    ComHisCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[ComHisCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    if(0 == indexPath.row)
    {
        cell.imgView.image = [UIImage imageNamed:@"gspic2"];
        cell.contentLabel.text = @"加入深圳市智能交通\n行业协会";
        cell.timeLabel.text = @"2015-4-12";
    }
    else
    {
        cell.imgView.image = [UIImage imageNamed:@"gspic3"];
        cell.contentLabel.text = @"参观赛格导航的\n生产基地及会议交流";
        cell.timeLabel.text = @"2015-4-15";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HisDetailViewController *detailVC = [[HisDetailViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    if(0 == indexPath.row)
    {
        detailVC.imgStr = @"1";
        detailVC.contentStr = @"    深圳市智能交通行业协会是经深圳市民政局批准登记、由市政府有关部门领导管理的行业性组织，是非营利性社会团体、社会独立法人。\n    本协会是跨部门、跨不通风经济成份的全行业组织，是行业代表。成立于二00七年五月八日。其主要职责是，在市政府有关部门的领导下，依靠行业集体的力量加速全市智能交通产业的发展，为会员单位的共同利益服务，维护全行业于会员单位的合法权益；发挥政府部门实施行业管理的助手作用；积极与国内外相关领域交流、往来，以促进全行业经济、技术、管理水平和经济效益的不断提高，推进全市智能交通产业的发展；为维护全市道路交通畅通、保护环境和人身安全作出努力。";
    }
    else
    {
        detailVC.imgStr = @"2";
        detailVC.contentStr = @"    深圳市易停车库科技有限公司到深圳市龙岗区赛格导航科技园参观赛格导航的生产基地以及会议交流。";
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
