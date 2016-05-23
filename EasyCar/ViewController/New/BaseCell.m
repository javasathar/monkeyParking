//
//  BaseCell.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/24.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark 时间格式转换
- (NSString *)stringFromTimeInterval:(double)timeInterval
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSDate *inTimeDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [formatter stringFromDate:inTimeDate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
