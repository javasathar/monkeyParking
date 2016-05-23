//
//  ComProductViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ComProductViewController.h"
#import "ComHisCell.h"
#import "ProductDetailViewController.h"

@interface ComProductViewController ()

@end

@implementation ComProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"test");
    self.title = @"公司产品";
    [self.nav setTitle:@"公司产品" leftText:@"返回" rightTitle:nil showBackImg:YES];
    UITableView *tableviews = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64) style:(UITableViewStylePlain)];
    tableviews.dataSource = self;
    tableviews.delegate = self;
    tableviews.rowHeight = 80;
    tableviews.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableviews];
    
//    [self requestProduct];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 请求新闻产品
- (void)requestProduct
{
    NSString *url = BaseURL@"pushInfo";
    NSDictionary *parameters = @{@"memberId":self.user.userID,
                                 @"type":@"2"// 2表示公司产品
                                 };
    [self getRequestURL:url parameters:parameters success:^(NSDictionary *dic) {
        
    } elseAction:^(NSDictionary *dic) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
        cell.imgView.image = [UIImage imageNamed:@"pmhy.jpg"];
        cell.contentLabel.text = @"平面移动类";
        cell.timeLabel.text = @"2015-4-12";
    }
    else if(1 == indexPath.row)
    {
        cell.imgView.image = [UIImage imageNamed:@"sjhy.jpg"];
        cell.contentLabel.text = @"升降横移类";
        cell.timeLabel.text = @"2015-4-15";
    }
    else if(2 == indexPath.row)
    {
        cell.imgView.image = [UIImage imageNamed:@"xddd.jpg"];
        cell.contentLabel.text = @"巷道堆垛类";
        cell.timeLabel.text = @"2015-4-15";
    }
    else if(3 == indexPath.row)
    {
        cell.imgView.image = [UIImage imageNamed:@"czsj.jpg"];
        cell.contentLabel.text = @"垂直升降类";
        cell.timeLabel.text = @"2015-4-15";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    switch (indexPath.row) {
        case 0:
        {
            detailVC.imgStr = @"b1.jpg";
            detailVC.titleStr = @"平面移动类";
            detailVC.contentStr = @"    采用与立体仓库类似的原理和结构，在系统的每一层都有至少一台横移车负责本层的车辆存取，由升降机将不同的停车层与出入口相连，车辆 只需停到出入口，存取车全过程均由系统自动完成。";
        }
            break;
        case 1:
        {
            detailVC.imgStr = @"b4.jpg";
            detailVC.titleStr = @"升降横移类";
            detailVC.contentStr = @"    上、下层车位可升降，中间层车位可横移。当上、下层车位存取车时，中间层车位通过横移留出空位，上、下层的车辆降下或者升起至地面，实现车辆存取；中间层存取车，直接驶入或者驶出即可";
        }
            break;
        case 2:
        {
            detailVC.imgStr = @"b6.jpg";
            detailVC.titleStr = @"巷道堆垛类";
            detailVC.contentStr = @"    巷道立体停车设备是全智能系统，每套系统有一台堆垛机，可以在轨道上水平运动，同时堆垛机上有可以升降的平台，整套系统通过水平和垂直运动的组合来存取 指定位置的车辆，车辆只需停到出入口，存取车全过程均由系统自动完成。可以满足地上或地下从2层车库到7层车库的使用要求，实现自动化快速安全存取车。";
        }
            break;
        case 3:
        {
            detailVC.imgStr = @"b5";
            detailVC.titleStr = @"垂直升降类";
            detailVC.contentStr = @"    亦可称为塔式立体停车库，是通过搬运器的升降机构和装在搬运器上的横移机构将车辆或在车板横移来实现存取车辆。";
        }
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
