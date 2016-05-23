//
//  SpaceNumViewController.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/12.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "SpaceNumViewController.h"
#import "MySpaceOrderViewController.h"
@interface SpaceNumViewController ()
@property (nonatomic ,strong)NSMutableArray *btnArr;
@property (nonatomic ,strong)UIButton *addBtn;
@end

@implementation SpaceNumViewController
{
    UIButton *selectBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.nav setTitle:@"选择车位" leftText:nil rightTitle:nil showBackImg:YES];
    [self viewInitial];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewInitial
{
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setFrame:CGRectMake(10, Heigth - 50, Width - 20 , 40)];
    [_addBtn setBackgroundColor:RGBA(40, 125, 195, 1.0)];
    [_addBtn setTitle:@"提交" forState:UIControlStateNormal];
    _addBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:_addBtn];
    [_addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
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
                label.text = [NSString stringWithFormat:@"%ld",(long) btn.tag];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:10];
                [parkView addSubview:label];
                
                [self.btnArr addObject:@{@"btn":btn,@"label":label}];
            }
        }
    }
    
    [self.view addSubview:parkView];
}
-(void)spaceBtnClick:(UIButton *)sender
{
    selectBtn.selected = NO;
    sender.selected = !sender.selected;
    selectBtn = sender;
}
-(void)addBtnClick:(UIButton *)sender
{
    if (selectBtn) {
//        MySpaceOrderViewController *vc = [[MySpaceOrderViewController alloc] init];
//        vc.park = _park;
//        vc.parkArea = _parkArea;
//        vc.parkNO = [NSString stringWithFormat:@"%ld",(long)selectBtn.tag];
//        [self.navigationController pushViewController:vc animated:YES];
        
        NSString *getUrl = BaseURL@"remoteParkOrTakeCar";
        NSDictionary *parameterDic = @{
                                       @"memberId":self.user.userID,
                                       @"parkId":_park.ID,
                                       @"parkArea":_parkArea,
                                       @"spaceNo":[NSString stringWithFormat:@"%ld",(long) selectBtn.tag],
                                       @"operation":_opration
                                       
                                       };
        [self getRequestURL:getUrl parameters:parameterDic success:^(NSDictionary *dic) {
            [MBProgressHUD showResult:YES text:dic[@"msg"] delay:1.5f];
        } elseAction:^(NSDictionary *dic) {
            
        } failure:^(NSError *error) {
            
        }];
    }

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
