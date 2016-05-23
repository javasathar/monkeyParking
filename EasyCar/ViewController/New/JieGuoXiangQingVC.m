//
//  JieGuoXiangQingVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 16/1/15.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "JieGuoXiangQingVC.h"

@interface JieGuoXiangQingVC ()

@end

@implementation JieGuoXiangQingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.nav setTitle:@"结果详情" leftText:@"返回" rightTitle:nil showBackImg:YES];
    
    _timeLB1.text = [Unit stringFromTimeInterval:_time1 formatterOrNil:@"MM-dd hh:mm"];
    _timeLB2.text = [Unit stringFromTimeInterval:_time2 formatterOrNil:@"MM-dd hh:mm"];
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
