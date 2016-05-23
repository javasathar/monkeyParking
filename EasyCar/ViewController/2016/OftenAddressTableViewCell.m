//
//  OftenAddressTableViewCell.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/6.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "OftenAddressTableViewCell.h"

@implementation OftenAddressTableViewCell

-(void)setCellInfoWithModel:(OftenAddressModel *)model
{
    _addressStr.text = model.parkAddress;
    if ([model.addressType isEqualToString:@"Home"]) {
        _addressType.text = @"家庭";
        _addressImg.image = [UIImage imageNamed:@"addressHome"];
    }else if([model.addressType isEqualToString:@"company"])
    {
        _addressType.text = @"公司";
        _addressImg.image = [UIImage imageNamed:@"company"];
    }else if([model.addressType isEqualToString:@"other"])
    {
        _addressType.text = @"其他";
        _addressImg.image = [UIImage imageNamed:@"other"];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
