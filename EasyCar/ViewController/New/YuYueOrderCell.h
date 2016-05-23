//
//  YuYueOrderCell.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/17.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointOrder.h"

@interface YuYueOrderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *timeLB;
@property (strong, nonatomic) IBOutlet UILabel *addressLB;
@property (strong, nonatomic) IBOutlet UILabel *moneyLB;
@property (nonatomic, strong) AppointOrder *order;
@property (strong, nonatomic) IBOutlet UILabel *stateLB;


- (void)setCellInfoWithAppointOrder:(AppointOrder *)order;
@end