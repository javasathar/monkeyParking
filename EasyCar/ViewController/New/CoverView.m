//
//  CoverView.m
//  EasyCar
//
//  Created by 橙晓侯 on 16/1/7.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//



#import "CoverView.h"

@implementation CoverView


// 这个方法不会创建CoverView，考虑到上拉刷新失败时不该出现cover的情况，所以创建用单独方法更加灵活
- (void)setTitle:(NSString *)title image:(UIImage *)image handle:(OneMoreThing)handle
{

    if (title) {
        _titleLB.text = title;
    }
    
    if (image) {
        _imgView.image = image;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    if (handle) {
        _block = handle;
    }
    
}

- (IBAction)clickView:(id)sender {
    
    if (_block) {
        
        _block();
    }
    else
    {
        NSLog(@"没有找到_block");
    }
}


- (void)sethandle:(OneMoreThing)handle
{
    _block = handle;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
