//
//  ComHisCell.m
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ComHisCell.h"

@implementation ComHisCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 100, 52)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.image = [UIImage imageNamed:@"zhanweitu"];
        _imgView.clipsToBounds = YES;
        [self addSubview:_imgView];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.right+10, 14, UI_SCREEN_WIDTH-_imgView.right-15, 40)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_contentLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.right+10, 54, 100, 15)];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = RGBA(160, 160, 160, 1);
        [self addSubview:_timeLabel];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 79.5, UI_SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGBA(220, 220, 220, 1);
        [self addSubview:line];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}


- (void)setCellInfo:(ComNews *)comNews{
    
    NSURL *url = [NSURL URLWithString:[SysURL stringByAppendingString:comNews.infoimg]];
    [_imgView setImageWithURL:url];
    _contentLabel.text = comNews.title;
    _timeLabel.text = [Unit stringFromTimeInterval:comNews.createtime/1000 formatterOrNil:@"yyyy.MM.dd"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
