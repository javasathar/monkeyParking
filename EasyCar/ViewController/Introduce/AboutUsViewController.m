//
//  AboutUsViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AboutUsCell.h"
#import "CompInfoViewController.h"
#import "ComHistViewController.h"
#import "ComNewsViewController.h"
#import "ComCultureViewController.h"
#import "ComProductViewController.h"

@interface AboutUsViewController ()
{
    NSMutableArray *aboutArr;
    NSMutableArray *aboutImgArr;
}
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    
    [self.nav setTitle:@"关于我们" leftText:@"返回" rightTitle:nil showBackImg:YES];
    self.view.backgroundColor = RGBA(242, 242, 248, 1);
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    aboutArr = [[NSMutableArray alloc] initWithObjects:@"公司信息",@"公司动态",@"公司文化",@"公司产品", nil];
    aboutImgArr = [[NSMutableArray alloc] initWithObjects:@"about1",@"about3",@"about4",@"about5", nil];
    
    UITableView *tableviews = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT -64) style:(UITableViewStylePlain)];
    tableviews.dataSource = self;
    tableviews.delegate = self;
    tableviews.rowHeight = 45;
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"AboutUsCell";
    AboutUsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[AboutUsCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    cell.imgviEW.image = [UIImage imageNamed:aboutImgArr[indexPath.row]];
    cell.nameLabel.text = aboutArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            CompInfoViewController *aboutVC = [[CompInfoViewController alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;

        
        case 1:
        {
            #pragma mark 公司动态（新闻）
            ComNewsViewController *aboutVC = [[ComNewsViewController alloc] init];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationItem setBackBarButtonItem:backItem];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;

        case 2:
        {
            ComCultureViewController *aboutVC = [[ComCultureViewController alloc] init];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationItem setBackBarButtonItem:backItem];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
            
            
        case 3:
        {
            #pragma mark 公司产品
            ComProductViewController *aboutVC = [[ComProductViewController alloc] init];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationItem setBackBarButtonItem:backItem];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
        default:
            break;
    }
    
}
@end
