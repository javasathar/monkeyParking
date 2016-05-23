//
//  MySpaceTableViewCell.h
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/11.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySpaceModel.h"
@interface MySpaceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *parkName;
@property (weak, nonatomic) IBOutlet UILabel *parkAddress;
@property (weak, nonatomic) IBOutlet UILabel *spaceState;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
-(void)setCellInfoWithModel:(MySpaceModel *)model;
@end
