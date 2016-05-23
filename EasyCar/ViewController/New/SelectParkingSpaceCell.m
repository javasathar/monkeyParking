//
//  SelectParkingSpaceCell.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/16.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "SelectParkingSpaceCell.h"


@implementation SelectParkingSpaceCell

- (void)awakeFromNib {
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setCellInfo:(RentInfo *)info
{
    _info = info;

    self.areaLB.text = [NSString stringWithFormat:@"%@%@",info.parkArea,info.parkNo];
    self.parkLB.text = [NSString stringWithFormat:@"停车场：%@%@%@",info.address,info.parkArea,info.parkNo];
    self.carLB.text = [NSString stringWithFormat:@"车牌：%@",info.rentPlate];
    
    [_info addObserver:self forKeyPath:@"condition" options:NSKeyValueObservingOptionNew context:nil];
    
    _rentBtn.selected = info.condition;
    _rentBtn.backgroundColor = _rentBtn.selected ? [UIColor lightGrayColor]:[UIColor colorWithRed:0.157 green:0.404 blue:0.996 alpha:1.000];
}

#pragma mark - 监听回调方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    

    if([keyPath isEqualToString:@"condition"]){

       _rentBtn.selected = [change[@"new"] boolValue];
        
        _rentBtn.backgroundColor = _rentBtn.selected ? [UIColor lightGrayColor]:[UIColor colorWithRed:0.157 green:0.404 blue:0.996 alpha:1.000];
 
    }
    

}

- (void)dealloc
{
    [_info removeObserver:self forKeyPath:@"condition"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
