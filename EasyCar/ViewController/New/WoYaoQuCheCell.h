//
//  WoYaoQuCheCell.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/16.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CarParkingInfo;
@interface WoYaoQuCheCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIImageView *washIcon;
@property (strong, nonatomic) IBOutlet UIImageView *elecIcon;
@property (strong, nonatomic) IBOutlet UIImageView *shoppingIcon;

@property (strong, nonatomic) IBOutlet UILabel *carModelLB;
@property (strong, nonatomic) IBOutlet UILabel *locationLB;
@property (strong, nonatomic) IBOutlet UILabel *stayLB;
@property (strong, nonatomic) IBOutlet UILabel *priceLB;

@property (strong, nonatomic) IBOutlet UIButton *adBtn;
@property (strong, nonatomic) IBOutlet UIButton *quBtn;

@property (strong, nonatomic) IBOutlet UILabel *aTextLB;

- (void)setCellInfo:(CarParkingInfo *)info;





@end
