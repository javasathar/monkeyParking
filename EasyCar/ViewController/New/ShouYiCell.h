//
//  ShouYiCell.h
//  EasyCar
//
//  Created by 橙晓侯 on 16/1/14.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarProfit.h"
@interface ShouYiCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *carLB;
@property (strong, nonatomic) IBOutlet UILabel *begainLB;
@property (strong, nonatomic) IBOutlet UILabel *endLB;
@property (strong, nonatomic) IBOutlet UILabel *profitLB;

- (void)setCellInfo:(CarProfit *)cp;
@end
