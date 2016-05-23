//
//  MiddleViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/29.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "MiddleViewController.h"
//#import "WashCarViewController.h"
//#import "ChongdianViewController.h"
#import "DaijiaViewController.h"
#import "CarProsViewController.h"
#import "MyCarWeiViewController.h"
#import "MyTicketViewController.h"
#import "SelectParkingSpaceVC.h"
#import "ChongdianVC.h"
#import "XiCheVC.h"
#import "MeViewController.h"
#import "GuanYuWoMenVC.h"
#import "AboutUsViewController.h"
#define BGH Heigth*0.65
@interface MiddleViewController ()<UMSocialUIDelegate>

@end

@implementation MiddleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.disableMLTransition = YES;// 禁止侧滑
    
    
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgImg.image = [UIImage imageNamed:@"index_index_bg.png"];
    [self.view addSubview:bgImg];
    
    UIView *btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, BGH)];
    btnBgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnBgView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Heigth-100, UI_SCREEN_WIDTH, 100)];
    bottomView.backgroundColor = [UIColor clearColor];
    
    UIView *whiteBGView = [[UIView alloc] initWithFrame:CGRectMake(0, Heigth-55, Width, 55)];
    whiteBGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteBGView];
    [self.view addSubview:bottomView];
    
    // 选中中间，两边变灰
    UIButton *centerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    centerBtn.frame = CGRectMake(UI_SCREEN_WIDTH/2-25, bottomView.height-55, 50, 50);
    [centerBtn setImage:[UIImage imageNamed:@"logo"] forState:(UIControlStateNormal)];
    [centerBtn addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:centerBtn];
    
    UIButton *leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    leftBtn.frame = CGRectMake(0, centerBtn.top, 110, 55);

    [leftBtn setImage:[[UIImage imageNamed:@"home_tab1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:(UIControlStateNormal)];
    leftBtn.tintColor = [UIColor colorWithWhite:0.569 alpha:1.000];
    
    [leftBtn addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:leftBtn];
    

    UIButton *rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightBtn.frame = CGRectMake(UI_SCREEN_WIDTH-110, centerBtn.top, 110, 55);
    
    [rightBtn setImage:[[UIImage imageNamed:@"home_tab3"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:(UIControlStateNormal)];
    rightBtn.tintColor = [UIColor colorWithWhite:0.569 alpha:1.000];
    
    [rightBtn addTarget:self action:@selector(meVC) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:rightBtn];
    

    
    
    UIButton *btn1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn1.tag = 2000;
    btn1.frame = CGRectMake(20, 0, 60, 60);
    [btn1 setImage:[UIImage imageNamed:@"index_index3.png"] forState:(UIControlStateNormal)];
    [btnBgView addSubview:btn1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(btn1.left-10, btn1.bottom+5, 80, 20)];
    label1.text = @"关于我们";
    label1.font = [UIFont systemFontOfSize:16];
    label1.textColor = RGBA(81, 81, 81, 1);
    label1.textAlignment = NSTextAlignmentCenter;
    [btnBgView addSubview:label1];
    
    UIButton *btn2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn2.tag = 2001;
    btn2.frame = CGRectMake(UI_SCREEN_WIDTH/2-30, 0, 60, 60);
    [btn2 setImage:[UIImage imageNamed:@"index_index5"] forState:(UIControlStateNormal)];
    [btnBgView addSubview:btn2];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(btn2.left-10, btn2.bottom+5, 80, 20)];
    label2.text = @"我的优惠券";
    label2.font = [UIFont systemFontOfSize:16];
    label2.textColor = RGBA(81, 81, 81, 1);
    label2.textAlignment = NSTextAlignmentCenter;
    [btnBgView addSubview:label2];
    
    UIButton *btn3 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn3.tag = 2002;
    btn3.frame = CGRectMake(UI_SCREEN_WIDTH-80, 0, 60, 60);
    [btn3 setImage:[UIImage imageNamed:@"index_index6"] forState:(UIControlStateNormal)];
    [btnBgView addSubview:btn3];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(btn3.left-10, btn3.bottom+5, 80, 20)];
    label3.text = @"我的车位";
    label3.font = [UIFont systemFontOfSize:16];
    label3.textColor = RGBA(81, 81, 81, 1);
    label3.textAlignment = NSTextAlignmentCenter;
    [btnBgView addSubview:label3];
    
    UIButton *btn4 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn4.tag = 2003;
    btn4.frame = CGRectMake(20, label1.bottom+20, 60, 60);
    [btn4 setImage:[UIImage imageNamed:@"share_icon"] forState:(UIControlStateNormal)];
    [btnBgView addSubview:btn4];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(btn4.left-10, btn4.bottom+5, 80, 20)];
    label4.text = @"分享";
    label4.font = [UIFont systemFontOfSize:16];
    label4.textColor = RGBA(81, 81, 81, 1);
    label4.textAlignment = NSTextAlignmentCenter;
    [btnBgView addSubview:label4];
    
    UIButton *btn5 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn5.tag = 2004;
    btn5.frame = CGRectMake(UI_SCREEN_WIDTH/2-30, label2.bottom+20, 60, 60);
    [btn5 setImage:[UIImage imageNamed:@"index_index5.png"] forState:(UIControlStateNormal)];
//    [btnBgView addSubview:btn5];
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(btn5.left-10, btn5.bottom+5, 80, 20)];
    label5.text = @"我的优惠券";
    label5.font = [UIFont systemFontOfSize:16];
    label5.textColor = RGBA(81, 81, 81, 1);
    label5.textAlignment = NSTextAlignmentCenter;
//    [btnBgView addSubview:label5];
    
    UIButton *btn6 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn6.tag = 2005;
    btn6.frame = CGRectMake(UI_SCREEN_WIDTH-80, label3.bottom+20, 60, 60);
    [btn6 setImage:[UIImage imageNamed:@"index_index6.png"] forState:(UIControlStateNormal)];
//    [btnBgView addSubview:btn6];
    
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(btn6.left-10, btn6.bottom+5, 80, 20)];
    label6.text = @"我的车位";
    label6.font = [UIFont systemFontOfSize:16];
    label6.textColor = RGBA(81, 81, 81, 1);
    label6.textAlignment = NSTextAlignmentCenter;
