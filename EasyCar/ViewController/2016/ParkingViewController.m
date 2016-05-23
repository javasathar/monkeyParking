//
//  ParkingViewController.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/2/17.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ParkingViewController.h"
#import "PlcTestViewController.h"
#import "ParkingNumViewController.h"
#import "PlcData.h"
#import "FileData.h"
#define keyHeight Width / 4
#define keyWidth  Width / 3
@interface ParkingViewController ()
@property (nonatomic ,strong)UILabel *inputLabel;
@property (weak, nonatomic) IBOutlet UILabel *chooseShowLabel;

@property (nonatomic ,strong)NSString *socketStr;
@end

@implementation ParkingViewController
{
    NSDictionary *_wifiInfo;
    NSDictionary *_mapDic;
    BOOL _isConnectMonkeyWIFI;
    UIView *parkView;  //车库地图
    UIButton *autoBtn;  //一键操作按钮
    UIButton *handBtn;  //手动操作按钮
    UIView *_keyView;  //键盘
    UIView *_showView;//展示LABEL
    BOOL _isDown;     //键盘是否下降
    int _btnTag;//按钮标签
    NSString *_btnText;
    UIButton *_downBtn;//下滑按钮
    UILabel *_parkingNum;//车库标签
    NSTimer *_timer;
    MBProgressHUD *_hud;
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appBecome) name:@"become" object:nil];
//    NSLog(@"监控者来了");
    
    [self wifiInitinal];
}
//初始化，检测WIFI连接性
-(void)wifiInitinal
{
    if ([[CGTool shareInitial] isMonkeyWIFI]) {
        //        [MBProgressHUD showResult:YES text:@"已成功连接上车库" delay:1.0f];
        _isConnectMonkeyWIFI = YES;
    }else
    {
        _isConnectMonkeyWIFI = NO;
        [self showFunctionAlertWithTitle:@"未连接车库wifi" message:@"请搜寻并连接“Monkey”开头的WIFI" functionName:@"去设置" Handler:^{
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
        }];
    }
    
}
-(void)cancel
{
    //    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    NSLog(@"监控者走了");
}
-(void)appBecome
{
    [self wifiInitinal];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([CGTool isMonkey]) {
        [self.nav setTitle:@"我要停车" leftText:@"返回" rightTitle:@"设置" showBackImg:YES];
        
    }else
    {
        [self.nav setTitle:@"我要停车" leftText:@"返回" rightTitle:nil showBackImg:YES];
        
    }
    
    [self allViewInitial];
    
//    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSomeView)]];
    
}
-(void)allViewInitial
{

    
    FileData *filedata = [[FileData alloc] init];
    NSDictionary *mapDic = [filedata checkupMap];
//    NSLog(@"%@",mapDic);
    if ([filedata checkupFile:mapDic[@"imageName"]]) {
        _mapDic = mapDic;
        [self showParkingMap:mapDic];
    }else
    {
        [self showParkingPlc];
    }
    
    [self showViewInitial];  //顶部框
    
    [self keyViewInitial]; //键盘

    
//    [self autoParkingView];  //一键操作盘
}
-(void)right
{
    PlcTestViewController *vc = [[PlcTestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//展示缓存地图
-(void)showParkingMap:(NSDictionary *)dic
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *imagePath = [path stringByAppendingPathComponent:dic[@"imageName"]];
    NSDictionary *uiContent = dic[@"UIcontent"];
    NSArray *imageFrame = uiContent[@"frame"];
    //车库地图
    parkView = [[UIView alloc] initWithFrame:CGRectMake([imageFrame[0] floatValue] * Width, [imageFrame[1] floatValue] * Heigth, [imageFrame[2] floatValue] * Width, [imageFrame[3] floatValue] * Heigth)];
    [self.view addSubview:parkView];
    UIImageView *parkImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, parkView.width, parkView.height)];
    parkImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
    [parkView addSubview:parkImage];
    
    //plc按钮
    NSInteger i = 0;
    char c = 'A';
    for (NSArray *btnArr in uiContent[@"plcFrame"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[NSString stringWithFormat:@"%c",(char)(c + i)] forState:UIControlStateNormal];
        btn.tag = 120 + i++;
        btn.titleLabel.font = [UIFont systemFontOfSize:24];
        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake([btnArr[0] floatValue] * parkView.width, [btnArr[1] floatValue] * parkView.height, [btnArr[2] floatValue] * parkView.width, [btnArr[3] floatValue] * parkView.height)];
        
        [btn addTarget:self action:@selector(btnClick2:) forControlEvents:UIControlEventTouchUpInside];
        [parkView addSubview:btn];
    }
}
- (void)btnClick2:(UIButton*)sender {
    _btnTag = [sender tag] - 120 ;
    _btnText = sender.currentTitle;
    NSLog(@"btnTag : %ld",(long)_btnTag);
    
//    [self showAutoParkingView];
    _parkingNum.text = [NSString stringWithFormat:@"当前已选择%@车库",sender.currentTitle];
    _chooseShowLabel.text = [NSString stringWithFormat:@"已选择%@车库",sender.currentTitle];
    [_parkingNum setTextColor:[UIColor orangeColor]];
    
    ParkingNumViewController *parkingNum = [[ParkingNumViewController alloc] init];
    parkingNum.mapArr = _mapDic[@"UIcontent"][@"plcFrame"][_btnTag];
    parkingNum.plcNum = _btnTag;
//    NSLog(@"%@",_mapDic);
    [self.navigationController pushViewController:parkingNum animated:YES];
}
//一次性用的label
-(void)showParkingPlc
{
    float plcWidth = Width / 9;
    char c = 'A';
    for (NSInteger j = 0; j < 3; j ++) {
        for (NSInteger i = 0 ; i < 4; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:[NSString stringWithFormat:@"%c",(char)(c + i + j * 4) ] forState:UIControlStateNormal];
            btn.tag = 120 + i + j * 4;
            btn.titleLabel.font = [UIFont systemFontOfSize:24];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [btn setFrame:CGRectMake(plcWidth * (i * 2 + 1), Width / 3 + plcWidth * ( j * 2.5 + 1), plcWidth, plcWidth)];
            
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
        }
    }
    
    
}

