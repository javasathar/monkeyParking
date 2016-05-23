//
//  BuyItemCell.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/11.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyItemCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLB;
@property (strong, nonatomic) IBOutlet UILabel *priceLB;
@property (strong, nonatomic) IBOutlet UILabel *countLB;
- (void)setCellInfoWithDic:(NSDictionary *)dic;
@end
