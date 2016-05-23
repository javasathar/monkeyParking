//
//  OrderCarsViewController.h
//  EasyCar
//
//  Created by zhangke on 15/5/20.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCarsViewController : UIViewController
<
    UIAlertViewDelegate,
    UITextFieldDelegate
>
@property (nonatomic, strong) IBOutlet UIScrollView *_mainScrollView;
@property (nonatomic, strong) IBOutlet UILabel *bankLabel;
@property (nonatomic, strong) UIButton *zfBtn;
@end
