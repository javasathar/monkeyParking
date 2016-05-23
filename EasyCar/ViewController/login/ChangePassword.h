//
//  ChangePassword.h
//  TLthumb
//
//  Created by 田隆真 on 15/9/17.
//  Copyright (c) 2015年 田隆真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePassword : baseVC

@property (weak, nonatomic) IBOutlet UITextField * passTFnew;

@property (weak, nonatomic) IBOutlet UITextField * passTFnew2;

@property (weak, nonatomic) IBOutlet UIButton *reBtn;

@property (strong, nonatomic)NSString * phone;

@end
