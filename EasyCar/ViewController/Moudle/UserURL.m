//
//  UserURL.m
//  tl_Good
//
//  Created by 田隆真 on 15/7/20.
//  Copyright (c) 2015年 田隆真. All rights reserved.
//

#import "UserURL.h"
#import "NSString+JSON.h"

@implementation UserURL
{
    NSMutableData * _data;
}

// 登陆
+ (void)loginURL_name:(NSString *)name password:(NSString *)password isLogin:(LoginBOOLBlock)block
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:[NSString stringWithFormat:@"%@phone=%@&password=%@",@"",name,password] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
		 NSLog(@"%@",responseObject);
         NSString * status = [responseObject objectForKey:@"status"];
         if ([status intValue]== 404)
         {
             block(NO,nil);
         }
         else if([status intValue] == 200)
         {
             block(YES,responseObject);
         }
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         block(NO,nil);
         
     }];

}
// 查询
+ (void)inquireIphone:(NSString *)iphone isIphone:(RequestBOOLBlock)block
{
    NSString * getURL = [NSString stringWithFormat:@"%@member/checkphone",BaseURL];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"phone"] = iphone;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:getURL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * dic = (NSDictionary * )responseObject;
         NSString * str = [dic objectForKey:@"status"];
         NSString * message = [dic objectForKey:@"message"];
         if ([str intValue] == 404)
         {
             block(NO,@"404");
         }
         else if([str intValue] == 200)
         {
             //            手机号正确
             block(YES,@"200");
         }
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         NSLog(@"错误 %@",error);
         
     }];
}
// 注册
+ (void)registerIphone:(NSString *)iphone password:(NSString *)password isMan:(NSString *)man isIphone:(RequestBOOLBlock)block
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//	manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//	manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    NSDictionary * dic = @{@"phone":iphone,@"password":password,@"sex":man};

    [manager POST:BaseURL@"member/register" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {

//		 NSString *str = [NSString jsonStringWithObject:responseObject];
         
         NSString *status = responseObject[@"status"];

         if ([status intValue] == 404)
         {
             block(NO,@"404");
         }
         else if([status intValue] == 200)
         {
             block(YES,@"200");
         }
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         block(NO,@"error");
     }];
}

//修改
+ (void)alterUserDataID:(NSString *)memberId memberName:(NSString *)memberName memberSex:(NSString *)memberSex memberContent:(NSString *)memberContent speciality:(NSString *)speciality birthday:(NSString *)birthday workyear:(NSString *)workyear workplace:(NSString *)workplace education:(NSString *)education hometown:(NSString *)hometown isTriumph:(RequestBOOLBlock)block
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (memberId != nil)
    {
        [dic setObject:memberId forKey:@"memberId"];
    }
    if (memberName != nil)
    {
        [dic setObject:memberName forKey:@"memberName"];
    }
    if (memberSex != nil)
    {
        [dic setObject:[NSNumber numberWithInt:[memberSex intValue]] forKey:@"memberSex"];
    }
    
    if (memberContent != nil)
    {
        [dic setObject:memberContent forKey:@"memberContent"];
    }
    if (speciality != nil)
    {
        [dic setObject:speciality forKey:@"speciality"];
    }
    if (birthday != nil)
    {
        [dic setObject:birthday forKey:@"birthday"];
    }
    if (workyear != nil)
    {
        [dic setObject:workyear forKey:@"workyear"];
    }
    if (workplace != nil)
    {
        [dic setObject:workplace forKey:@"workplace"];
    }
    if (education != nil)
    {
        [dic setObject:education forKey:@"education"];
    }
    
    if (hometown != nil)
    {
        [dic setObject:hometown forKey:@"hometown"];
    }

    [manager POST:[NSString stringWithFormat:@"%@member/edit",BaseURL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString * message = [responseObject objectForKey:@"message"];
         NSString * str = [responseObject objectForKey:@"status"];
         if ([str intValue] == 402)
         {
             block(NO,message);
         }
         else if([str intValue] == 200)
         {
             block(YES,message);
         }
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         block(NO,@"error");
     }];

}

#pragma mark --测试数据
- (void)loginIphone:(NSString * )requesturl
{
    NSURL  * url = [NSURL URLWithString:requesturl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLConnection * connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"响应");
    _data = [[NSMutableData alloc]init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"下载");
    [_data appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"完成");
    NSLog(@"%@",_data);
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"失败");
}

