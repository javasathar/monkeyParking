//
//  MyCarViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "MyCarViewController.h"
#import "TianJiaCheLiangVC.h"




@interface MyCarViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyCarViewController
{
    UITableView *_tableView;
    NSMutableArray *_carLists;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:AddCarSuccess object:nil];
    
    
    _carLists = [[NSMutableArray alloc] initWithCapacity:0];
    
    // Do any additional setup after loading the view.
    self.title = @"我的车辆";
    [self.nav setTitle:@"我的车辆" leftText:@"返回" rightTitle:@"添加" showBackImg:YES];
    self.view.backgroundColor = RGBA(242, 242, 248, 1);
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(tianjia)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    
//    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [self requestCarList];
//    }];
    
//    _tableView.estimatedRowHeight = 44;
    _tableView.rowHeight = 100;

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"CarTVCell" bundle:nil] forCellReuseIdentifier:@"CarTVCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self showCoverViewOn:_tableView title:nil image:nil handle:^{
        
        [self requestCarList];
    }];
    
    
    [self requestCarList];
    
    [self viewInitial];
}
#pragma mark 视图初始化
-(void)viewInitial
{
    UILabel *messageLB = [[UILabel alloc] initWithFrame:CGRectMake(Width * 0.5 - 100, Heigth -50, 200, 50)];
    messageLB.textAlignment = NSTextAlignmentCenter;
    messageLB.text = @"长按车辆删除";
    messageLB.textColor = [UIColor orangeColor];
    [self.view addSubview:messageLB];
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
    return _carLists.count;
}

#pragma mark ［配置单元格］
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CarTVCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"CarTVCell"];
    [cell setCellInfo:_carLists[indexPath.row]];
    
    return cell;
}

#pragma mark 单元格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarTVCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_selectType == selectForReturnValue) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ReturnCarInfo object:cell.car];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (_selectType == selectForDefaultAction)
    {
        
    }
}

#pragma mark 长按删除
- (void)onLongPressDelete:(CarTVCell *)cell
{
    [self showFunctionAlertWithTitle:@"提示" message:@"您确定要删除该车辆吗？" functionName:@"删除" Handler:^{
        
        [self requestDeleteCar:cell.car];
    }];
}

#pragma mark 请求车列表
- (void)requestCarList
{
    NSString *url = CarURL;
    NSDictionary *parameters = @{
                                 @"memberId":[UserManager manager].userID,
                                 @"pageNo":@"1",
                                 @"pageSize":@"100"
                                 };
    
    [self getRequestURL:url parameters:parameters success:^(NSDictionary *dic) {
        
        
        [_carLists removeAllObjects];
        for (NSDictionary *tempDic in dic[@"data"]) {

            Car *car = [Car mj_objectWithKeyValues:tempDic];
            [_carLists addObject:car];
        }
        [self removeCoverView];
        [_tableView reloadData];

        
    } elseAction:^(NSDictionary *dic) {
        
        [_carLists removeAllObjects];
        [_tableView reloadData];
        [self.coverView setTitle:dic[@"msg"] image:[UIImage imageNamed:@"icon_car_nomal"] handle:nil];


        
    } failure:^(NSError *error) {
        
    }];
}


/*
 31.判断车辆是否整租过车位
 测试地址：http://localhost:8080/ytcSystem/rest/api/member/carPlateRent
 http://localhost:8080/ytcSystem/rest/api/member/carPlateRent?memberId=402880e950b76f4b0150b76fba780000&carPlate=1
 测试参数：memberId=会员id
 carPlate=车牌
 返回参数：status:200,msg:车辆整租了车位,data:null
 status:300,msg:车辆无整租,data:null
 status:500,msg:请求异常,data:null
 
 */
#pragma mark 删除车辆(需判断是否有整租)
- (void)requestDeleteCar:(Car *)car
{
    NSString *url = BaseURL@"carPlateRent";
    NSDictionary *parameters = @{
                                 @"memberId":self.user.userID,
                                 @"carPlate":car.carPlate
                                  };

    [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        
        if ([dic[@"status"] isEqual:@(200)]) {
            // 有整租
            [MBProgressHUD showError:@"请勿删除有整租车位的车辆" toView:self.view];
        }
        else if ([dic[@"status"] isEqual:@(300)])
        {
            // 无整租
            
            NSString *url1 = BaseURL@"deleteCar";
            NSDictionary *parameters1 = @{
                                          @"carId":car.ID
                                          };
            
            [self getRequestURL:url1 parameters:parameters1 success:^(NSDictionary *dic) {
                
                [self requestCarList];
                [MBProgressHUD showResult:YES text:dic[@"msg"] delay:1];
                
            } elseAction:^(NSDictionary *dic) {
                
            } failure:^(NSError *error) {
                
            }];

        }
        else
        {
            [MBProgressHUD showError:dic[@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"报错：%@", [error localizedDescription]);
        [MBProgressHUD showError:@"网络加载失败" toView:self.view];
    }];
    
    
    
}



#pragma mark 再次刷新通知
- (void)notification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:AddCarSuccess]) {
        
        [self requestCarList];
    }
}

- (void)right
{
    [self tianjia];
}

- (void)tianjia
{
    
    [self.navigationController pushViewController:[Unit EPStoryboard:@"TianJiaCheLiangVC"] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
