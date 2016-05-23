//
//  WoDeDingDanVC.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/7.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WoDeDingDanVC : baseVC

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)clickZhengZuBtn:(id)sender;

@property (nonatomic,assign) int pageIndex;// 需要展示哪个tableView
@end