#pragma mark - request by get method
+ (void) requestDataByGet:(NSString *)url
				   header:(NSDictionary *)headerData
					param:(NSDictionary *)paramData
		  successCallback:(void (^)(id responseObject))successCallback
			errorCallback:(void (^)(NSError * error)) errorCallback{

	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	//manager.responseSerializer = [AFHTTPResponseSerializer serializer];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	//manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

	if (headerData) {

		manager.requestSerializer = [AFJSONRequestSerializer serializer];

		for (NSString *headerField in headerData) {
			[manager.requestSerializer setValue:[headerData objectForKey:headerField] forHTTPHeaderField:headerField];
		}

	}

	[manager GET:url parameters:paramData success:^(AFHTTPRequestOperation *operation, id responseObject) {

		//NSLog(@"JSON: %@", responseObject);
		successCallback(responseObject);

	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {

		errorCallback(error);

	}];
}

#pragma mark - request by post method
+ (void) requestDataByPost:(NSString *)url
					header:(NSDictionary *)headerData
					  body:(NSDictionary *)bodyData
		   successCallback:(void (^)(id responseObject))successCallback
			 errorCallback:(void (^)(NSError * error)) errorCallback{

	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	//manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

	if (headerData) {

		manager.requestSerializer = [AFJSONRequestSerializer serializer];

		for (NSString *headerField in headerData) {
			[manager.requestSerializer setValue:[headerData objectForKey:headerField] forHTTPHeaderField:headerField];
		}
	}

	//NSDictionary *parameters = @{@"foo": @"bar"};
	[manager POST:url parameters:bodyData success:^(AFHTTPRequestOperation *operation, id responseObject) {
		//NSLog(@"JSON: %@", responseObject);
		successCallback(responseObject);

	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		//NSLog(@"Error: %@", error);
		errorCallback(error);
	}];

}

#pragma mark - request by put method
+ (void) requestDataByPut:(NSString *)url
				   header:(NSDictionary *)headerData
					param:(NSDictionary *)paramData
		  successCallback:(void (^)(id responseObject))successCallback
			errorCallback:(void (^)(NSError * error)) errorCallback{

	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];

	if (headerData) {

		manager.requestSerializer = [AFJSONRequestSerializer serializer];

		for (NSString *headerField in headerData) {
			[manager.requestSerializer setValue:[headerData objectForKey:headerField] forHTTPHeaderField:headerField];
		}
	}

	[manager PUT:url parameters:paramData success:^(AFHTTPRequestOperation *operation, id responseObject) {
		//NSLog(@"JSON: %@", responseObject);
		successCallback(responseObject);

	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		//NSLog(@"Error: %@", error);
		errorCallback(error);

	}];
}

#pragma mark - request by delete method
+ (void) requestDataByDelete:(NSString *)url
					  header:(NSDictionary *)headerData
					   param:(NSDictionary *)paramData
			 successCallback:(void (^)(id responseObject))successCallback
			   errorCallback:(void (^)(NSError * error)) errorCallback {

	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];

	if (headerData) {

		manager.requestSerializer = [AFJSONRequestSerializer serializer];

		for (NSString *headerField in headerData) {
			[manager.requestSerializer setValue:[headerData objectForKey:headerField] forHTTPHeaderField:headerField];
		}
	}

	[manager DELETE:url parameters:paramData success:^(AFHTTPRequestOperation *operation, id responseObject) {
		//NSLog(@"JSON: %@", responseObject);
		successCallback(responseObject);

	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		//NSLog(@"Error: %@", error);
		errorCallback(error);

	}];
}

#pragma mark -- 视频类请求
// 点赞
+ (void)likeVideo_videoID:(NSString *)videoID memberID:(NSString *)memberID likeBlock:(LikeBlock)block
{
    NSString * url = BaseURL@"video/like";
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"videoId"] = videoID;
    dic[@"memberId"] = memberID;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSString * status = responseObject[@"status"];
        NSString * message = responseObject[@"message"];
        NSDictionary * data = responseObject[@"data"];
        if ([status isEqualToString:@"200"])
        {
            block(message,data);
        }
        else
        {
            block(message,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        
    }];
}
@end
