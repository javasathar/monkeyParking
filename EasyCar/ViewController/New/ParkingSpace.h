//
//  ParkingSpace.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/18.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParkingSpace : NSObject

//@property (nonatomic,assign) NSInteger parkFloor;

@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic, copy) NSString *parkNo;
@property (nonatomic,assign) NSString *parkSpaceId;

//@property (nonatomic, copy) NSString *parkArea;
//@property (nonatomic, copy) NSString *parkname;
//@property (nonatomic, copy) NSString *parkId;
//@property (nonatomic, copy) NSString *carplate;
//@property (nonatomic, copy) NSString *parkGarageno;

//- (instancetype)initWithDic:(NSDictionary *)dic;
//- (void)setInfo:(NSDictionary *)dic;


@end
