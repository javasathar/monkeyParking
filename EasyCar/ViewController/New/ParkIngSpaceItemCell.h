//
//  ParkIngSpaceItemCell.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/16.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyParkingSpaceVC.h"
#import "ParkingSpace.h"

@interface ParkIngSpaceItemCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *numLB;
@property (nonatomic, strong) ParkingSpace *parkingSpace;

- (void)setCellInfoWithParkingSpace:(ParkingSpace *)parkingSpace myCarSpaceId:(NSString *)myCarSpaceId ParkFunction:(ParkFunction)parkFunction;
@end
