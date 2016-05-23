//
//  CarProsViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/18.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "CarProsViewController.h"
#import "BuyCarProViewController.h"
#import "BuyItemCell.h"

#pragma mark - FlowLayout布局



@interface CarProsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation ItemFlowLayout


- (void)prepareLayout
{
    [super prepareLayout];
    //大小
    CGFloat width = (UI_SCREEN_WIDTH-30)/2;//20*3=60
    CGFloat height = width * 1.5;
    self.itemSize = CGSizeMake(width, height);
    self.minimumLineSpacing = 20;
    //仅设置左右边距
    self.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    // (全局)设置段头视图大小它才能显示出来
    //    self.headerReferenceSize = CGSizeMake(WIDTH, 40);
}
@end

@implementation CarProsViewController
{
    UICollectionView *_collectionView;
    
    NSArray *_datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"爱车用品";
    [self.nav setTitle:@"爱车用品" leftText:@"返回" rightTitle:nil showBackImg:YES];
    self.view.backgroundColor = RGBA(242, 242, 248, 1);
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // _collectionView
    self.automaticallyAdjustsScrollViewInsets = YES;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64) collectionViewLayout:[[ItemFlowLayout alloc] init]];
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self registerCVCellsAndRefreshView];
    [self.view addSubview:_collectionView];
    
    _datas = @[@{
                   @"image":@"zuoyi",
                   @"name":@"儿童座椅",
                   @"price":@"￥420.00",
                   @"count":@"已售：103件"
                   },
               @{
                   @"image":@"xiangshuizuo",
                   @"name":@"香水座",
                   @"price":@"￥32.00",
                   @"count":@"已售303件"
                   },
               @{
                   @"image":@"yaozheng.jpg",
                   @"name":@"腰枕",
                   @"price":@"￥120.00",
                   @"count":@"已售53件"
                   },
               @{
                   @"image":@"quwei",
                   @"name":@"去味剂",
                   @"price":@"￥28.00",
                   @"count":@"已售1008件"
                   }
               ];
    
//    [self oldConfig];
    
}



#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _datas.count;
}

#pragma mark ［配置单元格］
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BuyItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BuyItemCell" forIndexPath:indexPath];
    [cell setCellInfoWithDic:_datas[indexPath.row]];

    return cell;
}

#pragma mark - 点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BuyItemCell *cell = (BuyItemCell *) [_collectionView cellForItemAtIndexPath:indexPath];
    BuyCarProViewController *carpro = [[BuyCarProViewController alloc] init];
    carpro.imgStr = _datas[indexPath.row][@"image"];
    carpro.count = cell.countLB.text;
    carpro.proName = cell.nameLB.text;
    carpro.singlePrice = cell.priceLB.text;
    [self.navigationController pushViewController:carpro animated:YES];
}

#pragma mark 注册
- (void)registerCVCellsAndRefreshView
{
    NSArray *registerArr_CV = @[@"BuyItemCell"];
    for (NSString *cellName in registerArr_CV) {
        [_collectionView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellWithReuseIdentifier:cellName];
    }
}



-  (void)buyPro:(UIButton *)sender
{
    BuyCarProViewController *carpro = [[BuyCarProViewController alloc] init];
    switch (sender.tag) {
        case 2001:
        {
            carpro.imgStr = @"zuoyi";
            carpro.count = @"已售103件";
            carpro.proName = @"儿童座椅";
            carpro.singlePrice = @"￥420.00";
        }
            break;
        case 2002:
        {
            carpro.imgStr = @"yaozheng.jpg";
            carpro.count = @"已售53件";
            carpro.proName = @"腰枕";
            carpro.singlePrice = @"￥120.00";
        }
            break;
        case 2003:
        {
            carpro.imgStr = @"xiangshuizuo";
            carpro.count = @"已售303件";
            carpro.proName = @"香水座";
            carpro.singlePrice = @"￥32.00";
        }
            break;
        case 2004:
        {
            carpro.imgStr = @"quwei";
            carpro.count = @"已售1008件";
            carpro.proName = @"去味剂";
            carpro.singlePrice = @"￥28.00";
        }
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:carpro animated:YES];
}

- (void)oldConfig
{
    
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

@end
