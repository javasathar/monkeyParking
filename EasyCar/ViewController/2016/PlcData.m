//
//  PlcData.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/3/31.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "PlcData.h"

//定义枚举类型
typedef enum {
    _AutoParking=0,//一键停车
    _Parking,//手动停车
    _Taking,//手动取车
    _searchPlc,//查询停车情况
} PlcType;
@implementation PlcData
{
    NSMutableArray *plcDataArr;
    int plcOperation;
    int storePlcStr;
    NSString *storeSpacePlc;
    NSMutableArray *searchPlcDataArr;
}
//单例
+(id)shareInitial
{
    static PlcData *plcData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        plcData = [[PlcData alloc] init];
    });
    return plcData;
}
#pragma mark 初始化
- (id)init
{
    self = [super init];
    if (self) {
        _plcHost = @"199";                //plcIP  100~199
        _plcGateway = @"192.168.10.";      //plc网关 默认192.168.10.1
        _plcPort = @"5000";               //plc端口 默认8002
        _plcState = @"@00RD2002";             //查询plc状态
        _plcParkingStr = @"@00WD2000";        //手动停车
        _plcTakingStr = @"@00WD2001";         //手动取车
        _plcAutoParkingStr = @"@00WD2009";    //自动停车
        //        _plcSearchParkIsOrNot = @"@00RD4200";   //查询有无车
        //        _plcSearchParkSpaceNum = @"@00RD5100";  //查询所有车位数
        _plcSearchAllPark = @"@00RD2011";   //查询所有车位数
        _plcSearchLeftPark = @"@00RD2010";  //查询剩余车位数
        _plcDownStateNum = @"@00RD2014";    //查询正在下放的载车板
        
    }
    return self;
}
//懒加载
-(PlcData *)plcData
{
    if (!_plcData) {
        _plcData = [PlcData shareInitial];
    }
    return _plcData;
}
#pragma mark 定时停止socket
-(void)startTimer
{
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(stopSocket) userInfo:nil repeats:NO];
}
-(void)stopTimer
{

    [_timer invalidate];
    _timer  = nil;
}
#pragma mark 停止socket
-(void)stopSocket
{
//    if (plcOperation == _searchPlc) {
//        NSArray *objArr = @[@"@00RD00000000010000000000000000000000000000000057*\r",
//                            @"@00RD00000000010000000000000000000000000000000057*\r",
//                            @"@00RD000000000100000000000000000000000057*\r",
//                            @"@00RD00000000010000000000000000000000000000000057*\r",
//                            @"@00RD00000000010000000000000000057*\r",
//                            @"@00RD0000000000000000000000000000057*\r",];
//        _success(objArr);
//    }
    if(_socket)
    {
        [_socket disconnect];
        [_socket setDelegate:nil];
        _socket = nil;
    }
    [_timer invalidate];
    _timer = nil;
    _failed(@"连接中断");
}
#pragma mark 校验和计算
-(NSString *)fillPlcStr:(NSString *)str
{
    const char *ch = [str cStringUsingEncoding:NSASCIIStringEncoding];
    int sum = ch[0];
    for (int i = 1; i < strlen(ch); i ++) {
        sum = sum ^ ch[i];
    }
    str = [str stringByAppendingFormat:@"%@*\r",[NSString stringWithFormat:@"%X",sum]];
    return str;
}
#pragma mark 查询车库停车情况
-(void)wantToSearchParkingWith:(int)plcStr andList:(NSInteger)list andStorey:(NSInteger)storey andSuccess:(success)success orFailed:(failed)failed
{
    _success = success;
    _failed = failed;
    storePlcStr = plcStr;
    plcOperation = _searchPlc;
    [plcDataArr removeAllObjects];
    [searchPlcDataArr removeAllObjects];
    searchPlcDataArr = [[NSMutableArray alloc] init];
    plcDataArr = [[NSMutableArray alloc] init];
    NSInteger num = 4200;
    for (NSInteger i = 0 ; i < storey; i ++) {
        [plcDataArr addObject:[self fillPlcStr:[NSString stringWithFormat:@"@00RD%ld0010",num + 20 * i ]]];
    }
//    NSLog(@"%ld",plcDataArr.count);
    [self writeDataToPlcWithPort:[_plcPort intValue] andHost:[NSString stringWithFormat:@"%@%d",_plcGateway,[_plcHost intValue] - plcStr]];
}
#pragma mark 一键停车
-(void)wantToParkingWithPlc:(int)plcStr andSuccess:(success)success orFailed:(failed)failed
{
    storePlcStr = plcStr;
    plcOperation = _AutoParking;
    [plcDataArr removeAllObjects];
    plcDataArr = [NSMutableArray arrayWithObjects:
                  [self fillPlcStr:[NSString stringWithFormat:@"%@0001" ,_plcState]],
                  [self fillPlcStr:[NSString stringWithFormat:@"%@0001" ,_plcSearchLeftPark]],
                  [self fillPlcStr:[NSString stringWithFormat:@"%@0001" ,_plcAutoParkingStr]],
                  [self fillPlcStr:[NSString stringWithFormat:@"%@0001" ,_plcDownStateNum]],
                  nil
                  ];
    _success = success;
    _failed = failed;
    [self writeDataToPlcWithPort:[_plcPort intValue] andHost:[NSString stringWithFormat:@"%@%d",_plcGateway,[_plcHost intValue] - plcStr]];
}
#pragma mark 手动停车
-(void)wantToParkingWithPlc:(int)plcStr andParkingSpace:(NSString *)spaceStr andSuccess:(success)success orFailed:(failed)failed
{
    storePlcStr = plcStr;
    plcOperation = _Parking;
    _success = success;
    _failed = failed;
    [plcDataArr removeAllObjects];
    //车位号与plc指令及16制转换的计算
    NSInteger a1 = [[spaceStr substringToIndex:1] integerValue];
    NSInteger a2 = [[spaceStr substringFromIndex:1] integerValue];
    NSInteger plcNum = 4180 + 20 * a1 + a2 -1;
    NSString *spaceStr16 = [NSString stringWithFormat:@"%X",[spaceStr intValue]];
    while (spaceStr16.length < 4) {
        spaceStr16 = [NSString stringWithFormat:@"0%@",spaceStr16];
    }
    // ******  //
    plcDataArr = [NSMutableArray arrayWithObjects:
                  [self fillPlcStr:[NSString stringWithFormat:@"%@0001" ,_plcState]],
                  [self fillPlcStr:[NSString stringWithFormat:@"@00RD%ld0001" ,plcNum]],
                  [self fillPlcStr:[NSString stringWithFormat:@"%@%@" ,_plcParkingStr,spaceStr16]],
                  nil
                  ];
    
    [self writeDataToPlcWithPort:[_plcPort intValue] andHost:[NSString stringWithFormat:@"%@%d",_plcGateway,[_plcHost intValue] - plcStr]];
}
#pragma mark 手动取车
-(void)wantToTakingWithPlc:(int)plcStr andParkingSpace:(NSString *)spaceStr andSuccess:(success)success orFailed:(failed)failed
{
    plcOperation = _Taking;
    _success = success;
    _failed = failed;
    //车位号与plc指令及16制转换的计算
    NSInteger a1 = [[spaceStr substringToIndex:1] integerValue];
    NSInteger a2 = [[spaceStr substringFromIndex:1] integerValue];
    NSInteger plcNum = 4180 + 20 * a1 + a2 - 1;
    NSString *spaceStr16 = [NSString stringWithFormat:@"%X",[spaceStr intValue]];
    while (spaceStr16.length < 4) {
        spaceStr16 = [NSString stringWithFormat:@"0%@",spaceStr16];
    }
    // ******  //
    [plcDataArr removeAllObjects];
    plcDataArr = [NSMutableArray arrayWithObjects:
                  [self fillPlcStr:[NSString stringWithFormat:@"%@0001" ,_plcState]],
                  [self fillPlcStr:[NSString stringWithFormat:@"@00RD%ld0001" ,plcNum]],
                  [self fillPlcStr:[NSString stringWithFormat:@"%@%@" ,_plcTakingStr,spaceStr16]],
                  nil
                  ];
    
    [self writeDataToPlcWithPort:[_plcPort intValue] andHost:[NSString stringWithFormat:@"%@%d",_plcGateway,[_plcHost intValue] - plcStr]];
}
#pragma mark 发送数据到plc
-(void)writeDataToPlcWithPort:(int)portStr andHost:(NSString *)hostStr
{
    NSLog(@"port:  %d \nhost:   %@",portStr,hostStr);
    if ([[CGTool shareInitial] isMonkeyWIFI]) {
        if(_socket)
        {
            [_socket disconnect];
            [_socket setDelegate:nil];
            _socket = nil;
        }
        _socket = [[AsyncSocket alloc] initWithDelegate:self];
        [_socket connectToHost:hostStr onPort:portStr error:nil];
        [self startTimer];
    }else
    {
        [MBProgressHUD showResult:NO text:@"未连接车库WIFI" delay:3.0f];
    }
   
}
#pragma mark 判断是否发送下一条指令
-(BOOL)canWriteDataToPlcSerial:(NSData *)data withTag:(long)tag
{
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Read:    %@",dataStr);
    if (dataStr.length < 10) {
        return NO;
    }
    if (![[dataStr substringWithRange:NSMakeRange(5, 2)] isEqualToString:@"00"]) {
        return NO;
    }
    if (plcOperation == _searchPlc) {
        [searchPlcDataArr addObject:dataStr];
    }
    if (tag == plcDataArr.count - 1) {
        return NO;
    }
    if (plcOperation == _searchPlc) {
        return YES;
    }



    NSString *dataSpace = [dataStr substringWithRange:NSMakeRange(7, 4)];
    switch (tag) {
        case 0:
            if (![dataSpace isEqualToString:@"0003"]) {
                return NO;
            }
            break;
        case 1:
            if ([dataSpace isEqualToString:@"0000"]) {
                if (plcOperation != _Parking) {
                    return NO;
                }
            }else
            {
                if (plcOperation == _Parking) {
                    return NO;
                }
            }
            break;
        case 2:
            
            //保存或消除停车记录
            //            [[NSUserDefaults standardUserDefaults] setObject:@{@"inputLabel": _inputLabel.text,@"btnTag":[NSString stringWithFormat:@"%ld",_btnTag],@"btnText":_btnText} forKey:@"parkingCar"];
            //            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 3:

            break;
            
        default:
            break;
    }
    return YES;
}
#pragma mark //******   SOCKET 代理      ******//
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    [_socket writeData:[plcDataArr[0] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    NSLog(@"Write:   %@",plcDataArr[0]);
    [_socket readDataWithTimeout:-1 tag:0];
}
-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
}
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if ([self canWriteDataToPlcSerial:data withTag:tag]) {
        [_socket writeData:[plcDataArr[tag+1] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:tag+1];
        NSLog(@"Write:   %@",plcDataArr[tag+1]);
        [_socket readDataWithTimeout:-1 tag:tag+1];
    }else
    {
        NSString *tagStr = [NSString stringWithFormat:@"%ld",tag];

        if (tag == plcDataArr.count - 1) {
            NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

            if (dataStr.length > 10) {
//                NSLog(@"%d",plcOperation);
                if (plcOperation == _searchPlc) {
                    _success(searchPlcDataArr);
                }else if(plcOperation == _AutoParking)
                {
                    _success([NSString stringWithFormat:@"%ld",(long)[self change16To10With:[dataStr substringWithRange:NSMakeRange(7, 4)]]]);
                }else
                {
                    _success(nil);
                }

            }
        }else
        {
            NSLog(@"failed:   %ld     %ld",tag,plcDataArr.count);
            _failed(tagStr);
        }
        if(_socket)
        {
            [_socket disconnect];
        }
        [_timer invalidate];
        _timer = nil;
    }
    
}
-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"AsyncSocket didDisconnect");
}
//16进制转10进制
-(NSInteger)change16To10With:(NSString *)numStr
{
    NSInteger num = strtoul([numStr UTF8String], 0, 16);
    return num;
}
@end
