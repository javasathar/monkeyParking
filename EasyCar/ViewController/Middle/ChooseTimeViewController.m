//
//  ChooseTimeViewController.m
//  EasyCar
//
//  Created by zhangke on 15/5/20.
//  Copyright (c) 2015年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "ChooseTimeViewController.h"

@interface ChooseTimeViewController ()
{
    UIButton *hourBtn;
    UIButton *monthBtn;
    UIView *line1;
    
    UIView *dateView;
    UIView *dateViewBg;
    UIPickerView *datePicker;
    
    NSArray *beginHourArr;
    NSArray *beginMuniteArr;
    NSArray *endHourArr;
    NSArray *endMuniteArr;
    
    UIScrollView *_mainScrollView;
    long int week;
}
@end

@implementation ChooseTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择时间";
    self.view.backgroundColor = RGBA(242, 242, 248, 1);
    self.navigationController.navigationBar.barTintColor = RGBA(50, 129, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    beginHourArr = [[NSArray alloc] initWithObjects:@"01时",@"02时",@"03时",@"04时",@"05时",@"06时",@"07时",@"08时",@"09时",@"10时",@"11时",@"12时",@"13时",@"14时",@"15时",@"16时",@"17时",@"18时",@"19时",@"20时",@"21时",@"22时",@"23时",@"24时", nil];
    
    beginMuniteArr = [[NSArray alloc] initWithObjects:@"01分",@"02分",@"03分",@"04分",@"05分",@"06分",@"07分",@"08分",@"09分",@"10分",@"11分",@"12分",@"13分",@"14分",@"15分",@"16分",@"17分",@"18分",@"19分",@"20分",@"21分",@"22分",@"23分",@"24分", @"25分",@"26分",@"27分",@"28分",@"29分",@"30分",@"31分",@"32分",@"33分",@"34分",@"35分",@"36分",@"37分",@"38分",@"39分",@"40分",@"41分",@"42分",@"43分",@"44分",@"45分",@"46分",@"47分",@"48分",@"49分",@"50分",@"51分",@"52分",@"53分",@"54分",@"55分",@"56分",@"57分",@"58分",@"59分",@"60分",nil];
    endHourArr = [[NSArray alloc] initWithObjects:@"01时",@"02时",@"03时",@"04时",@"05时",@"06时",@"07时",@"08时",@"09时",@"10时",@"11时",@"12时",@"13时",@"14时",@"15时",@"16时",@"17时",@"18时",@"19时",@"20时",@"21时",@"22时",@"23时",@"24时", nil];
    
    endMuniteArr = [[NSArray alloc] initWithObjects:@"01分",@"02分",@"03分",@"04分",@"05分",@"06分",@"07分",@"08分",@"09分",@"10分",@"11分",@"12分",@"13分",@"14分",@"15分",@"16分",@"17分",@"18分",@"19分",@"20分",@"21分",@"22分",@"23分",@"24分", @"25分",@"26分",@"27分",@"28分",@"29分",@"30分",@"31分",@"32分",@"33分",@"34分",@"35分",@"36分",@"37分",@"38分",@"39分",@"40分",@"41分",@"42分",@"43分",@"44分",@"45分",@"46分",@"47分",@"48分",@"49分",@"50分",@"51分",@"52分",@"53分",@"54分",@"55分",@"56分",@"57分",@"58分",@"59分",@"60分",nil];

    
    monthBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    monthBtn.frame = CGRectMake(0, 64, UI_SCREEN_WIDTH/2, 40);
    [monthBtn setTitle:@"月租" forState:(UIControlStateNormal)];
    monthBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [monthBtn setTitleColor:RGBA(36, 36, 36, 1) forState:(UIControlStateSelected)];
    [monthBtn setTitleColor:RGBA(119, 119, 119, 1) forState:(UIControlStateNormal)];
    [monthBtn addTarget:self action:@selector(chooseMonth:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:monthBtn];
    
    hourBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    hourBtn.frame = CGRectMake(UI_SCREEN_WIDTH/2, 64, UI_SCREEN_WIDTH/2, 40);
    [hourBtn setTitle:@"时租" forState:(UIControlStateNormal)];
    hourBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [hourBtn setTitleColor:RGBA(36, 36, 36, 1) forState:(UIControlStateSelected)];
    [hourBtn setTitleColor:RGBA(119, 119, 119, 1) forState:(UIControlStateNormal)];
    [hourBtn addTarget:self action:@selector(chooseHour:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:hourBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, monthBtn.bottom, UI_SCREEN_WIDTH, 2)];
    line.backgroundColor = RGBA(220, 220, 220, 1);
    [self.view addSubview:line];
    
    line1 = [[UIView alloc] initWithFrame:CGRectMake(0, monthBtn.bottom, UI_SCREEN_WIDTH/2, 2)];
    line1.backgroundColor = RGBA(50, 129, 255, 1);
    [self.view addSubview:line1];
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, line1.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-line1.bottom)];
    _mainScrollView.scrollEnabled = NO;
    _mainScrollView.pagingEnabled = YES;
    [_mainScrollView setContentSize:CGSizeMake(2*UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    [self.view addSubview:_mainScrollView];
    NSArray *weekArr = [[NSArray alloc] initWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
    for (int i = 0; i < 7; i ++) {
        UIButton *btn1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn1.frame = CGRectMake(0, 45*i, UI_SCREEN_WIDTH, 45);
        btn1.tag = 2000+i;
        [btn1 addTarget:self action:@selector(chooseTime:) forControlEvents:(UIControlEventTouchUpInside)];
        [_mainScrollView addSubview:btn1];
        
        UIButton *img1 = [[UIButton alloc] initWithFrame:CGRectMake(5, 12, 21, 21)];
        [img1 setImage:[UIImage imageNamed:@"yuan_unselect"] forState:(UIControlStateNormal)];
        [img1 setImage:[UIImage imageNamed:@"yuan_select"] forState:(UIControlStateSelected)];
        [img1 addTarget:self action:@selector(selectWeek:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn1 addSubview:img1];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(img1.right, 0, 40, 45)];
        label1.text = weekArr[i];
        label1.font = [UIFont systemFontOfSize:15];
        [btn1 addSubview:label1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(label1.right+5, 0, 0.5, 45)];
        line2.backgroundColor = RGBA(220, 220, 220, 1);
        [btn1 addSubview:line2];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(line2.right+10, 0, 200, 45)];
        timeLabel.tag = 3000+i;
        timeLabel.text = @"09:30 ~ 18:00";
        timeLabel.font = [UIFont systemFontOfSize:15];
        timeLabel.textColor = RGBA(181, 181, 181, 1);
        [btn1 addSubview:timeLabel];
        
        UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-15, 15, 10, 15)];
        img2.image = [UIImage imageNamed:@"arrow_right"];
        [btn1 addSubview:img2];
        
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, UI_SCREEN_WIDTH, 0.5)];
        line3.backgroundColor = RGBA(220, 220, 220, 1);
        [btn1 addSubview:line3];
    }
    NSArray *title1Arr = [[NSArray alloc] initWithObjects:@"今天",@"明天", nil];
    for (int i = 0; i < 2; i ++) {
        UIButton *btn1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn1.frame = CGRectMake(UI_SCREEN_WIDTH, 45*i, UI_SCREEN_WIDTH, 45);
        btn1.tag = 5000+i;
        [btn1 addTarget:self action:@selector(chooseHourTime:) forControlEvents:(UIControlEventTouchUpInside)];
        [_mainScrollView addSubview:btn1];
        
        UIButton *img1 = [[UIButton alloc] initWithFrame:CGRectMake(5, 12, 21, 21)];
        [img1 setImage:[UIImage imageNamed:@"yuan_unselect"] forState:(UIControlStateNormal)];
        [img1 setImage:[UIImage imageNamed:@"yuan_select"] forState:(UIControlStateSelected)];
        [img1 addTarget:self action:@selector(selectWeek:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn1 addSubview:img1];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(img1.right, 0, 40, 45)];
        label1.text = title1Arr[i];
        label1.font = [UIFont systemFontOfSize:15];
        [btn1 addSubview:label1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(label1.right+5, 0, 0.5, 45)];
        line2.backgroundColor = RGBA(220, 220, 220, 1);
        [btn1 addSubview:line2];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(line2.right+10, 0, 200, 45)];
        timeLabel.tag = 6000+i;
        timeLabel.text = @"09:30 ~ 18:00";
        timeLabel.font = [UIFont systemFontOfSize:15];
        timeLabel.textColor = RGBA(181, 181, 181, 1);
        [btn1 addSubview:timeLabel];
        
        UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-15, 15, 10, 15)];
        img2.image = [UIImage imageNamed:@"arrow_right"];
        [btn1 addSubview:img2];
        
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, UI_SCREEN_WIDTH, 0.5)];
        line3.backgroundColor = RGBA(220, 220, 220, 1);
        [btn1 addSubview:line3];
    }
    [self initDatePicker];
    NSDate *date = [NSDate date];
    
    // Get Current Year
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    // Get Current  Hour
    [formatter setDateFormat:@"hh"];
    NSString* currentHourString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    if([[currentHourString stringByReplacingOccurrencesOfString:@"时" withString:@""] integerValue] < 10)
    {
        currentHourString = [NSString stringWithFormat:@"0%@",currentHourString];
    }
    [formatter setDateFormat:@"mm"];
    NSString* currentMinuteString = [NSString stringWithFormat:@"%@分",[formatter stringFromDate:date]];
