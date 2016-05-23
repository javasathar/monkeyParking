//
//  MY_nav.h
//  tl_Good
//
//  Created by 田隆真 on 15/7/20.
//  Copyright (c) 2015年 田隆真. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MY_nav_delegate <NSObject>

@optional
- (void)left;
- (void)right;
@end

@interface MY_nav : UIView

@property (nonatomic, strong) UIButton * leftBtn;
@property (nonatomic, strong) UILabel * titleLB;
@property (nonatomic, strong) UIButton * rightImageBtn;
@property (nonatomic, strong) UIButton * rightTitleBtn;
@property (nonatomic, strong) UIImageView * backImg;


@property (nonatomic,strong) id<MY_nav_delegate>delegate;

- (id)initWithFrame:(CGRect)frame left:(NSString *)left title:(NSString *)title rigth:(NSString *)rigth;

- (id)initWithFrame:(CGRect)frame leftImage:(NSString *)left title:(NSString *)title rigthImage:(NSString *)rigth;

- (id)initWithFrame:(CGRect)frame leftImage:(NSString *)left title:(NSString *)title rigthTitle:(NSString *)rigth;

-(void)setTitle:(NSString *)title leftText:(NSString *)leftText rightTitle:(NSString *)rightTitle showBackImg:(BOOL)showBackImg;

@end
