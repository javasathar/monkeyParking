//
//  MessageCell.h
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/11.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLB;
@property (strong, nonatomic) IBOutlet UILabel *creatTimeLB;
@property (strong, nonatomic) IBOutlet UILabel *detailLB;
@property (strong, nonatomic) IBOutlet UIImageView *redIcon;

@property (nonatomic, strong) PushInfo *info;

- (void)setCellInfo:(PushInfo *)pushInfo;
@end
