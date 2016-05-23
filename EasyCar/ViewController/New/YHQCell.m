//
//  YHQCell.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/10.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "YHQCell.h"

@implementation YHQCell

- (void)setCellInfoWithCoupon:(Coupon *)coupon
{
    _coupon = coupon;
    
//    _imgView.image = [UIImage imageNamed:@"djinquan1.png"];
    NSURL *url = [NSURL URLWithString:[SysURL stringByAppendingPathComponent:coupon.couponimg]];
    if (coupon.couponimg.length == 0) {
        _imgView.image = [UIImage imageNamed:@"img13"];

    }else
    {
        [_imgView setImageWithURL:url];

    }
    _couponValueLB.text = [NSString stringWithFormat:@"金额：%.1f元",coupon.amount];
    _timeLB.text = [NSString stringWithFormat:@"截止时间：%@",[self stringFromTimeInterval:coupon.endTime/1000]];
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
