//
//  SpaceNumViewController.h
//  EasyCar
//
//  Created by 易停科技－18 on 16/5/12.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "baseVC.h"
#import "Park.h"
@interface SpaceNumViewController : baseVC
@property (nonatomic ,strong)NSArray *mapArr;
@property (nonatomic ,strong)Park *park;
@property (nonatomic ,strong)NSString *parkArea;
@property (nonatomic ,strong)NSNumber *opration;
@end
