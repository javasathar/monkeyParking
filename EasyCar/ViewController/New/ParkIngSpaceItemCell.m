//
//  ParkIngSpaceItemCell.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/16.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ParkIngSpaceItemCell.h"
#import "MyParkingSpaceVC.h"


@implementation ParkIngSpaceItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellInfoWithParkingSpace:(ParkingSpace *)parkingSpace myCarSpaceId:(NSString *)myCarSpaceId ParkFunction:(ParkFunction)parkFunction
{
    _parkingSpace = parkingSpace;
    
    self.hidden = NO;
    self.numLB.text = _parkingSpace.parkNo;
    // 是自己的车？
    if ([_parkingSpace.parkSpaceId isEqualToString:myCarSpaceId]) {
        
        self.imgView.image = [UIImage imageNamed:@"smallRedCar"];
    }
    // 不是，再判断有无车(选择停车||普通查看)
    else if (_parkingSpace.status == 1 && (parkFunction == toChooseParkSpace || parkFunction == none)) {
        
        self.imgView.image = [UIImage imageNamed:@"smallGrayCar"];
    }
    // 不是，再判断整租状态(选择整租)
    else if (_parkingSpace.type == 1 && parkFunction == toChooseRentParkSpace) {
        
        self.imgView.image = [UIImage imageNamed:@"smallGrayCar"];
    }
    // 都不是，不显示车的图片
    else
    {
        self.imgView.image = nil;
    }
    
}

@end
