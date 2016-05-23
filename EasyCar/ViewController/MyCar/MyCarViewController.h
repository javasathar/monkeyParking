//
//  MyCarViewController.h
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarTVCell.h"
@interface MyCarViewController : baseVC

typedef NS_ENUM (NSUInteger, CarSelectType) {
    selectForDefaultAction,
    selectForReturnValue,
};

@property (nonatomic, assign) CarSelectType selectType;
- (void)onLongPressDelete:(CarTVCell *)cell;
@end
