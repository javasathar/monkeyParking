//
//  MySpaceTableViewCell.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/11.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "MySpaceTableViewCell.h"

@implementation MySpaceTableViewCell
-(void)setCellInfoWithModel:(MySpaceModel *)model
{
    _selectBtn.layer.borderColor = RGBA(220, 220, 220, 1).CGColor;
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"yuan_select"] forState:UIControlStateSelected];
    _parkAddress.text = model.parkAddress;
    _parkName.text = model.parkName;
    NSInteger result = [model.result integerValue];
    switch (result) {
        case -1:
            _spaceState.text = @"订单开始";

            break;
        case 0:
            _spaceState.text = @"预约失败";
            break;
        case 1:
            _spaceState.text = @"待支付";

            break;
        case 2:
            _spaceState.text = @"正常";

            break;
        case 3:
            _spaceState.text = @"已取消";

            break;
        case 4:
            _spaceState.text = @"已转租";

            break;
            
        default:
            break;
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
