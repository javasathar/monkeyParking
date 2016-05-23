//
//  BuyItemCell.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/11.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "BuyItemCell.h"

@implementation BuyItemCell

- (void)setCellInfoWithDic:(NSDictionary *)dic
{
    _imgView.image = [UIImage imageNamed:dic[@"image"]];
    _nameLB.text = [NSString stringWithFormat:@"商品名称：%@",dic[@"name"]];
    _priceLB.text = [NSString stringWithFormat:@"价格：%@",dic[@"price"]];
    _countLB.text = [NSString stringWithFormat:@"%@",dic[@"count"]];
}

- (void)awakeFromNib {
    // Initialization code
}

@end
