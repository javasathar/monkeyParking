//
//  GBWXPayManager.m
//  微信支付
//
//  Created by 张国兵 on 15/7/25.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import "GBWXPayManager.h"

@implementation GBWXPayManager
{
    NSString *_signKey;
    NSString *_partnerID;
}
/**
 *  针对多个商户的支付
 *
 *  @param orderID    支付订单号
 *  @param orderTitle 订单的商品描述
 *  @param amount     订单总额
 *  @param notifyURL  支付结果异步通知
 *  @param seller     商户号（收款账号）
 */
+(void)wxpayWithOrderID:(NSString*)orderID
             orderTitle:(NSString*)orderTitle
                 amount:(NSString*)amount
               sellerID:(NSString *)sellerID
                  appID:(NSString*)appID
              partnerID:(NSString*)partnerID{
    
    //微信支付的金额单位是分转化成我们比较常用的'元'
    NSString*realPrice=[NSString stringWithFormat:@"%.f",amount.floatValue*100];
    
    if(realPrice.floatValue<=0){
        return;
    }
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:appID mch_id:sellerID];
    //设置密钥
    [req setKey:partnerID];
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo:orderID title:orderTitle price: realPrice];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        BOOL status = [WXApi sendReq:req];
        NSLog(@"%d",status);
        
    }
    
}
/**
 *  单一用户
 *
 *  @param orderID    支付订单号
 *  @param orderTitle 订单的商品描述
 *  @param amount     订单总额
 */
+(void)wxpayWithOrderID:(NSString*)orderID
             orderTitle:(NSString*)orderTitle
                 amount:(NSString*)amount{
    
 
  
    //微信支付的金额单位是分转化成我们比较常用的'元'
    NSString*realPrice=[NSString stringWithFormat:@"%.f",amount.floatValue*100];
  
    if(realPrice.floatValue<=0){
        return;
    }
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo:orderID title:orderTitle price: realPrice];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        BOOL status = [WXApi sendReq:req];
        NSLog(@"%d",status);
        
    }
    
    
    
    
}


//客户端提示信息
+ (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}
/**
 *  从服务器获取参数及签名
 *  request.partnerId = @"10000100";
 *  request.prepayId= @"1101000000140415649af9fc314aa427";
 *  request.package = @"Sign=WXPay";
 *  request.nonceStr= @"a462b76e7436e98e0ed6e13c64b4fd1c";
 *  request.timeStamp= @"1397527777";
 *  request.sign= @"582282D72DD2B03AD892830965F428CB16E7A256";
 *  [WXApi sendReq：request];
 */
-(void)wxpayWithOrderID:(NSString *)orderID
             orderTitle:(NSString *)orderTitle
                 amount:(NSString *)amount
              partnerID:(NSString *)partnerID
               prepayID:(NSString *)prepayID
                package:(NSString *)package
               nonceStr:(NSString *)nonceStr
              timeStamp:(NSString *)timeStamp
                signKey:(NSString *)signKey
{
    NSString *_package, *_time_stamp, *_nonce_str;
    time_t now;
    time(&now);
    _time_stamp = timeStamp;
    _nonce_str = nonceStr;
    _package = package;
    _signKey = signKey;
    _partnerID = partnerID;
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:APP_ID forKey:@"appid"];
    [signParams setObject:_nonce_str forKey:@"noncestr"];
    [signParams setObject:_package forKey:@"package"];
    [signParams setObject:partnerID forKey:@"partnerid"];
    [signParams setObject:_time_stamp forKey:@"timestamp"];
    [signParams setObject:prepayID forKey:@"prepayid"];
    NSString *sign = [self createMd5Sign:signParams];
    [signParams setObject:sign forKey:@"sign"];
    // 这里 调起微信  一个参数也不能少  重要的事 我不想说三遍了,调不起会来看三遍的 哈哈哈....
    PayReq *req = [[PayReq alloc] init];
    req.openID = APP_ID;
    req.partnerId = partnerID;
    req.prepayId = prepayID;
    req.nonceStr = nonceStr;
    req.timeStamp = _time_stamp.intValue;
    req.package = package;
    req.sign = sign;
    [WXApi sendReq:req];
}
-(NSString*)createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (![[dict objectForKey:categoryId] isEqualToString:@""] && ![categoryId isEqualToString:@"sign"] && ![categoryId isEqualToString:@"key"])
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", _signKey];
    //得到MD5 sign签名
    NSString *md5Sign =[WXUtil md5:contentString];
    //    //输出Debug Info
    //    [debugInfo appendFormat:@"MD5签名字符串：\n%@\n\n",contentString];
    return md5Sign;
}
@end
