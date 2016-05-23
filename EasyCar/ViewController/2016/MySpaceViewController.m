//
//  MySpaceViewController.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/11.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "MySpaceViewController.h"
#import "MySpaceModel.h"
#import "MySpaceTableViewCell.h"
#import "WoYaoTingCheVC.h"
#import "TransferViewController.h"
@interface MySpaceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)NSMutableArray *dataArr;
@property (nonatomic ,strong)UITableView *dataTabel;
@end

@implementation MySpaceViewController
{
    UIButton *historyBtn;
}
-(UITableView *)dataTabel
{
    
    if (!_dataTabel) {
        _dataTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Heigth -64-100) style:UITableViewStylePlain];
        _dataTabel.backgroundColor = RGBA(240, 240, 240, 1);
        _dataTabel.dataSource = self;
        _dataTabel.delegate = self;
        _dataTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dataTabel.estimatedRowHeight = 60;
        [_dataTabel registerNib:[UINib nibWithNibName:@"MySpaceTableViewCell" bundle:nil] forCellReuseIdentifier:@"mySpaceCell"];
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
    [self.nav setTitle:@"专用车位" leftText:nil rightTitle:nil showBackImg:YES];
    [self.nav.rightImageBtn setImage:[Unit changeImage:[UIImage imageNamed:@"iconfont_tianjia"] toScale:2] forState:UIControlStateNormal];
    
    [self.view addSubview:self.dataTabel];
    
    [self addCoverView];
