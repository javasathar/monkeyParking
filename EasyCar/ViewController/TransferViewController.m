//
//  TransferViewController.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/13.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "TransferViewController.h"
#import "TransferTableViewCell.h"
@interface TransferViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)NSMutableArray *dataArr;
@property (nonatomic ,strong)UITableView *dataTabel;

@end

@implementation TransferViewController
-(UITableView *)dataTabel
{
    
    if (!_dataTabel) {
        _dataTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Heigth -64) style:UITableViewStylePlain];
        _dataTabel.backgroundColor = RGBA(240, 240, 240, 1);
        _dataTabel.dataSource = self;
        _dataTabel.delegate = self;
        _dataTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dataTabel.estimatedRowHeight = 60;
        [_dataTabel registerNib:[UINib nibWithNibName:@"TransferTableViewCell" bundle:nil] forCellReuseIdentifier:@"TransferCell"];
    }
    return _dataTabel;
}
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.nav setTitle:@"转租收益" leftText:nil
            rightTitle:nil showBackImg:YES];
    [self.view addSubview:self.dataTabel];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
}
#pragma mark 刷新数据
-(void)requestData
{
    NSString *getUrl = BaseURL@"rentOrderList";
    NSDictionary *parametersDic = @{@"memberId":[UserManager manager].userID,
                                    @"pageNo":@1,
                                    @"pageSize":@10,
                                    };
    //    NSLog(@"%@?memberId:%@&pageNo:1&pageSize:20",getUrl,[UserManager manager].userID);
    
    [self getRequestURL:getUrl parameters:parametersDic success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
    } elseAction:^(NSDictionary *dic) {
        
        [self.coverView setTitle:@"无信息" image:[UIImage imageNamed:@"icon_car_nomal"] handle:nil];
        
    } failure:^(NSError *error) {
        [self.coverView setTitle:error.localizedDescription image:[UIImage imageNamed:@"icon_car_nomal"] handle:nil];
    }];
}
#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
    //    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mySpaceCell"];
//    [cell setCellInfoWithModel:self.dataArr[indexPath.row]];
    //    cell.addressStr.tag = indexPath.row + 10000;
    //    cell.addressEdit.tag = indexPath.row + 20000;
    //    cell.addressDelete.tag = indexPath.row + 30000;
    //    [cell setCellInfoWithModel:_addressArr[indexPath.row]];
    //    [cell.addressStr addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigateAddress:)]];
    //    [cell.addressEdit addTarget:self action:@selector(editOftenAddress:) forControlEvents:UIControlEventTouchUpInside];
    //    [cell.addressDelete addTarget:self action:@selector(deleteOftenAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
