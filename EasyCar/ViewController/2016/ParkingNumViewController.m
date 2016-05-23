//
//  ParkingNumViewController.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/4/12.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ParkingNumViewController.h"
#import "PlcData.h"
@interface ParkingNumViewController ()
@property (nonatomic ,strong)UIButton *parkingBtn;
@property (nonatomic ,strong)NSMutableArray *btnArr;
@property (nonatomic ,strong)UILabel *remind;
@end

@implementation ParkingNumViewController
{
    UIButton *selectBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.nav setTitle:@"请选择车位" leftText:@"返回" rightTitle:nil showBackImg:YES];
    [self viewInitial];
}
- (void)viewInitial
{
    //停车按钮
    _parkingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_parkingBtn setFrame:CGRectMake(10, Heigth - 50, Width - 20 , 40)];
    [_parkingBtn setBackgroundColor:RGBA(40, 125, 195, 1.0)];
    [_parkingBtn setTitle:@"一键停车" forState:UIControlStateNormal];
    _parkingBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:_parkingBtn];
    [_parkingBtn addTarget:self action:@selector(parkingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.btnArr = [[NSMutableArray alloc] init];
//    NSLog(@"%@",_mapArr);
    NSInteger list = [_mapArr[5] integerValue]; //列
    NSInteger storey = [_mapArr[6] integerValue];  //层
    
    UIView *parkView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, Width, Width)];
    float parkFloat = Width / 6;
    for (NSInteger i = list - 1; i >= 0; i --) {
        for (NSInteger j = storey - 1; j >= 0; j --) {
            if (j != 0 && i == list - 1) {
                
            }else
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(Width / 2 - parkFloat * list / 2 + parkFloat * i, Width / 2 - parkFloat * storey / 2 + parkFloat * j, parkFloat, parkFloat - 10)];
                [btn setImage:[UIImage imageNamed:@"nullcar"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"r"] forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(spaceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = (storey - j ) * 100 + i + 1;
                [parkView addSubview:btn];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Width / 2 - parkFloat * list / 2 + parkFloat * i,Width / 2 - parkFloat * storey / 2 + parkFloat * (j + 1) - 10, parkFloat, 10)];
                label.tag = btn.tag + 10000;
                label.textColor = [UIColor grayColor];
                label.text = [NSString stringWithFormat:@"%ld", btn.tag];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:10];
                [parkView addSubview:label];
                
                [self.btnArr addObject:@{@"btn":btn,@"label":label}];
            }
        }
    }
    
    [self.view addSubview:parkView];
    
    [[PlcData shareInitial] wantToSearchParkingWith:(int)_plcNum andList:list andStorey:storey andSuccess:^(id obj) {
        NSMutableArray *objArr = (NSMutableArray *)obj;
//        NSArray *objArr = @[@"@00RD00000000010000000000000000000000000000000057*\r",
//                            @"@00RD00000000010000000000000000000000000000000057*\r",
//                            @"@00RD00000000010000000000000000000000000000000057*\r",
//                            @"@00RD00000000010000000000000000000000000000000057*\r",
//                            @"@00RD00000000010000000000000000000000000000000057*\r",
//                            @"@00RD00000000010000000000000000000000000000000057*\r",];
        for (NSInteger j = 0 ; j < objArr.count ; j ++) {
            NSString *objStr = objArr[j];
            if (objStr.length > 50) {
                NSString *rangObjStr = [objStr substringWithRange:NSMakeRange(7, 40)];
                for (NSInteger i = 0 ; i < 10 ; i ++) {
                    NSString *have = [rangObjStr substringWithRange:NSMakeRange(i * 4 + 3, 1)];
                    if ([have isEqualToString:@"1"]) {
                        UIButton *btn = [self.view viewWithTag:(j + 1 ) * 100 + i + 1];
                        NSLog(@"%d",(int)btn.tag);
//                        UILabel *label = [self.view viewWithTag:(storey - j ) * 100 + i + 1001];
                        if (btn) {
                            [btn setImage:[UIImage imageNamed:@"b"] forState:UIControlStateNormal];
//                            btn.enabled = NO;
                        }

                    }
                }
            }
        }
    } orFailed:^(id obj) {
        NSLog(@"%@",obj);
        [MBProgressHUD showResult:NO text:@"无法查询到车库停车情况" delay:3.0f];
    }];
}
-(void)spaceBtnClick:(UIButton *)sender
{
    selectBtn.selected = NO;
    sender.selected = !sender.selected;
    selectBtn = sender;
}
-(void)parkingBtnClick:(UIButton *)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (selectBtn) {
        [[PlcData shareInitial] wantToParkingWithPlc:(int)_plcNum andParkingSpace:[NSString stringWithFormat:@"%d",(int)selectBtn.tag] andSuccess:^(id obj) {
//            NSString *objStr = obj;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            [MBProgressHUD showResult:YES text:[NSString stringWithFormat:@"正在为您下放%ld载车板",(long)selectBtn.tag] delay:5.0f];
            [[NSUserDefaults standardUserDefaults] setObject:@{@"plcTag":[NSString stringWithFormat:@"%ld",(long)_plcNum],@"parkingNum":[NSString stringWithFormat:@"%ld",(long)selectBtn.tag]} forKey:@"parkingList"];
            [[NSUserDefaults standardUserDefaults] synchronize];
                        [self performSelector:@selector(backmain) withObject:nil afterDelay:3.0f];
        } orFailed:^(id obj) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSString * str = obj;
            if ([str isEqualToString:@"1"]) {
                [MBProgressHUD showResult:NO text:@"该车位有车" delay:3.0f];

            }else{
                [MBProgressHUD showResult:NO text:@"车库繁忙中" delay:3.0f];

            }
        }];
    }else
    {
        [[PlcData shareInitial] wantToParkingWithPlc:(int)_plcNum andSuccess:^(id obj) {
            NSString *objStr = obj;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            [MBProgressHUD showResult:YES text:[NSString stringWithFormat:@"正在为您下放%@载车板",objStr] delay:5.0f];
            [[NSUserDefaults standardUserDefaults] setObject:@{@"plcTag":[NSString stringWithFormat:@"%ld",(long)_plcNum],@"parkingNum":objStr} forKey:@"parkingList"];
            [[NSUserDefaults standardUserDefaults] synchronize];
                        [self performSelector:@selector(backmain) withObject:nil afterDelay:3.0f];
        } orFailed:^(id obj) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showResult:NO text:@"车库繁忙中" delay:3.0f];
        }];
    }
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//}
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
-(void)backmain
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
