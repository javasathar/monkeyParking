//
//  PlcData.h
//  EasyCar
//
//  Created by 易停科技－18 on 16/3/31.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncSocket.h>
typedef void(^success)(id obj);
typedef void(^failed)(id obj);
@interface PlcData : NSObject<AsyncSocketDelegate>

@property (nonatomic ,strong) PlcData *plcData;
@property (nonatomic ,strong) AsyncSocket *socket;
@property (nonatomic ,strong) NSTimer *timer;

//plc指令集
@property (nonatomic ,strong) NSString *plcHost;    //plcIP  100~199
@property (nonatomic ,strong) NSString *plcGateway; //plc网关 默认192.168.1.1
@property (nonatomic ,strong) NSString *plcPort;    //plc端口 默认8002
@property (nonatomic ,strong) NSString *plcState;  //查询plc状态
@property (nonatomic ,strong) NSString *plcParkingStr;   //手动停车
@property (nonatomic ,strong) NSString *plcTakingStr;    //手动取车
@property (nonatomic ,strong) NSString *plcAutoParkingStr;  //自动停车
@property (nonatomic ,strong) NSString *plcSearchParkIsOrNot;   //查询有无车
@property (nonatomic ,strong) NSString *plcSearchParkSpaceNum; //查询车位号
@property (nonatomic ,strong) NSString *plcSearchAllPark; //查询所有车位数
@property (nonatomic ,strong) NSString *plcSearchLeftPark; //查询剩余车位数
@property (nonatomic ,strong) NSString *plcDownStateNum;   //查询正在下放的载车板

//**//
@property (nonatomic ,strong) success success;
@property (nonatomic ,strong) failed failed;

+(id)shareInitial;//单例
//一键停车
-(void)wantToParkingWithPlc:(int)plcStr andSuccess:(success)success orFailed:(failed)failed;
//手动停车
-(void)wantToParkingWithPlc:(int)plcStr andParkingSpace:(NSString *)spaceStr andSuccess:(success)success orFailed:(failed)failed;
//手动取车
-(void)wantToTakingWithPlc:(int)plcStr andParkingSpace:(NSString *)spaceStr andSuccess:(success)success orFailed:(failed)failed;
//查询停车情况
-(void)wantToSearchParkingWith:(int)plcStr andList:(NSInteger)list andStorey:(NSInteger)storey andSuccess:(success)success orFailed:(failed)failed;
@end
