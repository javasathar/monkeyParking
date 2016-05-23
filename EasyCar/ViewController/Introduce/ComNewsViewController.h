//
//  ComNewsViewController.h
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComNewsViewController : baseVC<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic,assign) NSInteger vc_type;

@end
