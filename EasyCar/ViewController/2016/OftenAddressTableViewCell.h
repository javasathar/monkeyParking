//
//  OftenAddressTableViewCell.h
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/6.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OftenAddressModel.h"
@interface OftenAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *addressImg;
@property (weak, nonatomic) IBOutlet UILabel *addressType;
@property (weak, nonatomic) IBOutlet UILabel *addressStr;
@property (weak, nonatomic) IBOutlet UIButton *addressEdit;
@property (weak, nonatomic) IBOutlet UIButton *addressDelete;
-(void)setCellInfoWithModel:(OftenAddressModel *)model;
@end
