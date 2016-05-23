//
//  ComHisCell.h
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComNews.h"

@interface ComHisCell : UITableViewCell
@property (nonatomic, strong)UIImageView *imgView;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong) ComNews *comNews;

- (void)setCellInfo:(ComNews *)comNews;
@end
