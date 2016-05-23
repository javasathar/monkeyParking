//
//  ShouYiHeaderCell.m
//  EasyCar
//
//  Created by 橙晓侯 on 16/1/14.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ShouYiHeaderCell.h"

@implementation ShouYiHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellInfo:(DayProfit *)dp
{
    _dateLB.text = [NSString stringWithFormat:@"%@月%@日",dp.rentMonth,dp.rentDay];
    _rentTimeLB.text = [NSString stringWithFormat:@"转租次数：%.0f",dp.rentCount];
    _rentProfitLB.text = [NSString stringWithFormat:@"转租收益：%.1f元",dp.money];

    // 箭头方向额
    dp.shouldHiden ? [_arrowBtn setImage:[UIImage imageNamed:@"cell_down_arrow"] forState:UIControlStateNormal] : [_arrowBtn setImage:[UIImage imageNamed:@"cell_up_arrow"] forState:UIControlStateNormal];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
