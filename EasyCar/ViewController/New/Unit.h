//
//  Unit.h
//  IDODiamond
//
//  Created by 小马科技 on 15/10/13.
//  Copyright (c) 2015年 小马科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Unit : NSObject

//找出主页的Viewcontroller
+ (id)EPStoryboard:(NSString *)viewControllerIdentifer;



+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//+ (void)loginWithPhone:(NSString *)phoneNumber password:(NSString*)password;

//+ (void)loginWithPhone:(NSString *)phoneNumber password:(NSString*)password successCallback:(void (^)(id responseObject))success errorCallback:(void (^)(NSError * error)) errorBack;

+ (NSString *)stringFromDate:(NSDate *)date formatterOrNil:(NSString *)formatterStr;

+ (NSString *)stringFromTimeInterval:(double)timeInterval formatterOrNil:(NSString *)formatterStr;

+ (UIImage *)changeImage:(UIImage *)image toScale:(CGFloat)scale;

+ (NSString *)getTimeWithFormat:(NSString *)format;
@end