//    [btnBgView addSubview:label6];
    
    [btn1 addTarget:self action:@selector(menuAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [btn2 addTarget:self action:@selector(menuAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [btn3 addTarget:self action:@selector(menuAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [btn4 addTarget:self action:@selector(menuAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [btn5 addTarget:self action:@selector(menuAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [btn6 addTarget:self action:@selector(menuAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [UIView animateWithDuration:0.5 animations:^{
        btnBgView.top = UI_SCREEN_HEIGHT-BGH;
    } completion:^(BOOL finished) {
        
    }];
    [self.view bringSubviewToFront:bottomView];
}

- (void)menuAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 2000:
        {
            #pragma mark 关于我们
            GuanYuWoMenVC *vc = [Unit EPStoryboard:@"GuanYuWoMenVC"];
//            GuanYuWoMenVC *vc = [[GuanYuWoMenVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            

        }
            break;
        case 2001:
        {
            #pragma mark 我的优惠券
            if ([UserManager manager].isLogin) {
                
                MyTicketViewController *ticVC = [[MyTicketViewController alloc] init];
                [self.navigationController pushViewController:ticVC animated:YES];
            }
            else
            {
                [self showFunctionAlertWithTitle:@"温馨提示" message:@"您尚未登录" functionName:@"点击登录" Handler:^{
                    [self loginBeforePushVC:NSStringFromClass([MyTicketViewController class])];
                }];
            }
            
        }
            break;
        case 2002:
        {
            #pragma mark 我的车位
            if ([UserManager manager].isLogin) {
                
                // 进入我的车位选择界面
                SelectParkingSpaceVC *vc = [Unit EPStoryboard:@"SelectParkingSpaceVC"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [self showFunctionAlertWithTitle:@"温馨提示" message:@"您尚未登录" functionName:@"点击登录" Handler:^{
                    [self loginBeforePushVC:NSStringFromClass([SelectParkingSpaceVC class])];
                }];
            }
        }
            break;
        case 2003:
        {
            #pragma mark 分享
            [self onShare];
            
        }
            
            break;
        case 2004:
        {
            #pragma mark 充电
            if (self.user.isLogin) {
                ChongDianVC *vc = [Unit EPStoryboard:@"ChongDianVC"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [self showFunctionAlertWithTitle:@"温馨提示" message:@"您尚未登录" functionName:@"点击登录" Handler:^{
                    [self loginBeforePushVC:NSStringFromClass([ChongDianVC class])];
                }];
            }
            
        }
            break;
        case 2005:
        {
            #pragma mark 洗车
            if (self.user.isLogin) {
                
                XiCheVC *vc = [Unit EPStoryboard:@"XiCheVC"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [self showFunctionAlertWithTitle:@"温馨提示" message:@"您尚未登录" functionName:@"点击登录" Handler:^{
                    [self loginBeforePushVC:NSStringFromClass([XiCheVC class])];
                }];
            }

        }
            break;
            
        default:
            break;
    }
}

#pragma mark 点击左边
- (void)dismiss
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}


#pragma mark 点击右边 我的
- (void)meVC
{
    NSInteger vcCount = self.navigationController.viewControllers.count;
    // 3:主页->我的->中间->我的  直接返回上一页
    if (vcCount >= 3) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    // 2:主页->中间->我的 推新的页面
    if (vcCount == 2) {
        if (self.user.isLogin)
        {
            MeViewController *vc = [[MeViewController alloc] init];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationItem setBackBarButtonItem:backItem];
            [self.navigationController pushViewController:vc animated:NO];
        }
        else
        {
            [self showFunctionAlertWithTitle:@"温馨提示" message:@"您尚未登录" functionName:@"点击登录" Handler:^{
                [self loginBeforePushVC:NSStringFromClass([MeViewController class])];
            }];
        }
    }
}


#pragma mark - 分享
- (void)onShare {
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UM_KEY
                                      shareText:@"新用户注册分享送这送那"
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToEmail,UMShareToSms,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToYXTimeline,UMShareToLWTimeline,nil]
                                       delegate:self];
}

#pragma mark 分享完成
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //    NSLog(@"%@", response);
    if (response.responseCode == UMSResponseCodeSuccess) {
        
        NSLog(@"============== 分享成功 =================");
        
        [self getRequestURL:BaseURL"shareCoupon"
         
        parameters:@{
                     @"memberId":self.user.userID,
                     @"type":@"1"
                     }
         
        success:^(NSDictionary *dic) {
            
            [MBProgressHUD showSuccess:dic[@"msg"] toView:Window];
            
        } elseAction:^(NSDictionary *dic) {
            
            [MBProgressHUD hideAllHUDsForView:Window animated:NO];
            
        } failure:^(NSError *error) {
            
            
        }];
    }
    else
    {
        NSLog(@"============== 分享失败 =================");
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
@end
