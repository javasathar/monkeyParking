//
//  ComNews.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/30.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComNews : NSObject

@property (nonatomic, strong) NSString *infoimg;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) double createtime;
@property (nonatomic, assign) double type;
@property (nonatomic, strong) NSString *contenturl;

@end
