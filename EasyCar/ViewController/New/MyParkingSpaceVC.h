//
//  MyParkingSpaceVC.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/16.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, ParkFunction) {
    none,
    toChooseParkSpace,
    toChooseRentParkSpace
};

@interface MyParkingSpaceVC : baseVC

@property (nonatomic, strong) NSString *myCarSpaceId;        // 我的车位ID

- (void)necessaryPropertyParkFunction:(ParkFunction)function parkArea:(NSString *)parkArea parkId:(NSString *)parkId ;

@end



@interface ParkingSpaceFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, strong) MyParkingSpaceVC *ctl;
@end