//
//  TianJiaCheLiangVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/16.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "TianJiaCheLiangVC.h"
#import "CharItem.h"
#import "CharItem1.h"

@interface TianJiaCheLiangVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) IBOutlet UITextField *bandTF;
@property (nonatomic, strong) IBOutlet UITextField *modelTF;
@property (nonatomic, strong) IBOutlet UITextField *plateTF;
@property (strong, nonatomic) IBOutlet UIButton *plateBtn;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cHeight;

@end


@implementation CharItemFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    //大小
    CGFloat width = 25;
    CGFloat height = width;
    self.itemSize = CGSizeMake(width, height);
    self.minimumInteritemSpacing = 5;
    self.minimumLineSpacing = 5;
    //仅设置左右边距
    self.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    // (全局)设置段头视图大小它才能显示出来
    //    self.headerReferenceSize = CGSizeMake(WIDTH, 40);
    
}
@end

@implementation TianJiaCheLiangVC
{
    NSArray * _leftArray;
    NSArray * _rightArray;
    NSIndexPath *_indexPathOne;
    NSIndexPath *_indexPathTwo;
    BOOL _didClickPlateBtn; // 车牌界面
}


- (void)viewDidAppear:(BOOL)animated
{
    if (!_didClickPlateBtn) {
        [self clickGuiShuDi:_plateBtn];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.nav setTitle:@"添加车辆" leftText:@"返回" rightTitle:@"添加" showBackImg:YES];
    
    _indexPathOne = [NSIndexPath indexPathForRow:0 inSection:0];
    _indexPathTwo = [NSIndexPath indexPathForRow:0 inSection:1];
    
    CharItemFlowLayout *flowLayout = [[CharItemFlowLayout alloc] init];
    _collectionView.collectionViewLayout = flowLayout;
    [_collectionView registerNib:[UINib nibWithNibName:@"CharItem1" bundle:nil] forCellWithReuseIdentifier:@"CharItem1"];
    
    _leftArray = [NSArray arrayWithObjects:@"粤",@"京",@"津",@"冀",@"蒙",@"辽",@"鲁",@"晋",@"吉",@"苏",@"皖",@"豫",@"陕",@"黑",@"沪",@"浙",@"赣",@"鄂",@"湘",@"渝",@"川",@"甘",@"宁",@"闽",@"桂",@"贵",@"云",@"藏",@"青",@"新",@"琼", nil];
    _rightArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];


}

#pragma mark 右边的添加
- (void)right
{
    [self addCarRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 点击归属地
- (IBAction)clickGuiShuDi:(UIButton *)sender {

    [UIView animateWithDuration:0.1 animations:^{
        if (_collectionView.contentSize.height < Heigth-270) {
            
            _cHeight.constant = _collectionView.contentSize.height - 1;// 减1 呵呵
        }
        else
        {
            _cHeight.constant = Heigth-270;
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {

        if (!_didClickPlateBtn) {
            _didClickPlateBtn = YES;
            // 一开始选中两个
            [self collectionView:_collectionView didSelectItemAtIndexPath:_indexPathOne];
            [self collectionView:_collectionView didSelectItemAtIndexPath:_indexPathTwo];
            
            NSString *title = [NSString stringWithFormat:@"%@%@",_leftArray[0],_rightArray[0]];
            [_plateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_plateBtn setTitle:title forState:UIControlStateNormal];

        }
        
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}


#pragma mark 点击添加（放在底下的添加用户体验不好，暂时隐藏）
- (IBAction)clickAddBtn:(id)sender {

    [self addCarRequest];
    
}

#pragma mark 添加车辆请求
- (void)addCarRequest
{
    if ([self isRight]) {
        NSString *url = BaseURL@"addCar";
        NSDictionary *parameters = @{
                                     @"memberId":[UserManager manager].userID,
                                     @"carBrand":_bandTF.text,
                                     @"carModel":_modelTF.text,
                                     @"carPlate":[NSString stringWithFormat:@"%@%@",_plateBtn.titleLabel.text,_plateTF.text]
                                     };
        
        [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dic = responseObject;
            NSLog(@"%@", dic[@"msg"]);
            
            if ([dic[@"status"] isEqual:@(200)]) {
                [MBProgressHUD showSuccess:dic[@"msg"] toView:self.view];
                // 添加成功 发通知
                [[NSNotificationCenter defaultCenter] postNotificationName:AddCarSuccess object:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [MBProgressHUD showError:dic[@"msg"] toView:self.view];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"报错：%@", [error localizedDescription]);
            [MBProgressHUD showError:@"网络加载出错" toView:self.view];
        }];
    }
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (!_leftArray) {
        return 0;
    }
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _leftArray.count;
    }
    else
    {
        return _rightArray.count;
    }
    
}

#pragma mark ［配置单元格］
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CharItem1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CharItem1" forIndexPath:indexPath];

    // 复用时需判断是否需要是被选中的
    if ([indexPath isEqual:_indexPathOne] || [indexPath isEqual:_indexPathTwo] ) {
        
        [cell shouldSelected:YES];
    }
    else
    {
        [cell shouldSelected:NO];
    }
    
    if (indexPath.section == 0) {
        
        cell.charLabel.text = _leftArray[indexPath.row];
    }
    else
    {
        cell.charLabel.text = _rightArray[indexPath.row];
    }

    return cell;
}

#pragma mark scrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing];
}
- (IBAction)collectionViewdidClick:(id)sender {
    
    [self endEditing];
}

- (void)endEditing
{
    [self.view endEditing:YES];
}

#pragma mark - 点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    NSMutableString *title = [NSMutableString stringWithString:_plateBtn.titleLabel.text];
    
    
    if (indexPath.section == 0) {

        CharItem1 *cell = (CharItem1 *)[_collectionView cellForItemAtIndexPath:_indexPathOne];
        [cell shouldSelected:NO];
        _indexPathOne = indexPath;
        // 换字
        [title replaceCharactersInRange:NSMakeRange(0, 1) withString:_leftArray[indexPath.row]];
    }
    else
    {
        CharItem1 *cell = (CharItem1 *)[_collectionView cellForItemAtIndexPath:_indexPathTwo];
        [cell shouldSelected:NO];
        _indexPathTwo = indexPath;
        
        // 换字
        [title replaceCharactersInRange:NSMakeRange(1, 1) withString:_rightArray[indexPath.row]];
    }
    
    // 更换
    [_plateBtn setTitle:title forState:UIControlStateNormal];
    
    CharItem1 *cell = (CharItem1 *)[_collectionView cellForItemAtIndexPath:indexPath];
    [cell shouldSelected:YES];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_bandTF])
    {
        [_modelTF becomeFirstResponder];
    }
    else if ([textField isEqual:_modelTF])
    {
//        [self clickGuiShuDi:_plateBtn];
        [self endEditing];
        [_plateTF becomeFirstResponder];
    }
    else if ([textField isEqual:_plateTF])
    {
        // 停止编辑键盘消失
        [self endEditing];
        [self addCarRequest];

    }
    return YES;
    
}

#pragma mark 添加条件
- (BOOL)isRight
{
    if (_bandTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入车辆品牌" toView:Window];
        return NO;
    }
    if (_modelTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入车辆型号" toView:Window];
        return NO;
    }
    if (_plateTF.text.length != 5) {
        [MBProgressHUD showError:@"请输入正确的五位车牌号" toView:Window];
        return NO;
    }
    
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view != self.collectionView) {
        
        return NO;
        
    }
    return YES;
}
@end
