//
//  ConsumeCell.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/22.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConsumeRecord;

@interface ConsumeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *addressLB;
@property (strong, nonatomic) IBOutlet UILabel *timeLB;
@property (strong, nonatomic) IBOutlet UILabel *moneyLB;
@property (strong, nonatomic) IBOutlet UILabel *stateLB;

@property (nonatomic, strong) ConsumeRecord *record;

- (void)setCellInfo:(ConsumeRecord *)record;

@end
