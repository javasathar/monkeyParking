//
//  ShouYiHeaderCell.h
//  EasyCar
//
//  Created by 橙晓侯 on 16/1/14.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayProfit.h"

@interface ShouYiHeaderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dateLB;
@property (strong, nonatomic) IBOutlet UILabel *rentTimeLB;
@property (strong, nonatomic) IBOutlet UILabel *rentProfitLB;
@property (strong, nonatomic) IBOutlet UIButton *arrowBtn
;


- (void)setCellInfo:(DayProfit *)dp;

@end
