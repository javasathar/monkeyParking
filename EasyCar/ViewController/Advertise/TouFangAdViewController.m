//
//  TouFangAdViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/16.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "TouFangAdViewController.h"
#import "OrderCheckViewController.h"

@interface TouFangAdViewController ()
{
    UILabel *placeholder;
    UIView *dateView;
    UIView *dateViewBg;
    UIDatePicker *datePicker;
    BOOL isStartTime;
    UILabel *beginTimLab;
    UILabel *endTimLab;
    UIView *chooseThemeBg;
    UIView *themeBottom;
    UILabel *chooseTLab;
    UIImageView *themeImg;
}
@end

@implementation TouFangAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(242, 248, 248, 1);
    self.title = @"投放广告";
    UIScrollView *_mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-self.navigationController.navigationBar.height)];
    [self.view addSubview:_mainScroll];
    
    UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    addLabel.text = @"投放场地";
    addLabel.textAlignment = NSTextAlignmentCenter;
    addLabel.font = [UIFont boldSystemFontOfSize:16];
    UITextField *addText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 45)];
    addText.backgroundColor = [UIColor whiteColor];
    addText.delegate = self;
    addText.returnKeyType = UIReturnKeyDone;
    addText.leftView = addLabel;
    addText.font = [UIFont systemFontOfSize:15];
    addText.textColor = RGBA(51, 51, 51, 1);
    addText.placeholder = @"请输入投放场地";
    addText.text = self.address;
    addText.leftViewMode = UITextFieldViewModeAlways;
    addText.clearButtonMode = UITextFieldViewModeAlways;
    [_mainScroll addSubview:addText];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(20, addText.bottom, UI_SCREEN_WIDTH-20, 0.5)];
    line1.backgroundColor = RGBA(200, 200, 200, 1);
    [_mainScroll addSubview:line1];
    
    UIButton *beginTimeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    beginTimeBtn.frame = CGRectMake(0, line1.bottom, UI_SCREEN_WIDTH, 45);
    beginTimeBtn.backgroundColor = [UIColor whiteColor];
    [beginTimeBtn addTarget:self action:@selector(chooseBegin) forControlEvents:(UIControlEventTouchUpInside)];
    [_mainScroll addSubview:beginTimeBtn];
    
    UILabel *beginLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    beginLab.text = @"开始时间";
    beginLab.textAlignment = NSTextAlignmentCenter;
    beginLab.font = [UIFont boldSystemFontOfSize:16];
    [beginTimeBtn addSubview:beginLab];
    
    beginTimLab = [[UILabel alloc] initWithFrame:CGRectMake(beginLab.right, 0, 200, 45)];
    beginTimLab.text = @"选择时间";
    beginTimLab.textAlignment = NSTextAlignmentLeft;
    beginTimLab.textColor = RGBA(220, 220, 220, 1);
    beginTimLab.font = [UIFont systemFontOfSize:16];
    [beginTimeBtn addSubview:beginTimLab];
    
    UIImageView *accImg = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-20, 15, 10, 15)];
    accImg.image = [UIImage imageNamed:@"arrow_right"];
    [beginTimeBtn addSubview:accImg];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(20, beginTimeBtn.bottom, UI_SCREEN_WIDTH-20, 0.5)];
    line2.backgroundColor = RGBA(200, 200, 200, 1);
    [_mainScroll addSubview:line2];
    
    UIButton *endTimeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    endTimeBtn.frame = CGRectMake(0, line2.bottom, UI_SCREEN_WIDTH, 45);
    endTimeBtn.backgroundColor = [UIColor whiteColor];
    [endTimeBtn addTarget:self action:@selector(chooseEnd) forControlEvents:(UIControlEventTouchUpInside)];
    [_mainScroll addSubview:endTimeBtn];
    
    UILabel *endLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    endLab.text = @"结束时间";
    endLab.textAlignment = NSTextAlignmentCenter;
    endLab.font = [UIFont boldSystemFontOfSize:16];
    [endTimeBtn addSubview:endLab];
    
    endTimLab = [[UILabel alloc] initWithFrame:CGRectMake(endLab.right, 0, 200, 45)];
    endTimLab.text = @"选择时间";
    endTimLab.textAlignment = NSTextAlignmentLeft;
    endTimLab.textColor = RGBA(220, 220, 220, 1);
    endTimLab.font = [UIFont systemFontOfSize:16];
    [endTimeBtn addSubview:endTimLab];
    
    UIImageView *accendImg = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-20, 15, 10, 15)];
    accendImg.image = [UIImage imageNamed:@"arrow_right"];
    [endTimeBtn addSubview:accendImg];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(20, endTimeBtn.bottom, UI_SCREEN_WIDTH-20, 0.5)];
    line3.backgroundColor = RGBA(200, 200, 200, 1);
    [_mainScroll addSubview:line3];
    
    UIButton *themeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    themeBtn.frame = CGRectMake(0, line3.bottom, UI_SCREEN_WIDTH-60, 45);
    themeBtn.backgroundColor = [UIColor whiteColor];
    [themeBtn addTarget:self action:@selector(chooseTheme) forControlEvents:(UIControlEventTouchUpInside)];
    [_mainScroll addSubview:themeBtn];
    
    UILabel *themeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    themeLab.text = @"投放主题";
    themeLab.textAlignment = NSTextAlignmentCenter;
    themeLab.font = [UIFont boldSystemFontOfSize:16];
    [themeBtn addSubview:themeLab];
    
    chooseTLab = [[UILabel alloc] initWithFrame:CGRectMake(themeLab.right, 0, 100, 45)];
    chooseTLab.text = @"选择主题";
    chooseTLab.textAlignment = NSTextAlignmentLeft;
    chooseTLab.textColor = RGBA(220, 220, 220, 1);
    chooseTLab.font = [UIFont boldSystemFontOfSize:15];
    [themeBtn addSubview:chooseTLab];
    
    UIImageView *addThImg = [[UIImageView alloc] initWithFrame:CGRectMake(themeBtn.width-20, 15, 10, 15)];
    addThImg.image = [UIImage imageNamed:@"arrow_right"];
    [themeBtn addSubview:addThImg];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(themeBtn.right, line3.bottom, 0.5, 45)];
    line4.backgroundColor = RGBA(200, 200, 200, 1);
    [_mainScroll addSubview:line4];
    
    UIButton *seeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    seeBtn.frame = CGRectMake(line4.right, line3.bottom, 59.5, 45);
    seeBtn.backgroundColor = [UIColor whiteColor];
    [seeBtn setImage:[UIImage imageNamed:@"scan_toufang"] forState:(UIControlStateNormal)];
    [seeBtn addTarget:self action:@selector(scan_theme) forControlEvents:(UIControlEventTouchUpInside)];
    [_mainScroll addSubview:seeBtn];
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(20, themeBtn.bottom, UI_SCREEN_WIDTH-20, 0.5)];
    line5.backgroundColor = RGBA(200, 200, 200, 1);
    [_mainScroll addSubview:line5];
    
    UIView *gexingView = [[UIView alloc] initWithFrame:CGRectMake(0, line5.bottom, UI_SCREEN_WIDTH, 100)];
    gexingView.backgroundColor = [UIColor whiteColor];
    [_mainScroll addSubview:gexingView];
    
    UILabel *gexingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    gexingLabel.text = @"个性文字";
    gexingLabel.textAlignment = NSTextAlignmentCenter;
    gexingLabel.font = [UIFont boldSystemFontOfSize:16];
    [gexingView addSubview:gexingLabel];
    
    UITextView *gexingText = [[UITextView alloc] initWithFrame:CGRectMake(100, 5, UI_SCREEN_WIDTH-110, 95)];
    gexingText.delegate = self;
    gexingText.returnKeyType = UIReturnKeyDone;
    gexingText.font = [UIFont systemFontOfSize:16];
    [gexingView addSubview:gexingText];
    
    placeholder = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 150, 30)];
    placeholder.text = @"输入个性文化语";
    placeholder.textAlignment = NSTextAlignmentLeft;
    placeholder.textColor = RGBA(200, 200, 200, 1);
    placeholder.font = [UIFont systemFontOfSize:16];
    [gexingText addSubview:placeholder];
    
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(20, gexingView.bottom, UI_SCREEN_WIDTH-20, 0.5)];
    line6.backgroundColor = RGBA(200, 200, 200, 1);
    [_mainScroll addSubview:line6];
    
    UILabel *PriceLab = [[UILabel alloc] initWithFrame:CGRectMake(0, line6.bottom, 100, 45)];
    PriceLab.backgroundColor = [UIColor whiteColor];
    PriceLab.text = @"总价";
    PriceLab.textAlignment = NSTextAlignmentCenter;
    PriceLab.font = [UIFont boldSystemFontOfSize:16];
    [_mainScroll addSubview:PriceLab];
    
    UILabel *tPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(PriceLab.right, line6.bottom, UI_SCREEN_WIDTH-PriceLab.right, 45)];
    tPriceLab.backgroundColor = [UIColor whiteColor];
    tPriceLab.text = @"50元";
    tPriceLab.textColor = RGBA(251, 17, 10, 1);
    tPriceLab.textAlignment = NSTextAlignmentLeft;
    tPriceLab.font = [UIFont boldSystemFontOfSize:16];
    [_mainScroll addSubview:tPriceLab];
    
    UIButton *touAdBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    touAdBtn.frame = CGRectMake(UI_SCREEN_WIDTH/2-140, tPriceLab.bottom+30, 280, 45);
    touAdBtn.layer.cornerRadius = 5;
    touAdBtn.backgroundColor = RGBA(50, 129, 255, 1);
    [touAdBtn setTitle:@"投放广告" forState:(UIControlStateNormal)];
    [touAdBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    touAdBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [touAdBtn addTarget:self action:@selector(touAdAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_mainScroll addSubview:touAdBtn];
    
    [self initDatePicker];
}

//投放广告---跳转到订单支付界面
- (void)touAdAction
{
    OrderCheckViewController *myAdvc = [[OrderCheckViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController pushViewController:myAdvc animated:YES];
}

- (void)initDatePicker
{
    dateViewBg = [[UIView alloc] initWithFrame:self.view.bounds];
    dateViewBg.backgroundColor = [UIColor blackColor];
    dateViewBg.hidden = YES;
    dateViewBg.alpha = .5;
    [self.view addSubview:dateViewBg];
    dateView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 265)];
    dateView.layer.borderColor = [RGBA(244, 244, 244, 1) CGColor];
    dateView.layer.borderWidth = 0.5;
    dateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dateView];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 215)];
    datePicker.backgroundColor = [UIColor clearColor];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    datePicker.locale = locale;
    datePicker.tag = 2002;
    //datePicker.minimumDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateView addSubview:datePicker];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 215, UI_SCREEN_WIDTH, .5)];
    line.backgroundColor = RGBA(220, 220, 220, 1);
    [dateView addSubview:line];
    
    UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelBtn.frame = CGRectMake(0, line.bottom, (UI_SCREEN_WIDTH-0.5)/2, 49.5);
    [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelBtn setTitleColor:RGBA(50, 129, 255, 1) forState:(UIControlStateNormal)];
    [cancelBtn addTarget:self action:@selector(dismissPicker) forControlEvents:(UIControlEventTouchUpInside)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [dateView addSubview:cancelBtn];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(cancelBtn.right, line.bottom, .5, 49.5)];
    line2.backgroundColor = RGBA(220, 220, 220, 1);
    [dateView addSubview:line2];
    
    UIButton *confirmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    confirmBtn.frame = CGRectMake(line2.right, line.bottom, (UI_SCREEN_WIDTH-0.5)/2, 49.5);
    [confirmBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [confirmBtn setTitleColor:RGBA(50, 129, 255, 1) forState:(UIControlStateNormal)];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirmBtn addTarget:self action:@selector(confirmTime) forControlEvents:(UIControlEventTouchUpInside)];
    [dateView addSubview:confirmBtn];
}

