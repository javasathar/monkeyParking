//
//  CoverView.h
//  EasyCar
//
//  Created by 橙晓侯 on 16/1/7.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OneMoreThing)(void);

@interface CoverView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLB;
@property (nonatomic, strong) OneMoreThing block;

- (void)setTitle:(NSString *)title image:(UIImage *)image handle:(OneMoreThing)handle;
- (void)sethandle:(OneMoreThing)handle;
@end
