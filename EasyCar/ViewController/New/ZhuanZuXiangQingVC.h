//
//  ZhuanZuXiangQingVC.h
//  EasyCar
//
//  Created by 橙晓侯 on 16/1/14.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "baseVC.h"
#import "RentInfo.h"
@interface ZhuanZuXiangQingVC : baseVC

@property (nonatomic, strong) RentInfo *info;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@end