- (void)btnClick:(UIButton*)sender {
    _btnTag = [sender tag] - 120 ;
    _btnText = sender.currentTitle;
    NSLog(@"btnTag : %ld",(long)_btnTag);
    
    [self keyViewDown:_downBtn];
    _parkingNum.text = [NSString stringWithFormat:@"当前已选择%@车库",sender.currentTitle];
    [_parkingNum setTextColor:[UIColor orangeColor]];
}

//展示框
-(void)showViewInitial
{
    _showView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, Width, Heigth - Width)];
    [self.view addSubview:_showView];
    CGFloat messageHeight = (Heigth - Width - 64 ) * 0.25;
    CGFloat carNumHeight = (Heigth - Width - 64) * 0.75;
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Width,messageHeight )];
    [_showView addSubview:messageLabel];
    [messageLabel setBackgroundColor:RGBA(200, 230, 253, 0.9)];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [messageLabel setFont:[UIFont systemFontOfSize:22]];
    [messageLabel setTextColor:[UIColor grayColor]];
    messageLabel.text = @"请输入车位号，如：203";
    
    _inputLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, messageHeight, Width,carNumHeight )];
    [_showView addSubview:_inputLabel];
    [_inputLabel setBackgroundColor:RGBA(200, 230, 253, 0.9)];
    _inputLabel.text = @"";
    _inputLabel.textAlignment = NSTextAlignmentCenter;
    [_inputLabel setFont:[UIFont systemFontOfSize:24]];
    [_inputLabel setTextColor:[UIColor blueColor]];
    
    _parkingNum = [[UILabel alloc] initWithFrame:CGRectMake(0, messageHeight, Width, messageHeight)];
    [_showView addSubview:_parkingNum];
    [_parkingNum setBackgroundColor:RGBA(200, 230, 253, 0.9)];
    _parkingNum.textAlignment = NSTextAlignmentCenter;
    [_parkingNum setFont:[UIFont systemFontOfSize:22]];
    [_parkingNum setTextColor:[UIColor grayColor]];
    _parkingNum.text = @"请选择车库";
}
//自定义输入键盘
-(void)keyViewInitial
{
    
    _keyView = [[UIView alloc] initWithFrame:CGRectMake(0, Heigth - Width , Width, Width)];
    [self.view addSubview: _keyView];
    
    
    
    for (NSInteger i = 0; i < 3; i ++) {
        for (NSInteger j =0 ; j < 3 ; j++) {
            UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(keyWidth * j, keyHeight * i, keyWidth, keyHeight)];
            [numLabel setBackgroundColor:RGBA(200, 241, 255, 0.9)];
            numLabel.tag = 900+ i * 3 + j + 1;
            numLabel.text = [NSString stringWithFormat:@"%ld",numLabel.tag - 900];
            numLabel.textAlignment = NSTextAlignmentCenter;
            [numLabel setFont:[UIFont systemFontOfSize:24]];
            numLabel.layer.borderWidth = 1;
            numLabel.layer.borderColor = [[UIColor whiteColor]CGColor];
            [_keyView addSubview:numLabel];
            numLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelAction:)];
            [numLabel addGestureRecognizer:tap];
        }
    }
    
    //0
    UILabel *numLabel0 = [[UILabel alloc] initWithFrame:CGRectMake(keyWidth , keyHeight * 3 , keyWidth, keyHeight)];
    [numLabel0 setBackgroundColor:RGBA(200, 241, 255, 0.9)];
    numLabel0.tag = 900;
    numLabel0.text = [NSString stringWithFormat:@"%ld",numLabel0.tag - 900];
    numLabel0.textAlignment = NSTextAlignmentCenter;
    [numLabel0 setFont:[UIFont systemFontOfSize:22]];
    numLabel0.layer.borderWidth = 1;
    numLabel0.layer.borderColor = [[UIColor whiteColor]CGColor];
    [_keyView addSubview:numLabel0];
    numLabel0.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelAction:)];
    [numLabel0 addGestureRecognizer:tap];
    
    //删除键
    UILabel *deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, keyHeight * 3 , keyWidth, keyHeight)];
    [deleteLabel setBackgroundColor:RGBA(200, 241, 255, 0.9)];
    deleteLabel.tag = 911;
    deleteLabel.text = @"删除";
    deleteLabel.textAlignment = NSTextAlignmentCenter;
    [deleteLabel setFont:[UIFont systemFontOfSize:22]];
    deleteLabel.layer.borderWidth = 1;
    deleteLabel.layer.borderColor = [[UIColor whiteColor]CGColor];
    [_keyView addSubview:deleteLabel];
    deleteLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelAction:)];
    [deleteLabel addGestureRecognizer:tap2];
    
    
    //确认键
    UILabel *sureLabel = [[UILabel alloc] initWithFrame:CGRectMake(keyWidth * 2, keyHeight * 3 , keyWidth , keyHeight)];
    [sureLabel setBackgroundColor:RGBA(120, 130, 160, 0.9)];
    sureLabel.tag = 912;
    sureLabel.text = @"确认";
    sureLabel.textAlignment = NSTextAlignmentCenter;
    [sureLabel setFont:[UIFont systemFontOfSize:22]];
    sureLabel.layer.borderWidth = 1;
    sureLabel.layer.borderColor = [[UIColor whiteColor]CGColor];
    sureLabel.layer.cornerRadius = 10.0f;
    [_keyView addSubview:sureLabel];
    sureLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelAction:)];
    [sureLabel addGestureRecognizer:tap3];
    
    //下滑键
    _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_downBtn setFrame:CGRectMake(0, _keyView.top - keyHeight/2.5, Width , keyHeight/2.5)];
    [_downBtn setBackgroundColor:RGBA(200, 220, 255, 0.9)];
    _downBtn.tag = 913;
    [_downBtn setTitle:@"︾" forState:UIControlStateNormal];
    _downBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    _downBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _downBtn.layer.borderWidth = 1;
    _downBtn.layer.cornerRadius = 3.0f;
    [_downBtn addTarget:self action:@selector(keyViewDown:) forControlEvents:UIControlEventTouchUpInside];
    _downBtn.clipsToBounds = YES;
    
    [self.view addSubview:_downBtn];
    
    [self keyViewDown:_downBtn];
}
//下滑键
-(void)keyViewDown:(UIButton *)sender
{
    [self hideSomeView];

    if (!_isDown) {
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        //改变它的frame的x,y的值
        CGRect rect = _keyView.frame;
        rect.origin = CGPointMake(0, Heigth);
        _keyView.frame = rect;
        
        CGRect downRect = _downBtn.frame;
        downRect.origin.y = Heigth - keyHeight/2.5;
        _downBtn.frame = downRect;
        
        CGRect showRect = _showView.frame;
        showRect.origin.x = Width;
        _showView.frame = showRect;
        
        [UIView commitAnimations];
        [sender setTitle:@"︽" forState:UIControlStateNormal];
        _isDown = YES;
        
        [_keyView resignFirstResponder];
    }else
    {
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        //改变它的frame的x,y的值
        CGRect rect = _keyView.frame;
        rect.origin = CGPointMake(0, Heigth - Width);
        _keyView.frame = rect;
        
        CGRect downRect = _downBtn.frame;
        downRect.origin.y = Heigth - Width - keyHeight/2.5;
        _downBtn.frame = downRect;
        
        CGRect showRect = _showView.frame;
        showRect.origin.x = 0;
        _showView.frame = showRect;
        
        [UIView commitAnimations];
        [sender setTitle:@"︾" forState:UIControlStateNormal];
        _isDown = NO;
    }
    
}
-(void)labelAction:(UITapGestureRecognizer*)sender
{
    //    NSLog(@"%ld",sender.view.tag);
    PlcData *plcData = [PlcData shareInitial];
    switch (sender.view.tag) {
        case 900:
        case 901:
        case 902:
        case 903:
        case 904:
        case 905:
        case 906:
        case 907:
        case 908:
        case 909:
            if (_inputLabel.text.length < 3) {
                _inputLabel.text = [_inputLabel.text stringByAppendingFormat:@"%ld",sender.view.tag-900];
                
            }
            break;
        case 911://删除键
            if (_inputLabel.text.length > 0) {
                _inputLabel.text = [_inputLabel.text substringToIndex:_inputLabel.text.length - 1];
            }
            break;
        case 912://确认键
            if (_inputLabel.text.length == 3) {
                
                if (_isConnectMonkeyWIFI) {
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [plcData wantToParkingWithPlc:_btnTag andParkingSpace:_inputLabel.text andSuccess:^(id obj) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        NSString *objStr = obj;
                        [MBProgressHUD showResult:YES text:[NSString stringWithFormat:@"正在为您下放%@载车板",_inputLabel.text] delay:5.0f];
                        [[NSUserDefaults standardUserDefaults] setObject:@{@"plcTag":[NSString stringWithFormat:@"%ld",(long)_btnTag],@"parkingNum":_inputLabel.text} forKey:@"parkingList"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    } orFailed:^(id obj) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [MBProgressHUD showResult:NO text:[NSString stringWithFormat:@"操作失败"] delay:3.0f];
                        
                    }];

                }else
                {
                    [self wifiInitinal];
                }
            }else
            {
                [MBProgressHUD showError:@"请输入三位数字" toView:Window];
            }
            //
            break;
        default:
            NSLog(@"意外");
            break;
    }
}

