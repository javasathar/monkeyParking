//
//  UseCarViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/17.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "UseCarViewController.h"
#import "TouFangAdViewController.h"

@interface UseCarViewController ()

@end

@implementation UseCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我要取车";
    self.view.backgroundColor = RGBA(242, 242, 248, 1);
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIScrollView *_mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    [self.view addSubview:_mainScrollView];
    
    UIView *bigCarView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 118, 87)];
    bigCarView.backgroundColor = [UIColor whiteColor];
    bigCarView.layer.borderColor = [RGBA(220, 220, 220, 1) CGColor];
    bigCarView.layer.borderWidth = 0.5;
    [_mainScrollView addSubview:bigCarView];
    
    UIImageView *bigCarImg = [[UIImageView alloc] initWithFrame:CGRectMake(18, 17, 83, 61)];
    bigCarImg.image = [UIImage imageNamed:@"redCar_quche"];
    [bigCarView addSubview:bigCarImg];
    
    UIView *smallView = [[UIView alloc] initWithFrame:CGRectMake(10, bigCarView.bottom-0.5, 118, 22)];
    smallView.backgroundColor = [UIColor whiteColor];
    smallView.layer.borderColor = [RGBA(220, 220, 220, 1) CGColor];
    smallView.layer.borderWidth = 0.5;
    [_mainScrollView addSubview:smallView];
    
    UIImageView *washImg = [[UIImageView alloc] initWithFrame:CGRectMake(13, 1, 19, 19)];
    washImg.image = [UIImage imageNamed:@"green_car"];
    [smallView addSubview:washImg];
    
    UIImageView *chongImg = [[UIImageView alloc] initWithFrame:CGRectMake(smallView.width/2-12, 5, 24, 12)];
    chongImg.image = [UIImage imageNamed:@"yellow_dian"];
    [smallView addSubview:chongImg];
    
    UIImageView *gwcImg = [[UIImageView alloc] initWithFrame:CGRectMake(90, 4, 20, 14)];
    gwcImg.image = [UIImage imageNamed:@"red_gwc"];
    [smallView addSubview:gwcImg];
    
    UILabel *chexingLabel = [[UILabel alloc] initWithFrame:CGRectMake(bigCarView.right+15, 10, UI_SCREEN_WIDTH-bigCarView.right-20, 15)];
    chexingLabel.text = @"车型:  宝马-Z4";
    chexingLabel.textColor = RGBA(36, 36, 36, 1);
    chexingLabel.font = [UIFont systemFontOfSize:15];
    [_mainScrollView addSubview:chexingLabel];
    
    UILabel *locLabel = [[UILabel alloc] initWithFrame:CGRectMake(chexingLabel.left, chexingLabel.bottom+5, 43,15)];
    locLabel.textAlignment = NSTextAlignmentLeft;
    locLabel.text = @"位置:";
    locLabel.font = [UIFont systemFontOfSize:15];
    locLabel.textColor = RGBA(36, 36, 36, 1);
    [_mainScrollView addSubview:locLabel];
    
    CGSize textSize = [@"TCL国际E城多媒体大厦停车场2层A点" sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(UI_SCREEN_WIDTH-locLabel.right-10,60)lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *locLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(locLabel.right, chexingLabel.bottom+5, UI_SCREEN_WIDTH-locLabel.right-10,textSize.height)];
    locLabel1.textAlignment = NSTextAlignmentLeft;
    locLabel1.font = [UIFont systemFontOfSize:15];
    locLabel1.numberOfLines = 0;
    locLabel1.lineBreakMode = NSLineBreakByWordWrapping;
    locLabel1.text = @"TCL国际E城多媒体大厦停车场2层A点";
    locLabel1.textColor = RGBA(36, 36, 36, 1);
    [_mainScrollView addSubview:locLabel1];
    
    UILabel *tingLabel = [[UILabel alloc] initWithFrame:CGRectMake(bigCarView.right+15, locLabel1.bottom+5, UI_SCREEN_WIDTH-bigCarView.right-20, 15)];
    tingLabel.text = @"停留:  2小时40分";
    tingLabel.textColor = RGBA(36, 36, 36, 1);
    tingLabel.font = [UIFont systemFontOfSize:15];
    [_mainScrollView addSubview:tingLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(bigCarView.right+15, tingLabel.bottom+5, UI_SCREEN_WIDTH-bigCarView.right-20, 15)];
    //priceLabel.text = @"价格:  340元";
    priceLabel.textColor = RGBA(36, 36, 36, 1);
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:@"价格:  50元"];
    long int a = [[mstr string] rangeOfString:@"50元"].location;
    [mstr addAttribute:NSForegroundColorAttributeName value:RGBA(251, 25, 54, 1) range:NSMakeRange(a,@"50元".length)];
    priceLabel.attributedText = mstr;
    priceLabel.font = [UIFont systemFontOfSize:15];
    [_mainScrollView addSubview:priceLabel];
    
    UIButton *touAdBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    touAdBtn.frame = CGRectMake(20, priceLabel.bottom+40, UI_SCREEN_WIDTH/2-40, 40);
    touAdBtn.layer.cornerRadius = 3;
    [touAdBtn setTitle:@"投放广告" forState:(UIControlStateNormal)];
    [touAdBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    touAdBtn.backgroundColor = RGBA(251, 70, 95, 1);
    [touAdBtn addTarget:self action:@selector(touAdAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_mainScrollView addSubview:touAdBtn];
    
    UIButton *qucheBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    qucheBtn.frame = CGRectMake(UI_SCREEN_WIDTH/2+20, priceLabel.bottom+40, UI_SCREEN_WIDTH/2-40, 40);
    qucheBtn.layer.cornerRadius = 3;
    [qucheBtn setTitle:@"取车" forState:(UIControlStateNormal)];
    [qucheBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    qucheBtn.backgroundColor = RGBA(50, 129, 255, 1);
    [qucheBtn addTarget:self action:@selector(useCarAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_mainScrollView addSubview:qucheBtn];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, touAdBtn.bottom+20, UI_SCREEN_WIDTH-20, (UI_SCREEN_WIDTH-20)*0.8956)];
    imageV.image = [UIImage imageNamed:@"carBg1"];
    [_mainScrollView addSubview:imageV];
    
    
    _mainScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, imageV.bottom+20);
}

//投放广告
- (void)touAdAction
{
    TouFangAdViewController *touAdVc = [[TouFangAdViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController pushViewController:touAdVc animated:YES];
}

//取车
- (void)useCarAction
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定预约取车?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(0 == buttonIndex)
    {
        
    }
    else
    {
        [MBProgressHUD showSuccess:@"预约取车成功" toView:self.view];
    }
}

@end