//    NSLog(@"%@",self.user.userID);
    
}
-(void)addCoverView
{
    self.coverView = [[NSBundle mainBundle] loadNibNamed:@"CoverView" owner:nil options:nil][0];
    self.coverView.frame = self.dataTabel.bounds;
    self.coverView.tag = 100;
    [self.coverView setTitle:@"努力加载中" image:[UIImage imageNamed:@"zhanweitu-1"] handle:^{
        
    }];
    
    [self.dataTabel addSubview:self.coverView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
}
#pragma mark 添加车位
-(void)right
{
    WoYaoTingCheVC * vc = [[WoYaoTingCheVC alloc] init];
    vc.mapType = 3;
    vc.lastVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 刷新数据
-(void)requestData
{
    NSLog(@"刷新数据");
    NSString *getUrl = BaseURL@"myRentSpace";
    NSDictionary *parametersDic = @{@"memberId":[UserManager manager].userID,
//                                    @"pageNo":@1,
//                                    @"pageSize":@10,
                                    };
//    NSLog(@"%@?memberId:%@&pageNo:1&pageSize:20",getUrl,[UserManager manager].userID);

    [self getRequestURL:getUrl parameters:parametersDic success:^(NSDictionary *dic) {
        [self.coverView removeFromSuperview];
        NSLog(@"%@",dic);
        if (![dic[@"data"] isEqual:[NSNull null]]) {
            [self.dataArr removeAllObjects];
            for (NSDictionary *dict in dic[@"data"]) {
                MySpaceModel *model = [[MySpaceModel alloc] initWithDict:dict];
                [self.dataArr addObject:model];
                
            }
        }
        
        [self.dataTabel reloadData];
    } elseAction:^(NSDictionary *dic) {
        
        [self.coverView setTitle:@"无信息" image:[UIImage imageNamed:@"icon_car_nomal"] handle:nil];

    } failure:^(NSError *error) {
        [self.coverView setTitle:error.localizedDescription image:[UIImage imageNamed:@"icon_car_nomal"] handle:nil];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
//    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MySpaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mySpaceCell"];
    if (self.dataArr.count > indexPath.row) {
        [cell setCellInfoWithModel:self.dataArr[indexPath.row]];
    }
    
    cell.selectBtn.tag = indexPath.row + 10000;
    [cell.selectBtn addTarget:self action:@selector(cellSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.clickBtn.tag = indexPath.row + 20000;
    [cell.clickBtn addTarget:self action:@selector(cellClickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    cell.addressStr.tag = indexPath.row + 10000;
//    cell.addressEdit.tag = indexPath.row + 20000;
//    cell.addressDelete.tag = indexPath.row + 30000;
//    [cell setCellInfoWithModel:_addressArr[indexPath.row]];
//    [cell.addressStr addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigateAddress:)]];
//    [cell.addressEdit addTarget:self action:@selector(editOftenAddress:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.addressDelete addTarget:self action:@selector(deleteOftenAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
#pragma mark 点击cell
-(void)cellClickBtnClick:(UIButton *)sender
{
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"操控车库" message:@"停取车" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *handleAction1 = [UIAlertAction actionWithTitle:@"停车" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self mySpaceParkingOrPickUp:0 and:sender];
    }];
    UIAlertAction *handleAction2 = [UIAlertAction actionWithTitle:@"取车" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self mySpaceParkingOrPickUp:1 and:sender];

    }];
    [alertCtl addAction:cancelAction];
    [alertCtl addAction:handleAction1];
    [alertCtl addAction:handleAction2];

    [self presentViewController:alertCtl animated:YES completion:nil];
}
#pragma mark 专用车位停取车
-(void)mySpaceParkingOrPickUp:(NSInteger)num and:(UIButton *)sender
{
    NSNumber *opration = @1;
    if (num) {
        opration = @2;
    }
    NSString *getUrl = BaseURL@"remoteParkOrTakeCar";
    MySpaceModel *model = self.dataArr[sender.tag - 20000];
    NSDictionary *parameterDic = @{
                                   @"memberId":self.user.userID,
                                   @"parkId":model.parkId,
//                                   @"parkArea":model.parkArea,
                                   @"parkArea":@"A",
                                   @"spaceNo":model.parkNo,
                                   @"operation":opration
                                   
                                   };
    [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
        [MBProgressHUD showResult:YES text:dic[@"msg"] delay:1.5f];
    } elseAction:^(NSDictionary *dic) {
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark 点击cell左边
-(void)cellSelectBtnClick:(UIButton*)sender
{
    historyBtn.selected = NO;
    historyBtn = sender;
    sender.selected = YES;
}
#pragma mark 转租收益
- (IBAction)checkTransfer:(id)sender {
    TransferViewController *vc = [[TransferViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 转租
- (IBAction)rentTran:(id)sender {
    if (!historyBtn) {
        return;
    }
    NSString *getUrl = BaseURL@"rentTran";
    MySpaceModel *model = self.dataArr[historyBtn.tag - 10000];
    if ([model.result isEqual:@4]) {
        [MBProgressHUD showResult:YES text:@"已转租" delay:1.0f];

    }
    NSDictionary *parameterDic = @{
                                   @"id":model.parkspaceId,
                                   @"startDay":[Unit getTimeWithFormat:@"yyyyMMdd"],
                                   @"endDay":@"20160610"
                                   };
    NSLog(@"parameterDic:%@",parameterDic);
    [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
        [MBProgressHUD showSuccess:dic[@"msg"] toView:Window];
        if (![dic[@"data"] isEqual:[NSNull null]]) {
            [self checkRentTranResult:dic[@"data"]];
        }
    } elseAction:^(NSDictionary *dic) {
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark 转租结果查询
-(void)checkRentTranResult:(NSString *)orderID
{
    NSString *getUrl = BaseURL@"getStatus/rentTran";
    NSDictionary *parameterDic = @{
                                   @"id":orderID
                                   };
    [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
        [MBProgressHUD showSuccess:dic[@"msg"] toView:Window];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(requestData) withObject:nil afterDelay:1.0f];
        });
    } elseAction:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(requestData) withObject:nil afterDelay:1.0f];
        });
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark 取消转租
- (IBAction)cancelRentTran:(id)sender {
    if(!historyBtn)
    {
        return;
    }
    NSString *getUrl = BaseURL@"rentTranCancel";
    MySpaceModel *model = self.dataArr[historyBtn.tag - 10000];
    if (![model.result isEqual:@4]) {
        [MBProgressHUD showResult:YES text:@"已取消转租" delay:1.0f];
        
    }
    NSDictionary *parameterDic = @{
                                   @"id":model.parkspaceId,
                                   @"supsid":model.orderId
                                   };
//    NSLog(@"parameterDic:%@",parameterDic);
    [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
        [MBProgressHUD showSuccess:dic[@"msg"] toView:Window];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestData];
            [self performSelector:@selector(requestData) withObject:nil afterDelay:1.0f];
        });
    } elseAction:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(requestData) withObject:nil afterDelay:1.0f];
        });
    } failure:^(NSError *error) {
        
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

@end
