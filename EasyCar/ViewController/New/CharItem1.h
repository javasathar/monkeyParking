//
//  CharItem1.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/16.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharItem1 : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *charLabel;
- (void)shouldSelected:(BOOL)should;

@end
