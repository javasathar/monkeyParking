//
//  WashCarViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "WashCarViewController.h"

@interface WashCarViewController ()

@end

@implementation WashCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"洗车服务";
    self.view.backgroundColor = RGBA(242, 242, 248, 1);
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIScrollView *_mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    [self.view addSubview:_mainScrollView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, UI_SCREEN_WIDTH-20, (UI_SCREEN_WIDTH-20)*0.617)];
    imgView.image = [UIImage imageNamed:@"washcar"];
    [_mainScrollView addSubview:imgView];
    
    NSString *textStr = @"    无水洗车：利用现代高新科技产品，对汽车进行清洁、打蜡、上光、养护一次完成的新型汽车保洁方式。无水洗车是一门有前景的新生意，其产品配方由多种新型表面活性剂、浮化剂及悬浮剂等漆面保护成分组成，能有效地将尘土吸附在擦车布上，避免划伤车漆，而且可以使清洗更彻底，光洁效果更好。可以说，其产品具有洗车、打蜡、上光一次完成的功效，既节水又省力。";
    CGSize textSize = [textStr sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(UI_SCREEN_WIDTH-20,10000.0f)lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, imgView.bottom+20, UI_SCREEN_WIDTH-20, textSize.height+10)];
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textStr length])];
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
