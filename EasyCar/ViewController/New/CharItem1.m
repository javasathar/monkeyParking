//
//  CharItem1.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/16.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "CharItem1.h"

@implementation CharItem1

- (void)awakeFromNib {
    // Initialization code
}

- (void)shouldSelected:(BOOL)should
{
    if (should) {
        
        self.charLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithRed:0.137 green:0.388 blue:1.000 alpha:1.000];
        
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
        self.charLabel.textColor = [UIColor blackColor];        
    }
}

@end
