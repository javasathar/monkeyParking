//
//  RentInfo.h
//  EasyCar
//
//  Created by 橙晓侯 on 16/1/13.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RentInfo : NSObject

@property (nonatomic, assign) BOOL condition;
@property (nonatomic, strong) NSString *parkArea;
@property (nonatomic, strong) NSString *spaceId;
@property (nonatomic, strong) NSString *parkNo;
@property (nonatomic, strong) NSString *rentPlate;
@property (nonatomic, strong) NSString *address;

@end


