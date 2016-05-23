//
//  ChooseTimeViewController.h
//  EasyCar
//
//  Created by zhangke on 15/5/20.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseTimeViewController : UIViewController<
    UIPickerViewDataSource,
    UIPickerViewDelegate
>

@property (nonatomic, assign)BOOL ismonth;

@end
