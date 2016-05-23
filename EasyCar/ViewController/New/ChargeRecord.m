//
//  chargeRecord.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/22.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ChargeRecord.h"

@implementation ChargeRecord


// json带下划线的转成驼峰 (注意：转换系统敏感词改为在这里如下写)
+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName
{
    if ([propertyName isEqual: @"ID"]) {
        
        return @"id";
    }
    
    // nickName -> nick_name
    return [propertyName mj_underlineFromCamel];
}

@end
