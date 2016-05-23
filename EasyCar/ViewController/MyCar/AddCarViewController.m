//
//  AddCarViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/18.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "AddCarViewController.h"

@interface AddCarViewController ()
{
    UITextField *_bandTF;
    UITextField *_modelTF;
    UITextField *_plateTF;
}
@end

@implementation AddCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加车辆";
    [self.nav setTitle:@"添加车辆" leftText:@"返回" rightTitle:nil showBackImg:YES];
    self.view.backgroundColor = RGBA(242, 242, 248, 1);
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    addLabel.text = @"品牌";
    addLabel.textAlignment = NSTextAlignmentCenter;
    addLabel.font = [UIFont boldSystemFontOfSize:16];
    
    _bandTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, 45)];
    _bandTF.backgroundColor = [UIColor whiteColor];
    _bandTF.delegate = self;
    _bandTF.returnKeyType = UIReturnKeyDone;
    _bandTF.leftView = addLabel;
    _bandTF.font = [UIFont systemFontOfSize:15];
    _bandTF.textColor = RGBA(51, 51, 51, 1);
    _bandTF.placeholder = @"输入车辆品牌";
    _bandTF.leftViewMode = UITextFieldViewModeAlways;
    _bandTF.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_bandTF];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(20, _bandTF.bottom, UI_SCREEN_WIDTH-20, 0.5)];
    line1.backgroundColor = RGBA(200, 200, 200, 1);
    [self.view addSubview:line1];
    
    UILabel *addLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    addLabel1.text = @"型号";
    addLabel1.textAlignment = NSTextAlignmentCenter;
    addLabel1.font = [UIFont boldSystemFontOfSize:16];
    _modelTF = [[UITextField alloc] initWithFrame:CGRectMake(0, line1.bottom, UI_SCREEN_WIDTH, 45)];
    _modelTF.backgroundColor = [UIColor whiteColor];
    _modelTF.delegate = self;
    _modelTF.returnKeyType = UIReturnKeyDone;
    _modelTF.leftView = addLabel1;
    _modelTF.font = [UIFont systemFontOfSize:15];
    _modelTF.textColor = RGBA(51, 51, 51, 1);
    _modelTF.placeholder = @"输入车辆型号";
    _modelTF.leftViewMode = UITextFieldViewModeAlways;
    _modelTF.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_modelTF];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(20, _modelTF.bottom, UI_SCREEN_WIDTH-20, 0.5)];
    line2.backgroundColor = RGBA(200, 200, 200, 1);
    [self.view addSubview:line2];
    
    UILabel *addLabe2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    addLabe2.text = @"车牌";
    addLabe2.textAlignment = NSTextAlignmentCenter;
    addLabe2.font = [UIFont boldSystemFontOfSize:16];
    _plateTF = [[UITextField alloc] initWithFrame:CGRectMake(0, line2.bottom, UI_SCREEN_WIDTH, 45)];
    _plateTF.backgroundColor = [UIColor whiteColor];
    _plateTF.delegate = self;
    _plateTF.returnKeyType = UIReturnKeyDone;
    _plateTF.leftView = addLabe2;
    _plateTF.font = [UIFont systemFontOfSize:15];
    _plateTF.textColor = RGBA(51, 51, 51, 1);
    _plateTF.placeholder = @"输入车辆车牌";
    _plateTF.leftViewMode = UITextFieldViewModeAlways;
    _plateTF.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_plateTF];
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(20, _plateTF.bottom, UI_SCREEN_WIDTH-20, 0.5)];
    line3.backgroundColor = RGBA(200, 200, 200, 1);
    [self.view addSubview:line3];
    
    UIButton *addBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    addBtn.frame = CGRectMake(20, _plateTF.bottom+30, UI_SCREEN_WIDTH-40, 40);
    addBtn.layer.cornerRadius = 3;
    [addBtn setTitle:@"添加" forState:(UIControlStateNormal)];
    addBtn.backgroundColor = RGBA(50, 129, 255, 1);
    [addBtn addTarget:self action:@selector(addCar) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:addBtn];
}

- (void)addCar
{
    if([_bandTF.text length] == 0){
        [MBProgressHUD showError:@"请输入品牌" toView:self.view];
        return;
    }
    if([_modelTF.text length] == 0)
    {
        [MBProgressHUD showError:@"请输入型号" toView:self.view];
        return;
    }
    if([_plateTF.text length] == 0)
    {
        [MBProgressHUD showError:@"请输入车牌" toView:self.view];
        return;
    }
    
    [self addCarRequest];
}

- (void)addCarRequest
{
    NSString *url = BaseURL@"addCar";
    NSDictionary *parameters = @{
                                 @"memberId":[UserManager manager].userID,
                                 @"carBrand":_bandTF.text,
                                 @"carModel":_modelTF.text,
                                 @"carPlate":_plateTF.text
                                 };
    
    [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        NSLog(@"%@", dic[@"msg"]);
        
        if ([dic[@"status"] isEqual:@(200)]) {
            [MBProgressHUD showSuccess:dic[@"msg"] toView:self.view];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
