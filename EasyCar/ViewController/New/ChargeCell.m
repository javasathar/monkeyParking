//
//  ChargeCell.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/22.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ChargeCell.h"
#import "ChargeRecord.h"
@implementation ChargeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellInfo:(ChargeRecord *)record
{
    if (record.type == 1) {
        
        _addressLB.text = @"充值金额：";
        _timeLB.text = [NSString stringWithFormat:@"充值时间：%@",[self stringFromTimeInterval:record.orderTime/1000]];
    }
    else
    {
        _addressLB.text = @"提现金额：";
        _timeLB.text = [NSString stringWithFormat:@"提现时间：%@",[self stringFromTimeInterval:record.orderTime/1000]];
    }
    
    _moneyLB.text = [NSString stringWithFormat:@"%.2f元",record.orderMoney];
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
