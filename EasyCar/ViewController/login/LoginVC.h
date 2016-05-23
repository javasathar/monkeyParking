//
//  LoginVC.h
//  TLthumb
//
//  Created by 田隆真 on 15/9/16.
//  Copyright (c) 2015年 田隆真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : baseVC

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *reBtn;


@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (nonatomic, copy) NSString *pushVCName;

@end
