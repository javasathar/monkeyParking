//
//  YHQCell.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/10.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHQCell : BaseCell

@property (nonatomic, strong) Coupon *coupon;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *couponValueLB;
@property (strong, nonatomic) IBOutlet UILabel *timeLB;
@property (strong, nonatomic) IBOutlet UILabel *LocationLB;

- (void)setCellInfoWithCoupon:(Coupon *)coupon;
@end
