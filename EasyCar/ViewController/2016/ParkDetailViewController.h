//
//  ParkDetailViewController.h
//  EasyCar
//
//  Created by 易停科技－18 on 16/4/29.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "baseVC.h"
#import "Park.h"
#import "WoYaoTingCheVC.h"
@interface ParkDetailViewController : baseVC
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (nonatomic ,strong) Park *park;
@property (nonatomic ,strong) WoYaoTingCheVC *lastVC;
@property (nonatomic ) BOOL hiddenBottomBar;

@end
