//
//  AppointOrderCell.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/9.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "AppointOrderCell.h"
#import "AppointOrder.h"

@implementation AppointOrderCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setCellInfoWithAppointOrder:(AppointOrder *)order
{
//    _orderIdLB.text = [NSString stringWithFormat:@"订单号：%@",order.order_id];
//    
//    _appointTimeLB.text = [NSString stringWithFormat:@"预约时间：%@",[self stringFromTimeInterval:order.appoint_time/1000]];
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
