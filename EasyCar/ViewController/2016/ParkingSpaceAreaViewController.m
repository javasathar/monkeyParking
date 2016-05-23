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
@interface ParkingSpaceAreaViewController ()

@end

@implementation ParkingSpaceAreaViewController
{
    UIView *parkView;
    NSDictionary *_mapDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.nav setTitle:@"选择车库" leftText:nil rightTitle:nil showBackImg:YES];
    
    FileData *filedata = [[FileData alloc] init];
    if (_operateState) {
        _park = [Park new];
        _park.parkName = @"广州市钟村医院停车场";
        _park.ID = @"8aafdae854a3048a0154a39042d10004";
    }
    NSDictionary *mapDic = [filedata checkupMapForMapName:_park.parkName];
    
    _mapDic = mapDic;
//        NSLog(@"%@:%@",_park.parkName,mapDic);
    if ([filedata checkupFile:mapDic[@"imageName"]]) {
        [self showParkingMap:mapDic];
    }else
    {
        [self showParkingPlc];
    }
}
#pragma mark 展示缓存地图
-(void)showParkingMap:(NSDictionary *)dic
{
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
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
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

@end