- (void)chooseBegin
{
    [self.view endEditing:YES];
    isStartTime = YES;
    dateViewBg.hidden = NO;
    dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 265);
    [UIView animateWithDuration:0.5 animations:^{
        dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-265, UI_SCREEN_WIDTH, 265);
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)chooseEnd
{
    [self.view endEditing:YES];
    isStartTime = NO;
    dateViewBg.hidden = NO;
    dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 265);
    [UIView animateWithDuration:0.5 animations:^{
        dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-265, UI_SCREEN_WIDTH, 265);
    } completion:^(BOOL finished) {
        ;
    }];
}

-(void)dismissPicker
{
    isStartTime = NO;
    dateViewBg.hidden = YES;
    dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-265, dateView.frame.size.width, dateView.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, dateView.frame.size.width, dateView.frame.size.height);
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)confirmTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:datePicker.date];
    if(isStartTime)
    {
        beginTimLab.textColor = RGBA(51, 51, 51, 1);
        [beginTimLab setText:time];
    }
    else
    {
        endTimLab.textColor = RGBA(51, 51, 51, 1);
        [endTimLab setText:time];
    }
    dateViewBg.hidden = YES;
    dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-265, dateView.frame.size.width, dateView.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, dateView.frame.size.width, dateView.frame.size.height);
    } completion:^(BOOL finished) {
        ;
    }];
}

