//
//  ParkingSpaceModel.h
//  EasyCar
//
//  Created by 易停科技－18 on 16/6/3.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParkingSpaceModel : NSObject
@property (nonatomic, assign) double renttype;
@property (nonatomic, strong) NSString *dataIdentifier;
@property (nonatomic, strong) NSString *parkArea;
@property (nonatomic, strong) NSString *parkId;
@property (nonatomic, assign) double hascharge;
@property (nonatomic, strong) NSString *parkGarageno;
@property (nonatomic, strong) NSString *parkname;
@property (nonatomic, assign) double relieveTime;
@property (nonatomic, assign) double appointtype;
@property (nonatomic, strong) NSString *parkingNo;
@property (nonatomic, assign) double type;
@property (nonatomic, assign) double parkFloor;
@property (nonatomic, strong) NSString *parkNo;
@property (nonatomic, strong) NSString *rentplate;
@property (nonatomic, assign) id result;
@property (nonatomic, assign) double status;
@property (nonatomic, strong) NSString *carplate;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;
@end
