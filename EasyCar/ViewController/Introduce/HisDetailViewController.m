//
//  HisDetailViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "HisDetailViewController.h"

@interface HisDetailViewController ()

@end

@implementation HisDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"事迹详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIScrollView *_mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    [self.view addSubview:_mainScrollView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, UI_SCREEN_WIDTH-20, (UI_SCREEN_WIDTH-20)*0.55)];
    imgView.image = [UIImage imageNamed:self.imgStr];
    [_mainScrollView addSubview:imgView];
    
    
    
    CGSize textSize = [self.contentStr sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(UI_SCREEN_WIDTH-20,10000.0f)lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, imgView.bottom+30, UI_SCREEN_WIDTH-20, textSize.height+10)];
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.contentStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.contentStr length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    [_mainScrollView addSubview:label];
    
    
    _mainScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, label.bottom);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