//选择主题
- (void)chooseTheme
{
    [self.view endEditing:YES];
    chooseThemeBg = [[UIView alloc] initWithFrame:self.view.bounds];
    chooseThemeBg.backgroundColor = [UIColor blackColor];
    chooseThemeBg.alpha = 0;
    chooseThemeBg.userInteractionEnabled = YES;
    [self.view addSubview:chooseThemeBg];
    UITapGestureRecognizer *removeTheme = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeTheme)];
    [chooseThemeBg addGestureRecognizer:removeTheme];
    
    themeBottom = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 200)];
    themeBottom.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:themeBottom];
    
    NSArray *theArr = [[NSArray alloc] initWithObjects:@"新年",@"生日",@"圣诞",@"示爱", nil];
    for (int i = 0; i < 4; i ++) {
        UIButton *themeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        themeBtn.frame = CGRectMake(0, 50*i, UI_SCREEN_WIDTH, 49.5);
        [themeBtn setTitleColor:RGBA(51, 51, 51, 1) forState:(UIControlStateNormal)];
        [themeBtn setTitle:theArr[i] forState:(UIControlStateNormal)];
        themeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [themeBottom addSubview:themeBtn];
        [themeBtn addTarget:self action:@selector(confirmChoose:) forControlEvents:(UIControlEventTouchUpInside)];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5+50*i, UI_SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGBA(220, 220, 220, 1);
        [themeBottom addSubview:line];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        chooseThemeBg.alpha = 0.5;
        themeBottom.frame = CGRectMake(0, UI_SCREEN_HEIGHT-200, UI_SCREEN_WIDTH, 200);
    }];
}

