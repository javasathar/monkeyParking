//
//  CarOrderViewController.h
//  EasyCar
//
//  Created by zhangke on 15/5/18.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarOrderViewController : UIViewController
<
    UIAlertViewDelegate
>

@property (nonatomic, strong) IBOutlet UIScrollView *_mainScrollView;
@property (nonatomic, strong) IBOutlet UILabel *bankLabel;
@property (nonatomic, strong) UIButton *zfBtn;
@property (nonatomic, assign) int count;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) float price;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

@end
