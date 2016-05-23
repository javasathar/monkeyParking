//
//  reVC.h
//  TLthumb
//
//  Created by 田隆真 on 15/9/17.
//  Copyright (c) 2015年 田隆真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface reVC : baseVC

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordAgainTF;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UIButton *reBtn;

@property (weak, nonatomic) IBOutlet UIImageView *Gbtn;

@end