//一键停车，手动停车按钮
-(void)autoParkingView
{
//    _autoView = [[UIView alloc] initWithFrame:CGRectMake(0, Heigth , Width, Width)];
//    [self.view addSubview: _autoView];
    
    autoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [autoBtn setFrame:CGRectMake(Width *0.25, Heigth * 0.3, Width * 0.5, Width * 0.5)];
    autoBtn.backgroundColor = [UIColor orangeColor];
    [autoBtn setTitle:@"一键停车" forState:UIControlStateNormal];
    autoBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    autoBtn.layer.cornerRadius = Width * 0.25 ;
    autoBtn.alpha = 0.0f;
    [autoBtn addTarget:self action:@selector(autoParkingCar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:autoBtn];
    
    handBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [handBtn setFrame:CGRectMake(Width *0.325, Heigth *0.7, Width * 0.35, Width * 0.35)];
    handBtn.backgroundColor = [UIColor redColor];
    [handBtn setTitle:@"手动停车" forState:UIControlStateNormal];
    handBtn.layer.cornerRadius = Width * 0.175 ;
    handBtn.alpha = 0.0f;
    [self.view addSubview:handBtn];
}
-(void)autoParkingCar
{
    PlcData *plcData = [PlcData shareInitial];
//    NSLog(@"%f",autoBtn.alpha);
    if (autoBtn.alpha != 0) {
        [MBProgressHUD showMessag:@"请稍等" toView:self.view];
        [plcData wantToParkingWithPlc:_btnTag andSuccess:^(id obj) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSString *objStr = obj;
            [MBProgressHUD showResult:YES text:[NSString stringWithFormat:@"正在为您下放%@",obj] delay:5.0f];
            [[NSUserDefaults standardUserDefaults] setObject:@{@"plcTag":[NSString stringWithFormat:@"%d",_btnTag],@"parkingNum":objStr} forKey:@"parkingList"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } orFailed:^(id obj) {
            [MBProgressHUD showResult:NO text:[NSString stringWithFormat:@"操作失败"] delay:5.0f];
        }];
    }
}
//展示//隐藏
-(void)showAutoParkingView
{
    [UIView animateWithDuration:1.0f animations:^{
        if (autoBtn.alpha == 0) {
            autoBtn.alpha = 0.9f;
            handBtn.alpha = 0.9f;
            parkView.alpha = 0.1f;
        }else
        {
            autoBtn.alpha = 0;
            handBtn.alpha = 0;
            parkView.alpha = 1.0f;

        }

    } completion:^(BOOL finished) {
        
    }];
}
-(void)hideSomeView
{
    [UIView animateWithDuration:1.0f animations:^{
        if (autoBtn.alpha != 0) {
            autoBtn.alpha = 0;
            handBtn.alpha = 0;
            parkView.alpha = 1.0f;
        }
    } completion:^(BOOL finished) {
        
    }];

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
