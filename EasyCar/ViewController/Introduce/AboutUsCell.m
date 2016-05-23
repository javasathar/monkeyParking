//
//  AboutUsCell.m
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "AboutUsCell.h"

@implementation AboutUsCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _imgviEW = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 35, 35)];
        [self addSubview:_imgviEW];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imgviEW.right+15, 0, 200, 45)];
        _nameLabel.textColor = RGBA(36, 36, 36, 1);
        [self addSubview:_nameLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, UI_SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGBA(220, 220, 220, 1);
        [self addSubview:line];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