//    [datePicker selectRow:[beginHourArr indexOfObject:currentHourString] inComponent:0 animated:YES];
//    [datePicker selectRow:[beginMuniteArr indexOfObject:currentMinuteString] inComponent:1 animated:YES];
//    [datePicker selectRow:[endHourArr indexOfObject:currentHourString] inComponent:3 animated:YES];
//    [datePicker selectRow:[endMuniteArr indexOfObject:currentMinuteString] inComponent:4 animated:YES];
    [datePicker reloadAllComponents];
}

- (void)initDatePicker
{
    dateViewBg = [[UIView alloc] initWithFrame:self.view.bounds];
    dateViewBg.backgroundColor = [UIColor blackColor];
    dateViewBg.hidden = YES;
    dateViewBg.alpha = .5;
    [self.view addSubview:dateViewBg];
    dateView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 200)];
    dateView.layer.borderColor = [RGBA(244, 244, 244, 1) CGColor];
    dateView.layer.borderWidth = 0.5;
    dateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dateView];
    
    datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 150)];
    datePicker.dataSource = self;
    datePicker.delegate = self;
    datePicker.backgroundColor = [UIColor whiteColor];
    [dateView addSubview:datePicker];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 150, UI_SCREEN_WIDTH, .5)];
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
    [confirmBtn addTarget:self action:@selector(confirmTime:) forControlEvents:(UIControlEventTouchUpInside)];
    [dateView addSubview:confirmBtn];
}

