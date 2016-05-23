//
//  DayProfit.h
//  EasyCar
//
//  Created by 橙晓侯 on 16/1/15.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayProfit : NSObject

@property (nonatomic, assign) double money;

@property (nonatomic, strong) NSString *rentDay;
@property (nonatomic, strong) NSString *rentMonth;

@property (nonatomic, assign) double rentCount;

@property (nonatomic, strong) NSArray *rentList;

@property (nonatomic,assign) BOOL shouldHiden;
@end
