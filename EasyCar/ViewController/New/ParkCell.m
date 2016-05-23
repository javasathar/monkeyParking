//
//  ParkCell.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/28.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ParkCell.h"

@implementation ParkCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellInfo:(Park *)park
{
    _lb1.text = park.parkName;
    _lb2.text = [NSString stringWithFormat:@"剩余车位：%ld",(long)park.freeSpace];
    _lb3.text = park.address;
    _lb4.text = [NSString stringWithFormat:@"%@Km",park.distance];
    _freeLB.text = [NSString stringWithFormat:@"%ld",park.freeSpace];
    NSString *urlStr = [SysURL stringByAppendingString:park.comParkImg];
    NSURL *url = [NSURL URLWithString:urlStr];
    [_imgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_img"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
