//
//  XiCheCell.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/18.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "XiCheCell.h"

@implementation XiCheCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellInfoWithDic:(NSDictionary *)dic
{
    
    //设置日期格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    
    NSTimeInterval inTime = [dic[@"inTime"] doubleValue];
    
    NSDate *inTimeDate = [NSDate dateWithTimeIntervalSince1970:inTime];
    
    _stayLB.text = [NSString stringWithFormat:@"时间：%@",[formatter stringFromDate:inTimeDate]];
    _carModelLB.text = [NSString stringWithFormat:@"车牌：%@",dic[@"inCarPlate"]];
    _locationLB.text = [NSString stringWithFormat:@"位置：%@",dic[@"address"]];
    
    
    NSString *newString = @"数据缺失";
    NSMutableAttributedString *MAString = [[NSMutableAttributedString alloc] initWithAttributedString:_aTextLB.attributedText];
    
    [MAString replaceCharactersInRange:NSMakeRange(MAString.length -2, 1) withString:newString];
    _priceLB.attributedText = MAString;
    
}

- (IBAction)onWoYaoXiChe:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
