//
//  MessageDetailVC.m
//  EasyCar
//
//  Created by 橙晓侯 on 15/12/28.
//  Copyright © 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "MessageDetailVC.h"

@interface MessageDetailVC ()
@property (strong, nonatomic) IBOutlet UILabel *lb1;
@property (strong, nonatomic) IBOutlet UILabel *lb2;
@property (strong, nonatomic) IBOutlet UILabel *lb3;

@end

@implementation MessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.nav setTitle:@"消息" leftText:@"返回" rightTitle:nil showBackImg:YES];

    
    if (_info) {
        [self requestMessageID:_info.ID];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestMessageID:(NSString *)ID
{
    
    NSString *url = BaseURL@"CheckRead";
    NSDictionary *parameters = @{
                                 @"infoId":ID
                                 };
    [self getRequestURL:url parameters:parameters success:^(NSDictionary *dic) {
        
        _lb1.text = [NSString stringWithFormat:@"信息提示：%@",dic[@"data"][@"title"]];
        _lb2.text = [Unit stringFromTimeInterval:[dic[@"data"][@"createTime"] floatValue]/1000 formatterOrNil:@"yyyy.MM.dd"];
        _lb3.text = dic[@"data"][@"infonotify"];
        
    } elseAction:^(NSDictionary *dic) {
        
        
    } failure:^(NSError *error) {
        
        
    }];
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
