//
//  ChongDianCell.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/11/18.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChongDianCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) IBOutlet UILabel *carModelLB;
@property (strong, nonatomic) IBOutlet UILabel *locationLB;
@property (strong, nonatomic) IBOutlet UILabel *stayLB;
@property (strong, nonatomic) IBOutlet UILabel *priceLB;

@property (strong, nonatomic) IBOutlet UILabel *aTextLB;

- (void)setCellInfoWithDic:(NSDictionary *)dic;


@end
