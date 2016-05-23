//
//  BuySomeViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/20.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "BuySomeViewController.h"

@interface BuySomeViewController ()

@end

@implementation BuySomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"爱车用品";
    self.view.backgroundColor = RGBA(242, 242, 248, 1);
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIButton *etzy = [[UIButton alloc] initWithFrame:CGRectMake(10, 74, UI_SCREEN_WIDTH/2-20, UI_SCREEN_WIDTH/2-20)];
    etzy.tag = 2001;
    [etzy setBackgroundImage:[UIImage imageNamed:@"zuoyi"] forState:(UIControlStateNormal)];
    [etzy addTarget:self action:@selector(buyPro:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:etzy];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, etzy.bottom+5, etzy.width, 20)];
    name.textAlignment = NSTextAlignmentLeft;
    name.text = @"儿童座椅";
    name.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:name];
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, name.bottom+5, etzy.width, 20)];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.text = @"￥420.00";
    priceLabel.textColor = RGBA(251, 34, 4, 1);
    priceLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:priceLabel];
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, priceLabel.bottom+5, etzy.width, 20)];
    countLabel.textAlignment = NSTextAlignmentLeft;
    countLabel.text = @"已售：103件";
    countLabel.textColor = [UIColor lightGrayColor];
    countLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:countLabel];
    
    UIButton *yaozhen = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2+10, 74, UI_SCREEN_WIDTH/2-20, UI_SCREEN_WIDTH/2-20)];
    [yaozhen addTarget:self action:@selector(buyPro:) forControlEvents:(UIControlEventTouchUpInside)];
    yaozhen.tag = 2002;
    [yaozhen setBackgroundImage:[UIImage imageNamed:@"yaozheng.jpg"] forState:(UIControlStateNormal)];
    [self.view addSubview:yaozhen];
    UILabel *yzname = [[UILabel alloc] initWithFrame:CGRectMake(yaozhen.left, yaozhen.bottom+5, etzy.width, 20)];
    yzname.textAlignment = NSTextAlignmentLeft;
    yzname.text = @"腰枕";
    yzname.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:yzname];
    UILabel *priceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(yaozhen.left, yzname.bottom+5, etzy.width, 20)];
    priceLabel1.textAlignment = NSTextAlignmentLeft;
    priceLabel1.text = @"￥120.00";
    priceLabel1.textColor = RGBA(251, 34, 4, 1);
    priceLabel1.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:priceLabel1];
    
    UILabel *countLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(yaozhen.left, priceLabel1.bottom+5, etzy.width, 20)];
    countLabel1.textAlignment = NSTextAlignmentLeft;
    countLabel1.text = @"已售：53件";
    countLabel1.textColor = [UIColor lightGrayColor];
    countLabel1.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:countLabel1];
    
    UIButton *xsz = [[UIButton alloc] initWithFrame:CGRectMake(10, countLabel.bottom+10, UI_SCREEN_WIDTH/2-20, UI_SCREEN_WIDTH/2-20)];
    [xsz addTarget:self action:@selector(buyPro:) forControlEvents:(UIControlEventTouchUpInside)];
    xsz.tag = 2003;
    [xsz setBackgroundImage:[UIImage imageNamed:@"xiangshuizuo"] forState:(UIControlStateNormal)];
    [self.view addSubview:xsz];
    UILabel *xszname = [[UILabel alloc] initWithFrame:CGRectMake(10, xsz.bottom+5, etzy.width, 20)];
    xszname.textAlignment = NSTextAlignmentLeft;
    xszname.text = @"香水座";
    xszname.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:xszname];
    UILabel *priceLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, xszname.bottom+5, etzy.width, 20)];
    priceLabel2.textAlignment = NSTextAlignmentLeft;
    priceLabel2.text = @"￥32.00";
    priceLabel2.textColor = RGBA(251, 34, 4, 1);
    priceLabel2.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:priceLabel2];
    
    UILabel *countLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, priceLabel2.bottom+5, etzy.width, 20)];
    countLabel2.textAlignment = NSTextAlignmentLeft;
    countLabel2.text = @"已售：303件";
    countLabel2.textColor = [UIColor lightGrayColor];
    countLabel2.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:countLabel2];
    
    UIButton *qwj = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2+10, countLabel1.bottom+10, UI_SCREEN_WIDTH/2-20, UI_SCREEN_WIDTH/2-20)];
    [qwj addTarget:self action:@selector(buyPro:) forControlEvents:(UIControlEventTouchUpInside)];
    qwj.tag = 2004;
    [qwj setImage:[UIImage imageNamed:@"quwei"] forState:(UIControlStateNormal)];
    [self.view addSubview:qwj];
    UILabel *qwjname = [[UILabel alloc] initWithFrame:CGRectMake(yaozhen.left, qwj.bottom+5, etzy.width, 20)];
    qwjname.textAlignment = NSTextAlignmentLeft;
    qwjname.text = @"去味剂";
    qwjname.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:qwjname];
    UILabel *priceLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(yaozhen.left, qwjname.bottom+5, etzy.width, 20)];
    priceLabel3.textAlignment = NSTextAlignmentLeft;
    priceLabel3.text = @"￥28.00";
    priceLabel3.textColor = RGBA(251, 34, 4, 1);
    priceLabel3.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:priceLabel3];
    
    UILabel *countLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(yaozhen.left, priceLabel2.bottom+5, etzy.width, 20)];
    countLabel3.textAlignment = NSTextAlignmentLeft;
    countLabel3.text = @"已售：1008件";
    countLabel3.textColor = [UIColor lightGrayColor];
    countLabel3.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:countLabel3];

}

-  (void)buyPro:(UIButton *)sender
{
    NSString *proname;
    switch (sender.tag) {
        case 2001:
        {
            proname = @"儿童座椅";
        }
            break;
        case 2002:
        {
            proname = @"腰枕";
        }
            break;
        case 2003:
        {
            proname = @"香水座";
        }
            break;
        case 2004:
        {
            proname = @"去味剂";
        }
            break;
            
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"buyproname" object:proname];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
