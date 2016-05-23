//
//  CarTVCell.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/10.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *carBrandLB;
@property (strong, nonatomic) IBOutlet UILabel *carPlateLB;
@property (strong, nonatomic) IBOutlet UILabel *carModelLB;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic, strong) Car *car;

- (void)setCellInfo:(Car *)car;
@end
