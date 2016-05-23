//
//  MeViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/20.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "MeViewController.h"
#import "MyCarWeiViewController.h"
#import "ChangeInfoViewController.h"
#import "ChangePwdViewController.h"
#import "WoDeDingDanVC.h"
#import <MLTransition.h>
#import "MiddleViewController.h"
#import "MyTicketViewController.h"
#import "ParkingViewController.h"
#import "GuanYuWoMenVC.h"
#import "WoYaoTingCheVC.h"
#import "MyCarViewController.h"
#import "MyWalletViewController.h"
@interface MeViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UMSocialUIDelegate>

@property (strong, nonatomic) IBOutlet UILabel *nicknameLB;
@property (strong, nonatomic) IBOutlet UILabel *phoneLB;
@property (strong, nonatomic) IBOutlet UILabel *moneyLB;
@property (strong, nonatomic) IBOutlet UILabel *couponLB;

@property (strong, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *checkUp;

@end

@implementation MeViewController



- (void)viewDidAppear:(BOOL)animated
{
    
    [self setUserInfo];
    //    [self requestCouponCount];
    //    [self requestBalance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.disableMLTransition = YES;
    
    // 添加底部栏
    [self addBottomBar];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _headerView.layer.cornerRadius = _headerView.bounds.size.height/2;
    
    
}

#pragma mark 余额请求
- (void)requestBalance
{
    NSString *url = BaseURL@"getBalance";
    NSDictionary *parameters = @{@"memberId":self.user.userID};
    [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        NSLog(@"%@", dic[@"msg"]);
        
        if ([dic[@"status"] isEqual:@(200)]) {
            
            double banlance = [dic[@"data"] doubleValue];
            self.user.balance = [dic[@"data"] doubleValue];
            _moneyLB.text = [NSString stringWithFormat:@"%.2f元",self.user.balance];
            
        }
        else
        {
            NSLog(@"%@", dic[@"msg"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"报错：%@", [error localizedDescription]);
    }];
}


#pragma mark 添加底部栏。。。
- (void)addBottomBar
{
    [[CGTool shareInitial] setTabbarWithViewController:self];
    //    UIView *fakeTabbarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, Heigth-55, Width, 55)];
    //    fakeTabbarBackground.backgroundColor = [UIColor whiteColor];
    //    [self.view addSubview:fakeTabbarBackground];
    
    //    UIButton *leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    //    leftBtn.frame = CGRectMake(0, UI_SCREEN_HEIGHT-55, 110, 55);
    //
    //    [leftBtn setImage:[[UIImage imageNamed:@"home_tab1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:(UIControlStateNormal)];
    //    leftBtn.tintColor = [UIColor colorWithWhite:0.569 alpha:1.000];
    //
    //    [leftBtn addTarget:self action:@selector(gotoMain) forControlEvents:(UIControlEventTouchUpInside)];
    //    [self.view addSubview:leftBtn];
    //
    //    UIButton *centerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    //    centerBtn.frame = CGRectMake(UI_SCREEN_WIDTH/2-25, UI_SCREEN_HEIGHT-55, 50, 50);
    //
    //
    //    [centerBtn setImage:[UIImage imageNamed:@"logo"] forState:(UIControlStateNormal)];
    //    [centerBtn addTarget:self action:@selector(showMenu) forControlEvents:(UIControlEventTouchUpInside)];
    //    [self.view addSubview:centerBtn];
    //
    //    UIButton *rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    //    rightBtn.frame = CGRectMake(UI_SCREEN_WIDTH-110, UI_SCREEN_HEIGHT-55, 110, 55);
    //
    //    [rightBtn setImage:[[UIImage imageNamed:@"home_tab3"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:(UIControlStateNormal)];
    //    rightBtn.tintColor = [UIColor colorWithRed:0.220 green:0.522 blue:0.988 alpha:1.000];
    //    [self.view addSubview:rightBtn];
    
}



//#pragma mark 点击左边
//- (void)gotoMain
//{
//    [self.navigationController popToRootViewControllerAnimated:NO];
//}
//
//#pragma mark 点击中间
//- (void)showMenu
//{
////    MiddleViewController *vc = [[MiddleViewController alloc] init];
////    [self.navigationController pushViewController:vc animated:NO];
//    ParkingViewController *vc = [[ParkingViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
#pragma mark 点击退出登录
- (IBAction)logOutAction:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)changePwdAction
{
    ChangePwdViewController *addvc = [[ChangePwdViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController pushViewController:addvc animated:YES];
}


#pragma mark 修改资料
- (IBAction)onXiuGaiZiLiao:(id)sender {
    
    [self.navigationController pushViewController:[Unit EPStoryboard:@"XiuGaiZiLiaoVC"] animated:YES];
    //    ChangeInfoViewController *addvc = [[ChangeInfoViewController alloc] init];
    //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    //    [self.navigationItem setBackBarButtonItem:backItem];
    //    [self.navigationController pushViewController:addvc animated:YES];
}

#pragma mark 我的钱包
- (IBAction)onWoDeQianBao:(id)sender {
    MyWalletViewController *vc = [[MyWalletViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark 我的订单
- (IBAction)onMyOrder:(id)sender {
    [self.navigationController pushViewController:[Unit EPStoryboard:@"WoDeDingDanVC"]  animated:YES];
}

#pragma mark 账户余额
- (IBAction)onMyCar:(id)sender {
    MyCarViewController *myCarVC = [[MyCarViewController alloc] init];
    [self.navigationController pushViewController:myCarVC animated:YES];
}

#pragma mark 账户余额
- (IBAction)onZhangHuYuE:(id)sender {
    
    //    [self.navigationController pushViewController:[Unit EPStoryboard:@"ZhangHuYuEVC"] animated:YES];
}


#pragma mark 优惠券
- (IBAction)onYouHuiQuan:(id)sender {
    
    //    MyTicketViewController *ticVC = [[MyTicketViewController alloc] init];
    //    [self.navigationController pushViewController:ticVC animated:YES];
}

#pragma mark 车牌管理（我的车位）
- (IBAction)onChePaiGuanLi:(id)sender {
    
    //    MyCarViewController *mycarVC = [[MyCarViewController alloc] init];
    //    [self.navigationController pushViewController:mycarVC animated:YES];
    [self onShare];
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



#pragma mark 检查更新（我的车位）
- (IBAction)onWoDeZhengZu:(id)sender {
    
    if ([self.checkUp.text isEqualToString: @"有新版本可更新"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/ting-che-da-sheng/id1080875914?mt=8"]];
    }else
    {
        self.checkUp.text = @"正在检查...";
        //    [self.navigationController pushViewController:[Unit EPStoryboard:@"SelectParkingSpaceVC"] animated:YES];
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        
        NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        NSLog(@"当前版本：   %@",appVersion);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager POST:APP_URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            if (dic[@"results"]) {
                if (dic[@"results"][0]) {
                    if (dic[@"results"][0][@"version"]) {
                        if ([appVersion isEqualToString:dic[@"results"][0][@"version"] ]) {
                            self.checkUp.text = @"已是最新版本";
                        }else
                        {
                            self.checkUp.text = @"有新版本可更新";
                            
                        }
                    }
                }
            }
            NSLog(@"appstore版本：  %@",dic[@"results"][0][@"version"]);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            self.checkUp.text = @"网络有问题";
            
        }];
    }
}

#pragma mark 确认退出登录
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(1 == buttonIndex)
    {
        [UserManager manager].isLogin = NO;
        // 清除消息
        DELE.unReadCount = 0;
        
        [UserDefaultsFiles setUserDataName:nil password:nil];
        
        self.tabBarController.selectedIndex = 0;
    }
}

#pragma mark 查优惠券
- (void)requestCouponCount
{
    if (self.user.isLogin) {
        
        NSString *url = BaseURL@"couponCount";
        
        NSDictionary *parameters = @{
                                     @"memberId":self.user.userID
                                     };
        
        [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dic = responseObject;
            
            if ([dic[@"status"] isEqual:@(200)]) {
                
                _couponLB.text = [NSString stringWithFormat:@"%@",dic[@"data"]];
            }
            else if ([dic[@"status"] isEqual:@(300)]) {
                
                _couponLB.text = @"0";
            }
            else
            {
                [MBProgressHUD showError:@"未能获取优惠券数" toView:self.view];
                _couponLB.text = @"\\";
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"报错：%@", [error localizedDescription]);
            _couponLB.text = @"\\";
            [MBProgressHUD showError:@"未能获取优惠券数" toView:self.view];
        }];
    }
}

#pragma mark 设置用户信息
- (void)setUserInfo
{
    UserManager *user = [UserManager manager];
    _nicknameLB.text = user.nickname;
    //    _moneyLB.text = [NSString stringWithFormat:@"%.2f元",user.balance];
    NSMutableString *phoneNum = [NSMutableString stringWithString:user.phone];
    [phoneNum replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    _phoneLB.text = phoneNum;
    
    NSURL *url = [NSURL URLWithString:user.head_img];
    
    [_headerView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_img"]];
    
    
}



#pragma mark - 点击头像 从相册中选取图片
- (IBAction)changeUserImage:(id)sender {
    
    UIActionSheet *sheet;
    if ([self isCameraAvailble]) {
        
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选取",nil];
    }else{
        
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",nil];
    }
    
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.navigationBar.barStyle = UIBarStyleBlack;
    imagePicker.allowsEditing = YES;
    [imagePicker.navigationBar setBarTintColor:[UIColor colorWithRed:0.220 green:0.522 blue:0.988 alpha:1.000]];
    imagePicker.delegate = self;
    
    if ([self isCameraAvailble] && buttonIndex == 0) {
        //拍照
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }else if(([self isCameraAvailble] && buttonIndex == 1) || (![self isCameraAvailble] && buttonIndex == 0)){
        //相册
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }
    
}

#pragma mark 选中的图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    // UIImage -> NSString
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData *data = UIImageJPEGRepresentation(image , 0.1);
    NSString *pic = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    
    [self postPic:pic picker:picker];
}

#pragma mark 上传图片
- (void)postPic:(NSString *)pic picker:(UIImagePickerController *)picker
{
    NSLog(@"开始上传图片...");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [MBProgressHUD showAnimateHUDAddedTo:Window text:@"正在上传头像"]; // 动画开始
    NSString *url = BaseURL@"addHeadImg";
    NSDictionary *parameters = @{
                                 @"memberId":[UserManager manager].userID,
                                 @"pic":pic
                                 };
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        NSLog(@"msg : %@", dic[@"msg"]);
        
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        
        if ([dic[@"status"] isEqual:@(200)]) {
            [MBProgressHUD showSuccess:dic[@"msg"] toView:self.view];
            self.user.head_img = dic[@"data"];
            
            // 上传成功直接把头像改成新头像
            NSData *picData = [[NSData alloc] initWithBase64EncodedString:pic options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *picImage = [UIImage imageWithData:picData];
            _headerView.image = picImage;
        }
        else
        {
            [MBProgressHUD showError:dic[@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:Window animated:YES];// 动画隐藏
        NSLog(@"报错：%@", [error localizedDescription]);
        [MBProgressHUD showError:@"网络加载出错" toView:self.view];
    }];
}
-(void)clickMonkey
{
    WoYaoTingCheVC *mapVC = [[WoYaoTingCheVC alloc] initWithNibName:@"WoYaoTingCheVC" bundle:nil];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController pushViewController:mapVC animated:YES];
}
#pragma mark 判断照相机是否支持
- (BOOL) isCameraAvailble {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        return YES;
    }
    return NO;
}
@end
