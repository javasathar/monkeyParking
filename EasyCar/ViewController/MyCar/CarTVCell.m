//
//  CarTVCell.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/10.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "CarTVCell.h"
#import "MyCarViewController.h"
@implementation CarTVCell

- (void)awakeFromNib {
    // Initialization code
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [self addGestureRecognizer:longPress];
}

- (void)onLongPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        MyCarViewController *vc = (MyCarViewController *)[self.superview.superview.superview nextResponder];
        [vc onLongPressDelete:self];
        
    }
}

- (void)setCellInfo:(Car *)car
{

    _car = car;
    
    _imgView.image = [UIImage imageNamed:@"myCar.png"];
    _carBrandLB.text = [NSString stringWithFormat:@"品牌：%@",_car.carBrand];
    _carPlateLB.text = [NSString stringWithFormat:@"车牌：%@",_car.carPlate];
    _carModelLB.text = [NSString stringWithFormat:@"车型：%@",_car.carModel];
    
    /*
    id": "402880e950fa4ec40150fa52e0340000",
    "result": "",
    "status": "",
    "memberId": "402880f350ef375c0150ef77941e0002",
    "carBrand": "品牌pp",
    "carPlate": "车牌cp",
    "carModel": "型号xh",
    "carImg": ""
     */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
