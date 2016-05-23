//
//  WoYaoQuCheCell.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/16.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "WoYaoQuCheCell.h"
#import "CarParkingInfo.h"

@implementation WoYaoQuCheCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setCellInfo:(CarParkingInfo *)info
{
    //设置日期格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    
    // 后台给的时间是毫秒，所以要除1000
    NSTimeInterval inTime = info.inTime/1000;
    
    NSDate *inTimeDate = [NSDate dateWithTimeIntervalSince1970:inTime];
    
    _stayLB.text = [NSString stringWithFormat:@"时间：%@",[formatter stringFromDate:inTimeDate]];
    _carModelLB.text = [NSString stringWithFormat:@"车牌：%@",info.inCarPlate];
    _locationLB.text = [NSString stringWithFormat:@"位置：%@%@%@",info.address,info.parkArea,info.parkNo];
    
    
    NSString *newString = @"字段可能被取消了";
    NSMutableAttributedString *MAString = [[NSMutableAttributedString alloc] initWithAttributedString:_aTextLB.attributedText];
    
    [MAString replaceCharactersInRange:NSMakeRange(MAString.length -2, 1) withString:newString];
    _priceLB.attributedText = MAString;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
