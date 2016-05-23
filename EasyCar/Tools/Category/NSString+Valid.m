/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "NSString+Valid.h"

@implementation NSString (Valid)

- (BOOL) isChinese {

    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL) isPhoneNumber {

    NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '^1[0-9]{10}$'"];
    return [numberPredicate evaluateWithObject:self];
}

- (BOOL) isMobileNumber {
    
    NSString *mobile = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString *cm = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString *cu = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString *ct = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    NSPredicate *regextestCM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cm];
    NSPredicate *regextestCU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cu];
    NSPredicate *regextestCT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ct];
    
    if([regextestMobile evaluateWithObject:self] || [regextestCM evaluateWithObject:self]
       || [regextestCU evaluateWithObject:self] || [regextestCT evaluateWithObject:self]) {
        
        if ([regextestMobile evaluateWithObject:self]) {
            NSLog(@"中国移动");
        } else if ([regextestCM evaluateWithObject:self]) {
            NSLog(@"中国联通");
        } else if ([regextestCU evaluateWithObject:self]) {
            NSLog(@"中国电信");
        } else {
            NSLog(@"未知类型");
        }
        
        return YES;
        
    } else {
        
        return NO;
    }
    
}
- (BOOL) isValidateEmail {
   
    NSString *match=@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
    
}

- (BOOL) isValidatePassword {
    NSString *match=@"[A-Z0-9a-z]{6,20}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}


- (BOOL) isContainsString:(NSString*)other {
    NSRange range = [self rangeOfString:other];
    return range.length != 0;
}

@end