-(void)dismissPicker
{
    dateViewBg.hidden = YES;
    dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-200, dateView.frame.size.width, dateView.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, dateView.frame.size.width, dateView.frame.size.height);
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)confirmTime:(UIButton *)sender
{
    UILabel *timeLabel;
    if(week >= 5000)
    {
        timeLabel = (UILabel *)[self.view viewWithTag:3000+week-2000];
    }
    else
    {
        timeLabel = (UILabel *)[self.view viewWithTag:3000+week];
    }
    NSString *time = [NSString stringWithFormat:@"%@%@ ~ %@%@",[beginHourArr objectAtIndex:[datePicker selectedRowInComponent:0]],[beginMuniteArr objectAtIndex:[datePicker selectedRowInComponent:1]],[endHourArr objectAtIndex:[datePicker selectedRowInComponent:3]],[endMuniteArr objectAtIndex:[datePicker selectedRowInComponent:4]]];
    timeLabel.text = time;
    dateViewBg.hidden = YES;
    dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-200, dateView.frame.size.width, dateView.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, dateView.frame.size.width, dateView.frame.size.height);
    } completion:^(BOOL finished) {
        ;
    }];
}

//选择周几
- (void)selectWeek:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
}

//选择时间
- (void)chooseTime:(UIButton *)sender
{
    week = sender.tag - 2000;
    dateViewBg.hidden = NO;
    dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 200);
    [UIView animateWithDuration:0.5 animations:^{
        dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-200, UI_SCREEN_WIDTH, 200);
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)chooseHourTime:(UIButton *)sender
{
    week = sender.tag;
    dateViewBg.hidden = NO;
    dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 200);
    [UIView animateWithDuration:0.5 animations:^{
        dateView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-200, UI_SCREEN_WIDTH, 200);
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)chooseMonth:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    hourBtn.selected = NO;
    [UIView animateWithDuration:0.5 animations:^{
        line1.left = 0;
        _mainScrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)chooseHour:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    monthBtn.selected = NO;
    [UIView animateWithDuration:0.5 animations:^{
        line1.left = UI_SCREEN_WIDTH/2;
        _mainScrollView.contentOffset = CGPointMake(UI_SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIPickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(0 == component)
    {
        return beginHourArr.count;
    }
    else if (1 == component)
    {
        return beginMuniteArr.count;
    }
    else if (2 == component)
    {
        return 1;
    }
    else if (3 == component)
    {
        return endHourArr.count;
    }
    else
    {
        return endMuniteArr.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(0 == component)
    {
        return beginHourArr[row];
    }
    else if (1 == component)
    {
        return beginMuniteArr[row];
    }
    else if(2 == component)
    {
        return @"~";
    }
    else if (3 == component)
    {
        return endHourArr[row];
    }
    else
    {
        return endMuniteArr[row];
    }
}
@end
