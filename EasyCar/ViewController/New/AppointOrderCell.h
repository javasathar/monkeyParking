//
//  AppointOrderCell.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/9.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppointOrder;

@interface AppointOrderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *orderIdLB;
@property (strong, nonatomic) IBOutlet UILabel *appointTimeLB;

- (void)setCellInfoWithAppointOrder:(AppointOrder *)order;

@end