- (void)removeTheme
{
    [UIView animateWithDuration:0.5 animations:^{
        chooseThemeBg.alpha = 0;
        themeBottom.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 200);
    } completion:^(BOOL finished) {
        [chooseThemeBg removeFromSuperview];
        [themeBottom removeFromSuperview];
    }];
}

- (void)confirmChoose:(UIButton *)sender
{
    chooseTLab.textColor = RGBA(51, 51, 51, 1);
    chooseTLab.text = sender.titleLabel.text;
    [self removeTheme];
}

//浏览主题
- (void)scan_theme
{
    if([chooseTLab.text isEqualToString:@"选择主题"])
    {
        [MBProgressHUD showError:@"请先选择主题" toView:self.view];
    }
    else
    {
        themeImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
        if([chooseTLab.text isEqualToString:@"示爱"])
        {
            themeImg.image = [UIImage imageNamed:@"yulanlan"];
        }
        else if ([chooseTLab.text isEqualToString:@"圣诞"])
        {
            themeImg.image = [UIImage imageNamed:@"圣诞6.jpg"];
        }
        else if ([chooseTLab.text isEqualToString:@"新年"])
        {
            themeImg.image = [UIImage imageNamed:@"新年.jpg"];
        }
        else
        {
            themeImg.image = [UIImage imageNamed:@"圣诞6.jpg"];
        }
        
        themeImg.userInteractionEnabled = YES;
        [self.view.window addSubview:themeImg];
        
        UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        backBtn.frame = CGRectMake(10, 20, 80, 42);
        [backBtn setImage:[UIImage imageNamed:@"yulanBack"] forState:(UIControlStateNormal)];
        [backBtn addTarget:self action:@selector(removeThemeImg) forControlEvents:(UIControlEventTouchUpInside)];
        [themeImg addSubview:backBtn];
        
        [UIView animateWithDuration:0.5 animations:^{
            themeImg.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)removeThemeImg
{
    [UIView animateWithDuration:0.5 animations:^{
        themeImg.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [themeImg removeFromSuperview];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITextFirle Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect frame = textView.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length == 0)
    {
        placeholder.text = @"输入个性文化语";
    }
    else
    {
        placeholder.text = @"";
    }
}
@end
