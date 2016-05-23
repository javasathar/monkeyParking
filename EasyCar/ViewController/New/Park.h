//
//  Park.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/10.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Park : NSObject

@property (nonatomic,assign) NSInteger freeSpace;
@property (nonatomic,assign) NSInteger totalSpace;
@property (nonatomic,assign) NSInteger freeElec;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic, strong) NSString *comParkImg;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *parkName;
@property (nonatomic, strong) NSString *distance;
// 服务器返回的经纬度写反了，已做处理。
@property (nonatomic,assign) float parklat_R;// 交换处理后的纬度
@property (nonatomic,assign) float parklon_R;// 交换处理后的经度
@property (nonatomic, strong) NSString *parkAccount;
@property (nonatomic, strong) NSString *parkPassword;

@property (nonatomic,assign) float appointFee;// 预约费
@property (nonatomic,assign) float validDate;// 有效时长（min）

@property (nonatomic, strong) NSString *parkNo;

//2016猴赛雷
@property (nonatomic ,assign)BOOL big;
@property (nonatomic ,assign)BOOL pass;
@end
