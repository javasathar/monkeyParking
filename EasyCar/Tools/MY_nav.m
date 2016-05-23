//
//  MY_nav.m
//  tl_Good
//
//  Created by 田隆真 on 15/7/20.
//  Copyright (c) 2015年 田隆真. All rights reserved.
//

#import "MY_nav.h"

@implementation MY_nav



- (id)initWithFrame:(CGRect)frame left:(NSString *)left title:(NSString *)title rigth:(NSString *)rigth
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (left)
        {
            _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_leftBtn setTitle:left forState:UIControlStateNormal];
            //[_leftbtn setBackgroundImage:[UIImage imageNamed:left] forState:UIControlStateNormal];
            _leftBtn.titleLabel.font = [UIFont systemFontOfSize:Nav_Fond];
            _leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            [_leftBtn addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_leftBtn];
        }
        if (title)
        {
            _titleLB = [UILabel new];
            _titleLB.text = title;
            _titleLB.textAlignment = NSTextAlignmentCenter;
            _titleLB.font = [UIFont systemFontOfSize:20];
            _titleLB.textColor = [UIColor whiteColor];
            [self addSubview:_titleLB];
        }
        if (rigth)
        {
            _rightImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_rightImageBtn setTitle:rigth forState:UIControlStateNormal];
            //[_rigthbtn setBackgroundImage:[UIImage imageNamed:rigth] forState:UIControlStateNormal];
            [_rightImageBtn addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
            _rightImageBtn.titleLabel.font = [UIFont systemFontOfSize:Nav_Fond];
            _rightImageBtn.titleLabel.textAlignment = NSTextAlignmentRight;
            _rightImageBtn.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:_rightImageBtn];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame leftImage:(NSString *)left title:(NSString *)title rigthImage:(NSString *)rigth
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (left)
        {
            _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //[_leftbtn setTitle:left forState:UIControlStateNormal];
            _backImg = [UIImageView new];
            _backImg.image = [UIImage imageNamed:left];
            [self addSubview:_backImg];
//            [_leftbtn setBackgroundImage:_backImg forState:UIControlStateNormal];
            _leftBtn.titleLabel.font = [UIFont systemFontOfSize:Nav_Fond];
            _leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            [_leftBtn addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_leftBtn];
        }
        if (title)
        {
            _titleLB = [UILabel new];
            _titleLB.text = title;
            _titleLB.textAlignment = NSTextAlignmentCenter;
            _titleLB.font = [UIFont systemFontOfSize:20];
            _titleLB.textColor = [UIColor whiteColor];
            [self addSubview:_titleLB];
        }
        if (rigth)
        {
            _rightImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //[_rigthbtn setTitle:rigth forState:UIControlStateNormal];
            [_rightImageBtn setBackgroundImage:[UIImage imageNamed:rigth] forState:UIControlStateNormal];
            [_rightImageBtn addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
            _rightImageBtn.titleLabel.font = [UIFont systemFontOfSize:Nav_Fond];
            _rightImageBtn.titleLabel.textAlignment = NSTextAlignmentRight;
            [self addSubview:_rightImageBtn];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame leftImage:(NSString *)left title:(NSString *)title rigthTitle:(NSString *)rigth
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (left)
        {
            _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //[_leftbtn setTitle:left forState:UIControlStateNormal];
            _backImg = [UIImageView new];
            _backImg.image = [UIImage imageNamed:left];
            [self addSubview:_backImg];
            _leftBtn.titleLabel.font = [UIFont systemFontOfSize:Nav_Fond];
            _leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            [_leftBtn addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_leftBtn];
        }
        if (title)
        {
            _titleLB = [UILabel new];
            _titleLB.text = title;
            _titleLB.textAlignment = NSTextAlignmentCenter;
            _titleLB.font = [UIFont systemFontOfSize:20];
            _titleLB.textColor = [UIColor whiteColor];
            [self addSubview:_titleLB];
        }
        if (rigth)
        {
            _rightTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_rightTitleBtn setTitle:rigth forState:UIControlStateNormal];
//            [_rigthbtn setBackgroundImage:[UIImage imageNamed:rigth] forState:UIControlStateNormal];
            [_rightTitleBtn addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
            _rightTitleBtn.titleLabel.font = [UIFont systemFontOfSize:Nav_Fond];
            _rightTitleBtn.titleLabel.textAlignment = NSTextAlignmentRight;
            [self addSubview:_rightTitleBtn];
        }
    }
    return self;
}

#pragma mark addSubView调用
- (void)layoutSubviews
{
//    self.backgroundColor = MainColor(100, 100, 0, 1);

    _titleLB.frame          = CGRectMake(Width/2-60, 27, 120, 30);
    
    _backImg.frame          = CGRectMake(7, 21, 25, 45);
    _leftBtn.frame          = CGRectMake(30, 31, 80, 25);
    
    _rightImageBtn.frame    = CGRectMake(Width - 40, 28, 30, 30);
    _rightTitleBtn.frame    = CGRectMake(Width - 93, 21, 80, 45);
}

- (void)left:(UIButton *)sender
{
    [self.delegate left];
}

- (void)right:(UIButton *)sender
{
    [self.delegate right];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark 设置左右中间
-(void)setTitle:(NSString *)title leftText:(NSString *)leftText rightTitle:(NSString *)rightTitle showBackImg:(BOOL)showBackImg
{
    if (showBackImg) {
        self.backImg.image = [UIImage imageNamed:@"Back_Icon_SystemType"];
    }
    // 如果传入参数有长度 判定为需要创建
    if (title.length > 0) {
        self.titleLB.text = title;
    }
    if (leftText.length > 0) {
        [self.leftBtn setTitle:leftText forState:UIControlStateNormal];
    }
    if (rightTitle.length > 0) {
        [self.rightTitleBtn setTitle:rightTitle forState:UIControlStateNormal];
    }
}

- (UIImageView *)backImg
{
    if (!_backImg) {
        _backImg = [UIImageView new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(left:)];
        _backImg.contentMode = UIViewContentModeScaleAspectFit;
        [_backImg addGestureRecognizer:tap];
        _backImg.userInteractionEnabled = YES;
        [self addSubview:_backImg];
    }
    return _backImg;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {

        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:Nav_Fond];
        [_leftBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        // _leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;是无效的
        _leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [_leftBtn addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBtn];
    }
    return _leftBtn;
}

- (UIButton *)rightImageBtn
{
    if (!_rightImageBtn) {
        _rightImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _rightImageBtn.titleLabel.font = [UIFont systemFontOfSize:Nav_Fond];
        _rightImageBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_rightImageBtn addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightImageBtn];
    }
    return _rightImageBtn;
}

- (UIButton *)rightTitleBtn
{
    if (!_rightTitleBtn) {
        _rightTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        
        [_rightTitleBtn addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
        _rightTitleBtn.titleLabel.font = [UIFont systemFontOfSize:Nav_Fond];
        [_rightTitleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        _rightTitleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [self addSubview:_rightTitleBtn];
    }
    return _rightTitleBtn;
}

- (UILabel *)titleLB
{
    if(!_titleLB){
        _titleLB = [UILabel new];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.font = [UIFont systemFontOfSize:18];
        _titleLB.textColor = [UIColor whiteColor];
        [self addSubview:_titleLB];
    }
    return _titleLB;
}

@end
