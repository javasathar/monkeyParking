//
//  CompInfoViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "CompInfoViewController.h"

@interface CompInfoViewController ()

@end

@implementation CompInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"公司信息";
    [self.nav setTitle:@"公司信息" leftText:@"返回" rightTitle:nil showBackImg:YES];
    self.view.backgroundColor = RGBA(242, 242, 248, 1);
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIScrollView *_mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64)];
    [self.view addSubview:_mainScrollView];
    
    NSString *textStr = @"    深圳市易停车库科技有限公司是一家集策划、设计、研发、生成、销售、媒体传播等一体投资运营的公司，业务涵盖城市静态交通方案规划和实施智能出行方案规划和实施、智能停车网络规划投资与运营、车主综合服务等方面。公司在\"创造停车新空间\"的理念之下，利用先进的商业模式和运营理念，将具有国际先进水平的停车设备与智能交通管理体系相结合，为城市提供最佳的智能交通综合解决方案。\n    易停车库以\"立体空中花园停车库\"为投资的主切入点，汇集国内目前最先进的各种机械式立体停车库产品，针对城市不同地块特点和消费者需求，为城 市提供多层次、差异化的\"停车综合解决方案\"，通过投资建设安全、智能、便捷、生态立体停车库，缓解城市\"停车难\"状况；致力于改善交通、智慧出行，打造生态车库、提升城市形象，是提高城市人车生活高品质的综合服务商。通过为车主提供一站式综合服务，更好地为您解决停车难，找车难等交通问题，附加提供 投放广告、无水洗车、新能源汽车充电站、代驾、陪驾等个性化服务，全面打开空中立体车库的新纪元模式和智慧、便捷、舒适的人车生活方式。";
    CGSize textSize = [textStr sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(UI_SCREEN_WIDTH-20,10000.0f)lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, UI_SCREEN_WIDTH-20, textSize.height+10)];
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
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, label.bottom+10, UI_SCREEN_WIDTH-20, (UI_SCREEN_WIDTH-20)*1.5181)];
    imgView.image = [UIImage imageNamed:@"comInfo.jpg"];
    [_mainScrollView addSubview:imgView];
    
    _mainScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, imgView.bottom+10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
