//
//  SelectParkingSpaceCell.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/16.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentInfo.h"

@interface SelectParkingSpaceCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *areaLB;
@property (strong, nonatomic) IBOutlet UILabel *parkLB;
@property (strong, nonatomic) IBOutlet UILabel *carLB;
@property (nonatomic, strong) RentInfo *info;
@property (strong, nonatomic) IBOutlet UIButton *rentBtn;

- (void)setCellInfo:(RentInfo *)dic;
@end
