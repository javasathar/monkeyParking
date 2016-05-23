//
//  NewsDetailViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"动态详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIScrollView *_mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    [self.view addSubview:_mainScrollView];
    
    CGSize textSize = [self.content sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(UI_SCREEN_WIDTH-20,1000)lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, UI_SCREEN_WIDTH-20, textSize.height)];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.content length])];
    titleLabel.attributedText = attributedString;
    [titleLabel sizeToFit];
    [_mainScrollView addSubview:titleLabel];
    
    UIImage *img1 = [UIImage imageNamed:self.img1];
    UIImage *img2 = [UIImage imageNamed:self.img2];
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, titleLabel.bottom+5, UI_SCREEN_WIDTH-10, (UI_SCREEN_WIDTH-20)/img1.size.width*img1.size.height)];
    image1.image = img1;
    [_mainScrollView addSubview:image1];
    
    if(img2 != nil)
    {
        UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(5, image1.bottom+5, UI_SCREEN_WIDTH-10, (UI_SCREEN_WIDTH-20)/img2.size.width*img2.size.height)];
        image2.image = img2;
        [_mainScrollView addSubview:image2];
        _mainScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, image2.bottom+10);
    }
    else
    {
        _mainScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, image1.bottom+10);
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
