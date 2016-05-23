//
//  ZhengZuOrderCell.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/17.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ZhengZuOrderCell.h"
#import "RentOrder.h"

@implementation ZhengZuOrderCell

- (void)awakeFromNib {
    // Initialization code
}



- (void)setCellInfoWithRentOrder:(RentOrder *)order
{
    
    _order = order;
    _moneyLB.text    = [NSString stringWithFormat:@"金额：%@元",order.rentMoney];
    _addressLB.text  = [NSString stringWithFormat:@"地址：%@",order.parkAddress];

    
    _timeLB.text     = [NSString stringWithFormat:@"整租时间：%@",[Unit stringFromTimeInterval:order.orderTime/1000 formatterOrNil:@"yyyy.MM.dd"]];

    CGFloat deadLine = (order.orderTime/1000 + order.rentTime * 3600 * 24 * 30);
    
    _deadLIneLB.text = [NSString stringWithFormat:@"结束时间：%@",[Unit stringFromTimeInterval:deadLine formatterOrNil:@"yyyy.MM.dd"]];
    
    NSURL *url = [NSURL URLWithString:[SysURL stringByAppendingString:_order.parkImg]];
    [_imgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_img"]];
                  
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
