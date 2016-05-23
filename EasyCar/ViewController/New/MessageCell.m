//
//  MessageCell.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/11.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellInfo:(PushInfo *)pushInfo
{
    _info = pushInfo;
    
    _titleLB.text = pushInfo.infoNotify;
    _creatTimeLB.text = [Unit stringFromTimeInterval:pushInfo.time/1000 formatterOrNil:@"yyyy-MM-dd"];
    
    if (pushInfo.type == 0) {
        // 未读
        _redIcon.hidden = NO;
//        _titleLB.textColor = [UIColor blackColor];
//        _creatTimeLB.textColor = [UIColor blackColor];
//        _detailLB.textColor = [UIColor blackColor];
    }
    else
    {
        // 已读
        _redIcon.hidden = YES;
//        _titleLB.textColor = [UIColor lightGrayColor];
//        _creatTimeLB.textColor = [UIColor lightGrayColor];
//        _detailLB.textColor = [UIColor lightGrayColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
