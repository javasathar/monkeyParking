//
//  YiJianFanKuiVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 16/1/4.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "YiJianFanKuiVC.h"

@interface YiJianFanKuiVC ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *placeHodlerLB;
@property (strong, nonatomic) IBOutlet UITextView *feedbackTV;
@property (strong, nonatomic) IBOutlet UITextField *connectTF;



@end

@implementation YiJianFanKuiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nav setTitle:@"意见反馈" leftText:@"返回" rightTitle:nil showBackImg:YES];
    // Do any additional setup after loading the view.
    
    _feedbackTV.layer.borderWidth = 0.5;
    _feedbackTV.layer.borderColor = [[UIColor colorWithWhite:0.834 alpha:1.000] CGColor];
    _connectTF.layer.borderWidth = 0.5;
    _connectTF.layer.borderColor = [[UIColor colorWithWhite:0.834 alpha:1.000] CGColor];
    
    CGRect frame = [_connectTF frame];
    frame.size.width = 7.0f;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    _connectTF.leftViewMode = UITextFieldViewModeAlways;
    _connectTF.leftView = leftview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 意见反馈请求

- (void)sendFeedbackInfo
{
    NSString *url = BaseURL"feedbackInfo";
    NSDictionary *parameters = @{
                                 @"memberId":self.user.userID,
                                 @"contentInfo":_feedbackTV.text,
                                 @"connectWay":_connectTF.text
                                 };
    [self getRequestURL:url parameters:parameters success:^(NSDictionary *dic) {
        
        [MBProgressHUD showSuccess:dic[@"msg"] toView:Window];
        [self.navigationController popViewControllerAnimated:YES];
        
    } elseAction:^(NSDictionary *dic) {
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark 点击提交

- (IBAction)onSubmit:(id)sender {
    
    [self sendFeedbackInfo];
}


- (void)textViewDidChange:(UITextView *)textView
{
    _placeHodlerLB.hidden = textView.hasText;
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
