//
//  BaseCell.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/24.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCell : UITableViewCell

#pragma mark 时间格式转换
- (NSString *)stringFromTimeInterval:(double)timeInterval;

@end
