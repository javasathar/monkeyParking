//
//  ProductDetailViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ProductDetailViewController.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.nav setTitle:@"产品详情" leftText:@"返回" rightTitle:nil showBackImg:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIScrollView *_mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64)];
    [self.view addSubview:_mainScrollView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, UI_SCREEN_WIDTH-20, (UI_SCREEN_WIDTH-20)*0.55)];
    imgView.image = [UIImage imageNamed:self.imgStr];
    if([self.imgStr isEqualToString:@"b5"])
    {
        imgView.frame = CGRectMake(40, 10, UI_SCREEN_WIDTH-80, (UI_SCREEN_WIDTH-80)*1.34);
    }
    [_mainScrollView addSubview:imgView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, imgView.bottom+10, 150, 20)];
    title.textAlignment = NSTextAlignmentLeft;
    title.text = self.titleStr;
    [_mainScrollView addSubview:title];
    
    CGSize textSize = [self.contentStr sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(UI_SCREEN_WIDTH-20,10000.0f)lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, title.bottom+20, UI_SCREEN_WIDTH-20, textSize.height+10)];
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
