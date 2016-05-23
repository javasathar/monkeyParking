//
//  ConsumeCell.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/22.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ConsumeCell.h"
#import "consumeRecord.h"
@implementation ConsumeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellInfo:(ConsumeRecord *)record
{
    _record = record;
    _addressLB.text = record.parkName;
    _timeLB.text = [self stringFromTimeInterval:record.appointTime/1000];
    _moneyLB.text = [NSString stringWithFormat:@"%.2f元",record.parkFee];
    _stateLB.text = @"交易成功";
}

#pragma mark 时间转换 double
- (NSString *)stringFromTimeInterval:(double)timeInterval
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [formatter stringFromDate:date];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
