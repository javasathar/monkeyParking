//
//  PushInfo.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/11.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushInfo : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, assign) double type;
@property (nonatomic, assign) double time;
@property (nonatomic, strong) NSString *infoNotify;

@end
