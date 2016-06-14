//
//  ParkingSpaceAreaViewController.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/12.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ParkingSpaceAreaViewController.h"
#import "SpaceNumViewController.h"
#import "MySpaceOrderViewController.h"
#import "ParkingSpaceModel.h"
@interface ParkingSpaceAreaViewController ()
@property (nonatomic ,strong)NSMutableArray *dataArr;
@property (nonatomic ,strong)NSMutableArray *spaceArr;
@property (nonatomic ,strong)NSMutableArray *btnArr;
@property (weak, nonatomic) IBOutlet UILabel *parkNameLB;
@end

@implementation ParkingSpaceAreaViewController
{
    UIView *parkView;
    NSDictionary *_mapDic;
}
-(NSMutableArray *)btnArr
{
    if (!_btnArr) {
        _btnArr = [NSMutableArray new];
    }
    return _btnArr;
}
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(NSMutableArray *)spaceArr
{
    if (!_spaceArr) {
        _spaceArr = [NSMutableArray new];
    }
    return _spaceArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.nav setTitle:@"请选择车库" leftText:nil rightTitle:nil showBackImg:YES];
    
    FileData *filedata = [[FileData alloc] init];
    //    if (_operateState) {
    //        _park = [Park new];
    //        _park.parkName = @"";
    //        _park.ID = @"8aafdae854a3048a0154a39042d10004";
    ////        _park.ID = @"00000000000000000000";
    //
    //    }
    NSDictionary *mapDic = [filedata checkupMapForMapName:_park.parkName];
    
    _mapDic = mapDic;
    //        NSLog(@"%@:%@",_park.parkName,mapDic);
    if ([filedata checkupFile:mapDic[@"imageName"]]) {
        [self showParkingMap:mapDic];
    }else
    {
        [self showParkingPlc];
    }
    if(_operateState)
    {
        [self checkParkingSpaceList];
    }
}
#warning ???
#pragma mark 刷新数据？
-(void)requestParkingSpaceList
{
    NSString *getUrl = BaseURL@"parkSpaceList";
    NSDictionary *parameterDic = @{
                                   @"parkId":_park.ID
                                   };
    AFHTTPRequestOperationManager *man = [AFHTTPRequestOperationManager manager];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [man GET:getUrl parameters:parameterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        NSDictionary *dic = responseObject;
        NSLog(@"getDic:%@",dic);
        if ([dic[@"status"] isEqual:@(200)]) {
            if ([[dic[@"data"] class] isSubclassOfClass:[NSMutableArray class]]) {
                NSArray *arr = dic[@"data"];
                [self.dataArr removeAllObjects];
                for (NSDictionary *dict in arr) {
                    ParkingSpaceModel *model = [[ParkingSpaceModel alloc] initWithDictionary:dict];
                    //                    NSLog(@"test%@",model.parkId);
                    [self.dataArr addObject:model];
                }
            }
        }
        else
        {
            //            [MBProgressHUD showError:dic[@"msg"] toView:Window];
            [MBProgressHUD showMessag:dic[@"msg"] toView:Window];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"%@",operation);
        
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        NSLog(@"报错：%@", [error localizedDescription]);
        [MBProgressHUD showError:@"网络加载出错" toView:Window];
    }];

}
#pragma mark 查询车库车位数据
-(void)checkParkingSpaceList
{
    NSString *getUrl = BaseURL@"parkSpaceList";
    NSDictionary *parameterDic = @{
                                   @"parkId":_park.ID
                                   };
    AFHTTPRequestOperationManager *man = [AFHTTPRequestOperationManager manager];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [man GET:getUrl parameters:parameterDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        NSDictionary *dic = responseObject;
        NSLog(@"getDic:%@",dic);
        if ([dic[@"status"] isEqual:@(200)]) {
            if ([[dic[@"data"] class] isSubclassOfClass:[NSMutableArray class]]) {
                NSArray *arr = dic[@"data"];
                [self.dataArr removeAllObjects];
                for (NSDictionary *dict in arr) {
                    ParkingSpaceModel *model = [[ParkingSpaceModel alloc] initWithDictionary:dict];
//                    NSLog(@"test%@",model.parkId);
                    [self.dataArr addObject:model];
                }
                if(_parkingNote)
                {
                    [self pickUp];

                }
            }
        }
        else
        {
            //            [MBProgressHUD showError:dic[@"msg"] toView:Window];
            [MBProgressHUD showMessag:dic[@"msg"] toView:Window];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"%@",operation);
        
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        NSLog(@"报错：%@", [error localizedDescription]);
        [MBProgressHUD showError:@"网络加载出错" toView:Window];
    }];
    
}
#pragma mark 展示缓存地图
-(void)showParkingMap:(NSDictionary *)dic
{
    self.parkNameLB.text = _park.parkName;
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *imagePath = [path stringByAppendingPathComponent:dic[@"imageName"]];
    NSDictionary *uiContent = dic[@"UIcontent"];
    NSArray *imageFrame = uiContent[@"frame"];
    //车库地图
    parkView = [[UIView alloc] initWithFrame:CGRectMake([imageFrame[0] floatValue] * Width, [imageFrame[1] floatValue] * Heigth, [imageFrame[2] floatValue] * Width, [imageFrame[3] floatValue] * Heigth)];
    [self.view addSubview:parkView];
    UIImageView *parkImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, parkView.width, parkView.height)];
    parkImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
    [parkView addSubview:parkImage];
    
    //plc按钮
    NSInteger i = 0;
    char c = 'A';
    for (NSArray *btnArr in uiContent[@"plcFrame"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[NSString stringWithFormat:@"%c",(char)(c + i)] forState:UIControlStateNormal];
        btn.tag = 120 + i++;
        btn.titleLabel.font = [UIFont systemFontOfSize:24];
        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake([btnArr[0] floatValue] * parkView.width, [btnArr[1] floatValue] * parkView.height, [btnArr[2] floatValue] * parkView.width, [btnArr[3] floatValue] * parkView.height)];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArr addObject:btn];
        [parkView addSubview:btn];
    }
}
#pragma mark 当本地没有缓存该车库地图时
-(void)showParkingPlc
{
    float plcWidth = Width / 9;
    char c = 'A';
    for (NSInteger j = 0; j < 3; j ++) {
        for (NSInteger i = 0 ; i < 4; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:[NSString stringWithFormat:@"%c",(char)(c + i + j * 4) ] forState:UIControlStateNormal];
            btn.tag = 120 + i + j * 4;
            btn.titleLabel.font = [UIFont systemFontOfSize:24];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [btn setFrame:CGRectMake(plcWidth * (i * 2 + 1), Width / 3 + plcWidth * ( j * 2.5 + 1), plcWidth, plcWidth)];
            
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnArr addObject:btn];

            [self.view addSubview:btn];
        }
    }
}
#pragma mark 点击车库
-(void)btnClick:(UIButton *)sender
{

    if (_operateState) {
        SpaceNumViewController *vc = [[SpaceNumViewController alloc] init];
        if (_mapDic) {
            vc.mapArr = _mapDic[@"UIcontent"][@"plcFrame"][sender.tag - 120];
        }
        vc.park = _park;
        vc.parkArea = sender.titleLabel.text;
        vc.opration = _opration;
        for (ParkingSpaceModel *model in self.dataArr) {
            if ([vc.parkArea isEqualToString:[model.parkArea substringWithRange:NSMakeRange(0, 1)]]) {
                [self.spaceArr addObject:model];
            }
        }
        if (self.spaceArr.count > 0) {
            vc.spaceArr = self.spaceArr;

        }
        if(_parkingNote)
        {
            vc.parkNo = _parkingNote[@"parkNo"];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        //下整租订单
        MySpaceOrderViewController *vc = [[MySpaceOrderViewController alloc] init];
        vc.park = _park;
        vc.parkArea = sender.titleLabel.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
#pragma mark 跳转至取车
-(void)pickUp
{
    NSString *parkArea = _parkingNote[@"parkArea"];
    for (UIButton *btn in self.btnArr) {
        if ([btn.titleLabel.text isEqualToString:[parkArea substringToIndex:1] ]) {
                [self btnClick:btn];
        }
    }

}
@end
