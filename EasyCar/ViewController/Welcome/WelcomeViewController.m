//
//  WelcomeViewController.m
//  test
//
//  Created by zhangke on 15/5/12.
//
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()
{
    UIScrollView *_mainScroll;
}
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    _mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _mainScroll.pagingEnabled = YES;
    _mainScroll.delegate = self;
    _mainScroll.showsHorizontalScrollIndicator = NO;
    [_mainScroll setContentSize:CGSizeMake(4*self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_mainScroll];
    
    UIPageControl *pages = [[UIPageControl alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2-20, self.view.frame.size.height - 60, 50, 40)];
    pages.tag = 3001;
    pages.numberOfPages = 4;
    pages.currentPage = 0;
    pages.pageIndicatorTintColor = [UIColor grayColor];
    pages.currentPageIndicatorTintColor = RGBA(50, 129, 255, 1);
    [pages addTarget:self action:@selector(pageTurn) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pages];
    
    for (int i = 0; i < 4; i ++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, self.view.frame.size.height)];
        img.image = [UIImage imageNamed:[NSString stringWithFormat:@"00%d.png",i+1]];
        [_mainScroll addSubview:img];
        if(3 == i)
        {
            UIImageView *loginImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height-100, 100, 35)];
            loginImg.image = [UIImage imageNamed:@"djjr"];
            [img addSubview:loginImg];
            img.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
            [img addGestureRecognizer:tap];
        }
    }
}

- (void)tap
{
    
    [UIView animateWithDuration:0.1f animations:^
     {
         self.view.alpha = 1;
     }completion:^(BOOL finished)
     {
         
         [UIView transitionWithView:self.view.window duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
         
         [[AppDelegate shareInstance] initHomeVC];
     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)pageTurn
{
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:3001];
    _mainScroll.contentOffset = CGPointMake(UI_SCREEN_WIDTH*page.currentPage,0);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    int current = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    //根据scrollView 的位置对page 的当前页赋值
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:3001];
    page.currentPage = current;
}


@end
