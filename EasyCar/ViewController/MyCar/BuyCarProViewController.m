//
//  BuyCarProViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/18.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "BuyCarProViewController.h"
#import "CarOrderViewController.h"

@interface BuyCarProViewController ()
{
    UILabel *countLabel;
}
@end

@implementation BuyCarProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backBtn.frame = CGRectMake(10, 30, 80, 42);
    [backBtn setImage:[UIImage imageNamed:@"yulanBack"] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:backBtn];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = RGBA(242, 242, 248, 1);
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIScrollView *_mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    [self.view addSubview:_mainScroll];
    
    UIImageView *proImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH)];
    proImg.image = [UIImage imageNamed:self.imgStr];
    [_mainScroll addSubview:proImg];
    
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, proImg.bottom+10, 200, 20)];
    namelabel.textAlignment = NSTextAlignmentLeft;
    namelabel.text = self.proName;
    [_mainScroll addSubview:namelabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, namelabel.bottom+5, 200, 20)];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.text = self.singlePrice;
    priceLabel.textColor = RGBA(251, 34, 4, 1);
    [_mainScroll addSubview:priceLabel];
    
    UILabel *yishoulbale = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-115, namelabel.bottom, 90, 15)];
    yishoulbale.font = [UIFont systemFontOfSize:14];
    yishoulbale.textAlignment = NSTextAlignmentRight;
    yishoulbale.text = self.count;
    yishoulbale.textColor = [UIColor lightGrayColor];
    [_mainScroll addSubview:yishoulbale];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, priceLabel.bottom+10, UI_SCREEN_WIDTH-20, 0.5)];
    line.backgroundColor = RGBA(220, 220, 220, 1);
    [_mainScroll addSubview:line];
    
    UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, line.bottom+10, 200, 20)];
    colorLabel.text = @"颜色选择";
    colorLabel.font = [UIFont systemFontOfSize:18];
    colorLabel.textAlignment = NSTextAlignmentLeft;
    [_mainScroll addSubview:colorLabel];
    
    NSArray *colorArr = [[NSArray alloc] initWithObjects:@"灰色",@"白色",@"黑色", nil];
    for (int i = 0 ; i < 3; i ++) {
        UIButton *colorBtn= [UIButton buttonWithType:(UIButtonTypeCustom)];
        colorBtn.tag = 3000+i;
        colorBtn.frame = CGRectMake(10+90*i, colorLabel.bottom+10, 80, 40);
        [colorBtn setBackgroundImage:[UIImage imageNamed:@"colorUn"] forState:(UIControlStateNormal)];
        [colorBtn setBackgroundImage:[UIImage imageNamed:@"colorSelect"] forState:(UIControlStateSelected)];
        [colorBtn setTitle:colorArr[i] forState:(UIControlStateNormal)];
        [colorBtn setTitle:colorArr[i] forState:(UIControlStateSelected)];
        [colorBtn setTitleColor:RGBA(36, 36, 36, 1) forState:(UIControlStateNormal)];
        [colorBtn setTitleColor:RGBA(230, 137, 14, 1) forState:(UIControlStateSelected)];
        [colorBtn addTarget:self action:@selector(colorChoose:) forControlEvents:(UIControlEventTouchUpInside)];
        [_mainScroll addSubview:colorBtn];
    }
    
    UILabel *cpggLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, colorLabel.bottom+60, 200, 20)];
    cpggLabel.text = @"产品规格";
    cpggLabel.font = [UIFont systemFontOfSize:18];
    cpggLabel.textAlignment = NSTextAlignmentLeft;
    [_mainScroll addSubview:cpggLabel];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, cpggLabel.bottom+10, 150, 20)];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.text = @"香水分类: 座式香水";
    label1.textColor = RGBA(36, 36, 36, 1);
    label1.font = [UIFont systemFontOfSize:15];
    [_mainScroll addSubview:label1];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2+10, cpggLabel.bottom+10, 150, 20)];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.text = @"品牌: 千秋工坊";
    label2.textColor = RGBA(36, 36, 36, 1);
    label2.font = [UIFont systemFontOfSize:15];
    [_mainScroll addSubview:label2];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, label1.bottom+10, 150, 20)];
    label3.textAlignment = NSTextAlignmentLeft;
    label3.text = @"香调: 混合香调";
    label3.textColor = RGBA(36, 36, 36, 1);
    label3.font = [UIFont systemFontOfSize:15];
    [_mainScroll addSubview:label3];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2+10, label1.bottom+10, 150, 20)];
    label4.textAlignment = NSTextAlignmentLeft;
    label4.text = @"型号: 护主貔貅";
    label4.textColor = RGBA(36, 36, 36, 1);
    label4.font = [UIFont systemFontOfSize:15];
    [_mainScroll addSubview:label4];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10, label4.bottom+10, UI_SCREEN_WIDTH-20, 0.5)];
    line1.backgroundColor = RGBA(220, 220, 220, 1);
    [_mainScroll addSubview:line1];
    
    UIButton *deleteBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    deleteBtn.frame = CGRectMake(10, line1.bottom+10, 40, 40);
    [deleteBtn setImage:[UIImage imageNamed:@"deleteCount"] forState:(UIControlStateNormal)];
    [deleteBtn setTitleColor:RGBA(36, 36, 36, 1) forState:(UIControlStateNormal)];
    deleteBtn.layer.borderColor = [RGBA(36, 36, 36, 1) CGColor];
    deleteBtn.layer.borderWidth = 0.5;
    [_mainScroll addSubview:deleteBtn];
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(deleteBtn.right-0.5, line1.bottom+10, 40, 40)];
    countLabel.text = @"1";
    countLabel.layer.borderWidth = 0.5;
    countLabel.layer.borderColor = [RGBA(36, 36, 36, 1) CGColor];
    countLabel.textAlignment = NSTextAlignmentCenter;
    [_mainScroll addSubview:countLabel];
    UIButton *addBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [addBtn setImage:[UIImage imageNamed:@"addCount"] forState:(UIControlStateNormal)];
    [addBtn setTitleColor:RGBA(36, 36, 36, 1) forState:(UIControlStateNormal)];
    addBtn.layer.borderColor = [RGBA(36, 36, 36, 1) CGColor];
    addBtn.layer.borderWidth = 0.5;
    addBtn.frame = CGRectMake(countLabel.right-0.5, line1.bottom+10, 40, 40);
    [_mainScroll addSubview:addBtn];
    
    [deleteBtn addTarget:self action:@selector(deleteCount) forControlEvents:(UIControlEventTouchUpInside)];
    [addBtn addTarget:self action:@selector(addProCount) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *buyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    buyBtn.frame = CGRectMake(UI_SCREEN_WIDTH-160, line1.bottom+10, 140, 40);
    [buyBtn setTitle:@"立即购买" forState:(UIControlStateNormal)];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    buyBtn.backgroundColor = RGBA(253, 107, 11, 1);
    [buyBtn addTarget:self action:@selector(buyAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_mainScroll addSubview:buyBtn];
    
    [self.view bringSubviewToFront:backBtn];
    _mainScroll.contentSize = CGSizeMake(UI_SCREEN_WIDTH, countLabel.bottom+20);
}

//返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//立即购买
- (void)buyAction
{
    if([countLabel.text integerValue] == 0)
    {
        [MBProgressHUD showError:@"请选择商品数量" toView:self.view];
    }
    else
    {
        CarOrderViewController *order = [[CarOrderViewController alloc] init];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backItem];
        order.count = [countLabel.text intValue];
        order.name = self.proName;
        if([self.proName isEqualToString:@"儿童座椅"])
        {
            order.price = 420.00;
        }
        else if([self.proName isEqualToString:@"腰枕"])
        {
            order.price = 120.00;
        }
        else if([self.proName isEqualToString:@"香水座"])
        {
            order.price = 32.00;
        }
        else if([self.proName isEqualToString:@"去味剂"])
        {
            order.price = 28.00;
        }
        [self.navigationController pushViewController:order animated:YES];
    }
}

//减少数量
- (void)deleteCount
{
    int count = [countLabel.text intValue];
    if([countLabel.text intValue] == 0)
    {
        countLabel.text = @"0";
    }
    else
    {
        count--;
        countLabel.text = [NSString stringWithFormat:@"%d",count];
    }
}

//增加数量
- (void)addProCount
{
    int count = [countLabel.text intValue];
    count++;
    countLabel.text = [NSString stringWithFormat:@"%d",count];
}

//选择颜色
- (void)colorChoose:(UIButton *)sender
{
    for (int i = 0; i < 3; i ++) {
        UIButton *colorBtn = (UIButton *)[self.view viewWithTag:3000+i];
        colorBtn.selected = NO;
    }
    sender.selected = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
