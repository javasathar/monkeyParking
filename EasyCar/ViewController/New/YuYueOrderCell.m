//
//  YuYueOrderCell.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/17.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "YuYueOrderCell.h"
#import "AppointOrder.h"

@implementation YuYueOrderCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setCellInfoWithAppointOrder:(AppointOrder *)order
{
    _order = order;

    _moneyLB.text = [NSString stringWithFormat:@"金额：%@元",order.appointMoney];
    _addressLB.text = [NSString stringWithFormat:@"地址：%@",order.parkAddress];
    _timeLB.text = [NSString stringWithFormat:@"预约时间：%@",[self stringFromTimeInterval:order.appointTime/1000]];
    
    NSURL *url = [NSURL URLWithString:[SysURL stringByAppendingString:_order.parkImg]];
    [_imgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_img"]];
    if (order.type == 1) {
        _stateLB.text = @"已预约";
    }
    if (order.type == 2) {
        _stateLB.text = @"使用中";
    }
    if (order.type == 3) {
        _stateLB.text = @"已过期";
    }
    if (order.type == 4) {
        _stateLB.text = @"已完成";
    }
}

#pragma mark 时间格式转换
- (NSString *)stringFromTimeInterval:(double)timeInterval
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSDate *inTimeDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [formatter stringFromDate:inTimeDate];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
