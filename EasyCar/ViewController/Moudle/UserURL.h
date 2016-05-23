//
//  UserURL.h
//  tl_Good
//
//  Created by 田隆真 on 15/7/20.
//  Copyright (c) 2015年 田隆真. All rights reserved.
//

#import <Foundation/Foundation.h>

// 类型定义
typedef void(^RequestBOOLBlock)(BOOL isSuccess,NSString * message);
typedef void(^RequestBOOLBlock2)(BOOL isSuccess,NSDictionary * message);
typedef void(^LoginBOOLBlock)(BOOL isSuccess,NSDictionary * dic);

typedef void(^LikeBlock)(NSString * message,NSDictionary * dic);

@interface UserURL : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

// 登陆
+ (void)loginURL_name:(NSString *)name password:(NSString *)password isLogin:(LoginBOOLBlock)block;
// 查询手机
+ (void)inquireIphone:(NSString *)iphone isIphone:(RequestBOOLBlock)block;
// 注册
+ (void)registerIphone:(NSString *)iphone password:(NSString *)password isMan:(NSString *)man isIphone:(RequestBOOLBlock)block;
// 修改用户资料
+ (void)alterUserDataID:(NSString *)memberId memberName:(NSString *)memberName memberSex:(NSString *)memberSex memberContent:(NSString *)memberContent speciality:(NSString *)speciality birthday:(NSString *)birthday workyear:(NSString *)workyear workplace:(NSString *)workplace education:(NSString *)education hometown:(NSString *)hometown isTriumph:(RequestBOOLBlock)block;

#pragma mark -- 视频类请求
// 点赞
+ (void)likeVideo_videoID:(NSString *)videoID memberID:(NSString *)memberID likeBlock:(LikeBlock)block;

//GET/POST/PUT/DELETE
+ (void) requestDataByPut:(NSString *)url
				   header:(NSDictionary *)headerData
					param:(NSDictionary *)paramData
		  successCallback:(void (^)(id responseObject))successCallback
			errorCallback:(void (^)(NSError * error)) errorCallback;

+ (void) requestDataByDelete:(NSString *)url
					  header:(NSDictionary *)headerData
					   param:(NSDictionary *)paramData
			 successCallback:(void (^)(id responseObject))successCallback
			   errorCallback:(void (^)(NSError * error)) errorCallback;

+ (void) requestDataByPost:(NSString *)url
					header:(NSDictionary *)headerData
					  body:(NSDictionary *)bodyData
		   successCallback:(void (^)(id responseObject))successCallback
			 errorCallback:(void (^)(NSError * error)) errorCallback;

+ (void) requestDataByGet:(NSString *)url
				   header:(NSDictionary *)headerData
					param:(NSDictionary *)paramData
		  successCallback:(void (^)(id responseObject))successCallback
			errorCallback:(void (^)(NSError * error)) errorCallback;


+ (void) postUploadWithUrlByMulti:(NSString *)urlStr header:(NSDictionary *)headerData fileArray:(NSMutableArray *)fileArray fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)(NSError * error))fail;
@end
