//
//  OftenAddressViewController.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/4/28.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "OftenAddressViewController.h"
#import "OftenAddressTableViewCell.h"
#import "WoYaoTingCheVC.h"
#import "Database.h"
#import "OftenAddressModel.h"
#import "Park.h"
typedef enum
{
    _other = 0 ,
    _home ,
    _company ,
}EditType;

@interface OftenAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *addressTabel;
@property (nonatomic ,strong) NSMutableArray *addressArr;
@property (nonatomic ) EditType editType;
@property (nonatomic ) NSInteger selectCount;
@end

@implementation OftenAddressViewController


-(UITableView *)addressTabel
{
    if (!_addressTabel) {
        if (!_addressTabel) {
            _addressTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Heigth - 64) style:UITableViewStylePlain];
            _addressTabel.backgroundColor = RGBA(240, 240, 240, 1);
            _addressTabel.dataSource = self;
            _addressTabel.delegate = self;
            _addressTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
            _addressTabel.estimatedRowHeight = 60;
            [_addressTabel registerNib:[UINib nibWithNibName:@"OftenAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"addressCell"];
        }
        return _addressTabel;
    }
    return _addressTabel;
}
-(NSMutableArray *)addressArr
{
    if (!_addressArr) {
        _addressArr = [NSMutableArray new];
    }
    return _addressArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.nav setTitle:@"常用地址" leftText:nil rightTitle:nil showBackImg:YES];
    [self.nav.rightImageBtn setImage:[Unit changeImage:[UIImage imageNamed:@"iconfont_tianjia"] toScale:2] forState:UIControlStateNormal];
    
    [self.view addSubview:self.addressTabel];
    
    //    [self requestData];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
}

#pragma mark 加入本地数据库
-(void)addDataIntoSql:(Park *)park
{
    OftenAddressModel *model = nil;

    if (self.selectCount == _addressArr.count) {
        model = [[OftenAddressModel alloc] init];
        model.parkName = park.parkName;
        model.parkAddress = park.address;
        switch (_editType) {
            case _other:
                model.addressType = @"other";
                break;
            case _home:
                model.addressType = @"home";
                break;
            case _company:
                model.addressType = @"company";
                break;
                
            default:
                break;
        }
        [_addressArr addObject:model];
    }else
    {
        model = _addressArr[_selectCount];
        model.parkName = park.parkName;
        model.parkAddress = park.address;
    }
    Database *database = [Database shareDatabase];
    [database insertIntoData:_addressArr];
    
}
#pragma mark 刷新数据
-(void)requestData
{
    [_addressArr removeAllObjects];
    Database *database = [Database shareDatabase];
    _addressArr = [database getAllData];
    [self checkAddressArr:_addressArr];
    [self.addressTabel reloadData];
}
#pragma mark 检查是否有家庭或者公司的地址
-(void)checkAddressArr:(NSMutableArray *)arr
{
    if (!arr.count) {    //这里是判断当第一次运行时，这个数值必为0
        for(NSInteger i = 0 ; i < 2 ; i ++)
        {
            OftenAddressModel *model = [[OftenAddressModel alloc] init];
            model.parkName = @"添加";
            model.parkAddress = @"添加";
            if (i) {
                model.addressType = @"company";
            }else
            {
                model.addressType = @"home";
                
            }
            [_addressArr addObject:model];
            
        }
    }
}
#pragma mark 添加常用地址
- (void)right
{
    self.selectCount = _addressArr.count;
    self.editType = _other;
    [self addOftenAddress];
}
-(void)addOftenAddress
{
    WoYaoTingCheVC * vc = [[WoYaoTingCheVC alloc] init];
    vc.mapType = 2;
    vc.lastVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OftenAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
    cell.addressStr.tag = indexPath.row + 10000;
    cell.addressEdit.tag = indexPath.row + 20000;
    cell.addressDelete.tag = indexPath.row + 30000;
    [cell setCellInfoWithModel:_addressArr[indexPath.row]];
    [cell.addressStr addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigateAddress:)]];
    [cell.addressEdit addTarget:self action:@selector(editOftenAddress:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addressDelete addTarget:self action:@selector(deleteOftenAddress:) forControlEvents:UIControlEventTouchUpInside];
     return cell;
}
#pragma mark 删除常用地址
-(void)deleteOftenAddress:(UIButton *)sender
{
    OftenAddressModel *model = _addressArr[sender.tag - 30000];
    if (sender.tag - 30000 < 2) {
        model.parkName = @"添加";
        model.parkAddress = @"添加";
    }else
    {
        [_addressArr removeObjectAtIndex:sender.tag - 30000];
//        [_addressTabel deleteRowsAtIndexPaths:sender.tag - 30000 withRowAnimation:UITableViewRowAnimationTop];
    }
    [_addressTabel reloadData];
    Database *database = [Database shareDatabase];
    [database insertIntoData:_addressArr];
}
#pragma mark 编辑常用地址
-(void)editOftenAddress:(UIButton *)sender
{
    self.selectCount = sender.tag - 20000;
    [self addOftenAddress];
}
#pragma mark 导航常用地址
-(void)navigateAddress:(UITapGestureRecognizer *)tap
{
    UILabel *addressLB = (UILabel *)tap.view;
    if ([addressLB.text isEqualToString:@"添加"]) {
        self.selectCount = addressLB.tag - 10000;
        [self addOftenAddress];
    }else{
        WoYaoTingCheVC * vc = [[WoYaoTingCheVC alloc] init];
        vc.mapType = 1;
        vc.lastVC = self;
        vc.selectPark = [_addressArr[addressLB.tag - 10000] parkName];
        [self.navigationController pushViewController:vc animated:YES];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
     
     /*
      #pragma mark - Navigation
      
      // In a storyboard-based application, you will often want to do a little preparation before navigation
      - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
      // Get the new view controller using [segue destinationViewController].
      // Pass the selected object to the new view controller.
      }
      */
     
     @end
