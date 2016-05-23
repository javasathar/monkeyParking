//
//  YuYueOrderViewController.h
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/5.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "baseVC.h"
#import "Park.h"
@interface YuYueOrderViewController : baseVC
@property (nonatomic ,strong) Park *park;
@property (nonatomic ,strong ) NSString *orderID;
@end
