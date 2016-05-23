//
//  ComCultureViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ComCultureViewController.h"

@interface ComCultureViewController ()

@end

@implementation ComCultureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"公司文化";
    [self.nav setTitle:@"公司文化" leftText:@"返回" rightTitle:nil showBackImg:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIScrollView *_mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64)];
    [self.view addSubview:_mainScrollView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, UI_SCREEN_WIDTH-20, (UI_SCREEN_WIDTH-20)*0.435)];
    imgView.image = [UIImage imageNamed:@"logo_cultuer"];
    [_mainScrollView addSubview:imgView];
    
    NSString *textStr = @"1、核心价值观：易行大道，停容天下\n2、企业精神：诚信铸就未来，创新得以发展，进取创造奇迹，和谐凝聚力量\n3、企业宗旨：以人为本，恪守诚信，敢于创新，追求卓越\n4、企业使命：改善交通，智慧出行，打造生态车库，提升城市形象\n5、企业愿景：成为提高城市人车生活高品质的综合服务商\n6、经营理念：安全·智能 宜人·生态 创新·共赢\n7、人文理念：给客户予信任感，给员工予归属感，给社会予责任感\n8、设计理念：“安全·生态”“创·造”一体 “行·停”便捷";
    CGSize textSize = [textStr sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(UI_SCREEN_WIDTH-20,10000.0f)lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, imgView.bottom+30, UI_SCREEN_WIDTH-20, textSize.height+10)];
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
