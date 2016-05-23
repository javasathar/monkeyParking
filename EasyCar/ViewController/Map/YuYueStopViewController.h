//
//  YuYueStopViewController.h
//  EasyCar
//
//  Created by zhangke on 15/5/20.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Park.h"
@interface YuYueStopViewController : baseVC<
    UITextFieldDelegate
>



@property (nonatomic, strong) NSDictionary *parkInfo;
@property (nonatomic, strong) NSString *timeStr;

@property (nonatomic, strong)IBOutlet UILabel *addressLabel;
@property (nonatomic, strong)IBOutlet UILabel *chooseCarLabel;

@property (strong, nonatomic) IBOutlet UILabel *chooseCouponLB;

@property (nonatomic, strong)IBOutlet UIButton *washBtn;
@property (nonatomic, strong)IBOutlet UIButton *chongBtn;
@property (nonatomic, strong)IBOutlet UILabel *chongLabel;
@property (nonatomic, strong)IBOutlet UILabel *washLabel;
@property (nonatomic, strong)IBOutlet UIButton *buyBtn;
@property (strong, nonatomic) IBOutlet UILabel *priceLB;

//@property (nonatomic, copy) NSString *shouldWash;
//@property (nonatomic, copy) NSString *shouldElec;
@property (nonatomic, strong) Car *car;
@property (nonatomic, strong) Park *park;
@end
