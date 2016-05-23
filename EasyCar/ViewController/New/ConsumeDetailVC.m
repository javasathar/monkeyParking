//
//  ConsumeDetailVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/22.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ConsumeDetailVC.h"

@interface ConsumeDetailVC ()
@property (strong, nonatomic) IBOutlet UILabel *appotinTimeLB;
@property (strong, nonatomic) IBOutlet UILabel *inTimeZD;
@property (strong, nonatomic) IBOutlet UILabel *inTimeCK;
@property (strong, nonatomic) IBOutlet UILabel *outTimeCK;
@property (strong, nonatomic) IBOutlet UILabel *outTimeZD;
@property (strong, nonatomic) IBOutlet UILabel *totalTime;
@property (strong, nonatomic) IBOutlet UILabel *PMCK_Time;
@property (strong, nonatomic) IBOutlet UILabel *LTCK_Time;
@property (strong, nonatomic) IBOutlet UILabel *moneyLB;

@end

@implementation ConsumeDetailVC

- (void)setDetail
{
    if (_record) {
        
        _appotinTimeLB.text = [Unit stringFromTimeInterval:_record.appointTime/1000 formatterOrNil:nil];
        _inTimeZD.text = [Unit stringFromTimeInterval:_record.inTime/1000 formatterOrNil:nil];
        _inTimeCK.text = [Unit stringFromTimeInterval:_record.inSpaceTime/1000 formatterOrNil:nil];
        _outTimeCK.text = [Unit stringFromTimeInterval:_record.outSpaceTime/1000 formatterOrNil:nil];
        _outTimeZD.text = [Unit stringFromTimeInterval:_record.outTime/1000 formatterOrNil:nil];
//        _totalTime.text = [Unit stringFromTimeInterval:_record.time/1000];
//        _outTimeZD.text = [Unit stringFromTimeInterval:_record.outTime/1000];
//        _outTimeZD.text = [Unit stringFromTimeInterval:_record.outTime/1000];
//        _outTimeZD.text = [Unit stringFromTimeInterval:_record.outTime/1000];
//        _outTimeZD.text = [Unit stringFromTimeInterval:_record.outTime/1000];
        _moneyLB.text = [NSString stringWithFormat:@"%.1f",_record.parkFee];
        
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nav setTitle:@"消费详情" leftText:@"返回" rightTitle:nil showBackImg:YES];
    [self setDetail];
    
    // Do any additional setup after loading the view.
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
