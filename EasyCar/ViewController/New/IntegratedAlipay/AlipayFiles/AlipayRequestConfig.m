//
//  AlipayRequestConfig.m
//  IntegratedAlipay
//
//  Created by Winann on 15/1/9.
//  Copyright (c) 2015年 Winann. All rights reserved.
//

#import "AlipayRequestConfig.h"

@implementation AlipayRequestConfig



// 仅含有变化的参数
+ (void)alipayWithPartner:(NSString *)partner
                   seller:(NSString *)seller
                  tradeNO:(NSString *)tradeNO
              productName:(NSString *)productName
       productDescription:(NSString *)productDescription
                   amount:(NSString *)amount
                notifyURL:(NSString *)notifyURL
                   itBPay:(NSString *)itBPay
                  service:(NSString *)service
             payment_type:(NSString *)payment_type

{
    [self alipayWithPartner:partner seller:seller tradeNO:tradeNO productName:productName productDescription:productDescription amount:amount notifyURL:notifyURL service:service paymentType:payment_type inputCharset:@"UTF-8" itBPay:itBPay privateKey:kPrivateKey appScheme:kAppScheme];
    
}

// 包含所有必要的参数
+ (void)alipayWithPartner:(NSString *)partner
                   seller:(NSString *)seller
                  tradeNO:(NSString *)tradeNO
              productName:(NSString *)productName
       productDescription:(NSString *)productDescription
                   amount:(NSString *)amount
                notifyURL:(NSString *)notifyURL
                  service:(NSString *)service
              paymentType:(NSString *)paymentType
             inputCharset:(NSString *)inputCharset
                   itBPay:(NSString *)itBPay
               privateKey:(NSString *)privateKey
                appScheme:(NSString *)appScheme {
    
    Order *order = [Order order];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = tradeNO;
    order.productName = productName;
    order.productDescription = productDescription;
    order.amount = amount;
    order.notifyURL = notifyURL;
    order.service = service;
    order.paymentType = paymentType;
    order.inputCharset = inputCharset;
    order.itBPay = itBPay;
    
    
    // 将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    
    NSString *signedString = [self genSignedStringWithPrivateKey:kPrivateKey OrderSpec:orderSpec];
    
    // 调用支付接口
    [self payWithAppScheme:appScheme orderSpec:orderSpec signedString:signedString];
}

// 生成signedString
+ (NSString *)genSignedStringWithPrivateKey:(NSString *)privateKey OrderSpec:(NSString *)orderSpec {
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    return [signer signString:orderSpec];
}

// 支付
+ (void)payWithAppScheme:(NSString *)appScheme orderSpec:(NSString *)orderSpec signedString:(NSString *)signedString {
    
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];
        #pragma mark 支付宝 支付结果回调
        NSLog(@"orderString:%@\nappScheme:%@",orderString,appScheme);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            int resultStatus = [resultDic[@"resultStatus"] intValue];
            
            // 仅自定义两种必要操作，支付成功一个通知或者失败一个通知。后面提供的更详细的回调类型有需要再说
            if (resultStatus == 9000) {

                [[NSNotificationCenter defaultCenter] postNotificationName:PayResult object:@1 userInfo:@{@"payType":@"0"}];// 0表示支付宝 这是特殊需要
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:PayResult object:@0];
            }

            
            switch (resultStatus) {
                case 9000:
                    //             支付成功回调
                    [MBProgressHUD showResult:YES text:@"支付成功" delay:2];
                    break;
                    
                case 8000:
                    //             处理中
                    [MBProgressHUD showResult:YES text:@"支付正在处理中" delay:2];
                    break;
                    
                case 4000:
                    //             失败
                    [MBProgressHUD showResult:NO text:@"支付失败" delay:2];
                    break;
                    
                case 6001:
                    //             取消
                    [MBProgressHUD showResult:NO text:@"您取消了支付" delay:2];

                    break;
                    
                case 6002:
                    //             网络错误
                    [MBProgressHUD showResult:NO text:@"网络错误" delay:2];
                    break;
                    
                default:
                    break;
            }
        }];
    }
    
}

@end


@implementation AlipayToolKit

+ (NSString *)genTradeNoWithTime {

//    NSTimeInterval time = [[[NSDate alloc] init] timeIntervalSince1970];
//    int tradeNo = time * 10000;
//    return [NSString stringWithFormat:@"%d", tradeNo]; // 暂时不用这种
    
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
