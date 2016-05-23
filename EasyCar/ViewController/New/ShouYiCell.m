//
//  ShouYiCell.m
//  EasyCar
//
//  Created by 橙晓侯 on 16/1/14.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ShouYiCell.h"

@implementation ShouYiCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellInfo:(CarProfit *)cp
{
    NSMutableString *mstr = [NSMutableString stringWithString:cp.carPlate];
    [mstr replaceCharactersInRange:NSMakeRange(2, 4) withString:@"****"];
    _carLB.text = [NSString stringWithFormat:@"车辆：%@",mstr];
    
    _begainLB.text = [NSString stringWithFormat:@"开始时间：%@",[Unit stringFromTimeInterval:cp.inTime/1000 formatterOrNil:nil]];
    _endLB.text = [NSString stringWithFormat:@"结束时间：%@",[Unit stringFromTimeInterval:cp.outTime/1000 formatterOrNil:nil]];
    _profitLB.text = [NSString stringWithFormat:@"收益：%.1f元",cp.parkFee];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
